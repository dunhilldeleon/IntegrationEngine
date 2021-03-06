SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_CNC_tblAppointment

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_CNC_tblAppointment]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[Appointment_ID], [Patient_ID], [Appointment_Type_ID], [Clinic_ID], [Clinic_Date], [Clinic_Location_ID], [Clinic_Date_Location_ID], [Clinic_Date_Lead_Clinician_Staff_ID], [Clinic_Date_Attending_Clinician_Staff_ID], [Professional_Group_ID], [Medical_Type_Code], [Appointment_Length_Minutes], [Single_Slot_Size_Minutes], [Number_Of_Slots_Used], [Scheduled_Start_Time], [Scheduled_End_Time], [Scheduled_CPA_Review_Flag_ID], [Attendance_Type_ID], [Attended_Date], [Time_Arrived], [Actual_Start_Time], [Actual_End_Time], [Carer_Support_Flag_ID], [Carer_Only_Attended_Flag_ID], [Actual_CPA_Review_Flag_ID], [Appointment_Outcome_ID], [Appointment_Outcome_Detail], [Transport_Required_ID], [Transport_Provider_ID], [Transport_Ambulance_Reference], [Transport_Manning_Type_ID], [Transport_Gender_Preference_ID], [Transport_Type_ID], [Transport_Groups_Flag_ID], [Transport_Start_Date], [Transport_End_Date], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Transport_Booked_Flag_ID], [Object_Type_ID], [Patient_Proxy_Attended_ID], [Patient_Proxy_Invited_ID], [Earliest_Reasonable_Offer_Date], [Earliest_Clinically_Appropriate_Date], [Replacement_Appointment_Date_Offered], [Replacement_Appointment_Booked_Date], [EROD_Override_Reason_ID], [Language_Interpreter_Booked_Flag_ID], [Marked_For_Rescheduling_ID], [Rescheduled_From_ID], [Rescheduled_To_ID], [Reschedule_Reason_ID], [Is_This_Psychological_Therapy_ID], [Slam_Core_Om_Rating_Period_Covered_ID]
						 FROM mrr_tbl.CNC_tblAppointment
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[Appointment_ID], [Patient_ID], [Appointment_Type_ID], [Clinic_ID], [Clinic_Date], [Clinic_Location_ID], [Clinic_Date_Location_ID], [Clinic_Date_Lead_Clinician_Staff_ID], [Clinic_Date_Attending_Clinician_Staff_ID], [Professional_Group_ID], [Medical_Type_Code], [Appointment_Length_Minutes], [Single_Slot_Size_Minutes], [Number_Of_Slots_Used], [Scheduled_Start_Time], [Scheduled_End_Time], [Scheduled_CPA_Review_Flag_ID], [Attendance_Type_ID], [Attended_Date], [Time_Arrived], [Actual_Start_Time], [Actual_End_Time], [Carer_Support_Flag_ID], [Carer_Only_Attended_Flag_ID], [Actual_CPA_Review_Flag_ID], [Appointment_Outcome_ID], [Appointment_Outcome_Detail], [Transport_Required_ID], [Transport_Provider_ID], [Transport_Ambulance_Reference], [Transport_Manning_Type_ID], [Transport_Gender_Preference_ID], [Transport_Type_ID], [Transport_Groups_Flag_ID], [Transport_Start_Date], [Transport_End_Date], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Transport_Booked_Flag_ID], [Object_Type_ID], [Patient_Proxy_Attended_ID], [Patient_Proxy_Invited_ID], [Earliest_Reasonable_Offer_Date], [Earliest_Clinically_Appropriate_Date], [Replacement_Appointment_Date_Offered], [Replacement_Appointment_Booked_Date], [EROD_Override_Reason_ID], [Language_Interpreter_Booked_Flag_ID], [Marked_For_Rescheduling_ID], [Rescheduled_From_ID], [Rescheduled_To_ID], [Reschedule_Reason_ID], [Is_This_Psychological_Therapy_ID], [Slam_Core_Om_Rating_Period_Covered_ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblAppointment])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[Appointment_ID], [Patient_ID], [Appointment_Type_ID], [Clinic_ID], [Clinic_Date], [Clinic_Location_ID], [Clinic_Date_Location_ID], [Clinic_Date_Lead_Clinician_Staff_ID], [Clinic_Date_Attending_Clinician_Staff_ID], [Professional_Group_ID], [Medical_Type_Code], [Appointment_Length_Minutes], [Single_Slot_Size_Minutes], [Number_Of_Slots_Used], [Scheduled_Start_Time], [Scheduled_End_Time], [Scheduled_CPA_Review_Flag_ID], [Attendance_Type_ID], [Attended_Date], [Time_Arrived], [Actual_Start_Time], [Actual_End_Time], [Carer_Support_Flag_ID], [Carer_Only_Attended_Flag_ID], [Actual_CPA_Review_Flag_ID], [Appointment_Outcome_ID], [Appointment_Outcome_Detail], [Transport_Required_ID], [Transport_Provider_ID], [Transport_Ambulance_Reference], [Transport_Manning_Type_ID], [Transport_Gender_Preference_ID], [Transport_Type_ID], [Transport_Groups_Flag_ID], [Transport_Start_Date], [Transport_End_Date], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Transport_Booked_Flag_ID], [Object_Type_ID], [Patient_Proxy_Attended_ID], [Patient_Proxy_Invited_ID], [Earliest_Reasonable_Offer_Date], [Earliest_Clinically_Appropriate_Date], [Replacement_Appointment_Date_Offered], [Replacement_Appointment_Booked_Date], [EROD_Override_Reason_ID], [Language_Interpreter_Booked_Flag_ID], [Marked_For_Rescheduling_ID], [Rescheduled_From_ID], [Rescheduled_To_ID], [Reschedule_Reason_ID], [Is_This_Psychological_Therapy_ID], [Slam_Core_Om_Rating_Period_Covered_ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblAppointment]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[Appointment_ID], [Patient_ID], [Appointment_Type_ID], [Clinic_ID], [Clinic_Date], [Clinic_Location_ID], [Clinic_Date_Location_ID], [Clinic_Date_Lead_Clinician_Staff_ID], [Clinic_Date_Attending_Clinician_Staff_ID], [Professional_Group_ID], [Medical_Type_Code], [Appointment_Length_Minutes], [Single_Slot_Size_Minutes], [Number_Of_Slots_Used], [Scheduled_Start_Time], [Scheduled_End_Time], [Scheduled_CPA_Review_Flag_ID], [Attendance_Type_ID], [Attended_Date], [Time_Arrived], [Actual_Start_Time], [Actual_End_Time], [Carer_Support_Flag_ID], [Carer_Only_Attended_Flag_ID], [Actual_CPA_Review_Flag_ID], [Appointment_Outcome_ID], [Appointment_Outcome_Detail], [Transport_Required_ID], [Transport_Provider_ID], [Transport_Ambulance_Reference], [Transport_Manning_Type_ID], [Transport_Gender_Preference_ID], [Transport_Type_ID], [Transport_Groups_Flag_ID], [Transport_Start_Date], [Transport_End_Date], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Transport_Booked_Flag_ID], [Object_Type_ID], [Patient_Proxy_Attended_ID], [Patient_Proxy_Invited_ID], [Earliest_Reasonable_Offer_Date], [Earliest_Clinically_Appropriate_Date], [Replacement_Appointment_Date_Offered], [Replacement_Appointment_Booked_Date], [EROD_Override_Reason_ID], [Language_Interpreter_Booked_Flag_ID], [Marked_For_Rescheduling_ID], [Rescheduled_From_ID], [Rescheduled_To_ID], [Reschedule_Reason_ID], [Is_This_Psychological_Therapy_ID], [Slam_Core_Om_Rating_Period_Covered_ID]
						 FROM mrr_tbl.CNC_tblAppointment))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.CNC_tblAppointment has discrepancies when compared to its source table.', 1;

				END;
				
GO
