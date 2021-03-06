SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE PROCEDURE HIE_ADA.uspADA_Populate_UrgentCare
AS

DECLARE @MaxDateTime DATETIME = ISNULL((SELECT MAX([MaxUpdateTime]) FROM [HIE].[dbo].[TableTracker] WHERE TABLE_NAME= 'ADA_UrgentCare'),'1 Jan 1900') 
--SELECT @MaxDateTime

DECLARE @LoadID INT = ISNULL((SELECT MAX(LoadID) FROM [HIE].[dbo].[TableTracker] WHERE TABLE_NAME= 'ADA_UrgentCare'),1) 
SET @LoadID = @LoadID + 1
--SELECT @LoadID

DECLARE @count INT 

TRUNCATE TABLE [HIE_ADA].[tblADA_UrgentCare]

INSERT INTO [HIE_ADA].[tblADA_UrgentCare]
(
	CaseRef,
       Patient,
       Caseno,
       Gender,
       DOB,
       Age,
       NHSNumber,
       ServiceName,
       CurrentPhone,
       CurrentAddress,
       HomeAddress,
       HomePhone,
       CaseType,
       Location,
       CallOrigin,
       ReportedCondition,
       AdastraConsultBy,
       Role,
       [Consult Start],
       StartingType,
       EndingType,
       ConsultEnd,
       History,
       Examination,
       Diagnosis,
       Treatment,
       Prescriptions,
       ClinicalCodes,
       InformationalOutcomes
)
SELECT CaseRef,
       Patient,
       Caseno,
       Gender,
       DOB,
       Age,
       NHSNumber,
       ServiceName,
       CurrentPhone,
       CurrentAddress,
       HomeAddress,
       HomePhone,
       CaseType,
       Location,
       CallOrigin,
       ReportedCondition,
       AdastraConsultBy,
       Role,
       [Consult Start],
       StartingType,
       EndingType,
       ConsultEnd,
       History,
       Examination,
       Diagnosis,
       Treatment,
       Prescriptions,
       ClinicalCodes,
       InformationalOutcomes 
FROM HIE_ADA.vwADA_UrgentCare
WHERE ConsultEnd > @MaxDateTime
ORDER BY ConsultEnd

SET @count = @@rowcount

IF @count > 0 
BEGIN
		INSERT INTO [dbo].[TableTracker] 
			VALUES('ADA'
					, 'ADA_UrgentCare'
					, GETDATE()
					, (SELECT MAX(ConsultEnd) FROM [HIE_ADA].[tblADA_UrgentCare]) 
					, @LoadID
					, @count
					)
END 
GO
