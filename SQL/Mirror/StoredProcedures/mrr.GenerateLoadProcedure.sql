SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
/*==========================================================================================================================================
Notes:
Template for loading Mirror table.

TODO Is this the right place for the transactions? Should transaction handling be external to this procedure?

Test:

EXECUTE mrr.GenerateLoadProcedure CNC_tblTeamMember
EXECUTE mrr.GenerateLoadProcedure CNC_tblTeamMember, 'F'

History:
11/04/2018 OBMH\Steve.Nicoll Initial version.
18/01/2019 OBMH\Nicholas.Walne Converted incremental INSERT step to "MIG style" where the SELECT is pushed down to remote source server.

==========================================================================================================================================*/

CREATE PROCEDURE [mrr].[GenerateLoadProcedure]
    @MirrorTableName NVARCHAR(128),
    @LoaderType NVARCHAR(1) = 'I'
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with statement count.
    SET NOCOUNT ON;
    DECLARE @ColumnNameList NVARCHAR(MAX),
            @srcColumnNameList NVARCHAR(MAX),
            @SourceTableFullName NVARCHAR(MAX),
            @WorkingTableColumnNameList NVARCHAR(MAX),
            @wrkPK NVARCHAR(MAX),
            @JoinOnPK NVARCHAR(MAX),
            @wrkTotgtJoinOnPK NVARCHAR(MAX),
            @MissingRecsTosrcJoinOnPK NVARCHAR(MAX),
            @JoinOnPKAndChangeDetectionColumn NVARCHAR(MAX),
            @sql NVARCHAR(MAX),
            @ThrowMsg NVARCHAR(MAX);

    IF OBJECT_ID('mrr_tbl.Load_' + @MirrorTableName, 'P') IS NOT NULL
    BEGIN
        SET @sql = N'DROP PROCEDURE mrr_tbl.Load_' + @MirrorTableName;
        EXECUTE (@sql);
    END;

    /*---------------------------------------------------------------------------------------------------------------------------------------
	If we only ask for a full loader (type F) or we have no option because there's no primary key/change detection column (and
	hence we could not create a working table) then create a loader that only does TRUNCATE/INSERT
	---------------------------------------------------------------------------------------------------------------------------------------*/
    IF @LoaderType = 'F'
       OR OBJECT_ID('mrr_wrk.' + @MirrorTableName, 'U') IS NULL
    BEGIN
        SET @sql
            = N'
				/*==========================================================================================================================================
				Notes:
				Template for loading Mirror table in full load mode only.

				TODO Is this the right place for the transactions? Should transaction handling be external to this procedure?

				Test:

				EXECUTE mrr_tbl.load_<MirrorTableName>
				EXECUTE mrr_tbl.load_<MirrorTableName> ''F''

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[load_<MirrorTableName>]
					-- Add the parameters for the stored procedure here
					@LoadType NVARCHAR(1) = ''F'' -- I= Incremental, F=Truncate/Insert, value ignored for full load only loaders
				AS
				BEGIN
					DECLARE @Inserted INTEGER = 0,
							@Updated INTEGER = 0,
							@Deleted INTEGER = 0,
							@StartTime DATETIME2 = GETDATE(),
							@EndTime DATETIME2;

					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;
					--Try...
					BEGIN TRY
						BEGIN TRANSACTION;

						TRUNCATE TABLE mrr_tbl.<MirrorTableName>;

						INSERT INTO mrr_tbl.<MirrorTableName>
						(
							<ColumnNameList>
						)
						SELECT <ColumnNameList>
						FROM <SourceTableFullName>;

						SET @Inserted = @@ROWCOUNT;
						SET @Deleted = @Inserted; -- TODO This is not right but as we do TRUNCATE rather than DELETE it is the best we can do for now.

						--	Update audit table.
						SET @EndTime = GETDATE();

						INSERT INTO mrr_aud.<MirrorTableName>
						(
							LoadType,
							RunByUser,
							StartTime,
							EndTime,
							Inserted,
							Updated,
							Deleted
						)
						VALUES
						(   @LoadType,   -- LoadType - nvarchar(1)
							SYSTEM_USER, -- RunByUser - nvarchar(128)
							@StartTime,  -- StartTime - datetime2(7)
							@EndTime,    -- EndTime - datetime2(7)
							@Inserted,   -- Inserted - int
							@Updated,    -- Updated - int
							@Deleted     -- Deleted - int
							);
						COMMIT TRANSACTION; -- INSERT INTO mrr_aud.<MirrorTableName>

					END TRY
					--Catch if transaction open roll it back.
					BEGIN CATCH
						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;
							THROW;
					END CATCH;

				END;
				';

        SET @ColumnNameList = mrr.GetColumnNameList(@MirrorTableName, DEFAULT);
        SET @SourceTableFullName = mrr.GetSourceTableFullName(@MirrorTableName);;

        SET @sql
            = REPLACE(
                         REPLACE(
                                    REPLACE(@sql, '<MirrorTableName>', @MirrorTableName),
                                    '<ColumnNameList>',
                                    @ColumnNameList
                                ),
                         '<SourceTableFullName>',
                         @SourceTableFullName
                     );
    END;
    /*---------------------------------------------------------------------------------------------------------------------------------------
	Else create a standard incremental loader.
	---------------------------------------------------------------------------------------------------------------------------------------*/
    ELSE
    BEGIN
        SET @sql
            = N'
				/*==========================================================================================================================================
				Notes:
				Template for loading Mirror table incrementally.

				TODO Is this the right place for the transactions? Should transaction handling be external to this procedure?

				Test:

				EXECUTE mrr_tbl.load_<MirrorTableName>
				EXECUTE mrr_tbl.load_<MirrorTableName> ''F''

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[load_<MirrorTableName>]
					-- Add the parameters for the stored procedure here
					@LoadType NVARCHAR(1) = ''I'' -- I= Incremental, F=Truncate/Insert
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;
					DECLARE @Threshold NUMERIC(4, 1) = 25.0; -- When gross change greater than this percentage, we will do a full reload. (Valid values between 0.0-100.0, to 1 decimal place.)
					DECLARE @OriginalTargetCount BIGINT,
							@WorkingCount INTEGER,
							@Inserted INTEGER = 0,
							@Updated INTEGER = 0,
							@Deleted INTEGER = 0,
							@StartTime DATETIME2 = GETDATE(),
							@EndTime DATETIME2;

					--Try...
					BEGIN TRY
						--	How many records in target (the count does not have to be super accurate but should be as fast as possible)?
						SET @OriginalTargetCount =
						(
							SELECT COUNT(*) FROM mrr_tbl.<MirrorTableName>
						);

						--	Load working table from source.
						BEGIN TRANSACTION; -- INSERT INTO mrr_wrk.<MirrorTableName>

						TRUNCATE TABLE mrr_wrk.<MirrorTableName>;

						INSERT INTO mrr_wrk.<MirrorTableName>
						(
							<WorkingTableColumnNameList>
						)
						SELECT <WorkingTableColumnNameList>
						FROM <SourceTableFullName>;

						--	How many records in working table?
						SET @WorkingCount = @@ROWCOUNT;

						COMMIT TRANSACTION; -- INSERT INTO mrr_wrk.<MirrorTableName>

						--	If 0 records in target or ABS(nW-nT) > Threshold force a Truncate/Insert. --TODO not ideal test but achievable without slowing the procedure down too much.
						IF ABS(@WorkingCount - @OriginalTargetCount) >= CAST((@OriginalTargetCount * @Threshold / 100) AS INTEGER)
							SET @LoadType = ''F'';

						BEGIN TRANSACTION; -- Start transaction for the load and audit.

						--	We now do either a full (F) reload of the target or an incremental (I) load depending on what has been requested or how much data is changing.
						IF @LoadType = ''F''
						BEGIN
							--	Full load target from source.

							TRUNCATE TABLE mrr_tbl.<MirrorTableName>;

							INSERT INTO mrr_tbl.<MirrorTableName>
							(
								<ColumnNameList>
							)
							SELECT <ColumnNameList>
							FROM <SourceTableFullName>;

							SET @Inserted = @@ROWCOUNT;

						END;
						--	Else load target incrementally...
						ELSE
						BEGIN

							--	Delete from target where target PK not in working table. --TODO We can save time by doing deletes and updated together but then we wouldn not be able to report separate counts for deleted/updated/inserted.
							DELETE tgt
							FROM mrr_tbl.<MirrorTableName> AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.<MirrorTableName> AS src
								WHERE <JoinOnPK>
							);
							--	How many deleted?
							SET @Deleted = @@ROWCOUNT;

							--	Delete from target where working table PK & ChangeDetectionColumn not in target.
							DELETE tgt
							FROM mrr_tbl.<MirrorTableName> AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.<MirrorTableName> AS src
								WHERE <JoinOnPKAndChangeDetectionColumn>
							);
							--	How many updated?
							SET @Updated = @@ROWCOUNT;

							--		Insert into Target from source where working table PK & ChangeDetectionColumn not in target.
							INSERT INTO mrr_tbl.<MirrorTableName>
							(
								<ColumnNameList>
							)
							SELECT <srcColumnNameList>
							FROM <SourceTableFullName> AS src
							INNER JOIN (SELECT <wrkPK> FROM mrr_wrk.<MirrorTableName> wrk
									WHERE NOT EXISTS
									(
										SELECT NULL
										FROM mrr_tbl.<MirrorTableName> AS tgt
										WHERE <wrkTotgtJoinOnPK>
									)
								) MissingRecs ON (<MissingRecsTosrcJoinOnPK>);


							--	How many really inserted? ROWCOUNT = inserted + updated records.
							SET @Inserted = @@ROWCOUNT - @Updated;

						--		Truncate working table? --TODO decide.
						END;

						--	Update audit table.
						SET @EndTime = GETDATE();

						INSERT INTO mrr_aud.<MirrorTableName>
						(
							LoadType,
							RunByUser,
							StartTime,
							EndTime,
							Inserted,
							Updated,
							Deleted
						)
						VALUES
						(   @LoadType,   -- LoadType - nvarchar(1)
							SYSTEM_USER, -- RunByUser - nvarchar(128)
							@StartTime,  -- StartTime - datetime2(7)
							@EndTime,    -- EndTime - datetime2(7)
							@Inserted,   -- Inserted - int
							@Updated,    -- Updated - int
							@Deleted     -- Deleted - int
							);

						-- Commit the data lolad and audit table update.
						COMMIT TRANSACTION; -- INSERT INTO mrr_aud.<MirrorTableName>

					END TRY
					--Catch if transaction open roll it back.
					BEGIN CATCH
						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;
						THROW;
					END CATCH;

				END;
				';

        SET @ColumnNameList = mrr.GetColumnNameList(@MirrorTableName, DEFAULT);
        SET @srcColumnNameList = mrr.GetColumnNameList(@MirrorTableName, 'src');
        SET @SourceTableFullName = mrr.GetSourceTableFullName(@MirrorTableName);
        SET @WorkingTableColumnNameList = mrr.GetWorkingTableColumnNameList(@MirrorTableName);
        SET @wrkPK = mrr.GetPK(@MirrorTableName, 'wrk');
        SET @JoinOnPK = mrr.GetPKJoin(@MirrorTableName, DEFAULT, DEFAULT);
        SET @wrkTotgtJoinOnPK = mrr.GetPKJoin(@MirrorTableName, 'wrk', 'tgt');
        SET @MissingRecsTosrcJoinOnPK = mrr.GetPKJoin(@MirrorTableName, 'MissingRecs', 'src');
        SET @JoinOnPKAndChangeDetectionColumn = mrr.GetPKAndChangeDetectionJoin(@MirrorTableName);

        SET @sql
            = REPLACE(
                         REPLACE(
                                    REPLACE(
                                               REPLACE(
                                                          REPLACE(
                                                                     REPLACE(
                                                                                REPLACE(
                                                                                           REPLACE(
                                                                                                      REPLACE(
                                                                                                                 REPLACE(
                                                                                                                            @sql,
                                                                                                                            '<MirrorTableName>',
                                                                                                                            @MirrorTableName
                                                                                                                        ),
                                                                                                                 '<ColumnNameList>',
                                                                                                                 @ColumnNameList
                                                                                                             ),
                                                                                                      '<SourceTableFullName>',
                                                                                                      @SourceTableFullName
                                                                                                  ),
                                                                                           '<WorkingTableColumnNameList>',
                                                                                           @WorkingTableColumnNameList
                                                                                       ),
                                                                                '<JoinOnPK>',
                                                                                @JoinOnPK
                                                                            ),
                                                                     '<JoinOnPKAndChangeDetectionColumn>',
                                                                     @JoinOnPKAndChangeDetectionColumn
                                                                 ),
                                                          '<wrkPK>',
                                                          @wrkPK
                                                      ),
                                               '<srcColumnNameList>',
                                               @srcColumnNameList
                                           ),
                                    '<MissingRecsTosrcJoinOnPK>',
                                    @MissingRecsTosrcJoinOnPK
                                ),
                         '<wrkTotgtJoinOnPK>',
                         @wrkTotgtJoinOnPK
                     );
    END;

    /*---------------------------------------------------------------------------------------------------------------------------------------
	Whatever type of loader we are building - build it now.
	---------------------------------------------------------------------------------------------------------------------------------------*/
    IF (@sql IS NULL)
    BEGIN
        SET @ThrowMsg = N'Cannot create load procedure for ' + @MirrorTableName + N' as generate script is NULL.';
        THROW 51010, @ThrowMsg, 1;
    END;

    --SELECT @sql
    EXECUTE (@sql);

END;

GO
