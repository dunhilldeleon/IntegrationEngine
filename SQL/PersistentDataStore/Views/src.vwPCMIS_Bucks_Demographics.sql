SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON







CREATE VIEW [src].[vwPCMIS_Bucks_Demographics]
AS

--WITH Recent_Pat AS 
--( SELECT  pat.NHSNumber, rd.CaseNumber, pat.PatientID, ca.CreateDate, rd.GPCode, ROW_NUMBER() OVER(PARTITION BY pat.NHSNumber ORDER BY ISNULL(ca.CreateDate,GETDATE()) DESC) AS ordr
--  FROM [mrr].[PCMSBCKS_PatientDetails] pat 
--  LEFT JOIN [mrr].[PCMSBCKS_ReferralDetails] rd 
--	ON pat.PatientID = rd.PatientID
--  LEFT JOIN [mrr].[PCMSBCKS_CasesAll] ca
--	ON rd.CaseNumber = ca.CaseNumber
--  WHERE ISNULL(pat.NHSNumber ,'') != ''
--)
WITH Recent_Pat AS 
( SELECT  pat.NHSNumber, rd.CaseNumber, pat.PatientID, ca.CreateDate, rd.GPCode
	, ROW_NUMBER() OVER(PARTITION BY (SOUNDEX(REPLACE(REPLACE(REPLACE(UPPER(FirstName),' ',''),'-',''),'''',''))
						+ SOUNDEX(REPLACE(REPLACE(REPLACE(UPPER(LastName),' ',''),'-',''),'''',''))
						+ CONVERT(VARCHAR(10),ISNULL(DOB,''),112 )
						--+ REPLACE(REPLACE(REPLACE(UPPER(Address1),' ',''),'-',''),'''','') 
						+ REPLACE(UPPER(PostCode),' ','')
			) ORDER BY ISNULL(ca.CreateDate,GETDATE()) DESC) AS ordr
  FROM [mrr].[PCMSBCKS_PatientDetails] pat 
  LEFT JOIN [mrr].[PCMSBCKS_ReferralDetails] rd 
	ON pat.PatientID = rd.PatientID
  LEFT JOIN [mrr].[PCMSBCKS_CasesAll] ca
	ON rd.CaseNumber = ca.CaseNumber
  WHERE pat.LastName NOT LIKE '%XX%TEST%%'
  AND ISNULL(pat.NHSNumber ,'') != ''
  AND pat.NHSNumber NOT IN ('0000000000','1111111111','2222222222','3333333333','4444444444','5555555555','6666666666','7777777777','8888888888','9999999999')
)
SELECT  CAST(pc.CreateDate AS DATETIME)  AS CaseStart_Dttm
      , pc.CaseNumber
	  , pat.[PatientID]
      , LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(pat.[FirstName],' ','<>'),'><',''),'<>',' '))),50) AS [FirstName]
      , LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(pat.[MiddleName],' ','<>'),'><',''),'<>',' '))),50) AS [MiddleName]
      , LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(pat.[LastName],' ','<>'),'><',''),'<>',' '))),50) AS [LastName]
      , LTRIM(RTRIM(REPLACE(pat.[DisplayName],'  ',''))) AS [DisplayName]
      , ttl.Title_Desc AS [Title]
      , pat.[DOB]
      , CAST(REPLACE(REPLACE(pat.[NHSNumber],' ',''),'-','') AS VARCHAR(10))  AS [NHSNumber]
      , CASE WHEN LEN(ISNULL(pat.[Gender],'')) = 0 THEN 0
			 ELSE pat.[Gender]
		END AS Gender_ID
      , LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(pat.[Address1],' ','<>'),'><',''),'<>',' '))) AS [Address1]
      , LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(pat.[Address2],' ','<>'),'><',''),'<>',' '))) AS [Address2]
      , LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(pat.[TownCity],' ','<>'),'><',''),'<>',' ')))	AS [Address3]
      , pat.[County]	AS [Address4]
      , pat.[PostCode]	AS  [Postcode]
      , pat.[DateOfDeath]
      , GPCode AS PracticeCode
      , [MainLanguage]
      , [MaritalStatus]
      , CASE WHEN LEN(ISNULL([Ethnicity],'')) <> 1 THEN 'Z'
			 ELSE [Ethnicity]
		END AS [Ethnicity]
      , CASE WHEN LEN(ISNULL([Religion],'')) <> 1 THEN 'N'
			 ELSE [Religion]
		END AS [Religion]
	  , pc.CreateDate AS CreatedDate
	  , pc.CreateDate AS UpdatedDate
	  
FROM [mrr].[PCMSBCKS_PatientDetails] pat 
INNER JOIN Recent_Pat pc 
	ON pat.PatientID = pc.PatientID
	AND pc.ordr = 1 
LEFT JOIN mrr.CNC_tblTitleValues ttl  
	ON  CASE WHEN REPLACE(REPLACE(pat.Title,' ',''),'.','') = 'Mss' THEN 'Miss'
			 WHEN REPLACE(REPLACE(pat.Title,' ',''),'.','') = 'Mt' THEN 'Mr'
			 WHEN REPLACE(REPLACE(pat.Title,' ',''),'.','') = 'Nr' THEN 'Mr'
			 WHEN REPLACE(REPLACE(pat.Title,' ',''),'.','') = 'Ns' THEN 'Ms'
			 WHEN REPLACE(REPLACE(pat.Title,' ',''),'.','') = 'Reverand' THEN 'Rev'
			 ELSE REPLACE(REPLACE(pat.Title,' ',''),'.','') 
	    END = REPLACE(ttl.Title_Desc,' ','') COLLATE Latin1_General_CI_AS
WHERE ISNULL(pat.NHSNumber ,'') != ''
--AND pat.NHSNumber = '6146980358'

GO
