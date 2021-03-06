SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE PROCEDURE [HIE_CNS].[uspCNS_Populate_Diagnosis]
AS
 
/*
test Script:

EXEC HIE_CNS.uspCNS_Populate_Diagnosis

--select * from  [HIE_CNS].[tblCNS_Diagnosis]

select * from [dbo].[TableTracker]

*/

DECLARE @ExtractDate DATETIME = GETDATE();

DECLARE @Max_Date DATETIME

SET @Max_Date = ISNULL((SELECT MAX(MaxUpdateTime)  FROM [dbo].[TableTracker] WHERE TABLE_NAME = 'tblCNS_Diagnosis'),'1 Jan 1900')

DECLARE @LoadId int = ISNULL((SELECT MAX(LoadID)  FROM [dbo].[TableTracker] WHERE TABLE_NAME = 'tblCNS_Diagnosis'),0)
SET @LoadId = @LoadId + 1

SET NOCOUNT ON;

BEGIN TRY

	BEGIN TRANSACTION;

	TRUNCATE TABLE [HIE_CNS].[tblCNS_Diagnosis]

	INSERT INTO [HIE_CNS].[tblCNS_Diagnosis]
	SELECT [DiagnosisID]
      ,[PatientID]
      ,[UpdatedDate]
      ,[DiagnosisDate]
      ,[DiagnosisDescription]
      ,[Deleted]
      , 0 AS [ContainsInvalidChar]
	  , @LoadId
	FROM [HIE_CNS].[vwCNS_Diagnosis] 
	WHERE [UpdatedDate] > @Max_Date

	
	-- delete from Tracker table 
	DECLARE @newRecords INT

	SET @newRecords = (SELECT COUNT(*) FROM [HIE_CNS].[tblCNS_Diagnosis] WHERE LoadID = @LoadId)

	IF @newRecords > 0
	BEGIN 
		INSERT INTO [dbo].[TableTracker] VALUES ('HIE_CNS', 'tblCNS_Diagnosis',@ExtractDate, (SELECT ISNULL(MAX([UpdatedDate]),GETDATE()) FROM [HIE_CNS].[tblCNS_Diagnosis]), @LoadID, @newRecords)
	END

	COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH

 
GO
