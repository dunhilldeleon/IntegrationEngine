SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
/*==========================================================================================================================================
This procedure with raise an error if it finds that any loader in the mirror processing cube did not successfully complete.
Only run this at after Mirror processing is finished - otherwise it will raise an error for all the tables that have not
yet been loaded!

Test:

EXECUTE [mrr].[RaiseProcessErrors];

History:
21/08/2018 OBMH\Steve.Nicoll  Initial version.

==========================================================================================================================================*/
CREATE PROCEDURE [mrr].[RaiseProcessErrors]
AS
BEGIN

    --SET QUOTED_IDENTIFIER ON|OFF
    --SET ANSI_NULLS ON|OFF
    --GO
    DECLARE @IncompleteCount INT = 0,
            @ThrowMsg NVARCHAR(128);

    SELECT @IncompleteCount = COUNT(*)
    FROM [mrr_config].[ProcessingQueue]
    WHERE [ItemStatus] <> 'Completed';

    PRINT @IncompleteCount;

    IF @IncompleteCount <> 0
        THROW 51010, '', 1;

    IF @IncompleteCount > 0
    BEGIN
        SET @ThrowMsg = CAST(@IncompleteCount AS NVARCHAR(20)) + N' Mirror table(s) did not successfully load.';
        THROW 51010, @ThrowMsg, 1;
    END;

END;

GO
