SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

/*

Change Logs:
 
*/

CREATE  VIEW [Graphnet].[vwRiskPlans_HistoricalData]
AS

SELECT 'O'+CAST([OHFTGENRiskAssessment_ID]   AS VARCHAR(10))	AS 'RiskPlanID'
     , 'O'+CAST([OHFTGENRiskAssessment_ID]   AS VARCHAR(10))	AS 'RiskAssessmentID'
     , risk.[Patient_ID]										AS 'PatientID'
     , 125														AS 'TenancyID'
     , CONVERT(VARCHAR(23)
             , (
                   SELECT MAX([UpdatedDate])
                   FROM
                   (
                       VALUES
                           ([risk].[Updated_Dttm])
                   ) AS [AllDates] ([UpdatedDate])
               )
             , 21
              )                              AS [UpdatedDate]
     , CONVERT(VARCHAR(23), [StartDate], 21) AS 'DateEntered'
     , 'Risk Summary'                        AS 'Field1Description'
     , REPLACE(REPLACE(REPLACE(REPLACE(CAST(CONVERT(VARCHAR(500),RiskEvidenceGeneralComments) 
	    + CONVERT(VARCHAR(500),AccidentsComments) 
	    + CONVERT(VARCHAR(500),HarmToOthersComments) 
	    + CONVERT(VARCHAR(500),SexualOffencesComments)
	    + CONVERT(VARCHAR(500),ViolenceTowardsOthersComments) 
	    + CONVERT(VARCHAR(500),HarmFromOthersComments) 
	    + CONVERT(VARCHAR(500),HarmToSelfComments) AS VARCHAR(MAX)) , CHAR(13),''), CHAR(10),''),'|',''),'"','')    AS 'Field1Value'
     , CASE
		   WHEN InvalidDoc.CN_Doc_ID IS NULL THEN
               0
           ELSE
               1
       END                                   AS 'Deleted'
FROM [Graphnet].[vwInscopePatient]                                     AS scope
    INNER JOIN [mrr].[CNS_udfOHFTGENRiskAssessment] AS risk
        ON scope.[PatientNo] = risk.Patient_ID
	LEFT JOIN mrr.CNS_tblCNDocument                     CNDoc
		ON risk.OHFTGENRiskAssessment_ID = CNDoc.CN_Object_ID
    INNER JOIN mrr.CNS_tblObjectTypeValues     ObjTyp
        ON ObjTyp.Object_Type_ID = CNDoc.Object_Type_ID
		AND ObjTyp.Key_Table_Name = 'udfOHFTGENRiskAssessment'
    LEFT JOIN mrr.CNS_tblInvalidatedDocuments InvalidDoc
        ON InvalidDoc.CN_Doc_ID = CNDoc.CN_Doc_ID;


GO
