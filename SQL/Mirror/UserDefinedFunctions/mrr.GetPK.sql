SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON



/*==========================================================================================================================================
Notes: Return the list of PK columns for selected Mirror table.


Test:

DECLARE @PK NVARCHAR(MAX)

SET @PK =  mrr.GetPK('CNC_tblTeamMember', 'wrk');

SELECT @PK

History:
18/01/2019 OBMH\Steve.Nicoll Initial version.

==========================================================================================================================================*/

CREATE FUNCTION [mrr].[GetPK]
(
    @MirrorTableName NVARCHAR(128),
    @AliasName NVARCHAR(128) = N''
)
RETURNS NVARCHAR(MAX)
AS
BEGIN

    SET @AliasName = ISNULL(@AliasName, N'');

    IF @AliasName <> ''
        SET @AliasName = @AliasName + '.';

    SET @MirrorTableName = REPLACE(REPLACE(@MirrorTableName, '[', ''), ']', '');

    RETURN STUFF(
           (
               SELECT ', ' + @AliasName + '[' + PKColumns.COLUMN_NAME + ']'
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
           2,
           ''
                );
END;


GO
