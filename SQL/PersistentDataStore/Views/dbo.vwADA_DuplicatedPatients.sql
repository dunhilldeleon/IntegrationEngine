SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON






CREATE VIEW [dbo].[vwADA_DuplicatedPatients]
AS

WITH main AS 
(
		SELECT DISTINCT Matching_ID, Patient_ID1, Patient_ID2, P1_NHS_Number, P2_NHS_Number, c.MatchingOn
		FROM  [dbo].[tblADA_DQ_Issues_DuplicatedPatients] dq 
		   CROSS APPLY
		(
			SELECT 'HomePhone'
			WHERE HomePhone_Matching <> '' 
			UNION ALL
			SELECT 'Mobile'
			WHERE MobilePhone_Matching  <> '' 
			UNION ALL
			SELECT 'OtherPhone'
			WHERE OtherPhone_Matching  <> '' 
			UNION ALL
			SELECT 'Address'
			WHERE Address_Matching  <> '' 
			UNION ALL
			SELECT 'Postcode'
			WHERE PostCode_Matching  <> ''  
			UNION ALL
			SELECT 'Practice'
			WHERE Practice_Matching  <> '' 
		)                                                            c(MatchingOn)
)
, main2 AS 
(
	SELECT DISTINCT  [Matching_ID]
		  ,[Patient_ID1]
		  ,[Patient_ID2]
		  ,[P1_NHS_Number]
		  ,[P2_NHS_Number]
		  , 'Forename, Surname, DoB, ' + 
			(	SELECT  STUFF((
				SELECT   ', ' + CAST(MatchingOn AS VARCHAR(MAX))
				FROM main b
				WHERE a.[Patient_ID1] = b.[Patient_ID1]
				AND a.[Patient_ID2] = b.[Patient_ID2]
				FOR XML PATH('')
				), 1, 2, '')
			)  AS Matching_ON
	
	FROM main a 
	--WHERE Patient_ID1 = 283919
)
SELECT  [Matching_ID]
      , [Patient_ID1]
      , [Patient_ID2]
      , [P1_NHS_Number]
      , [P2_NHS_Number]
	  , CASE WHEN ISNULL(p.P1_NHS_Number,'x') = ISNULL(p.P2_NHS_Number , 'y') THEN 'Same NHSNo.' END AS SameNHSNoFlag
      , [Matching_ON]
	  , (SELECT COUNT(*) FROM mrr.ADA_Case p1 WHERE p1.PatientRef = p.Patient_ID1) Pat1_No_Cases
	  , (SELECT COUNT(*) FROM mrr.ADA_Case p2 WHERE p2.PatientRef = p.Patient_ID2) Pat2_No_Cases
	  , (SELECT MAX(p1.EditDate) FROM mrr.ADA_Case p1 WHERE p1.PatientRef = p.Patient_ID1) Pat1_LatestCaseEditDate
	  , (SELECT MAX(p2.EditDate) FROM mrr.ADA_Case p2 WHERE p2.PatientRef = p.Patient_ID2) Pat2_LatestCaseEditDate
	  , p1.NationalCodeSourceDatabase AS P1_PDSTrace
	  , p2.NationalCodeSourceDatabase AS P2_PDSTrace
  FROM main2 p
  LEFT JOIN mrr.ADA_Patient p1
	ON p.Patient_ID1 = p1.PatientRef
  LEFT JOIN mrr.ADA_Patient p2
	ON p.Patient_ID2 = p2.PatientRef



GO
