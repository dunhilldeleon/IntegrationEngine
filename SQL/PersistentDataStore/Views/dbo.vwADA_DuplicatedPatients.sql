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


GO
