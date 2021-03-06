SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


CREATE VIEW [HIE_CNC].[vwCNC_Alerts]
AS

SELECT   Alerts.Patient_ID AS PatientNo
     , 125																	AS [TenancyID]
     , ROW_NUMBER() OVER (PARTITION BY Alerts.Patient_ID
                          ORDER BY Alerts.[Alert_ID] DESC
                         )													AS [AlertOrder]
     , 'Alert'																AS [AlertCategory]
     , CAST([AlertType].Alert_Type_Desc AS VARCHAR(100))					AS [AlertType]
     , REPLACE(CAST([Alerts].Alert_Description AS VARCHAR(100)), '|', '')	AS [AlertTypeDescription]
     , CAST(NULL AS VARCHAR(100))                                           AS [AlertSubType]
     , REPLACE(CAST(NULL AS VARCHAR(100)), '|', '')                         AS [AlertSubTypeDescription]
     , 'U'                                                                  AS [Severity]
     , REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(MAX),Alerts.[Alert_Comment]), '|', ''), CHAR(13),'-'),CHAR(10), ',')		AS [Comments]
     , CONVERT(VARCHAR(23), Alerts.Start_Date, 21)							AS StartDate
     , CONVERT(VARCHAR(23), Alerts.End_Date, 21)							AS EndDate
     , CONVERT(VARCHAR(23), Alerts.Updated_Dttm, 21)						AS UpdatedDate
FROM    [mrr].[CNC_tblAlert] [Alerts]
INNER JOIN HIE_CNC.tblCNC_InscopePatient                   [Inscope]
            ON ([Alerts].[Patient_ID] = [Inscope].[PatientNo])
LEFT OUTER JOIN [mrr].[CNC_tblAlertTypeValues] [AlertType]
        ON ([AlertType].[Alert_Type_ID] = [Alerts].[Alert_Type_ID])
WHERE Alerts.End_Date IS NULL


GO
