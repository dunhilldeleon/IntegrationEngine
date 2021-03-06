SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
/*==========================================================================================================================================
Notes:
Template for reconciling a Mirror table against its source table.

Test:

EXECUTE mrr.GenerateReconcileProcedure CNS_tblLocation
EXECUTE mrr.GenerateReconcileProcedure CNS_tblLocation, 'F'

History:
11/04/2018 OBMH\Steve.Nicoll Initial version.

==========================================================================================================================================*/

CREATE PROCEDURE [mrr].[GenerateReconcileProcedure] @MirrorTableName NVARCHAR(128)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with statement count.
    SET NOCOUNT ON;
    DECLARE @ColumnNameList NVARCHAR(MAX),
            @SourceTableFullName NVARCHAR(MAX),
            @sql NVARCHAR(MAX),
            @ThrowMsg NVARCHAR(MAX);

    IF OBJECT_ID('mrr_tbl.reconcile_' + @MirrorTableName, 'P') IS NOT NULL
    BEGIN
        SET @sql = N'DROP PROCEDURE mrr_tbl.reconcile_' + @MirrorTableName;
        EXECUTE (@sql);
    END;

    SET @sql
        = N'
			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_<MirrorTableName>

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_<MirrorTableName>]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT ''In Mirror'' AS DiscrepancySource
							   ,<ColumnNameList>
						 FROM mrr_tbl.<MirrorTableName>
						 EXCEPT
						 SELECT ''In Mirror'' AS DiscrepancySource
							   ,<ColumnNameList>
						 FROM <SourceTableFullName>)
						UNION ALL
						(SELECT ''In Source'' AS DiscrepancySource
							   ,<ColumnNameList>
						 FROM <SourceTableFullName>
						 EXCEPT
						 SELECT ''In Source'' AS DiscrepancySource
							   ,<ColumnNameList>
						 FROM mrr_tbl.<MirrorTableName>))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, ''Mirror table mrr_tbl.<MirrorTableName> has discrepancies when compared to its source table.'', 1;

				END;
				';

    SET @ColumnNameList = mrr.GetComparisonColumnNameList(@MirrorTableName);
    SET @SourceTableFullName = mrr.GetSourceTableFullName(@MirrorTableName);;

    SET @sql
        = REPLACE(
                     REPLACE(REPLACE(@sql, '<MirrorTableName>', @MirrorTableName), '<ColumnNameList>', @ColumnNameList),
                     '<SourceTableFullName>',
                     @SourceTableFullName
                 );

    /*---------------------------------------------------------------------------------------------------------------------------------------
	Build the procedure.
	---------------------------------------------------------------------------------------------------------------------------------------*/
    IF (@sql IS NULL)
    BEGIN
        SET @ThrowMsg
            = N'Cannot create reconciliation procedure for ' + @MirrorTableName + N' as generate script is NULL.';
        THROW 51010, @ThrowMsg, 1;
    END;

    --SELECT @sql
	--PRINT @sql
    EXECUTE (@sql);

END;

GO
