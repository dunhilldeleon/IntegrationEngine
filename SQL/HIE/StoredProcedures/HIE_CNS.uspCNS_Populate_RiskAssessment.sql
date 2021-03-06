SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE PROCEDURE [HIE_CNS].[uspCNS_Populate_RiskAssessment]
AS
 
/*
test Script:

EXEC HIE_CNS.uspCNS_Populate_RiskAssessment

--select * from  [HIE_CNS].[tblCNS_RiskAssessment]

select * from [dbo].[TableTracker]

*/


DECLARE @ExtractDate DATETIME = GETDATE();

DECLARE @Max_Date DATETIME

SET @Max_Date = ISNULL((SELECT MAX(MaxUpdateTime)  FROM [dbo].[TableTracker] WHERE TABLE_NAME = 'tblCNS_RiskAssessment'),'1 Jan 1900')

DECLARE @LoadId int = ISNULL((SELECT MAX(LoadID)  FROM [dbo].[TableTracker] WHERE TABLE_NAME = 'tblCNS_RiskAssessment'),0)
SET @LoadId = @LoadId + 1

SET NOCOUNT ON;

BEGIN TRY

	BEGIN TRANSACTION;

	TRUNCATE TABLE [HIE_CNS].[tblCNS_RiskAssessment]

	INSERT INTO [HIE_CNS].[tblCNS_RiskAssessment]
	SELECT	 [RiskAssessmentID]
			,[PatientID]
			,[UpdatedDate]
			,[DateOfAssessment]
			,[ClinicalSetting]
			,[Assessor]
			,[Role]
			,[Deleted]
			, 0 AS [ContainsInvalidChar]
			, @LoadId
	FROM [HIE_CNS].[vwCNS_RiskAssessment]
	WHERE [UpdatedDate] > @Max_Date

	
	-- delete from Tracker table 
	DECLARE @newRecords INT

	SET @newRecords = (SELECT COUNT(*) FROM [HIE_CNS].[tblCNS_Notes] WHERE LoadID = @LoadId)

	IF @newRecords > 0
	BEGIN 
		INSERT INTO [dbo].[TableTracker] VALUES ('HIE_CNS', 'tblCNS_RiskAssessment',@ExtractDate, (SELECT ISNULL(MAX([UpdatedDate]),GETDATE()) FROM [HIE_CNS].[tblCNS_RiskAssessment]), @LoadID, @newRecords)
	END

	COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH

 
GO
