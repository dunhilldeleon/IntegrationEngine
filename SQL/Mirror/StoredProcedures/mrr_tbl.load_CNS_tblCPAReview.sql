SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

				/*==========================================================================================================================================
				Notes:
				Template for loading Mirror table incrementally.

				TODO Is this the right place for the transactions? Should transaction handling be external to this procedure?

				Test:

				EXECUTE mrr_tbl.load_CNS_tblCPAReview
				EXECUTE mrr_tbl.load_CNS_tblCPAReview 'F'

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[load_CNS_tblCPAReview]
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
							SELECT COUNT(*) FROM mrr_tbl.CNS_tblCPAReview
						);

						--	Load working table from source.
						BEGIN TRANSACTION; -- INSERT INTO mrr_wrk.CNS_tblCPAReview

						TRUNCATE TABLE mrr_wrk.CNS_tblCPAReview;

						INSERT INTO mrr_wrk.CNS_tblCPAReview
						(
							[CPA_Review_ID], [Updated_Dttm]
						)
						SELECT [CPA_Review_ID], [Updated_Dttm]
						FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblCPAReview];

						--	How many records in working table?
						SET @WorkingCount = @@ROWCOUNT;

						COMMIT TRANSACTION; -- INSERT INTO mrr_wrk.CNS_tblCPAReview

						--	If 0 records in target or ABS(nW-nT) > Threshold force a Truncate/Insert. --TODO not ideal test but achievable without slowing the procedure down too much.
						IF ABS(@WorkingCount - @OriginalTargetCount) >= CAST((@OriginalTargetCount * @Threshold / 100) AS INTEGER)
							SET @LoadType = 'F';

						BEGIN TRANSACTION; -- Start transaction for the load and audit.

						--	We now do either a full (F) reload of the target or an incremental (I) load depending on what has been requested or how much data is changing.
						IF @LoadType = 'F'
						BEGIN
							--	Full load target from source.

							TRUNCATE TABLE mrr_tbl.CNS_tblCPAReview;

							INSERT INTO mrr_tbl.CNS_tblCPAReview
							(
								[CPA_Review_ID], [Patient_ID], [CPA_Start_ID], [CPA_Review_Status_ID], [Plan_Month_ID], [Plan_Year_ID], [CPA_Review_Type_ID], [Sch_For_Staff_ID], [Sch_Date], [Sch_Start_Time], [Sch_End_Time], [Sch_Location_ID], [CPA_Employment_Status_ID], [CPA_Weekly_Hours_Worked_ID], [CPA_Accomodation_Status_ID], [CPA_Settled_Accomodation_Indicator_ID], [External_Invitees], [Act_Date], [Act_Start_Time], [Act_End_Time], [Act_Location_ID], [Act_Attended_By_Staff_ID], [External_Attendees], [Client_Given_Plan_ID], [Care_Plan_Reviewed_ID], [Risk_Assessment_Completed_ID], [HoNOS_Completed_ID], [Section_117_Status_Reviewed_ID], [Social_Worker_Involved_ID], [Child_Assessment_Requested_ID], [Day_Centre_Involved_ID], [Sheltered_Work_Involved_ID], [Non_NHS_Res_Accom_ID], [Domicil_Care_Involved_ID], [Level_Change_ID], [New_Level_ID], [Care_Coord_Change_ID], [Next_Meeting_Date], [Next_Step_ID], [Moved_To], [Contact_Info], [Responsibility_Of], [Moved_To_Accepted_ID], [Receiving_Direct_Payments_ID], [Individual_Budget_Agreed_ID], [Other_Financial_Considerations_ID], [Comments], [Accommodation_Status_Date], [Employment_Status_Date], [Abuse_Question_Asked_ID], [Attendance_Type_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Smoking_Status_ID], [Patient_Proxy_Attended_ID], [Patient_Proxy_Invited_ID], [Earliest_Reasonable_Offer_Date], [Earliest_Clinically_Appropriate_Date], [Replacement_Appointment_Date_Offered], [Replacement_Appointment_Booked_Date], [EROD_Override_Reason_ID]
							)
							SELECT [CPA_Review_ID], [Patient_ID], [CPA_Start_ID], [CPA_Review_Status_ID], [Plan_Month_ID], [Plan_Year_ID], [CPA_Review_Type_ID], [Sch_For_Staff_ID], [Sch_Date], [Sch_Start_Time], [Sch_End_Time], [Sch_Location_ID], [CPA_Employment_Status_ID], [CPA_Weekly_Hours_Worked_ID], [CPA_Accomodation_Status_ID], [CPA_Settled_Accomodation_Indicator_ID], [External_Invitees], [Act_Date], [Act_Start_Time], [Act_End_Time], [Act_Location_ID], [Act_Attended_By_Staff_ID], [External_Attendees], [Client_Given_Plan_ID], [Care_Plan_Reviewed_ID], [Risk_Assessment_Completed_ID], [HoNOS_Completed_ID], [Section_117_Status_Reviewed_ID], [Social_Worker_Involved_ID], [Child_Assessment_Requested_ID], [Day_Centre_Involved_ID], [Sheltered_Work_Involved_ID], [Non_NHS_Res_Accom_ID], [Domicil_Care_Involved_ID], [Level_Change_ID], [New_Level_ID], [Care_Coord_Change_ID], [Next_Meeting_Date], [Next_Step_ID], [Moved_To], [Contact_Info], [Responsibility_Of], [Moved_To_Accepted_ID], [Receiving_Direct_Payments_ID], [Individual_Budget_Agreed_ID], [Other_Financial_Considerations_ID], [Comments], [Accommodation_Status_Date], [Employment_Status_Date], [Abuse_Question_Asked_ID], [Attendance_Type_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Smoking_Status_ID], [Patient_Proxy_Attended_ID], [Patient_Proxy_Invited_ID], [Earliest_Reasonable_Offer_Date], [Earliest_Clinically_Appropriate_Date], [Replacement_Appointment_Date_Offered], [Replacement_Appointment_Booked_Date], [EROD_Override_Reason_ID]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblCPAReview];

							SET @Inserted = @@ROWCOUNT;

						END;
						--	Else load target incrementally...
						ELSE
						BEGIN

							--	Delete from target where target PK not in working table. --TODO We can save time by doing deletes and updated together but then we wouldn not be able to report separate counts for deleted/updated/inserted.
							DELETE tgt
							FROM mrr_tbl.CNS_tblCPAReview AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNS_tblCPAReview AS src
								WHERE tgt.[CPA_Review_ID] = src.[CPA_Review_ID]
							);
							--	How many deleted?
							SET @Deleted = @@ROWCOUNT;

							--	Delete from target where working table PK & ChangeDetectionColumn not in target.
							DELETE tgt
							FROM mrr_tbl.CNS_tblCPAReview AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNS_tblCPAReview AS src
								WHERE tgt.[CPA_Review_ID] = src.[CPA_Review_ID] AND tgt.[Updated_Dttm] = src.[Updated_Dttm]
							);
							--	How many updated?
							SET @Updated = @@ROWCOUNT;

							--		Insert into Target from source where working table PK & ChangeDetectionColumn not in target.
							INSERT INTO mrr_tbl.CNS_tblCPAReview
							(
								[CPA_Review_ID], [Patient_ID], [CPA_Start_ID], [CPA_Review_Status_ID], [Plan_Month_ID], [Plan_Year_ID], [CPA_Review_Type_ID], [Sch_For_Staff_ID], [Sch_Date], [Sch_Start_Time], [Sch_End_Time], [Sch_Location_ID], [CPA_Employment_Status_ID], [CPA_Weekly_Hours_Worked_ID], [CPA_Accomodation_Status_ID], [CPA_Settled_Accomodation_Indicator_ID], [External_Invitees], [Act_Date], [Act_Start_Time], [Act_End_Time], [Act_Location_ID], [Act_Attended_By_Staff_ID], [External_Attendees], [Client_Given_Plan_ID], [Care_Plan_Reviewed_ID], [Risk_Assessment_Completed_ID], [HoNOS_Completed_ID], [Section_117_Status_Reviewed_ID], [Social_Worker_Involved_ID], [Child_Assessment_Requested_ID], [Day_Centre_Involved_ID], [Sheltered_Work_Involved_ID], [Non_NHS_Res_Accom_ID], [Domicil_Care_Involved_ID], [Level_Change_ID], [New_Level_ID], [Care_Coord_Change_ID], [Next_Meeting_Date], [Next_Step_ID], [Moved_To], [Contact_Info], [Responsibility_Of], [Moved_To_Accepted_ID], [Receiving_Direct_Payments_ID], [Individual_Budget_Agreed_ID], [Other_Financial_Considerations_ID], [Comments], [Accommodation_Status_Date], [Employment_Status_Date], [Abuse_Question_Asked_ID], [Attendance_Type_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Smoking_Status_ID], [Patient_Proxy_Attended_ID], [Patient_Proxy_Invited_ID], [Earliest_Reasonable_Offer_Date], [Earliest_Clinically_Appropriate_Date], [Replacement_Appointment_Date_Offered], [Replacement_Appointment_Booked_Date], [EROD_Override_Reason_ID]
							)
							SELECT src.[CPA_Review_ID], src.[Patient_ID], src.[CPA_Start_ID], src.[CPA_Review_Status_ID], src.[Plan_Month_ID], src.[Plan_Year_ID], src.[CPA_Review_Type_ID], src.[Sch_For_Staff_ID], src.[Sch_Date], src.[Sch_Start_Time], src.[Sch_End_Time], src.[Sch_Location_ID], src.[CPA_Employment_Status_ID], src.[CPA_Weekly_Hours_Worked_ID], src.[CPA_Accomodation_Status_ID], src.[CPA_Settled_Accomodation_Indicator_ID], src.[External_Invitees], src.[Act_Date], src.[Act_Start_Time], src.[Act_End_Time], src.[Act_Location_ID], src.[Act_Attended_By_Staff_ID], src.[External_Attendees], src.[Client_Given_Plan_ID], src.[Care_Plan_Reviewed_ID], src.[Risk_Assessment_Completed_ID], src.[HoNOS_Completed_ID], src.[Section_117_Status_Reviewed_ID], src.[Social_Worker_Involved_ID], src.[Child_Assessment_Requested_ID], src.[Day_Centre_Involved_ID], src.[Sheltered_Work_Involved_ID], src.[Non_NHS_Res_Accom_ID], src.[Domicil_Care_Involved_ID], src.[Level_Change_ID], src.[New_Level_ID], src.[Care_Coord_Change_ID], src.[Next_Meeting_Date], src.[Next_Step_ID], src.[Moved_To], src.[Contact_Info], src.[Responsibility_Of], src.[Moved_To_Accepted_ID], src.[Receiving_Direct_Payments_ID], src.[Individual_Budget_Agreed_ID], src.[Other_Financial_Considerations_ID], src.[Comments], src.[Accommodation_Status_Date], src.[Employment_Status_Date], src.[Abuse_Question_Asked_ID], src.[Attendance_Type_ID], src.[User_Created], src.[Create_Dttm], src.[User_Updated], src.[Updated_Dttm], src.[Smoking_Status_ID], src.[Patient_Proxy_Attended_ID], src.[Patient_Proxy_Invited_ID], src.[Earliest_Reasonable_Offer_Date], src.[Earliest_Clinically_Appropriate_Date], src.[Replacement_Appointment_Date_Offered], src.[Replacement_Appointment_Booked_Date], src.[EROD_Override_Reason_ID]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblCPAReview] AS src
							INNER JOIN (SELECT wrk.[CPA_Review_ID] FROM mrr_wrk.CNS_tblCPAReview wrk
									WHERE NOT EXISTS
									(
										SELECT NULL
										FROM mrr_tbl.CNS_tblCPAReview AS tgt
										WHERE wrk.[CPA_Review_ID] = tgt.[CPA_Review_ID]
									)
								) MissingRecs ON (MissingRecs.[CPA_Review_ID] = src.[CPA_Review_ID]);


							--	How many really inserted? ROWCOUNT = inserted + updated records.
							SET @Inserted = @@ROWCOUNT - @Updated;

						--		Truncate working table? --TODO decide.
						END;

						--	Update audit table.
						SET @EndTime = GETDATE();

						INSERT INTO mrr_aud.CNS_tblCPAReview
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
						COMMIT TRANSACTION; -- INSERT INTO mrr_aud.CNS_tblCPAReview

					END TRY
					--Catch if transaction open roll it back.
					BEGIN CATCH
						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;
						THROW;
					END CATCH;

				END;
				
GO
