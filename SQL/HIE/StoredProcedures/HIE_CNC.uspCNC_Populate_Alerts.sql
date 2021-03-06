SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE PROCEDURE [HIE_CNC].[uspCNC_Populate_Alerts]
AS

/*
test Script:

EXEC HIE_CNC.uspCNC_Populate_Alerts

--select * from  HIE_CNC].[tblCNC_Alerts]

select * from [dbo].[TableTracker]

*/

DECLARE @ExtractDate DATETIME = GETDATE();

DECLARE @Max_Date DATETIME

SET @Max_Date = ISNULL((SELECT MAX(MaxUpdateTime)  FROM [dbo].[TableTracker] WHERE TABLE_NAME = 'tblCNC_Alerts'),'1 Jan 1900')

DECLARE @LoadId int = ISNULL((SELECT MAX(LoadID)  FROM [dbo].[TableTracker] WHERE TABLE_NAME = 'tblCNC_Alerts'),0)
SET @LoadId = @LoadId + 1


SET NOCOUNT ON;

BEGIN TRY

	BEGIN TRANSACTION;

	TRUNCATE TABLE [HIE_CNC].[tblCNC_Alerts]

	INSERT INTO [HIE_CNC].[tblCNC_Alerts]
	SELECT   [PatientNo]
      ,[AlertOrder]
      ,[AlertCategory]
      ,[AlertType]
      ,[AlertTypeDescription]
      ,[AlertSubType]
      ,[AlertSubTypeDescription]
      ,[Severity]
      ,[Comments]
      ,[StartDate]
      ,[EndDate]
      ,[UpdatedDate]
      , 0 AS [ContainsInvalidChar]
	  ,@LoadId
	FROM [HIE_CNC].[vwCNC_Alerts] 
	WHERE [UpdatedDate] > @Max_Date

	
	-- delete from Tracker table 
	DECLARE @newRecords INT

	SET @newRecords = (SELECT COUNT(*) FROM [HIE_CNC].[tblCNC_Alerts] WHERE LoadID = @LoadId)

	IF @newRecords > 0
	BEGIN 
		INSERT INTO [dbo].[TableTracker] VALUES ('HIE_CNC', 'tblCNC_Alerts',@ExtractDate, (SELECT ISNULL(MAX([UpdatedDate]),GETDATE()) FROM [HIE_CNC].[tblCNC_Alerts]), @LoadId, @newRecords)
	END 

	COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH

 
GO
