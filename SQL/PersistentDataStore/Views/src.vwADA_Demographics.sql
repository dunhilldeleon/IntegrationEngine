SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON






CREATE VIEW [src].[vwADA_Demographics]

AS

WITH CreateDt AS
 (
	 SELECT [PatientRef], MIN(EditDate) [CreatedDate]
	 FROM 
		 (
		 SELECT [PatientRef], EditDate FROM [mrr].[ADA_PatientAudit]
		 UNION ALL
		 SELECT [PatientRef], EditDate FROM [mrr].[ADA_Patient]
		 ) a
	 GROUP BY [PatientRef]
 )
 , unique_Pat AS 
(
	SELECT  [NationalCode], MAX(LocalID) AS LocalID
	FROM [mrr].[ADA_Patient]
	WHERE ISNULL([NationalCode], '') <> ''
	GROUP BY [NationalCode]

	--UNION 

	--SELECT  NULL ,  LocalID
	--FROM [mrr].[ADA_Patient]
	--WHERE ISNULL([NationalCode], '') = ''
)
SELECT   p.[PatientRef]
      --,p.[AddressRef]
      ,p.[Forename]
      ,p.[Surname]
      ,p.[SurnamePrefix]
      ,p.[MaidenPrefix]
      ,p.[Maiden]
      ,p.[Initials]
      ,p.[DOB] 
      ,p.[HomePhone]
      ,p.[MobilePhone]
      ,p.[OtherPhone]
      ,CASE WHEN p.[Sex] = 'M' THEN 1 
			WHEN p.Sex = 'F' THEN 2
			ELSE 0
		END AS Sex
      --,p.[AgeOnly]
      ,CAST(ISNULL(REPLACE(REPLACE(p.[NationalCode] ,' ',''),'-',''),'') AS VARCHAR(10))   AS NHS_Number
      --,p.[Obsolete]
      --,p.[LastEditByUserRef]
      ,p.[EditDate]
	  ,CreateDt.CreatedDate
      --,p.[EthnicityRef]
      ,hl.Code AS MainLanguage
      --,p.[LocalLanguageSpoken]
      --,p.[NationalityRef]
      --,p.[NationalCodeSource]
      ,p.[EmailAddress]
      ,p.[OtherPhoneExtn]
      --,p.[ExcludeFromPSQ]
      --,p.[LastCaseDate]
      ,p.[IsTwin]
      --,p.[DemographicsSensitive]
      --,p.[NationalCodeSourceDatabase]
      --,p.[NationalCodeEditDate]
      --,p.[NationalCodeEditByUserRef]
      ,p.[LocalID]
      ,p.[NationalCodeExtraInfo]
      --,p.[HomePhonePrefix]
      --,p.[AllergyStatusCode]
      --,p.[ConditionStatusCode]
      --,p.[MedicationStatusCode]
      ,p.[LatestModificationDate]
	  ,addrs.[Building]						AS Address1
      ,addrs.[Street]						AS Address2
      --,addrs.[Locality]						 
      ,addrs.[Town]						AS Address3
      ,addrs.[County]						AS Address4
      ,addrs.[Postcode]
      ,addrs.[AddressType]
      ,addrs.[Directions]
      ,addrs.[Country]
      --,addrs.[CountryRef]
      --,addrs.[Longitude]
      --,addrs.[Latitude]
      --,addrs.[MapReference]
      --,addrs.[StatusRef]
      --,addrs.[UPRN]
	  --,eth.Name Ethnicity_Name
	  ,eth.CategoryCode EthnicGroup 
  FROM [mrr].[ADA_Patient] p
  INNER JOIN unique_Pat pat
	ON p.LocalID = pat.LocalID
  LEFT JOIN CreateDt ON CreateDt.PatientRef = p.PatientRef
  LEFT JOIN [mrr].[ADA_Address] addrs
	ON p.AddressRef = addrs.AddressRef
LEFT JOIN [mrr].[ADA_Ethnicity] eth
	ON p.EthnicityRef = eth.EthnicityRef
 LEFT JOIN [mrr].[ADA_HumanLanguage] hl
	ON p.HumanLanguageRef = hl.HumanLanguageRef
  --WHERE NationalCode = '4042003052'
 

GO
