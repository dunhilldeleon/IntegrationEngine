SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON








CREATE VIEW [src].[vwCNS_Demographics]
AS
WITH Ad
AS (
   SELECT ROW_NUMBER() OVER (PARTITION BY Patient_ID ORDER BY Updated_Dttm DESC) AS rn
        , Patient_ID
        , Address1
        , Address2
        , Address3
        , Address4
        , Address5
        , Post_Code
        , Address_Type_ID
        , Updated_Dttm
   FROM mrr.CNS_tblAddress
   WHERE Address_Confidential_Flag_ID = 0)
, unique_Pat AS 
(
	SELECT  NHS_Number, MAX(Patient_ID) AS Patient_ID
	FROM mrr.CNS_tblPatient
	WHERE ISNULL(NHS_Number, '') <> ''
	AND NHS_Number NOT IN ('0000000000','1111111111','2222222222','3333333333','4444444444','5555555555','6666666666','7777777777','8888888888','9999999999')
	GROUP BY NHS_Number
	
	--UNION	

	--SELECT  NULL, Patient_ID
	--FROM mrr.CNS_tblPatient
	--WHERE ISNULL(NHS_Number, '') = ''

)
, Contact_Recent_Updated_Dttm AS 
(
	SELECT  c.Patient_ID
		 , (
			   SELECT MAX(Updated_Dttm)
			   FROM
			   (
				   VALUES 
					  (c.Updated_Dttm)
					 , (cr.Updated_Dttm)
			   ) AS alldates (Updated_Dttm)
		   )      AS UpdatedDate
		   , ROW_NUMBER() OVER(PARTITION BY c.Patient_ID ORDER  BY (
			   SELECT MAX(Updated_Dttm)
			   FROM
			   (
				   VALUES 
					  (c.Updated_Dttm)
					 , (cr.Updated_Dttm)
			   ) AS alldates (Updated_Dttm)
		   ) DESC ) rn 

	FROM  mrr.CNS_tblContact					c
	LEFT JOIN mrr.CNS_tblContactRole			cr
		ON c.Contact_ID = cr.Contact_ID
			AND cr.Contact_Role_ID IN ( 25, 26 )
)
SELECT DISTINCT p.Patient_ID
	 , p.Forename
     , p.Surname
	 , p.Patient_Name
	 , p.Title_ID
     , p.Date_Of_Birth
     , REPLACE(REPLACE(p.NHS_Number ,' ',''),'-','') 										   AS NHS_Number
     , p.Gender_ID
	 , a.Address1                                                                              AS Address1
     , a.Address2                                                                              AS Address2
     , a.Address3                                                                              AS Address3
     , CASE
           WHEN a.Address4 IS NULL
                AND a.Address5 IS NULL THEN
               NULL
           WHEN a.Address4 IS NULL
                AND a.Address5 IS NOT NULL THEN
               a.Address5
           WHEN a.Address4 IS NOT NULL
                AND a.Address5 IS NULL THEN
               a.Address4
           ELSE
               a.Address4 + ', ' + a.Address5
       END                                                                                     AS Address4
     , a.Post_Code                                                                             AS Postcode
     , a.Address_Type_ID                                                                       AS AddressType
     , p.Date_Of_Death
     , pr.Practice_Name                                                                        AS PracticeName
     , pr.Practice_Code                                                                        AS PracticeCode
     , gp.GP_Code                                                                              AS GPCode
     , IIF(COALESCE(gp.First_Name, '') = '', gp.Last_Name, gp.First_Name + ' ' + gp.Last_Name) AS GPName
     , NULL                                                                                    AS GPPrefix
     , lv.External_Code2																		AS PrimaryLanguage
     , msv.External_Code2																		AS [MaritalStatus]
     --, ev.Ethnicity_ID
	 , ev.External_Code1																		AS EthnicGroup
     , relig.External_Code1																		AS Religion
	 , p.Create_Dttm                                                                           AS CreatedDate
     , (
           SELECT MAX(Updated_Dttm)
           FROM
           (
               VALUES
                   (p.Updated_Dttm)
                 , (gpd.Updated_Dttm)
                 , (gp.Updated_Dttm)
                 , (pr.Updated_Dttm)
                 , (a.Updated_Dttm)
				 , (c.UpdatedDate)
           ) AS alldates (Updated_Dttm)
       )                                                                                       AS UpdatedDate
FROM mrr.CNS_tblPatient                            p
	INNER JOIN unique_Pat							up
		ON p.Patient_ID = up.Patient_ID
    LEFT OUTER JOIN Ad                             a
        ON a.Patient_ID = p.Patient_ID
           AND a.rn = 1
    LEFT OUTER JOIN mrr.CNS_tblGPDetail            gpd
        ON gpd.Patient_ID = p.Patient_ID
           AND gpd.End_Date IS NULL
    LEFT OUTER JOIN mrr.CNS_tblGP                  gp
        ON gp.GP_ID = gpd.GP_ID
    LEFT OUTER JOIN mrr.CNS_tblPractice            pr
        ON pr.Practice_ID = gpd.Practice_ID
    LEFT OUTER JOIN mrr.CNS_tblLanguageValues      lv
        ON lv.Language_ID = p.First_Language_ID
    LEFT OUTER JOIN mrr.CNS_tblEthnicityValues     ev
        ON ev.Ethnicity_ID = p.Ethnicity_ID
    LEFT OUTER JOIN mrr.CNS_tblMaritalStatusValues msv
        ON msv.Marital_Status_ID = p.Marital_Status_ID 
	LEFT JOIN mrr.CNS_tblReligionValues				relig
		ON p.Religion_ID = relig.Religion_ID
	LEFT JOIN Contact_Recent_Updated_Dttm 			c
		ON p.Patient_ID = c.Patient_ID
		AND c.rn = 1

--WHERE LEN(REPLACE(REPLACE(p.[NHS_Number],'-',''),' ','')) = 10 


GO
