SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

				/*==========================================================================================================================================
				Notes:
				Template for loading Mirror table incrementally.

				TODO Is this the right place for the transactions? Should transaction handling be external to this procedure?

				Test:

				EXECUTE mrr_tbl.load_CNC_tblStaff
				EXECUTE mrr_tbl.load_CNC_tblStaff 'F'

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[load_CNC_tblStaff]
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
							SELECT COUNT(*) FROM mrr_tbl.CNC_tblStaff
						);

						--	Load working table from source.
						BEGIN TRANSACTION; -- INSERT INTO mrr_wrk.CNC_tblStaff

						TRUNCATE TABLE mrr_wrk.CNC_tblStaff;

						INSERT INTO mrr_wrk.CNC_tblStaff
						(
							[Staff_ID], [Updated_Dttm]
						)
						SELECT [Staff_ID], [Updated_Dttm]
						FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblStaff];

						--	How many records in working table?
						SET @WorkingCount = @@ROWCOUNT;

						COMMIT TRANSACTION; -- INSERT INTO mrr_wrk.CNC_tblStaff

						--	If 0 records in target or ABS(nW-nT) > Threshold force a Truncate/Insert. --TODO not ideal test but achievable without slowing the procedure down too much.
						IF ABS(@WorkingCount - @OriginalTargetCount) >= CAST((@OriginalTargetCount * @Threshold / 100) AS INTEGER)
							SET @LoadType = 'F';

						BEGIN TRANSACTION; -- Start transaction for the load and audit.

						--	We now do either a full (F) reload of the target or an incremental (I) load depending on what has been requested or how much data is changing.
						IF @LoadType = 'F'
						BEGIN
							--	Full load target from source.

							TRUNCATE TABLE mrr_tbl.CNC_tblStaff;

							INSERT INTO mrr_tbl.CNC_tblStaff
							(
								[Staff_ID], [Staff_Name], [Forename], [MiddleInitial], [Surname], [Active], [Staff_Type_ID], [Job_Title], [Email], [Enable_Email_ID], [Mobile], [Enable_Mobile_ID], [Employee_Ref], [Staff_Loc_ID], [Professional_Group_ID], [Occupation_Code_ID], [Specialty_ID], [Consultant_GMC_Code], [Available_Appointment_1], [Available_Appointment_2], [Available_Appointment_3], [Available_Appointment_4], [Available_Appointment_5], [Available_Appointment_6], [Available_Appointment_7], [Available_Appointment_8], [Available_Appointment_9], [Available_Appointment_10], [Additional_Information], [RC_Type_ID], [Appointment_Notes], [Staff_Notes], [Prescriber_PIN], [Prescriber_Type_ID], [Job_Role_Code_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [SDS_ID], [Default_Role_Profile_Code_ID], [IAPT_Training_ID], [CYP_IAPT_Dataset_Profession_ID], [Treatment_Function_Code_ID], [Clinician_Type_ID], [Gender_ID], [Religion_ID], [Professional_Registration_Entry], [Professional_Body_ID]
							)
							SELECT [Staff_ID], [Staff_Name], [Forename], [MiddleInitial], [Surname], [Active], [Staff_Type_ID], [Job_Title], [Email], [Enable_Email_ID], [Mobile], [Enable_Mobile_ID], [Employee_Ref], [Staff_Loc_ID], [Professional_Group_ID], [Occupation_Code_ID], [Specialty_ID], [Consultant_GMC_Code], [Available_Appointment_1], [Available_Appointment_2], [Available_Appointment_3], [Available_Appointment_4], [Available_Appointment_5], [Available_Appointment_6], [Available_Appointment_7], [Available_Appointment_8], [Available_Appointment_9], [Available_Appointment_10], [Additional_Information], [RC_Type_ID], [Appointment_Notes], [Staff_Notes], [Prescriber_PIN], [Prescriber_Type_ID], [Job_Role_Code_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [SDS_ID], [Default_Role_Profile_Code_ID], [IAPT_Training_ID], [CYP_IAPT_Dataset_Profession_ID], [Treatment_Function_Code_ID], [Clinician_Type_ID], [Gender_ID], [Religion_ID], [Professional_Registration_Entry], [Professional_Body_ID]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblStaff];

							SET @Inserted = @@ROWCOUNT;

						END;
						--	Else load target incrementally...
						ELSE
						BEGIN

							--	Delete from target where target PK not in working table. --TODO We can save time by doing deletes and updated together but then we wouldn not be able to report separate counts for deleted/updated/inserted.
							DELETE tgt
							FROM mrr_tbl.CNC_tblStaff AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNC_tblStaff AS src
								WHERE tgt.[Staff_ID] = src.[Staff_ID]
							);
							--	How many deleted?
							SET @Deleted = @@ROWCOUNT;

							--	Delete from target where working table PK & ChangeDetectionColumn not in target.
							DELETE tgt
							FROM mrr_tbl.CNC_tblStaff AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNC_tblStaff AS src
								WHERE tgt.[Staff_ID] = src.[Staff_ID] AND tgt.[Updated_Dttm] = src.[Updated_Dttm]
							);
							--	How many updated?
							SET @Updated = @@ROWCOUNT;

							--		Insert into Target from source where working table PK & ChangeDetectionColumn not in target.
							INSERT INTO mrr_tbl.CNC_tblStaff
							(
								[Staff_ID], [Staff_Name], [Forename], [MiddleInitial], [Surname], [Active], [Staff_Type_ID], [Job_Title], [Email], [Enable_Email_ID], [Mobile], [Enable_Mobile_ID], [Employee_Ref], [Staff_Loc_ID], [Professional_Group_ID], [Occupation_Code_ID], [Specialty_ID], [Consultant_GMC_Code], [Available_Appointment_1], [Available_Appointment_2], [Available_Appointment_3], [Available_Appointment_4], [Available_Appointment_5], [Available_Appointment_6], [Available_Appointment_7], [Available_Appointment_8], [Available_Appointment_9], [Available_Appointment_10], [Additional_Information], [RC_Type_ID], [Appointment_Notes], [Staff_Notes], [Prescriber_PIN], [Prescriber_Type_ID], [Job_Role_Code_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [SDS_ID], [Default_Role_Profile_Code_ID], [IAPT_Training_ID], [CYP_IAPT_Dataset_Profession_ID], [Treatment_Function_Code_ID], [Clinician_Type_ID], [Gender_ID], [Religion_ID], [Professional_Registration_Entry], [Professional_Body_ID]
							)
							SELECT src.[Staff_ID], src.[Staff_Name], src.[Forename], src.[MiddleInitial], src.[Surname], src.[Active], src.[Staff_Type_ID], src.[Job_Title], src.[Email], src.[Enable_Email_ID], src.[Mobile], src.[Enable_Mobile_ID], src.[Employee_Ref], src.[Staff_Loc_ID], src.[Professional_Group_ID], src.[Occupation_Code_ID], src.[Specialty_ID], src.[Consultant_GMC_Code], src.[Available_Appointment_1], src.[Available_Appointment_2], src.[Available_Appointment_3], src.[Available_Appointment_4], src.[Available_Appointment_5], src.[Available_Appointment_6], src.[Available_Appointment_7], src.[Available_Appointment_8], src.[Available_Appointment_9], src.[Available_Appointment_10], src.[Additional_Information], src.[RC_Type_ID], src.[Appointment_Notes], src.[Staff_Notes], src.[Prescriber_PIN], src.[Prescriber_Type_ID], src.[Job_Role_Code_ID], src.[User_Created], src.[Create_Dttm], src.[User_Updated], src.[Updated_Dttm], src.[SDS_ID], src.[Default_Role_Profile_Code_ID], src.[IAPT_Training_ID], src.[CYP_IAPT_Dataset_Profession_ID], src.[Treatment_Function_Code_ID], src.[Clinician_Type_ID], src.[Gender_ID], src.[Religion_ID], src.[Professional_Registration_Entry], src.[Professional_Body_ID]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblStaff] AS src
							INNER JOIN (SELECT wrk.[Staff_ID] FROM mrr_wrk.CNC_tblStaff wrk
									WHERE NOT EXISTS
									(
										SELECT NULL
										FROM mrr_tbl.CNC_tblStaff AS tgt
										WHERE wrk.[Staff_ID] = tgt.[Staff_ID]
									)
								) MissingRecs ON (MissingRecs.[Staff_ID] = src.[Staff_ID]);


							--	How many really inserted? ROWCOUNT = inserted + updated records.
							SET @Inserted = @@ROWCOUNT - @Updated;

						--		Truncate working table? --TODO decide.
						END;

						--	Update audit table.
						SET @EndTime = GETDATE();

						INSERT INTO mrr_aud.CNC_tblStaff
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
						COMMIT TRANSACTION; -- INSERT INTO mrr_aud.CNC_tblStaff

					END TRY
					--Catch if transaction open roll it back.
					BEGIN CATCH
						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;
						THROW;
					END CATCH;

				END;
				
GO
