SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE PROCEDURE [HIE_CNS].[uspCNS_Populate_Demographics]
AS

/*
test Script:

EXEC HIE_CNS.uspCNS_Populate_Demographics

--truncate table [dbo].[TableTracker]
*/

DECLARE @ExtractDate DATETIME = GETDATE();

DECLARE @Max_Date DATETIME

SET @Max_Date = ISNULL((SELECT MAX(MaxUpdateTime)  FROM [dbo].[TableTracker] WHERE TABLE_NAME = 'tblCNS_Demographics'),'1 Jan 1900')

DECLARE @LoadId int = ISNULL((SELECT MAX(LoadID)  FROM [dbo].[TableTracker] WHERE TABLE_NAME = 'tblCNS_Demographics'),0)
SET @LoadId = @LoadId + 1

SET NOCOUNT ON;

BEGIN TRY

	BEGIN TRANSACTION;

	TRUNCATE TABLE [HIE_CNS].[tblCNS_Demographics]

	INSERT INTO [HIE_CNS].[tblCNS_Demographics]
	SELECT   [PatientNo]
			,[UpdatedDate]
			,[NHSNo]
			,[Title]
			,[Surname]
			,[Forenames]
			,[MaritalStatus]
			,[Sex]
			,[DOB]
			,[Address1]
			,[Address2]
			,[Address3]
			,[Address4]
			,[Address5]
			,[PostCode]
			,[HomeTelephone]
			,[WorkTelephone]
			,[MobileTelephone]
			,[Email]
			,[DeathDate]
			,[Deceased]
			,[GPCode]
			,[GPPracticeCode]
			,[Religion]
			,[EthnicOrigin]
			,[SpokenLanguage]
			,0 AS ContainsInvalidChar
			, @LoadId
	FROM [HIE_CNS].[vwCNS_Demographics] 
	WHERE [UpdatedDate] > @Max_Date

	
	-- delete from Tracker table 
	DECLARE @newRecords INT

	SET @newRecords = (SELECT COUNT(*) FROM [HIE_CNS].[tblCNS_Demographics] WHERE LoadID = @LoadId)

	IF @newRecords > 0
	BEGIN 
		INSERT INTO [dbo].[TableTracker] VALUES ('HIE_CNS', 'tblCNS_Demographics',@ExtractDate, (SELECT ISNULL(MAX([UpdatedDate]),GETDATE()) FROM [HIE_CNS].[tblCNS_Demographics]), @LoadId, @newRecords)
	END

	COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH

 
GO
