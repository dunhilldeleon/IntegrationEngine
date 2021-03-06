SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


/*==========================================================================================================================================
Notes:


Test:

DECLARE @ColumnNameList NVARCHAR(MAX)

SET @ColumnNameList =  mrr.GetWorkingTableColumnNameList('CNS_tblTeamMember');

SELECT @ColumnNameList

History:
11/04/2018 OBMH\Steve.Nicoll Initial version.

==========================================================================================================================================*/

CREATE FUNCTION [mrr].[GetWorkingTableColumnNameList]
(
    @MirrorTableName NVARCHAR(128)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN

			SET @MirrorTableName = REPLACE(REPLACE(@MirrorTableName,'[',''),']','')

			RETURN STUFF((
                             SELECT ', [' + COLUMN_NAME + ']'
                             FROM INFORMATION_SCHEMA.COLUMNS
                             WHERE TABLE_SCHEMA = 'mrr_wrk'
                                   AND TABLE_NAME = @MirrorTableName
                             ORDER BY ORDINAL_POSITION ASC
                             FOR XML PATH('')
                         )
                        ,1
                        ,2
                        ,''
                        );

END;


GO
