SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON



/*==========================================================================================================================================
Notes:


Test:

DECLARE @PKJoin NVARCHAR(MAX)

SET @PKJoin =  mrr.GetPKJoin('CNC_tblTeamMember', 'wrk', 'tgt');

SELECT @PKJoin

History:
11/04/2018 OBMH\Steve.Nicoll Initial version.
18/01/2019 OBMH\Steve.Nicoll Added optional alias names.

==========================================================================================================================================*/

CREATE FUNCTION [mrr].[GetPKJoin]
(
    @MirrorTableName NVARCHAR(128),
	@tgtAliasName NVARCHAR(128) = N'tgt',
	@srcAliasName NVARCHAR(128) = N'src'
)
RETURNS NVARCHAR(MAX)
AS
BEGIN


    SET @tgtAliasName = ISNULL(@tgtAliasName, N'tgt');
    SET @srcAliasName = ISNULL(@srcAliasName, N'src');

    SET @MirrorTableName = REPLACE(REPLACE(@MirrorTableName, '[', ''), ']', '');

    RETURN STUFF(
           (
               SELECT ' AND ' + @tgtAliasName + '.[' + PKColumns.COLUMN_NAME + '] = ' + @srcAliasName+ '.[' + PKColumns.COLUMN_NAME + ']'
               FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS PKConstraint
                   INNER JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE PKColumns
                       ON (
                              PKColumns.CONSTRAINT_NAME = PKConstraint.CONSTRAINT_NAME
                              AND PKColumns.TABLE_SCHEMA = PKConstraint.TABLE_SCHEMA
                              AND PKColumns.TABLE_NAME = PKConstraint.TABLE_NAME
                          )
               WHERE PKConstraint.TABLE_SCHEMA = 'mrr_wrk'
                     AND PKConstraint.TABLE_NAME = @MirrorTableName
                     AND PKConstraint.CONSTRAINT_TYPE = 'PRIMARY KEY'
               FOR XML PATH('')
           ),
           1,
           5,
           ''
                );
END;


GO
