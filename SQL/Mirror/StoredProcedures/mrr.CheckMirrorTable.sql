SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


/*==========================================================================================================================================
Notes:
Template for checking that Mirror table structure matches the source table. This can be run periodically to see if the source system have
added/changed columns. If columns have been removed on the source system, we will already know about it as it would break the load procedure.


Test:

EXECUTE mrr.CheckMirrorTable CNC_tblTeamMember;

History:
11/04/2018 OBMH\Steve.Nicoll Initial version.

==========================================================================================================================================*/

CREATE PROCEDURE [mrr].[CheckMirrorTable]
    -- Add the parameters for the stored procedure here
    @MirrorTableName NVARCHAR(128)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with statement count.
    SET NOCOUNT ON;

    DECLARE @ColumnCount BIGINT = 0,
            @MirrorSchema NVARCHAR(128) = 'mrr_tbl',
            @LinkedServer NVARCHAR(128),
            @SourceDatabase NVARCHAR(128),
            @SourceSchemaName NVARCHAR(128),
            @SourceTableName NVARCHAR(128),
            @Prefix NVARCHAR(10),
            @ThrowMsg NVARCHAR(128),
            @sql NVARCHAR(MAX);

    -- Check that the mirror table exists.
    SELECT @ColumnCount = COUNT(*)
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = @MirrorSchema
          AND TABLE_NAME = @MirrorTableName;


    IF @ColumnCount = 0
    BEGIN
        SET @ThrowMsg = N'Mirror table ' + @MirrorSchema + N'.' + @MirrorTableName + N' does not exist.';
        THROW 51010, @ThrowMsg, 1;
    END;

    -- Work out the mirror table prefix and source table name.
    SET @Prefix = SUBSTRING(@MirrorTableName, 1, PATINDEX('%[_]%', @MirrorTableName));

	SET @SourceTableName = SUBSTRING(@MirrorTableName, PATINDEX('%[_]%', @MirrorTableName) + 1, LEN(@MirrorTableName));

    ---- Work out the remaining source table details from the config table and prefix.
    SELECT @LinkedServer = CASE
                               WHEN ISNULL([LinkedServer], '') = '' THEN
                                   ''
                               ELSE
                                   '[' + [LinkedServer] + '].'
                           END,
           @SourceDatabase = [DatabaseName],
           @SourceSchemaName = [SchemaName]
    FROM [Mirror].[mrr_config].[SourceSystem]
    WHERE TablePrefix = @Prefix;

    IF (@@ROWCOUNT = 0)
    BEGIN
        SET @ThrowMsg = N'Mirror table prefix' + @Prefix + N' does not exist in [Mirror].[mrr_config].[SourceSystem].';
        THROW 51005, @ThrowMsg, 1;
    END;


    -- Check for discrepancies in the table structure between source and mirror.
    SET @sql
        = N'
	DECLARE @DiscrepacyCount BIGINT = 0,
		@ThrowMsg NVARCHAR(128);

    WITH GatherDiscrepancies
    AS (SELECT COLUMN_NAME,
               DATA_TYPE,
               CHARACTER_MAXIMUM_LENGTH,
               COLLATION_NAME,
               NUMERIC_PRECISION,
               NUMERIC_SCALE
        FROM <LinkedServer><SourceDatabase>.INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_SCHEMA = ''<SourceSchemaName>'' 
              AND TABLE_NAME = ''<SourceTableName>''
        EXCEPT
        SELECT COLUMN_NAME,
               DATA_TYPE,
               CHARACTER_MAXIMUM_LENGTH,
               COLLATION_NAME,
               NUMERIC_PRECISION,
               NUMERIC_SCALE
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = ''<MirrorSchema>''
              AND TABLE_NAME = ''<MirrorTableName>'')
    SELECT @DiscrepacyCount = COUNT(*)
    FROM GatherDiscrepancies;

	IF @DiscrepacyCount > 0
    BEGIN
        SET @ThrowMsg
            = N''Mirror table <MirrorSchema>.<MirrorTableName> structure no longer matches that of its source table.'';
        THROW 51010, @ThrowMsg, 1;
    END;
	';
	
    SET @sql
        = REPLACE(
                     REPLACE(
                                REPLACE(
                                           REPLACE(
                                                      REPLACE(
                                                                 REPLACE(@sql, '<LinkedServer>', @LinkedServer),
                                                                 '<SourceDatabase>',
                                                                 @SourceDatabase
                                                             ),
                                                      '<SourceSchemaName>',
                                                      @SourceSchemaName
                                                  ),
                                           '<SourceTableName>',
                                           @SourceTableName
                                       ),
                                '<MirrorSchema>',
                                @MirrorSchema
                            ),
                     '<MirrorTableName>',
                     @MirrorTableName
                 );

    EXEC( @sql);

END;


GO
