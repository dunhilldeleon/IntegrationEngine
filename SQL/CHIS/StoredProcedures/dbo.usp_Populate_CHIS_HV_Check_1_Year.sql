SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


-- To extract all Children who have had a 9-12 Month Review completed
-- This is found in the Child Health Module
-- The Row_NUmber SQL is to order the 9-12 Month Review by whether it has been completed and the date to make
-- sure only those completed and the first one of these for each child is extracted


CREATE PROCEDURE  [dbo].[usp_Populate_CHIS_HV_Check_1_Year]
AS

/*
Test Script:
===========
EXEC [dbo].[Populate_CHIS_HV_Check_1_Year] '17 Sep 2018','21 Sep 2018'
SELECT * FROM [chis].[tblCHIS_TableTracker] 


Development Comments:
=====================
Part 1 - Read the maximum Update datetime for TABLE_NAME = '1_Year' from [chis].[tblCHIS_TableTracker] and generate new load id (previous load id  + 1)
Part 2 - Truncate and populate table chis.tblCHIS_HV_Check_1_Year
Part 3 - log the new data load info to [chis].[tblCHIS_TableTracker] including the new maximum Update datetime and load id

*/


DECLARE @Max_Date DATETIME
SET @Max_Date = ISNULL((SELECT MAX(MaxUpdateTime) FROM [chis].[tblCHIS_TableTracker] WHERE TABLE_NAME = '1_Year'),'1 Jan 1900')

DECLARE @LoadId int = ISNULL((SELECT MAX(LoadID) FROM [chis].[tblCHIS_TableTracker] WHERE TABLE_NAME = '1_Year'),0)
SET @LoadId = @LoadId + 1



--ALTER TABLE chis.tblCHIS_HV_Check_1_Year ADD LoadID int 

SET NOCOUNT ON;

BEGIN TRY

	BEGIN TRANSACTION;

		TRUNCATE TABLE chis.tblCHIS_HV_Check_1_Year


		SELECT * 
		INTO #Temp_NineTo12HVReview
		FROM (SELECT	[CarenotesPatientId]
						, D.[NHS_Number] AS 'NHS_Number'
						, [LongName]
						, CASE WHEN [OutcomeDesc] IS NULL THEN 'Unoutcomed' ELSE OutcomeDesc END AS 'NineTo12Review'
						, [DateOutcome] AS 'Date_of_Nineto12Review'
						, DATEDIFF (MONTH,D.[Date_Of_Birth],[DateOutcome]) AS 'MonthsTo9to12Review'
						, reviewlocationdesc
						, ROW_NUMBER() OVER(PARTITION BY CarenotesPatientId ORDER BY case when [OutcomeCode] in ('as','hrcom') then 0 else 1 end asc,[DateOutcome] asc) as rn
				FROM [dbo].[ReportPatientReview] R  
				LEFT OUTER JOIN [mrr].[CNC_tblPatient] D 
					ON R.CarenotesPatientId = RIGHT (D.Patient_ID, 6) --AND D.EPR_System = 'CNS_CH'
				WHERE LongName LIKE '%9-12 Month Health Visiting Review%'
				AND [OutcomeDesc] in ('Completed','Did Not Attend','Declined','Refused') 
			  )AS X

				
      
		WHERE RN = 1
		and Date_of_Nineto12Review > @Max_Date  --  BETWEEN @StaDate AND @EndDate -- 
		AND NineTo12Review = 'Completed'

		INSERT INTO chis.tblCHIS_HV_Check_1_Year ([NHS_Number],[forename],[surname],[Child_DOB],[Child_Gender],[Date_of_contact],[Review_Location_Desc],[Created_Dttm], LoadID)
		select distinct
				tmp.NHS_Number
				, p.forename
				, p.surname
				, convert(date,p.date_of_birth) as 'Child_DOB'
				, case
						 when p.Gender_ID = 0 then 'Not known'
						 when p.Gender_ID = 1 then 'Not specified'
						 when p.Gender_ID = 2 then 'Female'
						 when p.Gender_ID = 3 then 'Male'
						 when p.Gender_ID = 4 then 'Prefer not to say' 
				   end as 'Child_Gender'
				, convert(date,tmp.Date_of_Nineto12Review) as 'Date_of_contact'
				, tmp.ReviewLocationDesc
				, Date_of_Nineto12Review
				, @LoadId
		from #Temp_NineTo12HVReview tmp

		left join  [mrr].[CNC_tblPatient] p--[OXH_EDM_LIVE].[dbo].[CNC_tblPatient] p 
		on tmp.NHS_Number = p.NHS_Number
		where tmp.NHS_Number is not null


		-- delete from Tracker table 
			DECLARE @newRecords INT

			SET @newRecords = (SELECT COUNT(*) FROM chis.tblCHIS_HV_Check_1_Year WHERE LoadID = @LoadId)

			IF @newRecords > 0
			BEGIN 
				INSERT INTO [chis].[tblCHIS_TableTracker] values ('1_Year', getdate() , (select isnull(max(Created_Dttm),getdate()) from chis.tblCHIS_HV_Check_1_Year), @LoadId)
			END 

		drop table #Temp_NineTo12HVReview

		COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH;
GO
