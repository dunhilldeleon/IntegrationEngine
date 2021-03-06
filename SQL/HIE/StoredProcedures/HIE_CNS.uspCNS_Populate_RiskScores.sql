SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE PROCEDURE [HIE_CNS].[uspCNS_Populate_RiskScores]
AS
 
/*
test Script:

EXEC HIE_CNS.uspCNS_Populate_RiskScores

--select * from  [HIE_CNS].[tblCNS_RiskScores]

select * from [dbo].[TableTracker]

*/


DECLARE @ExtractDate DATETIME = GETDATE();

DECLARE @Max_Date DATETIME

SET @Max_Date = ISNULL((SELECT MAX(MaxUpdateTime)  FROM [dbo].[TableTracker] WHERE TABLE_NAME = 'tblCNS_RiskScores'),'1 Jan 1900')

DECLARE @LoadId int = ISNULL((SELECT MAX(LoadID)  FROM [dbo].[TableTracker] WHERE TABLE_NAME = 'tblCNS_RiskScores'),0)
SET @LoadId = @LoadId + 1


SET NOCOUNT ON;

BEGIN TRY

	BEGIN TRANSACTION;

	TRUNCATE TABLE [HIE_CNS].[tblCNS_RiskScores]

	INSERT INTO [HIE_CNS].[tblCNS_RiskScores]
	SELECT [RiskScoreID]
		  ,[RiskAssessmentID]
		  ,[PatientID]
		  ,[UpdatedDate]
		  ,[RiskDescription]
		  ,[RiskStatus]
		  ,[Deleted]
		  , 0 AS [ContainsInvalidChar]
		  , @LoadId
		  , [Order]
	FROM [HIE_CNS].[vwCNS_RiskScores]
	WHERE [UpdatedDate] > @Max_Date

	
	-- delete from Tracker table 
	DECLARE @newRecords INT

	SET @newRecords = (SELECT COUNT(*) FROM [HIE_CNS].[tblCNS_RiskScores] WHERE LoadID = @LoadId)

	IF @newRecords > 0
	BEGIN 
		INSERT INTO [dbo].[TableTracker] VALUES ('HIE_CNS', 'tblCNS_RiskScores',@ExtractDate, (SELECT ISNULL(MAX([UpdatedDate]),GETDATE()) FROM [HIE_CNS].[tblCNS_RiskScores]), @LoadID, @newRecords)
	END

	COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH

 
GO
