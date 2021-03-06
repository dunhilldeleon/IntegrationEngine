SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
/*==========================================================================================================================================
Run the reconcile procedures for all current Mirror tables.

Test:
EXECUTE [mrr].[ReconcileAll]

History:
03/07/2018 OBMH\Steve.Nicoll  Initial version.
21/08/2018 OBMH\Steve.Nicoll  Prevent reconciliation of SG as it is not log shipped and data is always changing.

==========================================================================================================================================*/
CREATE PROCEDURE [mrr].[ReconcileAll]
AS
DECLARE @RoutineName NVARCHAR(128),
        @SQL NVARCHAR(MAX);

DECLARE [MirrorCursor] CURSOR FORWARD_ONLY LOCAL READ_ONLY FOR
SELECT [RecProc].[ROUTINE_NAME]
FROM [INFORMATION_SCHEMA].[ROUTINES] [RecProc]
    INNER JOIN [INFORMATION_SCHEMA].[TABLES] [RecTable]
        ON ('reconcile_' + [RecTable].[TABLE_NAME] = [RecProc].[ROUTINE_NAME])
WHERE [RecProc].[ROUTINE_SCHEMA] = 'mrr_tbl'
      AND [RecProc].[ROUTINE_TYPE] = 'PROCEDURE'
      AND [RecProc].[ROUTINE_NAME] LIKE 'reconcile[_]%'
      AND [RecTable].[TABLE_SCHEMA] = 'mrr_tbl'
      AND [RecTable].[TABLE_TYPE] = 'BASE TABLE'
	  AND [RecProc].[ROUTINE_NAME] NOT LIKE 'reconcile[_]SG[_]%'  -- Workaround as SG is a real-time access database - not log shipped - so unlikely ever to reconcile.
ORDER BY [RecProc].[ROUTINE_NAME];

OPEN [MirrorCursor];

FETCH NEXT FROM [MirrorCursor]
INTO @RoutineName;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @SQL = N'EXECUTE [mrr_tbl].[' + @RoutineName + N']';
    EXECUTE(@SQL);
    FETCH NEXT FROM [MirrorCursor]
    INTO @RoutineName;
END;

CLOSE [MirrorCursor];

DEALLOCATE [MirrorCursor];



GO
