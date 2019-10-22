SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE VIEW [mrr].[CNS_tblICD10] AS SELECT [ICD10_ID], [Patient_ID], [Version_ID], [Diagnosis_Date], [RMO_GP_Flag_ID], [Diagnosis_By_ID], [RMO_Name_ID], [Confirm_Flag_ID], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [Confirm_Date], [RMO_Confirm_Date], [Prev_Psy_Episode_ID], [Primary_Diag], [Secondary_Diag_1], [Secondary_Diag_2], [Secondary_Diag_3], [Secondary_Diag_4], [Secondary_Diag_5], [Secondary_Diag_6], [Secondary_Diag_7], [Accept_Previous_Primary_Diag_ID], [Accept_Previous_Secondary_Diag1_ID], [Accept_Previous_Secondary_Diag2_ID], [Accept_Previous_Secondary_Diag3_ID], [Accept_Previous_Secondary_Diag4_ID], [Accept_Previous_Secondary_Diag5_ID], [Accept_Previous_Secondary_Diag6_ID], [End_Date], [Comments], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Status_Of_Diagnosis_ID] FROM [Mirror].[mrr_tbl].[CNS_tblICD10];

GO
