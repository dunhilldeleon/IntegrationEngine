SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_CNC_tblClinic

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_CNC_tblClinic]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[Clinic_ID], [Clinic_Name], [Administrator_Staff_ID], [Clinic_Location_ID], [Clinic_Type_ID], [Active_Flag_ID], [External_Code1], [External_Code2], [Allow_First_Appointments_Flag_ID], [Start_Time], [End_Time], [Clinic_Schedule_Type_ID], [Number_Of_Weeks], [Clinic_Period_Start_Date], [Clinic_Period_End_Date], [Slot_Size_Minutes], [SMS_Appointment_Reminders_Flag_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Colour_Code], [Clinic_Group_ID], [Referral_Required_Flag_ID], [Multi_Patient_Required_Flag_ID], [Auto_Generate_Overbook_Slots_ID]
						 FROM mrr_tbl.CNC_tblClinic
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[Clinic_ID], [Clinic_Name], [Administrator_Staff_ID], [Clinic_Location_ID], [Clinic_Type_ID], [Active_Flag_ID], [External_Code1], [External_Code2], [Allow_First_Appointments_Flag_ID], [Start_Time], [End_Time], [Clinic_Schedule_Type_ID], [Number_Of_Weeks], [Clinic_Period_Start_Date], [Clinic_Period_End_Date], [Slot_Size_Minutes], [SMS_Appointment_Reminders_Flag_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Colour_Code], [Clinic_Group_ID], [Referral_Required_Flag_ID], [Multi_Patient_Required_Flag_ID], [Auto_Generate_Overbook_Slots_ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblClinic])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[Clinic_ID], [Clinic_Name], [Administrator_Staff_ID], [Clinic_Location_ID], [Clinic_Type_ID], [Active_Flag_ID], [External_Code1], [External_Code2], [Allow_First_Appointments_Flag_ID], [Start_Time], [End_Time], [Clinic_Schedule_Type_ID], [Number_Of_Weeks], [Clinic_Period_Start_Date], [Clinic_Period_End_Date], [Slot_Size_Minutes], [SMS_Appointment_Reminders_Flag_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Colour_Code], [Clinic_Group_ID], [Referral_Required_Flag_ID], [Multi_Patient_Required_Flag_ID], [Auto_Generate_Overbook_Slots_ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblClinic]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[Clinic_ID], [Clinic_Name], [Administrator_Staff_ID], [Clinic_Location_ID], [Clinic_Type_ID], [Active_Flag_ID], [External_Code1], [External_Code2], [Allow_First_Appointments_Flag_ID], [Start_Time], [End_Time], [Clinic_Schedule_Type_ID], [Number_Of_Weeks], [Clinic_Period_Start_Date], [Clinic_Period_End_Date], [Slot_Size_Minutes], [SMS_Appointment_Reminders_Flag_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Colour_Code], [Clinic_Group_ID], [Referral_Required_Flag_ID], [Multi_Patient_Required_Flag_ID], [Auto_Generate_Overbook_Slots_ID]
						 FROM mrr_tbl.CNC_tblClinic))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.CNC_tblClinic has discrepancies when compared to its source table.', 1;

				END;
				
GO
