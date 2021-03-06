SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

				/*==========================================================================================================================================
				Notes:
				Template for loading Mirror table incrementally.

				TODO Is this the right place for the transactions? Should transaction handling be external to this procedure?

				Test:

				EXECUTE mrr_tbl.load_CNC_tblAppointment
				EXECUTE mrr_tbl.load_CNC_tblAppointment 'F'

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[load_CNC_tblAppointment]
					-- Add the parameters for the stored procedure here
					@LoadType NVARCHAR(1) = 'I' -- I= Incremental, F=Truncate/Insert
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;
					DECLARE @Threshold NUMERIC(4, 1) = 25.0; -- When gross change greater than this percentage, we will do a full reload. (Valid values between 0.0-100.0, to 1 decimal place.)
					DECLARE @OriginalTargetCount BIGINT,
							@WorkingCount INTEGER,
							@Inserted INTEGER = 0,
							@Updated INTEGER = 0,
							@Deleted INTEGER = 0,
							@StartTime DATETIME2 = GETDATE(),
							@EndTime DATETIME2;

					--Try...
					BEGIN TRY
						--	How many records in target (the count does not have to be super accurate but should be as fast as possible)?
						SET @OriginalTargetCount =
						(
							SELECT COUNT(*) FROM mrr_tbl.CNC_tblAppointment
						);

						--	Load working table from source.
						BEGIN TRANSACTION; -- INSERT INTO mrr_wrk.CNC_tblAppointment

						TRUNCATE TABLE mrr_wrk.CNC_tblAppointment;

						INSERT INTO mrr_wrk.CNC_tblAppointment
						(
							[Appointment_ID], [Updated_Dttm]
						)
						SELECT [Appointment_ID], [Updated_Dttm]
						FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblAppointment];

						--	How many records in working table?
						SET @WorkingCount = @@ROWCOUNT;

						COMMIT TRANSACTION; -- INSERT INTO mrr_wrk.CNC_tblAppointment

						--	If 0 records in target or ABS(nW-nT) > Threshold force a Truncate/Insert. --TODO not ideal test but achievable without slowing the procedure down too much.
						IF ABS(@WorkingCount - @OriginalTargetCount) >= CAST((@OriginalTargetCount * @Threshold / 100) AS INTEGER)
							SET @LoadType = 'F';

						BEGIN TRANSACTION; -- Start transaction for the load and audit.

						--	We now do either a full (F) reload of the target or an incremental (I) load depending on what has been requested or how much data is changing.
						IF @LoadType = 'F'
						BEGIN
							--	Full load target from source.

							TRUNCATE TABLE mrr_tbl.CNC_tblAppointment;

							INSERT INTO mrr_tbl.CNC_tblAppointment
							(
								[Appointment_ID], [Patient_ID], [Appointment_Type_ID], [Clinic_ID], [Clinic_Date], [Clinic_Location_ID], [Clinic_Date_Location_ID], [Clinic_Date_Lead_Clinician_Staff_ID], [Clinic_Date_Attending_Clinician_Staff_ID], [Professional_Group_ID], [Medical_Type_Code], [Appointment_Length_Minutes], [Single_Slot_Size_Minutes], [Number_Of_Slots_Used], [Scheduled_Start_Time], [Scheduled_End_Time], [Scheduled_CPA_Review_Flag_ID], [Attendance_Type_ID], [Attended_Date], [Time_Arrived], [Actual_Start_Time], [Actual_End_Time], [Carer_Support_Flag_ID], [Carer_Only_Attended_Flag_ID], [Actual_CPA_Review_Flag_ID], [Appointment_Outcome_ID], [Appointment_Outcome_Detail], [Comments], [Transport_Required_ID], [Transport_Provider_ID], [Transport_Ambulance_Reference], [Transport_Manning_Type_ID], [Transport_Gender_Preference_ID], [Transport_Type_ID], [Transport_Groups_Flag_ID], [Transport_Start_Date], [Transport_End_Date], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Transport_Booked_Flag_ID], [Object_Type_ID], [Patient_Proxy_Attended_ID], [Patient_Proxy_Invited_ID], [Earliest_Reasonable_Offer_Date], [Earliest_Clinically_Appropriate_Date], [Replacement_Appointment_Date_Offered], [Replacement_Appointment_Booked_Date], [EROD_Override_Reason_ID], [Language_Interpreter_Booked_Flag_ID], [Marked_For_Rescheduling_ID], [Rescheduled_From_ID], [Rescheduled_To_ID], [Reschedule_Reason_ID], [Is_This_Psychological_Therapy_ID], [Slam_Core_Om_Rating_Period_Covered_ID]
							)
							SELECT [Appointment_ID], [Patient_ID], [Appointment_Type_ID], [Clinic_ID], [Clinic_Date], [Clinic_Location_ID], [Clinic_Date_Location_ID], [Clinic_Date_Lead_Clinician_Staff_ID], [Clinic_Date_Attending_Clinician_Staff_ID], [Professional_Group_ID], [Medical_Type_Code], [Appointment_Length_Minutes], [Single_Slot_Size_Minutes], [Number_Of_Slots_Used], [Scheduled_Start_Time], [Scheduled_End_Time], [Scheduled_CPA_Review_Flag_ID], [Attendance_Type_ID], [Attended_Date], [Time_Arrived], [Actual_Start_Time], [Actual_End_Time], [Carer_Support_Flag_ID], [Carer_Only_Attended_Flag_ID], [Actual_CPA_Review_Flag_ID], [Appointment_Outcome_ID], [Appointment_Outcome_Detail], [Comments], [Transport_Required_ID], [Transport_Provider_ID], [Transport_Ambulance_Reference], [Transport_Manning_Type_ID], [Transport_Gender_Preference_ID], [Transport_Type_ID], [Transport_Groups_Flag_ID], [Transport_Start_Date], [Transport_End_Date], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Transport_Booked_Flag_ID], [Object_Type_ID], [Patient_Proxy_Attended_ID], [Patient_Proxy_Invited_ID], [Earliest_Reasonable_Offer_Date], [Earliest_Clinically_Appropriate_Date], [Replacement_Appointment_Date_Offered], [Replacement_Appointment_Booked_Date], [EROD_Override_Reason_ID], [Language_Interpreter_Booked_Flag_ID], [Marked_For_Rescheduling_ID], [Rescheduled_From_ID], [Rescheduled_To_ID], [Reschedule_Reason_ID], [Is_This_Psychological_Therapy_ID], [Slam_Core_Om_Rating_Period_Covered_ID]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblAppointment];

							SET @Inserted = @@ROWCOUNT;

						END;
						--	Else load target incrementally...
						ELSE
						BEGIN

							--	Delete from target where target PK not in working table. --TODO We can save time by doing deletes and updated together but then we wouldn not be able to report separate counts for deleted/updated/inserted.
							DELETE tgt
							FROM mrr_tbl.CNC_tblAppointment AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNC_tblAppointment AS src
								WHERE tgt.[Appointment_ID] = src.[Appointment_ID]
							);
							--	How many deleted?
							SET @Deleted = @@ROWCOUNT;

							--	Delete from target where working table PK & ChangeDetectionColumn not in target.
							DELETE tgt
							FROM mrr_tbl.CNC_tblAppointment AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNC_tblAppointment AS src
								WHERE tgt.[Appointment_ID] = src.[Appointment_ID] AND tgt.[Updated_Dttm] = src.[Updated_Dttm]
							);
							--	How many updated?
							SET @Updated = @@ROWCOUNT;

							--		Insert into Target from source where working table PK & ChangeDetectionColumn not in target.
							INSERT INTO mrr_tbl.CNC_tblAppointment
							(
								[Appointment_ID], [Patient_ID], [Appointment_Type_ID], [Clinic_ID], [Clinic_Date], [Clinic_Location_ID], [Clinic_Date_Location_ID], [Clinic_Date_Lead_Clinician_Staff_ID], [Clinic_Date_Attending_Clinician_Staff_ID], [Professional_Group_ID], [Medical_Type_Code], [Appointment_Length_Minutes], [Single_Slot_Size_Minutes], [Number_Of_Slots_Used], [Scheduled_Start_Time], [Scheduled_End_Time], [Scheduled_CPA_Review_Flag_ID], [Attendance_Type_ID], [Attended_Date], [Time_Arrived], [Actual_Start_Time], [Actual_End_Time], [Carer_Support_Flag_ID], [Carer_Only_Attended_Flag_ID], [Actual_CPA_Review_Flag_ID], [Appointment_Outcome_ID], [Appointment_Outcome_Detail], [Comments], [Transport_Required_ID], [Transport_Provider_ID], [Transport_Ambulance_Reference], [Transport_Manning_Type_ID], [Transport_Gender_Preference_ID], [Transport_Type_ID], [Transport_Groups_Flag_ID], [Transport_Start_Date], [Transport_End_Date], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Transport_Booked_Flag_ID], [Object_Type_ID], [Patient_Proxy_Attended_ID], [Patient_Proxy_Invited_ID], [Earliest_Reasonable_Offer_Date], [Earliest_Clinically_Appropriate_Date], [Replacement_Appointment_Date_Offered], [Replacement_Appointment_Booked_Date], [EROD_Override_Reason_ID], [Language_Interpreter_Booked_Flag_ID], [Marked_For_Rescheduling_ID], [Rescheduled_From_ID], [Rescheduled_To_ID], [Reschedule_Reason_ID], [Is_This_Psychological_Therapy_ID], [Slam_Core_Om_Rating_Period_Covered_ID]
							)
							SELECT src.[Appointment_ID], src.[Patient_ID], src.[Appointment_Type_ID], src.[Clinic_ID], src.[Clinic_Date], src.[Clinic_Location_ID], src.[Clinic_Date_Location_ID], src.[Clinic_Date_Lead_Clinician_Staff_ID], src.[Clinic_Date_Attending_Clinician_Staff_ID], src.[Professional_Group_ID], src.[Medical_Type_Code], src.[Appointment_Length_Minutes], src.[Single_Slot_Size_Minutes], src.[Number_Of_Slots_Used], src.[Scheduled_Start_Time], src.[Scheduled_End_Time], src.[Scheduled_CPA_Review_Flag_ID], src.[Attendance_Type_ID], src.[Attended_Date], src.[Time_Arrived], src.[Actual_Start_Time], src.[Actual_End_Time], src.[Carer_Support_Flag_ID], src.[Carer_Only_Attended_Flag_ID], src.[Actual_CPA_Review_Flag_ID], src.[Appointment_Outcome_ID], src.[Appointment_Outcome_Detail], src.[Comments], src.[Transport_Required_ID], src.[Transport_Provider_ID], src.[Transport_Ambulance_Reference], src.[Transport_Manning_Type_ID], src.[Transport_Gender_Preference_ID], src.[Transport_Type_ID], src.[Transport_Groups_Flag_ID], src.[Transport_Start_Date], src.[Transport_End_Date], src.[User_Created], src.[Create_Dttm], src.[User_Updated], src.[Updated_Dttm], src.[Transport_Booked_Flag_ID], src.[Object_Type_ID], src.[Patient_Proxy_Attended_ID], src.[Patient_Proxy_Invited_ID], src.[Earliest_Reasonable_Offer_Date], src.[Earliest_Clinically_Appropriate_Date], src.[Replacement_Appointment_Date_Offered], src.[Replacement_Appointment_Booked_Date], src.[EROD_Override_Reason_ID], src.[Language_Interpreter_Booked_Flag_ID], src.[Marked_For_Rescheduling_ID], src.[Rescheduled_From_ID], src.[Rescheduled_To_ID], src.[Reschedule_Reason_ID], src.[Is_This_Psychological_Therapy_ID], src.[Slam_Core_Om_Rating_Period_Covered_ID]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblAppointment] AS src
							INNER JOIN (SELECT wrk.[Appointment_ID] FROM mrr_wrk.CNC_tblAppointment wrk
									WHERE NOT EXISTS
									(
										SELECT NULL
										FROM mrr_tbl.CNC_tblAppointment AS tgt
										WHERE wrk.[Appointment_ID] = tgt.[Appointment_ID]
									)
								) MissingRecs ON (MissingRecs.[Appointment_ID] = src.[Appointment_ID]);


							--	How many really inserted? ROWCOUNT = inserted + updated records.
							SET @Inserted = @@ROWCOUNT - @Updated;

						--		Truncate working table? --TODO decide.
						END;

						--	Update audit table.
						SET @EndTime = GETDATE();

						INSERT INTO mrr_aud.CNC_tblAppointment
						(
							LoadType,
							RunByUser,
							StartTime,
							EndTime,
							Inserted,
							Updated,
							Deleted
						)
						VALUES
						(   @LoadType,   -- LoadType - nvarchar(1)
							SYSTEM_USER, -- RunByUser - nvarchar(128)
							@StartTime,  -- StartTime - datetime2(7)
							@EndTime,    -- EndTime - datetime2(7)
							@Inserted,   -- Inserted - int
							@Updated,    -- Updated - int
							@Deleted     -- Deleted - int
							);

						-- Commit the data lolad and audit table update.
						COMMIT TRANSACTION; -- INSERT INTO mrr_aud.CNC_tblAppointment

					END TRY
					--Catch if transaction open roll it back.
					BEGIN CATCH
						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;
						THROW;
					END CATCH;

				END;
				
GO
