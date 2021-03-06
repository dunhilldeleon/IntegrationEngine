SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

-- To extract all Children who have had a 9-12 Month Review completed
-- This is found in the Child Health Module
-- The Row_NUmber SQL is to order the 9-12 Month Review by whether it has been completed and the date to make
-- sure only those completed and the first one of these for each child is extracted


CREATE PROCEDURE  [dbo].[usp_Populate_CHIS_School_Immunisations]
AS

/*
test Script:
================
EXEC [dbo].[Populate_CHIS_School_Immunisations]
SELECT * FROM [chis].[tblCHIS_TableTracker] 


Development Comments:
=====================
Part 1 - Read the maximum Update datetime for TABLE_NAME = 'School_Immunisation' from [chis].[tblCHIS_TableTracker] and generate new load id (previous load id  + 1)
Part 2 - Truncate and populate table chis.[tblCHIS_School_Immunisation]
	   - IMPORTANT - this procedures uses the view [CHIS].[dbo].[vwSchool_Immunisation_Report_CHIS] to populate chis.[tblCHIS_School_Immunisation] table
Part 3 - log the new data load info to [chis].[tblCHIS_TableTracker] including the new maximum Update datetime and load id



*/


DECLARE @Max_Date DATETIME
SET @Max_Date = ISNULL((SELECT MAX(MaxUpdateTime) FROM [chis].[tblCHIS_TableTracker] WHERE TABLE_NAME = 'School_Immunisation'), '31 Mar 2018')

DECLARE @LoadId int = ISNULL((SELECT MAX(LoadID) FROM [chis].[tblCHIS_TableTracker] WHERE TABLE_NAME = 'School_Immunisation'),0)
SET @LoadId = @LoadId + 1
print @LoadId


SET NOCOUNT ON;

BEGIN TRY

	BEGIN TRANSACTION;

		TRUNCATE TABLE [CHIS].[tblCHIS_School_Immunisation]

		INSERT INTO [CHIS].[tblCHIS_School_Immunisation]
		SELECT [NHSNumber]
			  ,[Surname]
			  ,[Forename]
			  ,[DateOfBirth]
			  ,[Gender]
			  ,[DateAttended]
			  ,[Venue]
			  ,[VaccineName]
			  ,[Site]
			  ,[BatchNumber]
			  ,@LoadId
			  ,VaccineNumber
		  FROM [CHIS].[dbo].[vwSchool_Immunisation_Report_CHIS]


		-- delete from Tracker table 
			DECLARE @newRecords INT

			SET @newRecords = (SELECT COUNT(*) FROM [CHIS].[tblCHIS_School_Immunisation] WHERE LoadID = @LoadId)

			IF @newRecords > 0
			BEGIN 
				INSERT INTO [chis].[tblCHIS_TableTracker] values ('School_Immunisation', getdate() , (select max([DateAttended]) from [CHIS].[tblCHIS_School_Immunisation] WHERE ISNULL([DateAttended],'' ) != ''), @LoadId)
			END 


		COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH;
GO
