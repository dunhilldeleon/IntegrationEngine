SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
--USE [HIE]
--GO
--/****** Object:  StoredProcedure [HIE].[uspPopulateTable]    Script Date: 14/01/2019 09:53:33 ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO

/*==========================================================================================================================================
Procedure to populate HIE tables.

NOTE: Assumes every table has a UpdatedDate column - if not we will need to amend this code to add a variable that hold column name.

Test:

EXECUTE [dbo].[uspPopulateTable] N'Demographics'

History:
13/06/2018 OBMH\Steve.Nicoll  Initial version.

==========================================================================================================================================*/
CREATE  PROCEDURE [dbo].[uspPopulateTable]
    @TableName NVARCHAR(128),
	@SourceViewSchema NVARCHAR(128),
	@TargetTableSchema NVARCHAR(128),
    @Verbose NVARCHAR(1) = N'N'
AS
BEGIN

    SET NOCOUNT ON;

    -- Set these variables if changing the location of views and tables.
    DECLARE @TargetTableDatabase NVARCHAR(128) = 'HIE',
            --@TargetTableSchema NVARCHAR(128) = 'HIE',
            @SourceViewDatabase NVARCHAR(128) = 'HIE',
            --@SourceViewSchema NVARCHAR(128) = 'HIE',
            @SourceViewPrefix NVARCHAR(128) = 'vw';

    -- Working variables.
    DECLARE @CurrentMaxUpdateTime DATETIME2,
            @NewMaxUpdateTime DATETIME2,
            @LoadTime DATETIME2
        =   GETDATE(),
            @FullTableName NVARCHAR(128),
            @FullViewName NVARCHAR(128),
            @sqlTruncate NVARCHAR(MAX) = 'TRUNCATE TABLE <FullTableName>;',
            @sqlPopulate NVARCHAR(MAX) = 'INSERT INTO <FullTableName> (<TableColumnList>)
											SELECT
												<ViewColumnList>,
												CASE
													WHEN PATINDEX(''%[^ -{}~]%'', <InvalidCharChecker> COLLATE Latin1_General_BIN) <> 0 THEN 1
													ELSE 0
												END AS ContainsInvalidChar
											FROM <FullViewName>
											WHERE UpdatedDate > CAST(''<MaxUpdateTime>'' AS DATETIME2);',
            @sqlGetMaxUpdated NVARCHAR(MAX) = 'SELECT @MaxUpdateTime = MAX(UpdatedDate) FROM <FullTableName>;',
            @Params NVARCHAR(MAX),
            @ThrowMsg NVARCHAR(128),
            @TableColumnList NVARCHAR(MAX),
            @ViewColumnList NVARCHAR(MAX),
            @InvalidCharChecker NVARCHAR(MAX),
            @CurrentExtractID BIGINT = [HIE].[CurrentExtractID](); -- Set the ID for this extract group - could be NULL.

    -- Set the full object names.
    SET @FullTableName = @TargetTableDatabase + N'.' + @TargetTableSchema + N'.' + @TableName;
    SET @FullViewName = @SourceViewDatabase + N'.' + @SourceViewSchema + N'.' + @SourceViewPrefix + @TableName;

    PRINT CAST(SYSDATETIME() AS NVARCHAR(50)) + ': ' + @TableName;

    -- Check target table exists.
    IF OBJECT_ID(@FullTableName) IS NULL
    BEGIN
        SET @ThrowMsg = N'HIE target table ' + @FullTableName + N' does not exist.';
        THROW 51010, @ThrowMsg, 1;
    END;

    -- Check source view exists.
    IF OBJECT_ID(@FullViewName) IS NULL
    BEGIN
        SET @ThrowMsg = N'HIE source view ' + @FullViewName + N' does not exist.';
        THROW 51015, @ThrowMsg, 1;
    END;

    -- Get list of columns to populate - this is led by the table, the view must have at least these columns but could also have others.
    SET @TableColumnList =
    (
        SELECT STUFF(
               (
                   SELECT ', [' + [COLUMN_NAME] + ']'
                   FROM [INFORMATION_SCHEMA].[COLUMNS]
                   WHERE [TABLE_SCHEMA] = @TargetTableSchema
                         AND [TABLE_NAME] = @TableName
                   ORDER BY [ORDINAL_POSITION]
                   FOR XML PATH('')
               ),
               1,
               2,
               ''
                    )
    );

    SET @ViewColumnList = REPLACE(@TableColumnList, ', [ContainsInvalidChar]', '');

    -- Get a string that can be used to check for invalid characters in a record.
    SET @InvalidCharChecker =
    (
        SELECT STUFF(
               (
                   SELECT ' + CAST(ISNULL([' + [COLUMN_NAME] + '], '''') AS NVARCHAR(MAX))'
                   FROM [INFORMATION_SCHEMA].[COLUMNS]
                   WHERE [TABLE_SCHEMA] = @TargetTableSchema
                         AND [TABLE_NAME] = @TableName
                         AND [COLUMN_NAME] <> 'ContainsInvalidChar'
                   ORDER BY [ORDINAL_POSITION]
                   FOR XML PATH('')
               ),
               1,
               3,
               ''
                    )
    );

    BEGIN TRY

        -- Get last maximum updatetime from TableTracker.
        SET @CurrentMaxUpdateTime = [HIE].[MaxUpdateTime](@TableName); -- [Graphnet].[MaxUpdateTime](@TableName);

        IF @CurrentMaxUpdateTime IS NULL
            SET @CurrentMaxUpdateTime = '19000101';

        -- Truncate target table.
        SET @sqlTruncate = REPLACE(@sqlTruncate, '<FullTableName>', @FullTableName);

        IF @Verbose = N'Y'
            PRINT @sqlTruncate;

        EXEC [sp_executesql] @stmt = @sqlTruncate;

        -- Populate table.
        SET @sqlPopulate
            = REPLACE(
                         REPLACE(
                                    REPLACE(
                                               REPLACE(
                                                          REPLACE(
                                                                     REPLACE(
                                                                                @sqlPopulate,
                                                                                '<FullTableName>',
                                                                                @FullTableName
                                                                            ),
                                                                     '<FullViewName>',
                                                                     @FullViewName
                                                                 ),
                                                          '<MaxUpdateTime>',
                                                          @CurrentMaxUpdateTime
                                                      ),
                                               '<TableColumnList>',
                                               @TableColumnList
                                           ),
                                    '<InvalidCharChecker>',
                                    @InvalidCharChecker
                                ),
                         '<ViewColumnList>',
                         @ViewColumnList
                     );

        IF @Verbose = N'Y'
            PRINT @sqlPopulate;

        EXEC [sp_executesql] @stmt = @sqlPopulate;

        -- Get MaxUpdateTime.
        SET @sqlGetMaxUpdated = REPLACE(@sqlGetMaxUpdated, '<FullTableName>', @FullTableName);
        SET @Params = N'@MaxUpdateTime DATETIME2 OUTPUT';

        IF @Verbose = N'Y'
            PRINT @sqlGetMaxUpdated;

        EXEC [sp_executesql] @stmt = @sqlGetMaxUpdated,
                             @params = @Params,
                             @MaxUpdateTime = @NewMaxUpdateTime OUTPUT;

        IF @Verbose = N'Y'
            PRINT @NewMaxUpdateTime;

        -- Update (merge) TableTracker but if there is no incremental source data leave MaxUpdateTime unchanged from last time.
        -- This is to stop a lack of data this time causing an uneccessary full load next time.
        IF @NewMaxUpdateTime IS NULL
            SET @NewMaxUpdateTime = @CurrentMaxUpdateTime;

        MERGE INTO [dbo].[TableTracker] [tgt]
        USING
        (
            SELECT @TargetTableSchema	AS [SourceSystem],
				   @TableName AS [TABLE_NAME],
                   @CurrentExtractID AS [ExtractID],
                   @NewMaxUpdateTime AS [MaxUpdateTime]
        ) [src]
        ON [tgt].[TABLE_NAME] = [src].[TABLE_NAME]
			AND [tgt].[ExtractID] = [src].[ExtractID]
        WHEN MATCHED THEN
            UPDATE SET [tgt].[MaxUpdateTime] = [src].[MaxUpdateTime]
        WHEN NOT MATCHED THEN
            INSERT
            (
				[SourceSystem],
                [TABLE_NAME],
                [ExtractID],
                [MaxUpdateTime]
            )
            VALUES
            ([src].[SourceSystem], [src].[TABLE_NAME], [src].[ExtractID], [src].[MaxUpdateTime]);


    END TRY
    BEGIN CATCH
        THROW;
    END CATCH;

END;


GO
