SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
/*==========================================================================================================================================
Return the current Graphnet EXtractID (created using Graphnet.uspStartNewExtract).

Test:

DECLARE @ExtractID BIGINT;

SET @ExtractID = [Graphnet].[CurrentExtractID]();

SELECT @ExtractID;


History:
21/06/2018 OBMH\Steve.Nicoll  Initial version.

==========================================================================================================================================*/
 
CREATE FUNCTION [HIE].[CurrentExtractID]
()
RETURNS BIGINT
AS
BEGIN
    DECLARE @ExtractID BIGINT;

    SET @ExtractID =
    (
        SELECT TOP 1
               [ExtractID]
        FROM [dbo].[ExtractTracker]
        ORDER BY [ExtractID] DESC
    );

    RETURN @ExtractID;

END;

GO
