SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_CNS_tblStaff

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_CNS_tblStaff]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[Staff_ID], [Staff_Name], [Forename], [MiddleInitial], [Surname], [Active], [Staff_Type_ID], [Job_Title], [Email], [Enable_Email_ID], [Mobile], [Enable_Mobile_ID], [Employee_Ref], [Staff_Loc_ID], [Professional_Group_ID], [Occupation_Code_ID], [Specialty_ID], [Consultant_GMC_Code], [Available_Appointment_1], [Available_Appointment_2], [Available_Appointment_3], [Available_Appointment_4], [Available_Appointment_5], [Available_Appointment_6], [Available_Appointment_7], [Available_Appointment_8], [Available_Appointment_9], [Available_Appointment_10], [Additional_Information], [RC_Type_ID], [Appointment_Notes], [Prescriber_PIN], [Prescriber_Type_ID], [Job_Role_Code_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [SDS_ID], [Default_Role_Profile_Code_ID], [IAPT_Training_ID], [CYP_IAPT_Dataset_Profession_ID], [Treatment_Function_Code_ID], [Clinician_Type_ID], [Gender_ID], [Religion_ID], [Professional_Registration_Entry], [Professional_Body_ID]
						 FROM mrr_tbl.CNS_tblStaff
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[Staff_ID], [Staff_Name], [Forename], [MiddleInitial], [Surname], [Active], [Staff_Type_ID], [Job_Title], [Email], [Enable_Email_ID], [Mobile], [Enable_Mobile_ID], [Employee_Ref], [Staff_Loc_ID], [Professional_Group_ID], [Occupation_Code_ID], [Specialty_ID], [Consultant_GMC_Code], [Available_Appointment_1], [Available_Appointment_2], [Available_Appointment_3], [Available_Appointment_4], [Available_Appointment_5], [Available_Appointment_6], [Available_Appointment_7], [Available_Appointment_8], [Available_Appointment_9], [Available_Appointment_10], [Additional_Information], [RC_Type_ID], [Appointment_Notes], [Prescriber_PIN], [Prescriber_Type_ID], [Job_Role_Code_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [SDS_ID], [Default_Role_Profile_Code_ID], [IAPT_Training_ID], [CYP_IAPT_Dataset_Profession_ID], [Treatment_Function_Code_ID], [Clinician_Type_ID], [Gender_ID], [Religion_ID], [Professional_Registration_Entry], [Professional_Body_ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblStaff])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[Staff_ID], [Staff_Name], [Forename], [MiddleInitial], [Surname], [Active], [Staff_Type_ID], [Job_Title], [Email], [Enable_Email_ID], [Mobile], [Enable_Mobile_ID], [Employee_Ref], [Staff_Loc_ID], [Professional_Group_ID], [Occupation_Code_ID], [Specialty_ID], [Consultant_GMC_Code], [Available_Appointment_1], [Available_Appointment_2], [Available_Appointment_3], [Available_Appointment_4], [Available_Appointment_5], [Available_Appointment_6], [Available_Appointment_7], [Available_Appointment_8], [Available_Appointment_9], [Available_Appointment_10], [Additional_Information], [RC_Type_ID], [Appointment_Notes], [Prescriber_PIN], [Prescriber_Type_ID], [Job_Role_Code_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [SDS_ID], [Default_Role_Profile_Code_ID], [IAPT_Training_ID], [CYP_IAPT_Dataset_Profession_ID], [Treatment_Function_Code_ID], [Clinician_Type_ID], [Gender_ID], [Religion_ID], [Professional_Registration_Entry], [Professional_Body_ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblStaff]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[Staff_ID], [Staff_Name], [Forename], [MiddleInitial], [Surname], [Active], [Staff_Type_ID], [Job_Title], [Email], [Enable_Email_ID], [Mobile], [Enable_Mobile_ID], [Employee_Ref], [Staff_Loc_ID], [Professional_Group_ID], [Occupation_Code_ID], [Specialty_ID], [Consultant_GMC_Code], [Available_Appointment_1], [Available_Appointment_2], [Available_Appointment_3], [Available_Appointment_4], [Available_Appointment_5], [Available_Appointment_6], [Available_Appointment_7], [Available_Appointment_8], [Available_Appointment_9], [Available_Appointment_10], [Additional_Information], [RC_Type_ID], [Appointment_Notes], [Prescriber_PIN], [Prescriber_Type_ID], [Job_Role_Code_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [SDS_ID], [Default_Role_Profile_Code_ID], [IAPT_Training_ID], [CYP_IAPT_Dataset_Profession_ID], [Treatment_Function_Code_ID], [Clinician_Type_ID], [Gender_ID], [Religion_ID], [Professional_Registration_Entry], [Professional_Body_ID]
						 FROM mrr_tbl.CNS_tblStaff))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.CNS_tblStaff has discrepancies when compared to its source table.', 1;

				END;
				
GO
