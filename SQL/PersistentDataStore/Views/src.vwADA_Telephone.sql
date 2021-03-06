SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON






CREATE VIEW [src].[vwADA_Telephone]
AS

WITH  HomePatNo AS 
(
	SELECT   PatientRef 
         , NULL			AS NokContact_ID
         , REPLACE(HomePhone,' ','')	AS Telephone_Number
         , CASE WHEN LEFT(LTRIM(HomePhone),2) = '07' THEN 'CP' ELSE 'PH' END	AS PhoneTypeCode 
         , 'PRN'		AS UseCode          --PRN = PrimaryResidenceNumber'
         , 'Patient'	AS ContactRole
		 , CASE WHEN LEFT(LTRIM(HomePhone),2) = '07' THEN 'Mobile' ELSE 'Home' END AS PhoneType
         , EditDate		AS Updated_Dttm
         , CASE
               WHEN ISNULL(HomePhone,'') <> '' THEN
                   1
               ELSE
                   0
           END         AS Main_Number_Flag --main patient contact number = 1
    FROM mrr.ADA_Patient 
	WHERE ISNULL(HomePhone,'') <> ''
	AND HomePhone <> '00000000000' 
)
, MobilePatNo AS 
(
	SELECT PatientRef
         , NULL			AS NokContact_ID
         , REPLACE(MobilePhone,' ','') 	AS Telephone_Number
         , CASE WHEN LEFT(LTRIM(MobilePhone),2) = '07' THEN 'CP' ELSE 'PH' END	AS PhoneTypeCode  
         , 'PRS'		AS UseCode   -- PRS = Personal Phone
		 , 'Patient'	AS ContactRole
         , CASE WHEN LEFT(LTRIM(MobilePhone),2) = '07' THEN 'Mobile' ELSE 'Home' END AS PhoneType
         , EditDate		AS Updated_Dttm
         , CASE
               WHEN ISNULL(HomePhone,'') = '' AND ISNULL(MobilePhone,'') <> '' THEN
                   1
               ELSE
                   0
           END         AS Main_Number_Flag
    FROM mrr.ADA_Patient 
	WHERE ISNULL(MobilePhone,'') <> '' 
	AND MobilePhone <> '00000000000' 

)
, AllNumbers AS 
(
	SELECT *
    FROM HomePatNo

    UNION ALL

    SELECT *
    FROM MobilePatNo	
)
SELECT *
FROM AllNumbers an
WHERE an.Telephone_Number NOT LIKE '%[a-z]%'
      AND an.Telephone_Number NOT LIKE '%/%'
      AND LEFT(an.Telephone_Number, 1) = '0'
      AND LEN(an.Telephone_Number) = 11;

GO
