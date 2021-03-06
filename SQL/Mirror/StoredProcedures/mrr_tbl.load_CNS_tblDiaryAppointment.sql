SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

				/*==========================================================================================================================================
				Notes:
				Template for loading Mirror table incrementally.

				TODO Is this the right place for the transactions? Should transaction handling be external to this procedure?

				Test:

				EXECUTE mrr_tbl.load_CNS_tblDiaryAppointment
				EXECUTE mrr_tbl.load_CNS_tblDiaryAppointment 'F'

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[load_CNS_tblDiaryAppointment]
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
							SELECT COUNT(*) FROM mrr_tbl.CNS_tblDiaryAppointment
						);

						--	Load working table from source.
						BEGIN TRANSACTION; -- INSERT INTO mrr_wrk.CNS_tblDiaryAppointment

						TRUNCATE TABLE mrr_wrk.CNS_tblDiaryAppointment;

						INSERT INTO mrr_wrk.CNS_tblDiaryAppointment
						(
							[Diary_Appointment_ID], [Updated_Dttm]
						)
						SELECT [Diary_Appointment_ID], [Updated_Dttm]
						FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblDiaryAppointment];

						--	How many records in working table?
						SET @WorkingCount = @@ROWCOUNT;

						COMMIT TRANSACTION; -- INSERT INTO mrr_wrk.CNS_tblDiaryAppointment

						--	If 0 records in target or ABS(nW-nT) > Threshold force a Truncate/Insert. --TODO not ideal test but achievable without slowing the procedure down too much.
						IF ABS(@WorkingCount - @OriginalTargetCount) >= CAST((@OriginalTargetCount * @Threshold / 100) AS INTEGER)
							SET @LoadType = 'F';

						BEGIN TRANSACTION; -- Start transaction for the load and audit.

						--	We now do either a full (F) reload of the target or an incremental (I) load depending on what has been requested or how much data is changing.
						IF @LoadType = 'F'
						BEGIN
							--	Full load target from source.

							TRUNCATE TABLE mrr_tbl.CNS_tblDiaryAppointment;

							INSERT INTO mrr_tbl.CNS_tblDiaryAppointment
							(
								[Diary_Appointment_ID], [Patient_ID], [Created_By_Staff_ID], [Service_ID], [Location_ID], [DH_Session_Type_ID], [Attendance_Type_ID], [Event_Type_ID], [No_Clinicians_Attendee_Flag_ID], [Scheduled_Other_Invitees], [Scheduled_CPA_Review_Flag_ID], [Scheduled_Interpreter_Reqd_Flag_ID], [Scheduled_Location_ID], [Scheduled_Room_ID], [Scheduled_Start_Date], [Scheduled_Overnight_Flag_ID], [Scheduled_End_Date], [Scheduled_Start_Time], [Scheduled_End_Time], [Scheduled_Start_Dttm], [Scheduled_End_Dttm], [Scheduled_Event_Type_Of_Contact_ID], [Att_Other_Invitees], [Att_CPA_Review_Flag_ID], [Att_Interpreter_Attended_Flag_ID], [Att_Location_ID], [Att_Room_ID], [Att_Start_Date], [Att_End_Date], [Att_Overnight_Flag_ID], [Att_Start_Time], [Att_End_Time], [Att_Start_Dttm], [Att_End_Dttm], [Att_Event_Type_Of_Contact_ID], [Comments], [Transport_Required_ID], [Transport_Provider_ID], [Transport_Ambulance_Reference], [Transport_Manning_Type_ID], [Transport_Gender_Preference_ID], [Transport_Type_ID], [Transport_Groups_Flag_ID], [Transport_Start_Date], [Transport_End_Date], [Invitee_Staff_Only_ID], [Attendee_Staff_Only_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Object_Type_ID], [Att_Patient_Proxy_Attended_ID], [Scheduled_Patient_Proxy_Invited_ID], [Earliest_Reasonable_Offer_Date], [Earliest_Clinically_Appropriate_Date], [Replacement_Appointment_Date_Offered], [Replacement_Appointment_Booked_Date], [EROD_Override_Reason_ID]
							)
							SELECT [Diary_Appointment_ID], [Patient_ID], [Created_By_Staff_ID], [Service_ID], [Location_ID], [DH_Session_Type_ID], [Attendance_Type_ID], [Event_Type_ID], [No_Clinicians_Attendee_Flag_ID], [Scheduled_Other_Invitees], [Scheduled_CPA_Review_Flag_ID], [Scheduled_Interpreter_Reqd_Flag_ID], [Scheduled_Location_ID], [Scheduled_Room_ID], [Scheduled_Start_Date], [Scheduled_Overnight_Flag_ID], [Scheduled_End_Date], [Scheduled_Start_Time], [Scheduled_End_Time], [Scheduled_Start_Dttm], [Scheduled_End_Dttm], [Scheduled_Event_Type_Of_Contact_ID], [Att_Other_Invitees], [Att_CPA_Review_Flag_ID], [Att_Interpreter_Attended_Flag_ID], [Att_Location_ID], [Att_Room_ID], [Att_Start_Date], [Att_End_Date], [Att_Overnight_Flag_ID], [Att_Start_Time], [Att_End_Time], [Att_Start_Dttm], [Att_End_Dttm], [Att_Event_Type_Of_Contact_ID], [Comments], [Transport_Required_ID], [Transport_Provider_ID], [Transport_Ambulance_Reference], [Transport_Manning_Type_ID], [Transport_Gender_Preference_ID], [Transport_Type_ID], [Transport_Groups_Flag_ID], [Transport_Start_Date], [Transport_End_Date], [Invitee_Staff_Only_ID], [Attendee_Staff_Only_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Object_Type_ID], [Att_Patient_Proxy_Attended_ID], [Scheduled_Patient_Proxy_Invited_ID], [Earliest_Reasonable_Offer_Date], [Earliest_Clinically_Appropriate_Date], [Replacement_Appointment_Date_Offered], [Replacement_Appointment_Booked_Date], [EROD_Override_Reason_ID]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblDiaryAppointment];

							SET @Inserted = @@ROWCOUNT;

						END;
						--	Else load target incrementally...
						ELSE
						BEGIN

							--	Delete from target where target PK not in working table. --TODO We can save time by doing deletes and updated together but then we wouldn not be able to report separate counts for deleted/updated/inserted.
							DELETE tgt
							FROM mrr_tbl.CNS_tblDiaryAppointment AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNS_tblDiaryAppointment AS src
								WHERE tgt.[Diary_Appointment_ID] = src.[Diary_Appointment_ID]
							);
							--	How many deleted?
							SET @Deleted = @@ROWCOUNT;

							--	Delete from target where working table PK & ChangeDetectionColumn not in target.
							DELETE tgt
							FROM mrr_tbl.CNS_tblDiaryAppointment AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNS_tblDiaryAppointment AS src
								WHERE tgt.[Diary_Appointment_ID] = src.[Diary_Appointment_ID] AND tgt.[Updated_Dttm] = src.[Updated_Dttm]
							);
							--	How many updated?
							SET @Updated = @@ROWCOUNT;

							--		Insert into Target from source where working table PK & ChangeDetectionColumn not in target.
							INSERT INTO mrr_tbl.CNS_tblDiaryAppointment
							(
								[Diary_Appointment_ID], [Patient_ID], [Created_By_Staff_ID], [Service_ID], [Location_ID], [DH_Session_Type_ID], [Attendance_Type_ID], [Event_Type_ID], [No_Clinicians_Attendee_Flag_ID], [Scheduled_Other_Invitees], [Scheduled_CPA_Review_Flag_ID], [Scheduled_Interpreter_Reqd_Flag_ID], [Scheduled_Location_ID], [Scheduled_Room_ID], [Scheduled_Start_Date], [Scheduled_Overnight_Flag_ID], [Scheduled_End_Date], [Scheduled_Start_Time], [Scheduled_End_Time], [Scheduled_Start_Dttm], [Scheduled_End_Dttm], [Scheduled_Event_Type_Of_Contact_ID], [Att_Other_Invitees], [Att_CPA_Review_Flag_ID], [Att_Interpreter_Attended_Flag_ID], [Att_Location_ID], [Att_Room_ID], [Att_Start_Date], [Att_End_Date], [Att_Overnight_Flag_ID], [Att_Start_Time], [Att_End_Time], [Att_Start_Dttm], [Att_End_Dttm], [Att_Event_Type_Of_Contact_ID], [Comments], [Transport_Required_ID], [Transport_Provider_ID], [Transport_Ambulance_Reference], [Transport_Manning_Type_ID], [Transport_Gender_Preference_ID], [Transport_Type_ID], [Transport_Groups_Flag_ID], [Transport_Start_Date], [Transport_End_Date], [Invitee_Staff_Only_ID], [Attendee_Staff_Only_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Object_Type_ID], [Att_Patient_Proxy_Attended_ID], [Scheduled_Patient_Proxy_Invited_ID], [Earliest_Reasonable_Offer_Date], [Earliest_Clinically_Appropriate_Date], [Replacement_Appointment_Date_Offered], [Replacement_Appointment_Booked_Date], [EROD_Override_Reason_ID]
							)
							SELECT src.[Diary_Appointment_ID], src.[Patient_ID], src.[Created_By_Staff_ID], src.[Service_ID], src.[Location_ID], src.[DH_Session_Type_ID], src.[Attendance_Type_ID], src.[Event_Type_ID], src.[No_Clinicians_Attendee_Flag_ID], src.[Scheduled_Other_Invitees], src.[Scheduled_CPA_Review_Flag_ID], src.[Scheduled_Interpreter_Reqd_Flag_ID], src.[Scheduled_Location_ID], src.[Scheduled_Room_ID], src.[Scheduled_Start_Date], src.[Scheduled_Overnight_Flag_ID], src.[Scheduled_End_Date], src.[Scheduled_Start_Time], src.[Scheduled_End_Time], src.[Scheduled_Start_Dttm], src.[Scheduled_End_Dttm], src.[Scheduled_Event_Type_Of_Contact_ID], src.[Att_Other_Invitees], src.[Att_CPA_Review_Flag_ID], src.[Att_Interpreter_Attended_Flag_ID], src.[Att_Location_ID], src.[Att_Room_ID], src.[Att_Start_Date], src.[Att_End_Date], src.[Att_Overnight_Flag_ID], src.[Att_Start_Time], src.[Att_End_Time], src.[Att_Start_Dttm], src.[Att_End_Dttm], src.[Att_Event_Type_Of_Contact_ID], src.[Comments], src.[Transport_Required_ID], src.[Transport_Provider_ID], src.[Transport_Ambulance_Reference], src.[Transport_Manning_Type_ID], src.[Transport_Gender_Preference_ID], src.[Transport_Type_ID], src.[Transport_Groups_Flag_ID], src.[Transport_Start_Date], src.[Transport_End_Date], src.[Invitee_Staff_Only_ID], src.[Attendee_Staff_Only_ID], src.[User_Created], src.[Create_Dttm], src.[User_Updated], src.[Updated_Dttm], src.[Object_Type_ID], src.[Att_Patient_Proxy_Attended_ID], src.[Scheduled_Patient_Proxy_Invited_ID], src.[Earliest_Reasonable_Offer_Date], src.[Earliest_Clinically_Appropriate_Date], src.[Replacement_Appointment_Date_Offered], src.[Replacement_Appointment_Booked_Date], src.[EROD_Override_Reason_ID]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblDiaryAppointment] AS src
							INNER JOIN (SELECT wrk.[Diary_Appointment_ID] FROM mrr_wrk.CNS_tblDiaryAppointment wrk
									WHERE NOT EXISTS
									(
										SELECT NULL
										FROM mrr_tbl.CNS_tblDiaryAppointment AS tgt
										WHERE wrk.[Diary_Appointment_ID] = tgt.[Diary_Appointment_ID]
									)
								) MissingRecs ON (MissingRecs.[Diary_Appointment_ID] = src.[Diary_Appointment_ID]);


							--	How many really inserted? ROWCOUNT = inserted + updated records.
							SET @Inserted = @@ROWCOUNT - @Updated;

						--		Truncate working table? --TODO decide.
						END;

						--	Update audit table.
						SET @EndTime = GETDATE();

						INSERT INTO mrr_aud.CNS_tblDiaryAppointment
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
						COMMIT TRANSACTION; -- INSERT INTO mrr_aud.CNS_tblDiaryAppointment

					END TRY
					--Catch if transaction open roll it back.
					BEGIN CATCH
						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;
						THROW;
					END CATCH;

				END;
				
GO
