SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON





/*
Change Logs:
28-Nov-2018 FS replaced icd10.Confirm_Staff_Name by staff.staff_name for Confirmed_BY 
28-Nov-2018 FS changed the Comments to include Primary or Secondary Diag + Confirmed or Provisional 
*/

CREATE VIEW [HIE_CNS].[vwCNS_Diagnosis]
AS
SELECT REPLACE(
                  CAST(CAST(icd10.ICD10_ID AS VARCHAR(10)) + '-'
                       + CAST(ROW_NUMBER() OVER (PARTITION BY icd10.ICD10_ID ORDER BY icd10.Diagnosis_Date DESC) AS VARCHAR(2)) AS VARCHAR(20))
                , '|'
                , ''
              )                                                                        AS DiagnosisID
     , REPLACE(CAST(icd10.Patient_ID AS VARCHAR(20)), '|', '')                         AS PatientID
	 , 125                                                                             AS [TenancyID]
     , CONVERT(VARCHAR(23), icd10.Updated_Dttm, 21)                                    AS UpdatedDate
     , REPLACE(
                  CAST(CAST(icd10.ICD10_ID AS VARCHAR(10)) + '-'
                       + CAST(ROW_NUMBER() OVER (PARTITION BY icd10.ICD10_ID ORDER BY icd10.Diagnosis_Date DESC) AS VARCHAR(2)) AS VARCHAR(20))
                , '|'
                , ''
              )                                                                        AS LinkID
     , CONVERT(VARCHAR(23), icd10.Diagnosis_Date, 21)                                  AS DiagnosisDate
     , REPLACE(   CAST(CASE
                           WHEN LEN(SUBSTRING(diagnosisValue, 0, CHARINDEX(' ', diagnosisValue))) = 3 THEN
                               SUBSTRING(diagnosisValue, 0, CHARINDEX(' ', diagnosisValue)) + 'X'
                           ELSE
                               SUBSTRING(diagnosisValue, 0, CHARINDEX(' ', diagnosisValue))
                       END AS VARCHAR(7))
                , '|'
                , ''
              )                                                                        AS ICD10Code
     , REPLACE(CAST('' AS VARCHAR(100)), '|', '')                                      AS SnomedCTCode
     , ISNULL(REPLACE(CAST(cv.ICD10_Code_Desc AS VARCHAR(500)), '|', ''), 'Not known') AS DiagnosisDescription
     , REPLACE(CAST(Staff.Staff_Name AS VARCHAR(50)), '|', '')						   AS ConfirmedBy
	 --, REPLACE(CAST(icd10.Confirm_Staff_Name AS VARCHAR(50)), '|', '')                 AS ConfirmedBy
     ,    CASE WHEN diagnosisValue = icd10.Primary_Diag THEN 'Primary - ' ELSE 'Secondary - ' END 
	   +  CASE WHEN icd10.Status_Of_Diagnosis_ID = 0 THEN 'Confirmed. ' ELSE 'Provisional. ' END 
	   + REPLACE(REPLACE(REPLACE(CAST(icd10.Comments AS VARCHAR(1000)), '|', ''), CHAR(13), ''), CHAR(10),'')                       AS Comments
     , IIF(InvcnDoc.CN_Doc_ID IS NULL, 0, 1)                                           AS Deleted
FROM HIE_CNS.tblCNS_InscopePatient                           scope
    LEFT JOIN mrr.CNS_tblICD10                icd10
        ON scope.PatientNo = icd10.Patient_ID
    INNER JOIN mrr.CNS_tblCNDocument          cnDoc
        ON cnDoc.CN_Object_ID = icd10.ICD10_ID
           AND cnDoc.Object_Type_ID = 325
	LEFT JOIN mrr.CNS_tblStaff staff 
		ON icd10.Diagnosis_By_ID = staff.Staff_ID
    LEFT JOIN mrr.CNS_tblInvalidatedDocuments InvcnDoc
        ON InvcnDoc.CN_Doc_ID = cnDoc.CN_Doc_ID
    CROSS APPLY
(
    SELECT icd10.Primary_Diag
    WHERE icd10.Primary_Diag IS NOT NULL
    UNION ALL
    SELECT icd10.Secondary_Diag_1
    WHERE icd10.Secondary_Diag_1 IS NOT NULL
    UNION ALL
    SELECT icd10.Secondary_Diag_2
    WHERE icd10.Secondary_Diag_2 IS NOT NULL
    UNION ALL
    SELECT icd10.Secondary_Diag_3
    WHERE icd10.Secondary_Diag_3 IS NOT NULL
    UNION ALL
    SELECT icd10.Secondary_Diag_4
    WHERE icd10.Secondary_Diag_4 IS NOT NULL
    UNION ALL
    SELECT icd10.Secondary_Diag_5
    WHERE icd10.Secondary_Diag_5 IS NOT NULL
          AND Version_ID = 0
)                                                            c(diagnosisValue)
    LEFT JOIN mrr.CNS_tblICD10CodeValues cv
        ON CASE
               WHEN LEN(SUBSTRING(diagnosisValue, 0, CHARINDEX(' ', diagnosisValue))) = 3 THEN
                   SUBSTRING(diagnosisValue, 0, CHARINDEX(' ', diagnosisValue))
               ELSE
                   SUBSTRING(diagnosisValue, 0, CHARINDEX(' ', diagnosisValue))
           END = SUBSTRING(cv.ICD10_Code_Desc, 0, CHARINDEX('-', cv.ICD10_Code_Desc) - 1)
WHERE ISNULL(icd10.Status_Of_Diagnosis_ID, 0) = 0;





GO
