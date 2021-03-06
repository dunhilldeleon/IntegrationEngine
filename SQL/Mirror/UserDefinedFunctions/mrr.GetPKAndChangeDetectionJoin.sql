SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


/*==========================================================================================================================================
Notes:


Test:

DECLARE @PKJoin NVARCHAR(MAX)

SET @PKJoin =  mrr.GetPKAndChangeDetectionJoin('CNC_tblTeamMember');

SELECT @PKJoin

History:
11/04/2018 OBMH\Steve.Nicoll Initial version.

==========================================================================================================================================*/

CREATE FUNCTION [mrr].[GetPKAndChangeDetectionJoin]
(
    @MirrorTableName NVARCHAR(128)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN

    SET @MirrorTableName = REPLACE(REPLACE(@MirrorTableName, '[', ''), ']', '');

    RETURN STUFF(
           (
               SELECT ' AND tgt.[' + PKAndChangeDetectionColumns.COLUMN_NAME + '] = src.['
                      + PKAndChangeDetectionColumns.COLUMN_NAME + ']'
               FROM INFORMATION_SCHEMA.COLUMNS PKAndChangeDetectionColumns
               WHERE PKAndChangeDetectionColumns.TABLE_SCHEMA = 'mrr_wrk'
                     AND PKAndChangeDetectionColumns.TABLE_NAME = @MirrorTableName
               FOR XML PATH('')
           ),
           1,
           5,
           ''
                );
END;


GO
