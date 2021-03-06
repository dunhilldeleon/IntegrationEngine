SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE VIEW [HIE_CNC].[vwCNC_InscopePatient]
AS
SELECT DISTINCT [pat].[Patient_ID] AS [PatientNo]
FROM [mrr].[CNC_tblPatient]                              [pat]
    LEFT JOIN [mrr].[CNC_tblGPDetail]                   [gpd]
        ON [pat].[Patient_ID] = [gpd].[Patient_ID]
           AND [gpd].[End_Date] IS NULL
    LEFT JOIN [mrr].[CNC_tblPractice]                   [prac]
        ON [gpd].[Practice_ID] = [prac].[Practice_ID]
    LEFT JOIN mrr.CNC_tblPractice                          AS prac2
        ON LEFT(prac.Practice_Code, 6) = prac2.Practice_Code
    INNER JOIN [mrr].[CNC_tblClinicalCommissioningGroup] [ccg]
        ON [ccg].[CCG_ID] = COALESCE(gpd.CCG_ID, [prac].[CCG_ID], prac2.CCG_ID)
           AND [ccg].[CCG_Identifier] IN (   '10Q' -- NHS OXFORDSHIRE CCG
                                         )
WHERE pat.Surname LIKE '%XX%TEST%'
	AND pat.Surname NOT LIKE '%DO%NOT%USE%'


GO
