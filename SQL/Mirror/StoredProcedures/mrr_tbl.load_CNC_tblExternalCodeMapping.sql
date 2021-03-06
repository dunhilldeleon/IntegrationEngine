SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

				/*==========================================================================================================================================
				Notes:
				Template for loading Mirror table incrementally.

				TODO Is this the right place for the transactions? Should transaction handling be external to this procedure?

				Test:

				EXECUTE mrr_tbl.load_CNC_tblExternalCodeMapping
				EXECUTE mrr_tbl.load_CNC_tblExternalCodeMapping 'F'

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[load_CNC_tblExternalCodeMapping]
					-- Add the parameters for the stored procedure here
					@LoadType NVARCHAR(1) = 'I' -- I= Incremental, F=Truncate/Insert
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
							SELECT COUNT(*) FROM mrr_tbl.CNC_tblExternalCodeMapping
						);

						--	Load working table from source.
						BEGIN TRANSACTION; -- INSERT INTO mrr_wrk.CNC_tblExternalCodeMapping

						TRUNCATE TABLE mrr_wrk.CNC_tblExternalCodeMapping;

						INSERT INTO mrr_wrk.CNC_tblExternalCodeMapping
						(
							[External_Code_Mapping_Data_Source_ID], [Internal_Data_Key], [Updated_Dttm]
						)
						SELECT [External_Code_Mapping_Data_Source_ID], [Internal_Data_Key], [Updated_Dttm]
						FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblExternalCodeMapping];

						--	How many records in working table?
						SET @WorkingCount = @@ROWCOUNT;

						COMMIT TRANSACTION; -- INSERT INTO mrr_wrk.CNC_tblExternalCodeMapping

						--	If 0 records in target or ABS(nW-nT) > Threshold force a Truncate/Insert. --TODO not ideal test but achievable without slowing the procedure down too much.
						IF ABS(@WorkingCount - @OriginalTargetCount) >= CAST((@OriginalTargetCount * @Threshold / 100) AS INTEGER)
							SET @LoadType = 'F';

						BEGIN TRANSACTION; -- Start transaction for the load and audit.

						--	We now do either a full (F) reload of the target or an incremental (I) load depending on what has been requested or how much data is changing.
						IF @LoadType = 'F'
						BEGIN
							--	Full load target from source.

							TRUNCATE TABLE mrr_tbl.CNC_tblExternalCodeMapping;

							INSERT INTO mrr_tbl.CNC_tblExternalCodeMapping
							(
								[External_Code_Mapping_Data_Source_ID], [Internal_Data_Key], [External_Code], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
							)
							SELECT [External_Code_Mapping_Data_Source_ID], [Internal_Data_Key], [External_Code], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblExternalCodeMapping];

							SET @Inserted = @@ROWCOUNT;

						END;
						--	Else load target incrementally...
						ELSE
						BEGIN

							--	Delete from target where target PK not in working table. --TODO We can save time by doing deletes and updated together but then we wouldn not be able to report separate counts for deleted/updated/inserted.
							DELETE tgt
							FROM mrr_tbl.CNC_tblExternalCodeMapping AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNC_tblExternalCodeMapping AS src
								WHERE tgt.[External_Code_Mapping_Data_Source_ID] = src.[External_Code_Mapping_Data_Source_ID] AND tgt.[Internal_Data_Key] = src.[Internal_Data_Key]
							);
							--	How many deleted?
							SET @Deleted = @@ROWCOUNT;

							--	Delete from target where working table PK & ChangeDetectionColumn not in target.
							DELETE tgt
							FROM mrr_tbl.CNC_tblExternalCodeMapping AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNC_tblExternalCodeMapping AS src
								WHERE tgt.[External_Code_Mapping_Data_Source_ID] = src.[External_Code_Mapping_Data_Source_ID] AND tgt.[Internal_Data_Key] = src.[Internal_Data_Key] AND tgt.[Updated_Dttm] = src.[Updated_Dttm]
							);
							--	How many updated?
							SET @Updated = @@ROWCOUNT;

							--		Insert into Target from source where working table PK & ChangeDetectionColumn not in target.
							INSERT INTO mrr_tbl.CNC_tblExternalCodeMapping
							(
								[External_Code_Mapping_Data_Source_ID], [Internal_Data_Key], [External_Code], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
							)
							SELECT src.[External_Code_Mapping_Data_Source_ID], src.[Internal_Data_Key], src.[External_Code], src.[User_Created], src.[Create_Dttm], src.[User_Updated], src.[Updated_Dttm]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblExternalCodeMapping] AS src
							INNER JOIN (SELECT wrk.[External_Code_Mapping_Data_Source_ID], wrk.[Internal_Data_Key] FROM mrr_wrk.CNC_tblExternalCodeMapping wrk
									WHERE NOT EXISTS
									(
										SELECT NULL
										FROM mrr_tbl.CNC_tblExternalCodeMapping AS tgt
										WHERE wrk.[External_Code_Mapping_Data_Source_ID] = tgt.[External_Code_Mapping_Data_Source_ID] AND wrk.[Internal_Data_Key] = tgt.[Internal_Data_Key]
									)
								) MissingRecs ON (MissingRecs.[External_Code_Mapping_Data_Source_ID] = src.[External_Code_Mapping_Data_Source_ID] AND MissingRecs.[Internal_Data_Key] = src.[Internal_Data_Key]);


							--	How many really inserted? ROWCOUNT = inserted + updated records.
							SET @Inserted = @@ROWCOUNT - @Updated;

						--		Truncate working table? --TODO decide.
						END;

						--	Update audit table.
						SET @EndTime = GETDATE();

						INSERT INTO mrr_aud.CNC_tblExternalCodeMapping
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
						COMMIT TRANSACTION; -- INSERT INTO mrr_aud.CNC_tblExternalCodeMapping

					END TRY
					--Catch if transaction open roll it back.
					BEGIN CATCH
						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;
						THROW;
					END CATCH;

				END;
				
GO
