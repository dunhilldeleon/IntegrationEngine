SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON





CREATE VIEW [dbo].[vwADA_CNC_DQ_Issues_Mismatch_NHSNumber]
AS

WITH main AS 
(
		SELECT DISTINCT Matching_ID, [CH_Patient_ID], [CH_Forename],[CH_Surname], [ada_Patient_ID], [CH_NHS_Number], [ada_NHS_Number], c.MatchingOn
		FROM  [dbo].[tblADA_CNC_DQ_Issues_Mismatch_NHSNumber] abc -- [dbo].[tblCNS_DQ_Issues_DuplicatedPatients] dq
		   CROSS APPLY
		(
			SELECT 'HomePhone'
			WHERE HomePhone_Matching <> '' 
			UNION ALL
			SELECT 'Mobile'
			WHERE MobilePhone_Matching  <> '' 
			UNION ALL
			SELECT 'WorkPhone'
			WHERE WorkPhone_Matching  <> '' 
			UNION ALL
			SELECT 'Address'
			WHERE Address_Matching  <> '' 
			UNION ALL
			SELECT 'Postcode'
			WHERE PostCode_Matching  <> '' 
		)                                                            c(MatchingOn)
)

SELECT DISTINCT  Matching_ID
	, [CH_Patient_ID]
	, [CH_Forename]
	, [CH_Surname]
	, [ada_Patient_ID]
	, [CH_NHS_Number]
	, [ada_NHS_Number]
	  , 'Forename, Surname, DoB, ' + 
		(	SELECT  STUFF((
			SELECT   ', ' + CAST(MatchingOn AS VARCHAR(MAX))
			FROM main b
			WHERE a.[CH_Patient_ID] = b.[CH_Patient_ID]
			AND a.[ada_Patient_ID] = b.[ada_Patient_ID]
			FOR XML PATH('')
			), 1, 2, '')
		)  AS Matching_ON
	
FROM main a 



GO
