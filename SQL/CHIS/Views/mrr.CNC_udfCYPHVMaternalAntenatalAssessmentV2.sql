SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE VIEW [mrr].[CNC_udfCYPHVMaternalAntenatalAssessmentV2] AS SELECT [CYPHVMaternalAntenatalAssessmentV2_ID], [Patient_ID], [Invalid_Date], [Invalid_Flag_ID], [Invalid_Staff_Name], [Invalid_Reason], [Confirm_Flag_ID], [Confirm_Date], [Confirm_Time], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [OriginalAuthorID], [StartDate], [fldHvMatAnAsmtEstDueDate], [fldHvMatAnAsmtAsmtScoreID], [fldHvMatAnAsmtLetterSentID], [fldHvMatAnAsmtLetterSentText], [fldHvMatAnAsmtPrgncyOngoingID], [fldHvMatAnAsmtAnVstAchievedID], [fldHvMatAnAsmtAnVstAchievedTextID], [fldHvMatAnAsmtAnVstAchievedOther], [fldHvMatAnAsmtFeedingID], [fldHvMatAnAsmtRoutineQuestID], [fldHvMatAnAsmtRoutineQuestTextID], [fldHvMatAnAsmtRoutineQuestOther], [fldHvMatAnAsmtPromGuidesID], [fldHvMatAnAsmtPromGuidesText], [fldHvMatAnAsmtIntervReqID], [fldHvMatAnAsmtIntervReqHomelessID], [fldHvMatAnAsmtIntervReqMHConcernsID], [fldHvMatAnAsmtIntervReqAddictionsID], [fldHvMatAnAsmtIntervReqTeenagePregID], [fldHvMatAnAsmtIntervReqHistOfSfgConcID], [fldHvMatAnAsmtIntervReqCurrentSfgConcID], [fldHvMatAnAsmtIntervReqPhysicalDisabilityID], [fldHvMatAnAsmtIntervReqTravelFamID], [fldHvMatAnAsmtIntervReqAsylumID], [fldHvMatAnAsmtHlthyChildID], [fldHvMatAnAsmtFurtherVstReqID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [fldEnteredDate], [fldEnteredTime], [StartTime] FROM  [Mirror].[mrr_tbl].[CNC_udfCYPHVMaternalAntenatalAssessmentV2];

GO
