SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE PROCEDURE [HIE_CNS].[uspCNS_Populate_RiskPlans]
AS
 
/*
test Script:

EXEC HIE_CNS.uspCNS_Populate_RiskPlans

--select * from  [HIE_CNS].[tblCNS_RiskPlans]

select * from [dbo].[TableTracker]

*/


DECLARE @ExtractDate DATETIME = GETDATE();

DECLARE @Max_Date DATETIME

SET @Max_Date = ISNULL((SELECT MAX(MaxUpdateTime)  FROM [dbo].[TableTracker] WHERE TABLE_NAME = 'tblCNS_RiskPlans'),'1 Jan 1900')

DECLARE @LoadId int = ISNULL((SELECT MAX(LoadID)  FROM [dbo].[TableTracker] WHERE TABLE_NAME = 'tblCNS_RiskPlans'),0)
SET @LoadId = @LoadId + 1

SET NOCOUNT ON;

BEGIN TRY

	BEGIN TRANSACTION;

	TRUNCATE TABLE [HIE_CNS].[tblCNS_RiskPlans]

	INSERT INTO [HIE_CNS].[tblCNS_RiskPlans]
	SELECT [RiskPlanID]
		  ,[RiskAssessmentID]
		  ,[PatientID]
		  ,[UpdatedDate]
		  ,[DateEntered]
		  ,[Field1Description]
		  ,[Field1Value]
		  ,[Deleted]
		  , 0 AS [ContainsInvalidChar]
		  , @LoadID
	FROM [HIE_CNS].[vwCNS_RiskPlans]
	WHERE [UpdatedDate] > @Max_Date

	
	-- delete from Tracker table 
	DECLARE @newRecords INT

	SET @newRecords = (SELECT COUNT(*) FROM [HIE_CNS].[tblCNS_RiskPlans] WHERE LoadID = @LoadId)

	IF @newRecords > 0
	BEGIN 
		INSERT INTO [dbo].[TableTracker] VALUES ('HIE_CNS', 'tblCNS_RiskPlans',@ExtractDate, (SELECT ISNULL(MAX([UpdatedDate]),GETDATE()) FROM [HIE_CNS].[tblCNS_RiskPlans]), @LoadId, @newRecords)
	END

	COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH

 
GO
