SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

				/*==========================================================================================================================================
				Notes:
				Template for loading Mirror table incrementally.

				TODO Is this the right place for the transactions? Should transaction handling be external to this procedure?

				Test:

				EXECUTE mrr_tbl.load_CNC_tblEpisode
				EXECUTE mrr_tbl.load_CNC_tblEpisode 'F'

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[load_CNC_tblEpisode]
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
							SELECT COUNT(*) FROM mrr_tbl.CNC_tblEpisode
						);

						--	Load working table from source.
						BEGIN TRANSACTION; -- INSERT INTO mrr_wrk.CNC_tblEpisode

						TRUNCATE TABLE mrr_wrk.CNC_tblEpisode;

						INSERT INTO mrr_wrk.CNC_tblEpisode
						(
							[Episode_ID], [Updated_Dttm]
						)
						SELECT [Episode_ID], [Updated_Dttm]
						FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblEpisode];

						--	How many records in working table?
						SET @WorkingCount = @@ROWCOUNT;

						COMMIT TRANSACTION; -- INSERT INTO mrr_wrk.CNC_tblEpisode

						--	If 0 records in target or ABS(nW-nT) > Threshold force a Truncate/Insert. --TODO not ideal test but achievable without slowing the procedure down too much.
						IF ABS(@WorkingCount - @OriginalTargetCount) >= CAST((@OriginalTargetCount * @Threshold / 100) AS INTEGER)
							SET @LoadType = 'F';

						BEGIN TRANSACTION; -- Start transaction for the load and audit.

						--	We now do either a full (F) reload of the target or an incremental (I) load depending on what has been requested or how much data is changing.
						IF @LoadType = 'F'
						BEGIN
							--	Full load target from source.

							TRUNCATE TABLE mrr_tbl.CNC_tblEpisode;

							INSERT INTO mrr_tbl.CNC_tblEpisode
							(
								[Episode_ID], [Episode_Type_ID], [Patient_ID], [Referral_Date], [Referral_Time], [Referral_Received_Date], [Last_Contact_Date], [Referral_Source_ID], [Referral_Source_Type_ID], [Agency_ID], [Contact_Name], [Contact_Job_Title], [Contact_Telephone], [GP_ID], [Practice_ID], [GP_Code], [Practice_Code], [School_ID], [Contact_ID], [Staff_ID], [Episode_Priority_ID], [Referral_Reason_ID], [Presentation_Reason_ID], [Referrer_Address1], [Referrer_Address2], [Referrer_Address3], [Referrer_Address4], [Referrer_Address5], [Referrer_Post_Code], [Referrer_Telephone], [Referrer_Fax], [Referrer_Email], [Referrer_PCT_Code], [Referrer_PCT_Name], [Service_ID], [Location_ID], [Client_Normally_Seen_At_Location_ID], [Referral_Format_ID], [Referral_Status_ID], [Referral_Admin_Status_ID], [Referral_Administrative_Category_ID], [Episode_Admin_Priority_ID], [Accepted_Date], [Accepted_By_Staff_ID], [Accepted_By_Staff_Name], [Wait_Weeks], [Open_Weeks], [Start_Date], [Accommodation_ID], [Employment_ID], [Administration_Comments], [Rejection_Date], [Rejection_Reason_ID], [Rejection_Detail], [Rejected_By_Staff_ID], [Rejected_By_Staff_Name], [Discharge_Date], [Discharge_Time], [Discharge_Method_Episode_ID], [Discharge_Destination_ID], [Healthcare_Resource_Group_ID], [Discharge_Agreed_By_Staff_ID], [Discharge_Agreed_By_Staff_Name], [Discharge_Detail], [Comments], [Transport_Required_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Referrer_CCG_Code], [Referrer_CCG_Name], [Referral_Received_Time], [Agency_Staff_Category_ID], [Staff_Professional_Group_ID], [Discharge_Letter_Issued_Date], [Referral_Closure_Reason_ID], [NHS_Service_Agreement_Line_Number], [Reason_For_Out_Of_Area_Referral_ID]
							)
							SELECT [Episode_ID], [Episode_Type_ID], [Patient_ID], [Referral_Date], [Referral_Time], [Referral_Received_Date], [Last_Contact_Date], [Referral_Source_ID], [Referral_Source_Type_ID], [Agency_ID], [Contact_Name], [Contact_Job_Title], [Contact_Telephone], [GP_ID], [Practice_ID], [GP_Code], [Practice_Code], [School_ID], [Contact_ID], [Staff_ID], [Episode_Priority_ID], [Referral_Reason_ID], [Presentation_Reason_ID], [Referrer_Address1], [Referrer_Address2], [Referrer_Address3], [Referrer_Address4], [Referrer_Address5], [Referrer_Post_Code], [Referrer_Telephone], [Referrer_Fax], [Referrer_Email], [Referrer_PCT_Code], [Referrer_PCT_Name], [Service_ID], [Location_ID], [Client_Normally_Seen_At_Location_ID], [Referral_Format_ID], [Referral_Status_ID], [Referral_Admin_Status_ID], [Referral_Administrative_Category_ID], [Episode_Admin_Priority_ID], [Accepted_Date], [Accepted_By_Staff_ID], [Accepted_By_Staff_Name], [Wait_Weeks], [Open_Weeks], [Start_Date], [Accommodation_ID], [Employment_ID], [Administration_Comments], [Rejection_Date], [Rejection_Reason_ID], [Rejection_Detail], [Rejected_By_Staff_ID], [Rejected_By_Staff_Name], [Discharge_Date], [Discharge_Time], [Discharge_Method_Episode_ID], [Discharge_Destination_ID], [Healthcare_Resource_Group_ID], [Discharge_Agreed_By_Staff_ID], [Discharge_Agreed_By_Staff_Name], [Discharge_Detail], [Comments], [Transport_Required_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Referrer_CCG_Code], [Referrer_CCG_Name], [Referral_Received_Time], [Agency_Staff_Category_ID], [Staff_Professional_Group_ID], [Discharge_Letter_Issued_Date], [Referral_Closure_Reason_ID], [NHS_Service_Agreement_Line_Number], [Reason_For_Out_Of_Area_Referral_ID]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblEpisode];

							SET @Inserted = @@ROWCOUNT;

						END;
						--	Else load target incrementally...
						ELSE
						BEGIN

							--	Delete from target where target PK not in working table. --TODO We can save time by doing deletes and updated together but then we wouldn not be able to report separate counts for deleted/updated/inserted.
							DELETE tgt
							FROM mrr_tbl.CNC_tblEpisode AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNC_tblEpisode AS src
								WHERE tgt.[Episode_ID] = src.[Episode_ID]
							);
							--	How many deleted?
							SET @Deleted = @@ROWCOUNT;

							--	Delete from target where working table PK & ChangeDetectionColumn not in target.
							DELETE tgt
							FROM mrr_tbl.CNC_tblEpisode AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNC_tblEpisode AS src
								WHERE tgt.[Episode_ID] = src.[Episode_ID] AND tgt.[Updated_Dttm] = src.[Updated_Dttm]
							);
							--	How many updated?
							SET @Updated = @@ROWCOUNT;

							--		Insert into Target from source where working table PK & ChangeDetectionColumn not in target.
							INSERT INTO mrr_tbl.CNC_tblEpisode
							(
								[Episode_ID], [Episode_Type_ID], [Patient_ID], [Referral_Date], [Referral_Time], [Referral_Received_Date], [Last_Contact_Date], [Referral_Source_ID], [Referral_Source_Type_ID], [Agency_ID], [Contact_Name], [Contact_Job_Title], [Contact_Telephone], [GP_ID], [Practice_ID], [GP_Code], [Practice_Code], [School_ID], [Contact_ID], [Staff_ID], [Episode_Priority_ID], [Referral_Reason_ID], [Presentation_Reason_ID], [Referrer_Address1], [Referrer_Address2], [Referrer_Address3], [Referrer_Address4], [Referrer_Address5], [Referrer_Post_Code], [Referrer_Telephone], [Referrer_Fax], [Referrer_Email], [Referrer_PCT_Code], [Referrer_PCT_Name], [Service_ID], [Location_ID], [Client_Normally_Seen_At_Location_ID], [Referral_Format_ID], [Referral_Status_ID], [Referral_Admin_Status_ID], [Referral_Administrative_Category_ID], [Episode_Admin_Priority_ID], [Accepted_Date], [Accepted_By_Staff_ID], [Accepted_By_Staff_Name], [Wait_Weeks], [Open_Weeks], [Start_Date], [Accommodation_ID], [Employment_ID], [Administration_Comments], [Rejection_Date], [Rejection_Reason_ID], [Rejection_Detail], [Rejected_By_Staff_ID], [Rejected_By_Staff_Name], [Discharge_Date], [Discharge_Time], [Discharge_Method_Episode_ID], [Discharge_Destination_ID], [Healthcare_Resource_Group_ID], [Discharge_Agreed_By_Staff_ID], [Discharge_Agreed_By_Staff_Name], [Discharge_Detail], [Comments], [Transport_Required_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Referrer_CCG_Code], [Referrer_CCG_Name], [Referral_Received_Time], [Agency_Staff_Category_ID], [Staff_Professional_Group_ID], [Discharge_Letter_Issued_Date], [Referral_Closure_Reason_ID], [NHS_Service_Agreement_Line_Number], [Reason_For_Out_Of_Area_Referral_ID]
							)
							SELECT src.[Episode_ID], src.[Episode_Type_ID], src.[Patient_ID], src.[Referral_Date], src.[Referral_Time], src.[Referral_Received_Date], src.[Last_Contact_Date], src.[Referral_Source_ID], src.[Referral_Source_Type_ID], src.[Agency_ID], src.[Contact_Name], src.[Contact_Job_Title], src.[Contact_Telephone], src.[GP_ID], src.[Practice_ID], src.[GP_Code], src.[Practice_Code], src.[School_ID], src.[Contact_ID], src.[Staff_ID], src.[Episode_Priority_ID], src.[Referral_Reason_ID], src.[Presentation_Reason_ID], src.[Referrer_Address1], src.[Referrer_Address2], src.[Referrer_Address3], src.[Referrer_Address4], src.[Referrer_Address5], src.[Referrer_Post_Code], src.[Referrer_Telephone], src.[Referrer_Fax], src.[Referrer_Email], src.[Referrer_PCT_Code], src.[Referrer_PCT_Name], src.[Service_ID], src.[Location_ID], src.[Client_Normally_Seen_At_Location_ID], src.[Referral_Format_ID], src.[Referral_Status_ID], src.[Referral_Admin_Status_ID], src.[Referral_Administrative_Category_ID], src.[Episode_Admin_Priority_ID], src.[Accepted_Date], src.[Accepted_By_Staff_ID], src.[Accepted_By_Staff_Name], src.[Wait_Weeks], src.[Open_Weeks], src.[Start_Date], src.[Accommodation_ID], src.[Employment_ID], src.[Administration_Comments], src.[Rejection_Date], src.[Rejection_Reason_ID], src.[Rejection_Detail], src.[Rejected_By_Staff_ID], src.[Rejected_By_Staff_Name], src.[Discharge_Date], src.[Discharge_Time], src.[Discharge_Method_Episode_ID], src.[Discharge_Destination_ID], src.[Healthcare_Resource_Group_ID], src.[Discharge_Agreed_By_Staff_ID], src.[Discharge_Agreed_By_Staff_Name], src.[Discharge_Detail], src.[Comments], src.[Transport_Required_ID], src.[User_Created], src.[Create_Dttm], src.[User_Updated], src.[Updated_Dttm], src.[Referrer_CCG_Code], src.[Referrer_CCG_Name], src.[Referral_Received_Time], src.[Agency_Staff_Category_ID], src.[Staff_Professional_Group_ID], src.[Discharge_Letter_Issued_Date], src.[Referral_Closure_Reason_ID], src.[NHS_Service_Agreement_Line_Number], src.[Reason_For_Out_Of_Area_Referral_ID]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblEpisode] AS src
							INNER JOIN (SELECT wrk.[Episode_ID] FROM mrr_wrk.CNC_tblEpisode wrk
									WHERE NOT EXISTS
									(
										SELECT NULL
										FROM mrr_tbl.CNC_tblEpisode AS tgt
										WHERE wrk.[Episode_ID] = tgt.[Episode_ID]
									)
								) MissingRecs ON (MissingRecs.[Episode_ID] = src.[Episode_ID]);


							--	How many really inserted? ROWCOUNT = inserted + updated records.
							SET @Inserted = @@ROWCOUNT - @Updated;

						--		Truncate working table? --TODO decide.
						END;

						--	Update audit table.
						SET @EndTime = GETDATE();

						INSERT INTO mrr_aud.CNC_tblEpisode
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
						COMMIT TRANSACTION; -- INSERT INTO mrr_aud.CNC_tblEpisode

					END TRY
					--Catch if transaction open roll it back.
					BEGIN CATCH
						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;
						THROW;
					END CATCH;

				END;
				
GO
