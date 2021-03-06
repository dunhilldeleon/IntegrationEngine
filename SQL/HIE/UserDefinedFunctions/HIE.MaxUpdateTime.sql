SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
/*==========================================================================================================================================
For a given table, returns the most recent maximum UpdatedDate.

Test:

DECLARE @MaxUpdated DATETIME2,
        @TableName NVARCHAR(128) = 'Demographic';

SET @MaxUpdated = [Graphnet].[MaxUpdateTime](@TableName);

SELECT @MaxUpdated;

History:
21/06/2018 OBMH\Steve.Nicoll  Initial version.

==========================================================================================================================================*/
CREATE FUNCTION [HIE].[MaxUpdateTime]
(
    @TableName NVARCHAR(128)
)
RETURNS DATETIME2
AS
BEGIN
    DECLARE @CurrentMaxUpdateTime DATETIME2;

    SELECT @CurrentMaxUpdateTime = MAX([MaxUpdateTime])
    FROM [dbo].[TableTracker]
    WHERE [TABLE_NAME] = @TableName;

    RETURN @CurrentMaxUpdateTime;

END;

GO
