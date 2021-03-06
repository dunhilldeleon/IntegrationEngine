SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON





CREATE  VIEW [dbo].[vwSchool_Immunisation_Report_CHIS]

AS

 SELECT DISTINCT   --p.Patient_ID 
	  p.NHS_Number					AS NHSNumber
	, P.Surname
	, p.Forename
	, CAST(p.Date_Of_Birth AS DATE) AS DateOfBirth
	, gen.Gender_Desc				AS Gender
	, CAST(ci.DateOccurred AS DATE) AS DateAttended
	, ci.TreatmentCentre 
	, ISNULL(sc.National_School_Code,sc1.National_School_Code)		AS Venue 
	, ci.ImmunisationPartDescription VaccineName
	, ci.SITE					AS [Site]
	, ci.BatchNumber
	, ci.ImmunisationPartNo		AS VaccineNumber
	--, ci.ImmunisationPartNo			AS PartNo
	--, ci.GivenBy
	--, ci.Outcome
	--, ci.WhereGiven
	--, ci.BatchExpiryDate
	--, ci.Route					AS [Route]
FROM PersistentDataStore.CHIS.tblChildImmunisation ci
LEFT JOIN mrr.CNC_tblPatient p
ON ci.CareNotesPatient_ID = p.Patient_ID
LEFT JOIN mrr.CNC_tblGenderValues gen ON gen.Gender_ID = p.Gender_ID
LEFT JOIN mrr.CNC_tblSchool sc ON  LTRIM(RTRIM(REPLACE( REPLACE(REPLACE(REPLACE(REPLACE(ci.TreatmentCentre,'''',''),'OXF-',''),'BER-',''),'SHNN',''),'SHNS','')))  = REPLACE(sc.School_Name,'''','')
LEFT JOIN mrr.CNC_tblSchool sc1 ON  REPLACE(ci.TreatmentCentre,'''','') = REPLACE(sc1.School_Name,'''','')
LEFT JOIN mrr.CNC_tblGPDetail gp ON p.Patient_ID = gp.Patient_ID AND gp.End_Date IS NULL 
LEFT JOIN  mrr.CNC_tblPractice prac ON prac.Practice_ID = gp.Practice_ID
WHERE p.Patient_Name NOT LIKE '%XX%Test%%'
AND LoadID = (SELECT MAX(LoadID) FROM PersistentDataStore.CHIS.tblChildImmunisation)
AND 
( ci.ImmunisationPartDescription LIKE '%ACWY%'
	OR ci.ImmunisationPartDescription LIKE '%MMR%'
	OR (ci.ImmunisationPartDescription LIKE '%Measles%' AND ci.ImmunisationPartDescription LIKE '%Mumps%' AND ci.ImmunisationPartDescription LIKE '%Rubella%')
	OR (ci.ImmunisationPartDescription LIKE '%Tetanus%' AND ci.ImmunisationPartDescription LIKE '%Diphtheria%' AND ci.ImmunisationPartDescription LIKE '%Polio%')
	OR ci.ImmunisationPartDescription LIKE '%HPV%'
	OR (ci.ImmunisationPartDescription LIKE '%Human%' AND ci.ImmunisationPartDescription LIKE '%Papillomavirus%')
	OR ci.ImmunisationPartDescription LIKE 'Flu %'
)


GO
