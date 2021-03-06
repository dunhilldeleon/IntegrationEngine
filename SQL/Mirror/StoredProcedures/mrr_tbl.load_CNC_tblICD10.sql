SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

				/*==========================================================================================================================================
				Notes:
				Template for loading Mirror table incrementally.

				TODO Is this the right place for the transactions? Should transaction handling be external to this procedure?

				Test:

				EXECUTE mrr_tbl.load_CNC_tblICD10
				EXECUTE mrr_tbl.load_CNC_tblICD10 'F'

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[load_CNC_tblICD10]
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
							SELECT COUNT(*) FROM mrr_tbl.CNC_tblICD10
						);

						--	Load working table from source.
						BEGIN TRANSACTION; -- INSERT INTO mrr_wrk.CNC_tblICD10

						TRUNCATE TABLE mrr_wrk.CNC_tblICD10;

						INSERT INTO mrr_wrk.CNC_tblICD10
						(
							[ICD10_ID], [Updated_Dttm]
						)
						SELECT [ICD10_ID], [Updated_Dttm]
						FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblICD10];

						--	How many records in working table?
						SET @WorkingCount = @@ROWCOUNT;

						COMMIT TRANSACTION; -- INSERT INTO mrr_wrk.CNC_tblICD10

						--	If 0 records in target or ABS(nW-nT) > Threshold force a Truncate/Insert. --TODO not ideal test but achievable without slowing the procedure down too much.
						IF ABS(@WorkingCount - @OriginalTargetCount) >= CAST((@OriginalTargetCount * @Threshold / 100) AS INTEGER)
							SET @LoadType = 'F';

						BEGIN TRANSACTION; -- Start transaction for the load and audit.

						--	We now do either a full (F) reload of the target or an incremental (I) load depending on what has been requested or how much data is changing.
						IF @LoadType = 'F'
						BEGIN
							--	Full load target from source.

							TRUNCATE TABLE mrr_tbl.CNC_tblICD10;

							INSERT INTO mrr_tbl.CNC_tblICD10
							(
								[ICD10_ID], [Patient_ID], [Version_ID], [Diagnosis_Date], [RMO_GP_Flag_ID], [Diagnosis_By_ID], [RMO_Name_ID], [Confirm_Flag_ID], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [Confirm_Date], [RMO_Confirm_Date], [Prev_Psy_Episode_ID], [Primary_Diag], [Secondary_Diag_1], [Secondary_Diag_2], [Secondary_Diag_3], [Secondary_Diag_4], [Secondary_Diag_5], [Secondary_Diag_6], [Secondary_Diag_7], [Accept_Previous_Primary_Diag_ID], [Accept_Previous_Secondary_Diag1_ID], [Accept_Previous_Secondary_Diag2_ID], [Accept_Previous_Secondary_Diag3_ID], [Accept_Previous_Secondary_Diag4_ID], [Accept_Previous_Secondary_Diag5_ID], [Accept_Previous_Secondary_Diag6_ID], [End_Date], [Comments], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Status_Of_Diagnosis_ID]
							)
							SELECT [ICD10_ID], [Patient_ID], [Version_ID], [Diagnosis_Date], [RMO_GP_Flag_ID], [Diagnosis_By_ID], [RMO_Name_ID], [Confirm_Flag_ID], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [Confirm_Date], [RMO_Confirm_Date], [Prev_Psy_Episode_ID], [Primary_Diag], [Secondary_Diag_1], [Secondary_Diag_2], [Secondary_Diag_3], [Secondary_Diag_4], [Secondary_Diag_5], [Secondary_Diag_6], [Secondary_Diag_7], [Accept_Previous_Primary_Diag_ID], [Accept_Previous_Secondary_Diag1_ID], [Accept_Previous_Secondary_Diag2_ID], [Accept_Previous_Secondary_Diag3_ID], [Accept_Previous_Secondary_Diag4_ID], [Accept_Previous_Secondary_Diag5_ID], [Accept_Previous_Secondary_Diag6_ID], [End_Date], [Comments], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Status_Of_Diagnosis_ID]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblICD10];

							SET @Inserted = @@ROWCOUNT;

						END;
						--	Else load target incrementally...
						ELSE
						BEGIN

							--	Delete from target where target PK not in working table. --TODO We can save time by doing deletes and updated together but then we wouldn not be able to report separate counts for deleted/updated/inserted.
							DELETE tgt
							FROM mrr_tbl.CNC_tblICD10 AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNC_tblICD10 AS src
								WHERE tgt.[ICD10_ID] = src.[ICD10_ID]
							);
							--	How many deleted?
							SET @Deleted = @@ROWCOUNT;

							--	Delete from target where working table PK & ChangeDetectionColumn not in target.
							DELETE tgt
							FROM mrr_tbl.CNC_tblICD10 AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNC_tblICD10 AS src
								WHERE tgt.[ICD10_ID] = src.[ICD10_ID] AND tgt.[Updated_Dttm] = src.[Updated_Dttm]
							);
							--	How many updated?
							SET @Updated = @@ROWCOUNT;

							--		Insert into Target from source where working table PK & ChangeDetectionColumn not in target.
							INSERT INTO mrr_tbl.CNC_tblICD10
							(
								[ICD10_ID], [Patient_ID], [Version_ID], [Diagnosis_Date], [RMO_GP_Flag_ID], [Diagnosis_By_ID], [RMO_Name_ID], [Confirm_Flag_ID], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [Confirm_Date], [RMO_Confirm_Date], [Prev_Psy_Episode_ID], [Primary_Diag], [Secondary_Diag_1], [Secondary_Diag_2], [Secondary_Diag_3], [Secondary_Diag_4], [Secondary_Diag_5], [Secondary_Diag_6], [Secondary_Diag_7], [Accept_Previous_Primary_Diag_ID], [Accept_Previous_Secondary_Diag1_ID], [Accept_Previous_Secondary_Diag2_ID], [Accept_Previous_Secondary_Diag3_ID], [Accept_Previous_Secondary_Diag4_ID], [Accept_Previous_Secondary_Diag5_ID], [Accept_Previous_Secondary_Diag6_ID], [End_Date], [Comments], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Status_Of_Diagnosis_ID]
							)
							SELECT src.[ICD10_ID], src.[Patient_ID], src.[Version_ID], src.[Diagnosis_Date], src.[RMO_GP_Flag_ID], src.[Diagnosis_By_ID], src.[RMO_Name_ID], src.[Confirm_Flag_ID], src.[Confirm_Staff_Name], src.[Confirm_Staff_Job_Title], src.[Confirm_Date], src.[RMO_Confirm_Date], src.[Prev_Psy_Episode_ID], src.[Primary_Diag], src.[Secondary_Diag_1], src.[Secondary_Diag_2], src.[Secondary_Diag_3], src.[Secondary_Diag_4], src.[Secondary_Diag_5], src.[Secondary_Diag_6], src.[Secondary_Diag_7], src.[Accept_Previous_Primary_Diag_ID], src.[Accept_Previous_Secondary_Diag1_ID], src.[Accept_Previous_Secondary_Diag2_ID], src.[Accept_Previous_Secondary_Diag3_ID], src.[Accept_Previous_Secondary_Diag4_ID], src.[Accept_Previous_Secondary_Diag5_ID], src.[Accept_Previous_Secondary_Diag6_ID], src.[End_Date], src.[Comments], src.[User_Created], src.[Create_Dttm], src.[User_Updated], src.[Updated_Dttm], src.[Status_Of_Diagnosis_ID]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblICD10] AS src
							INNER JOIN (SELECT wrk.[ICD10_ID] FROM mrr_wrk.CNC_tblICD10 wrk
									WHERE NOT EXISTS
									(
										SELECT NULL
										FROM mrr_tbl.CNC_tblICD10 AS tgt
										WHERE wrk.[ICD10_ID] = tgt.[ICD10_ID]
									)
								) MissingRecs ON (MissingRecs.[ICD10_ID] = src.[ICD10_ID]);


							--	How many really inserted? ROWCOUNT = inserted + updated records.
							SET @Inserted = @@ROWCOUNT - @Updated;

						--		Truncate working table? --TODO decide.
						END;

						--	Update audit table.
						SET @EndTime = GETDATE();

						INSERT INTO mrr_aud.CNC_tblICD10
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
						COMMIT TRANSACTION; -- INSERT INTO mrr_aud.CNC_tblICD10

					END TRY
					--Catch if transaction open roll it back.
					BEGIN CATCH
						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;
						THROW;
					END CATCH;

				END;
				
GO
