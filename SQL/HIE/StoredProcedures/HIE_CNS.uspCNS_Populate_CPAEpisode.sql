SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE PROCEDURE [HIE_CNS].[uspCNS_Populate_CPAEpisode]
AS
 
/*
test Script:

EXEC HIE_CNS.uspCNS_Populate_CPAEpisode

--select * from  [HIE_CNS].[tblCNS_CPAEpisode]

select * from [dbo].[TableTracker]

*/


DECLARE @ExtractDate DATETIME = GETDATE();

DECLARE @Max_Date DATETIME

SET @Max_Date = ISNULL((SELECT MAX(MaxUpdateTime)  FROM [dbo].[TableTracker] WHERE TABLE_NAME = 'tblCNS_CPAEpisode'),'1 Jan 1900')

DECLARE @LoadId int = ISNULL((SELECT MAX(LoadID)  FROM [dbo].[TableTracker] WHERE TABLE_NAME = 'tblCNS_CPAEpisode'),0)
SET @LoadId = @LoadId + 1

SET NOCOUNT ON;

BEGIN TRY

	BEGIN TRANSACTION;

	TRUNCATE TABLE [HIE_CNS].[tblCNS_CPAEpisode]

	INSERT INTO [HIE_CNS].[tblCNS_CPAEpisode]
	SELECT   [CPAEpisodeID]
			,[PatientID]
			,[UpdatedDate]
			,[StartDate]
			,[EndDate]
			,[Details]
			,[Deleted]
			, 0 AS [ContainsInvalidChar]
			, @LoadId
	FROM [HIE_CNS].[vwCNS_CPAEpisode]
	WHERE [UpdatedDate] > @Max_Date

	
	-- delete from Tracker table 
	DECLARE @newRecords INT

	SET @newRecords = (SELECT COUNT(*) FROM [HIE_CNS].[tblCNS_CPAEpisode] WHERE LoadID = @LoadId)

	IF @newRecords > 0
	BEGIN 
		INSERT INTO [dbo].[TableTracker] VALUES ('HIE_CNS', 'tblCNS_CPAEpisode',@ExtractDate, (SELECT ISNULL(MAX([UpdatedDate]),GETDATE()) FROM [HIE_CNS].[tblCNS_CPAEpisode]), @LoadId, @newRecords)
	END

	COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH

 
GO
