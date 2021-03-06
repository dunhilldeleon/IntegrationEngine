SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
/*==========================================================================================================================================
Populate each Graphnet table in turn. Runs sequencially so we should look to find
a parallel solution going forward.

Test: (best set this up as a SQL Agent job rather than run interactively.

EXECUTE Graphnet.uspPopulateAllTables

History:
24/06/2018 OBMH\Steve.Nicoll  Initial version.

==========================================================================================================================================*/
CREATE PROCEDURE [Graphnet].[uspPopulateAllTables]
AS
DECLARE @TableName NVARCHAR(128);

DECLARE [GraphnetTables] CURSOR LOCAL READ_ONLY STATIC FORWARD_ONLY FOR
SELECT [TABLE_NAME]
FROM [INFORMATION_SCHEMA].[TABLES]
WHERE [TABLE_SCHEMA] = 'Graphnet'
      AND [TABLE_TYPE] = 'BASE TABLE'
ORDER BY [TABLE_NAME];

OPEN [GraphnetTables];

FETCH NEXT FROM [GraphnetTables]
INTO @TableName;


WHILE @@FETCH_STATUS = 0
BEGIN

    EXECUTE [Graphnet].[uspPopulateTable] @TableName = @TableName;

    FETCH NEXT FROM [GraphnetTables]
    INTO @TableName;
END;


CLOSE [GraphnetTables];
DEALLOCATE [GraphnetTables];

GO
