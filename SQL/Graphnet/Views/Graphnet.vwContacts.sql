SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON






/*

Change Logs:
1. FS 28-Nov-2018 replaced ContactType by Role.
	also exclude Clients from the extract. 
*/


CREATE VIEW [Graphnet].[vwContacts]
AS
SELECT REPLACE(CAST(c.Contact_ID AS VARCHAR(18)) + '-' + 
		CAST(ROW_NUMBER() OVER (PARTITION BY c.Patient_ID
                               ORDER BY c.Start_Date DESC
                                      , c.Updated_Dttm DESC
                                      , c.Contact_ID DESC
                              ) AS VARCHAR(2)) 
		
		, '|', '') AS ContactID
     , REPLACE(CAST(c.Patient_ID AS VARCHAR(20)), '|', '') AS PatientID
     , 125                                                 AS [TenancyID]
     , CONVERT(VARCHAR(23)
             , (
                   SELECT MAX(Updated_Dttm)
                   FROM
                   (
                       VALUES
                           (c  .Updated_Dttm)
                         , (tv.Updated_Dttm)
                   ) AS alldates (Updated_Dttm)
               )
             , 21
              )                                            AS UpdatedDate
     , CAST(ROW_NUMBER() OVER (PARTITION BY c.Patient_ID
                               ORDER BY c.Start_Date DESC
                                      , c.Updated_Dttm DESC
                                      , c.Contact_ID DESC
                              ) AS VARCHAR(3))             AS Rank
     --, CASE
     --      WHEN c.Contact_Type_ID = 0 THEN
     --          'Client'
     --      WHEN c.Contact_Type_ID = 1 THEN
     --          'GP'
     --      WHEN c.Contact_Type_ID = 2 THEN
     --          'Contact'
     --      ELSE
     --          'Not Known'
     --  END                                                 AS ContactType
	 , REPLACE(LEFT(ISNULL(crv.Contact_Role_Desc,'NULL'), 35), '|', '')   AS ContactType
	 --, crv.Contact_Role_Desc
     , REPLACE(LEFT(c.Relationship, 35), '|', '')						AS Relation		
     , REPLACE(LEFT(tv.Title_Desc, 15), '|', '')						AS Title
     , CASE WHEN LEN(c.Surname) = 0 
				THEN 'Unknown' 
			ELSE REPLACE(REPLACE(LEFT(c.Surname, 35), '|', ''),'"','') 
	   END																AS Surname
     , CASE WHEN LEN(c.Surname) = 0 
				THEN 'Unknown' 
			ELSE REPLACE(REPLACE(LEFT(c.Forename, 35), '|', ''),'"','') 
	   END																AS GivenName

     --, REPLACE(REPLACE(LEFT(c.Forename, 50), '|', ''),'"','')              AS GivenName
     , REPLACE(REPLACE(REPLACE(LEFT(c.Address1, 35), '|', ''),'\',''),'"','')			AS AddressLine1
     , REPLACE(REPLACE(LEFT(c.Address2, 35), '|', ''),'\','')           AS AddressLine2
     , REPLACE(REPLACE(LEFT(c.Address3, 35), '|', ''),'\','')           AS AddressLine3
     , REPLACE(REPLACE(LEFT(c.Address4, 35), '|', ''),'\','')           AS AddressLine4
     , REPLACE(REPLACE(LEFT(c.Address5, 35), '|', ''),'\','')           AS AddressLine5
     , REPLACE(REPLACE(LEFT(c.Post_Code, 25), '|', ''),'\','')          AS PostCode
     , NULL																AS Country
     , REPLACE(REPLACE(LEFT(c.Home_Telephone, 45), '|', ''),'\','')     AS MainPhone
     , REPLACE(REPLACE(LEFT(c.Work_Telephone, 45), '|', ''),'\','')     AS OtherPhone
     , REPLACE(REPLACE(LEFT(c.Mobile_Telephone, 45), '|', ''),'\','')   AS MobilePhone
     , REPLACE(LEFT(c.Email_Address, 100), '|', '')						AS Email
     , NULL																AS PreferredContactMethod
     , IIF(cn.CN_Object_ID IS NULL, 0, 1)								AS Deleted
FROM Graphnet.vwInscopePatient                            scope
    INNER JOIN  mrr.CNS_tblContact          c
        ON c.Patient_ID = scope.PatientNo
    LEFT OUTER JOIN  mrr.CNS_tblTitleValues tv
        ON tv.Title_ID = c.Title_ID
    LEFT OUTER JOIN
    (
        SELECT cn.CN_Object_ID
        FROM  mrr.CNS_tblCNDocument                     cn
            INNER JOIN  mrr.CNS_tblObjectTypeValues     ot
                ON ot.Object_Type_ID = cn.Object_Type_ID
            INNER JOIN  mrr.CNS_tblInvalidatedDocuments id
                ON id.CN_Doc_ID = cn.CN_Doc_ID
        WHERE ot.Key_Table_Name = 'tblContacts'
    )                                                     cn
        ON cn.CN_Object_ID = c.Contact_ID
	LEFT JOIN  mrr.CNS_tblContactRole r
		ON c.Contact_ID = r.Contact_ID
	LEFT JOIN  mrr.CNS_tblContactRoleValues crv
		ON crv.Contact_Role_ID = r.Contact_Role_ID
	--LEFT JOIN [mrr].[CNS_tblContactTypeValues]  ctv
	--	ON ctv.Contact_Type_ID = c.Contact_Type_ID
WHERE c.Contact_Type_ID != 0 AND c.End_Date IS NULL
	AND (SELECT MAX(Updated_Dttm)
                   FROM
                   (
                       VALUES
                           (c  .Updated_Dttm)
                         , (tv.Updated_Dttm)
                   ) AS alldates (Updated_Dttm)
				   ) >= DATEADD(YEAR, -2, GETDATE()) ; -- two years




GO
