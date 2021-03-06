SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE PROCEDURE [mrr].[GenerateMirrorObjects]
    /*==========================================================================================================================================
Notes:
This procedure creates the ancillary tables and viewused when loading a Mirror table using our standard load mechanism. It does not create
the Mirror table itself or its load procedure. There are separate procedures to do those things.
More details at: http://ITKB/display/ITKB/Creating+a+new+Mirror+table

Once these objects are built, the related view can be copied to the database that needs to access the Miorror table.

Test example:

EXECUTE mrr.GenerateMirrorTables 'CNS_testnopk', '', 'Y';
EXECUTE mrr.GenerateMirrorTables 'CNS_tblLocation', 'Updated_Dttm', 'Y';

History:
26/03/2018 OBMH\Steve.Nicoll Initial version.
18/01/2019 OBMH\Nicholas.Walne Removing Linked Server from generated view

==========================================================================================================================================*/
    @MirrorTable NVARCHAR(128)                -- This is the name of the table (with prefix) that has been created in the mrr_tbl schema on the mirror database.
   ,@ChangeDetectionColumn NVARCHAR(128) = '' -- TODO This is the name of the column in the source that detects changes in a source record. Currently assuming this to always be the same so may need some lookup logic here.
   ,@Verbose NVARCHAR(1) = N'N'
AS
SET NOCOUNT ON;

DECLARE @TargetDatabase NVARCHAR(255)
    = '' -- This is the database where the abstraction view should be created - if it's not the current database.
       ,@sql NVARCHAR(MAX)
       ,@TableSchema NVARCHAR(7) = 'mrr_tbl'
       ,@ViewSchema NVARCHAR(7) = 'mrr'
       ,@AuditSchema NVARCHAR(7) = 'mrr_aud'
       ,@WrkTableSchema NVARCHAR(7) = 'mrr_wrk';

DECLARE @MirrorTableName NVARCHAR(255)
    = '[' + DB_NAME() + '].[' + @TableSchema + '].[' + @MirrorTable + ']'  -- This is the how the target table will be referenced in the view.
       ,@ViewName NVARCHAR(255) = '[' + @ViewSchema + '].[' + @MirrorTable + ']'      -- This is the mirror view in the abstraction layer.
       ,@AuditTableName NVARCHAR(255) = '[' + @AuditSchema + '].[' + @MirrorTable + ']'  -- This is the working table that will stage the PKs and change detection column of the source records.
       ,@WrkTableName NVARCHAR(255) = '[' + @WrkTableSchema + '].[' + @MirrorTable + ']' -- This is the working table that will stage the PKs and change detection column of the source records.
       ,@column_list NVARCHAR(MAX)
       ,@pkcolumn_list NVARCHAR(MAX);

-- The following temp table is used when building the ancillary mirror tables.
IF OBJECT_ID('tempdb..#TempColumnList') IS NOT NULL
    DROP TABLE #TempColumnList;


-------------------------------------------------------------------------------------------------------------
--Create the abstraction layer view. This is how the outside world will access the mirror table.
-------------------------------------------------------------------------------------------------------------
IF @Verbose = N'Y'
    PRINT 'Creating view ' + @ViewName + '...';

IF OBJECT_ID(@ViewName, 'V') IS NOT NULL
BEGIN
    SET @sql = 'DROP VIEW ' + @ViewName + ';';
    IF @Verbose = N'Y'
        PRINT @sql;
    EXECUTE (@sql);
END;

SET @column_list = STUFF((
                             SELECT ', [' + COLUMN_NAME + ']'
                             FROM INFORMATION_SCHEMA.COLUMNS
                             WHERE TABLE_SCHEMA = 'mrr_tbl'
                                   AND TABLE_NAME = @MirrorTable
                             ORDER BY ORDINAL_POSITION ASC
                             FOR XML PATH('')
                         )
                        ,1
                        ,2
                        ,''
                        );

-- This is the template to create the view.
SET @sql = 'CREATE VIEW <view_name> AS SELECT <column_list> FROM <table_name>;';

SET @sql
    = REPLACE(
                 REPLACE(REPLACE(@sql, '<view_name>', @ViewName), '<column_list>', @column_list)
                ,'<table_name>'
                ,@MirrorTableName
             );

IF @Verbose = N'Y'
    PRINT @sql;
EXECUTE (@sql);

-------------------------------------------------------------------------------------------------------------
-- Create the working table for this mirror but only if there is a primary key and Change Detection Column -
-- otherwise it is of no use. The working table just holds the PK and the Change Detection Column and is
-- used in incremental loading.
-------------------------------------------------------------------------------------------------------------
IF OBJECT_ID(@WrkTableName, 'U') IS NOT NULL
BEGIN
    SET @sql = 'DROP TABLE ' + @WrkTableName + ';';
    IF @Verbose = N'Y'
        PRINT @sql;
    EXECUTE (@sql);
END;

SELECT cols.TABLE_SCHEMA
      ,cols.TABLE_NAME
      ,cols.COLUMN_NAME
      ,cols.DATA_TYPE
      ,cols.CHARACTER_MAXIMUM_LENGTH
      ,cols.NUMERIC_PRECISION
      ,cols.NUMERIC_SCALE
      ,'[' + cols.COLUMN_NAME + '] '
       + CASE
             WHEN cols.DATA_TYPE LIKE '%char' THEN
                 cols.DATA_TYPE + '(' + CAST(cols.CHARACTER_MAXIMUM_LENGTH AS NVARCHAR(30)) + ')'
             ELSE
                 cols.DATA_TYPE
         END AS ColumnWithDataType
      ,pk.CONSTRAINT_TYPE
      ,cols.ORDINAL_POSITION
INTO #TempColumnList
FROM INFORMATION_SCHEMA.COLUMNS AS cols
    LEFT OUTER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS colUsage
        ON (
               colUsage.TABLE_SCHEMA = cols.TABLE_SCHEMA
               AND colUsage.TABLE_NAME = cols.TABLE_NAME
               AND colUsage.COLUMN_NAME = cols.COLUMN_NAME
           )
    LEFT OUTER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS pk
        ON (
               pk.TABLE_SCHEMA = colUsage.TABLE_SCHEMA
               AND pk.TABLE_NAME = colUsage.TABLE_NAME
               AND pk.CONSTRAINT_NAME = colUsage.CONSTRAINT_NAME
               AND pk.CONSTRAINT_TYPE = 'PRIMARY KEY'
           )
WHERE cols.TABLE_SCHEMA = 'mrr_tbl'
      AND cols.TABLE_NAME = @MirrorTable;

IF EXISTS
(
    SELECT *
    FROM #TempColumnList AS SourceColumns
    WHERE SourceColumns.CONSTRAINT_TYPE = 'PRIMARY KEY'
)
   AND EXISTS
(
    SELECT *
    FROM #TempColumnList AS SourceColumns
    WHERE SourceColumns.COLUMN_NAME = @ChangeDetectionColumn
)
BEGIN
    IF @Verbose = N'Y'
        PRINT 'Creating working table ' + @WrkTableName + '...';

    SET @column_list = STUFF((
                                 SELECT ', ' + SourceColumns.ColumnWithDataType + ' NOT NULL'
                                 FROM #TempColumnList AS SourceColumns
                                 WHERE SourceColumns.CONSTRAINT_TYPE = 'PRIMARY KEY'
                                       OR SourceColumns.COLUMN_NAME = @ChangeDetectionColumn
                                 ORDER BY SourceColumns.ORDINAL_POSITION ASC
                                 FOR XML PATH('')
                             )
                            ,1
                            ,2
                            ,''
                            );

    SET @pkcolumn_list = STUFF((
                                   SELECT ', ' + SourceColumns.COLUMN_NAME + ' ASC'
                                   FROM #TempColumnList AS SourceColumns
                                   WHERE SourceColumns.CONSTRAINT_TYPE = 'PRIMARY KEY'
                                   ORDER BY SourceColumns.ORDINAL_POSITION ASC
                                   FOR XML PATH('')
                               )
                              ,1
                              ,2
                              ,''
                              );

    SET @sql
        = 'CREATE Table <working_table_name> (<column_list> ,CONSTRAINT pk<target_table>
        PRIMARY KEY CLUSTERED (<pkcolumn_list>));';
    SET @sql
        = REPLACE(
                     REPLACE(
                                REPLACE(
                                           REPLACE(@sql, '<working_table_name>', @WrkTableName)
                                          ,'<column_list>'
                                          ,@column_list
                                       )
                               ,'<target_table>'
                               ,@MirrorTable
                            )
                    ,'<pkcolumn_list>'
                    ,@pkcolumn_list
                 );

    IF @Verbose = N'Y'
        PRINT @sql;
    EXECUTE (@sql);
END;
ELSE
    PRINT 'Generate Warning: No working table was created for ' + @MirrorTableName
          + '. This Mirror table cannot be incrementally loaded.';


-------------------------------------------------------------------------------------------------------------
-- Create the audit table for this mirror.
-------------------------------------------------------------------------------------------------------------
IF @Verbose = N'Y'
    PRINT 'Creating audit table ' + @AuditTableName + '...';

IF OBJECT_ID(@AuditTableName, 'U') IS NOT NULL
BEGIN
    SET @sql = 'DROP TABLE ' + @AuditTableName + ';';
    IF @Verbose = N'Y'
        PRINT @sql;
    EXECUTE (@sql);
END;

SET @sql
    = 'CREATE TABLE <audit_table_name>
		(
			AuditID BIGINT NOT NULL IDENTITY(1, 1)
		   ,LoadType NVARCHAR(1) NULL
		   ,RunByUser NVARCHAR(128) NOT NULL
				CONSTRAINT DFAud_<target_table>_RunByUser DEFAULT SYSTEM_USER
		   ,StartTime DATETIME2 NULL
		   ,EndTime DATETIME2 NOT NULL 
				CONSTRAINT DFAud_<target_table>_EndTime DEFAULT GETDATE()
		   ,Duration
				AS DATEDIFF(MILLISECOND, StartTime, EndTime)
		   ,Inserted INTEGER NULL
		   ,Updated INTEGER NULL
		   ,Deleted INTEGER NULL
		   ,CONSTRAINT pkAud_<target_table>
				PRIMARY KEY CLUSTERED (AuditID ASC)
		);';
SET @sql = REPLACE(REPLACE(@sql, '<audit_table_name>', @AuditTableName), '<target_table>', @MirrorTable);

IF @Verbose = N'Y'
    PRINT @sql;
EXECUTE (@sql);

-------------------------------------------------------------------------------------------------------------
-- The End.
-------------------------------------------------------------------------------------------------------------

GO
