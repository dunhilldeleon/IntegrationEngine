SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_CNS_tblMHASectionDefinition

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_CNS_tblMHASectionDefinition]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[MHA_Section_Definition_ID], [MHA_Section_Definition_Desc], [Active], [Default_Flag], [External_Code1], [External_Code2], [Display_Order], [CORC_Export_Code], [MHA_Section_Duration_Type_ID], [MHA_Section_Duration_Value], [Nominated_Deputy_Visible_Flag_ID], [Nominated_Deputy_Mandatory_Flag_ID], [Recommendation1_Visible_Flag_ID], [Recommendation1_Mandatory_Flag_ID], [Recommendation2_Visible_Flag_ID], [Recommendation2_Mandatory_Flag_ID], [Nurse_Visible_Flag_ID], [Nurse_Mandatory_Flag_ID], [Nearest_Relative_Visible_Flag_ID], [Nearest_Relative_Mandatory_Flag_ID], [Approved_Social_Worker_Visible_Flag_ID], [Approved_Social_Worker_Mandatory_Flag_ID], [Warn_If_No_Overlap_Flag_ID], [Set_End_Time_To_Midnight_Flag_ID], [Include_Social_Service_Assessment_Flag_ID], [Display_Renewal_Button_Flag_ID], [Display_Extension_Button_Flag_ID], [Comment_For_Med_Officer_Knows_Patient_Flag_ID], [Auto_Create_Section117_Doc_Flag_ID], [Include_Court_Details_Flag_ID], [Include_Home_Office_Details_Flag_ID], [Display_Mental_Category_Change_Button_Flag_ID], [Display_Sec12_Recomendation1_Approved_Flag_ID], [Display_Sec12_Recomendation2_Approved_Flag_ID], [Allow_Section_To_Be_Run_Concurrently_Under_Other_Sections_Flag_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
						 FROM mrr_tbl.CNS_tblMHASectionDefinition
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[MHA_Section_Definition_ID], [MHA_Section_Definition_Desc], [Active], [Default_Flag], [External_Code1], [External_Code2], [Display_Order], [CORC_Export_Code], [MHA_Section_Duration_Type_ID], [MHA_Section_Duration_Value], [Nominated_Deputy_Visible_Flag_ID], [Nominated_Deputy_Mandatory_Flag_ID], [Recommendation1_Visible_Flag_ID], [Recommendation1_Mandatory_Flag_ID], [Recommendation2_Visible_Flag_ID], [Recommendation2_Mandatory_Flag_ID], [Nurse_Visible_Flag_ID], [Nurse_Mandatory_Flag_ID], [Nearest_Relative_Visible_Flag_ID], [Nearest_Relative_Mandatory_Flag_ID], [Approved_Social_Worker_Visible_Flag_ID], [Approved_Social_Worker_Mandatory_Flag_ID], [Warn_If_No_Overlap_Flag_ID], [Set_End_Time_To_Midnight_Flag_ID], [Include_Social_Service_Assessment_Flag_ID], [Display_Renewal_Button_Flag_ID], [Display_Extension_Button_Flag_ID], [Comment_For_Med_Officer_Knows_Patient_Flag_ID], [Auto_Create_Section117_Doc_Flag_ID], [Include_Court_Details_Flag_ID], [Include_Home_Office_Details_Flag_ID], [Display_Mental_Category_Change_Button_Flag_ID], [Display_Sec12_Recomendation1_Approved_Flag_ID], [Display_Sec12_Recomendation2_Approved_Flag_ID], [Allow_Section_To_Be_Run_Concurrently_Under_Other_Sections_Flag_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblMHASectionDefinition])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[MHA_Section_Definition_ID], [MHA_Section_Definition_Desc], [Active], [Default_Flag], [External_Code1], [External_Code2], [Display_Order], [CORC_Export_Code], [MHA_Section_Duration_Type_ID], [MHA_Section_Duration_Value], [Nominated_Deputy_Visible_Flag_ID], [Nominated_Deputy_Mandatory_Flag_ID], [Recommendation1_Visible_Flag_ID], [Recommendation1_Mandatory_Flag_ID], [Recommendation2_Visible_Flag_ID], [Recommendation2_Mandatory_Flag_ID], [Nurse_Visible_Flag_ID], [Nurse_Mandatory_Flag_ID], [Nearest_Relative_Visible_Flag_ID], [Nearest_Relative_Mandatory_Flag_ID], [Approved_Social_Worker_Visible_Flag_ID], [Approved_Social_Worker_Mandatory_Flag_ID], [Warn_If_No_Overlap_Flag_ID], [Set_End_Time_To_Midnight_Flag_ID], [Include_Social_Service_Assessment_Flag_ID], [Display_Renewal_Button_Flag_ID], [Display_Extension_Button_Flag_ID], [Comment_For_Med_Officer_Knows_Patient_Flag_ID], [Auto_Create_Section117_Doc_Flag_ID], [Include_Court_Details_Flag_ID], [Include_Home_Office_Details_Flag_ID], [Display_Mental_Category_Change_Button_Flag_ID], [Display_Sec12_Recomendation1_Approved_Flag_ID], [Display_Sec12_Recomendation2_Approved_Flag_ID], [Allow_Section_To_Be_Run_Concurrently_Under_Other_Sections_Flag_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblMHASectionDefinition]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[MHA_Section_Definition_ID], [MHA_Section_Definition_Desc], [Active], [Default_Flag], [External_Code1], [External_Code2], [Display_Order], [CORC_Export_Code], [MHA_Section_Duration_Type_ID], [MHA_Section_Duration_Value], [Nominated_Deputy_Visible_Flag_ID], [Nominated_Deputy_Mandatory_Flag_ID], [Recommendation1_Visible_Flag_ID], [Recommendation1_Mandatory_Flag_ID], [Recommendation2_Visible_Flag_ID], [Recommendation2_Mandatory_Flag_ID], [Nurse_Visible_Flag_ID], [Nurse_Mandatory_Flag_ID], [Nearest_Relative_Visible_Flag_ID], [Nearest_Relative_Mandatory_Flag_ID], [Approved_Social_Worker_Visible_Flag_ID], [Approved_Social_Worker_Mandatory_Flag_ID], [Warn_If_No_Overlap_Flag_ID], [Set_End_Time_To_Midnight_Flag_ID], [Include_Social_Service_Assessment_Flag_ID], [Display_Renewal_Button_Flag_ID], [Display_Extension_Button_Flag_ID], [Comment_For_Med_Officer_Knows_Patient_Flag_ID], [Auto_Create_Section117_Doc_Flag_ID], [Include_Court_Details_Flag_ID], [Include_Home_Office_Details_Flag_ID], [Display_Mental_Category_Change_Button_Flag_ID], [Display_Sec12_Recomendation1_Approved_Flag_ID], [Display_Sec12_Recomendation2_Approved_Flag_ID], [Allow_Section_To_Be_Run_Concurrently_Under_Other_Sections_Flag_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
						 FROM mrr_tbl.CNS_tblMHASectionDefinition))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.CNS_tblMHASectionDefinition has discrepancies when compared to its source table.', 1;

				END;
				
GO
