SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


/*==========================================================================================================================================
Notes:


Test:

DECLARE @SourceTableFullName NVARCHAR(MAX)

SET @SourceTableFullName =  mrr.GetSourceTableFullName('CNC_tblTeamMembers');

SELECT @SourceTableFullName

History:
11/04/2018 OBMH\Steve.Nicoll Initial version.

==========================================================================================================================================*/

CREATE FUNCTION [mrr].[GetSourceTableFullName]
(
    @MirrorTableName NVARCHAR(128)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN

    DECLARE @ColumnCount BIGINT = 0,
            @MirrorSchema NVARCHAR(128) = 'mrr_tbl',
            @LinkedServer NVARCHAR(128),
            @SourceDatabase NVARCHAR(128),
            @SourceSchemaName NVARCHAR(128),
            @SourceTableName NVARCHAR(128),
            @Prefix NVARCHAR(10),
            @ThrowMsg NVARCHAR(128),
            @sql NVARCHAR(MAX);


    -- Work out the mirror table prefix and source table name.
    SET @Prefix = SUBSTRING(@MirrorTableName, 1, PATINDEX('%[_]%', @MirrorTableName));

    SET @SourceTableName = '[' + SUBSTRING(@MirrorTableName, PATINDEX('%[_]%', @MirrorTableName) + 1, LEN(@MirrorTableName)) + ']';

    ---- Work out the remaining source table details from the config table and prefix.
    SELECT @LinkedServer = CASE
                               WHEN ISNULL([LinkedServer], '') = '' THEN
                                   ''
                               ELSE
                                   '[' + [LinkedServer] + '].'
                           END,
           @SourceDatabase = '[' + [DatabaseName] + '].',
           @SourceSchemaName = '[' + [SchemaName] + '].'
    FROM [Mirror].[mrr_config].[SourceSystem]
    WHERE TablePrefix = @Prefix;

    RETURN @LinkedServer + @SourceDatabase + @SourceSchemaName + @SourceTableName;

END;


GO
