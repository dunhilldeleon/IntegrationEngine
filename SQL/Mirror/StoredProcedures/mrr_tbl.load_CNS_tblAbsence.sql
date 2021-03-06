SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

				/*==========================================================================================================================================
				Notes:
				Template for loading Mirror table incrementally.

				TODO Is this the right place for the transactions? Should transaction handling be external to this procedure?

				Test:

				EXECUTE mrr_tbl.load_CNS_tblAbsence
				EXECUTE mrr_tbl.load_CNS_tblAbsence 'F'

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[load_CNS_tblAbsence]
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
							SELECT COUNT(*) FROM mrr_tbl.CNS_tblAbsence
						);

						--	Load working table from source.
						BEGIN TRANSACTION; -- INSERT INTO mrr_wrk.CNS_tblAbsence

						TRUNCATE TABLE mrr_wrk.CNS_tblAbsence;

						INSERT INTO mrr_wrk.CNS_tblAbsence
						(
							[Absence_ID], [Updated_Dttm]
						)
						SELECT [Absence_ID], [Updated_Dttm]
						FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblAbsence];

						--	How many records in working table?
						SET @WorkingCount = @@ROWCOUNT;

						COMMIT TRANSACTION; -- INSERT INTO mrr_wrk.CNS_tblAbsence

						--	If 0 records in target or ABS(nW-nT) > Threshold force a Truncate/Insert. --TODO not ideal test but achievable without slowing the procedure down too much.
						IF ABS(@WorkingCount - @OriginalTargetCount) >= CAST((@OriginalTargetCount * @Threshold / 100) AS INTEGER)
							SET @LoadType = 'F';

						BEGIN TRANSACTION; -- Start transaction for the load and audit.

						--	We now do either a full (F) reload of the target or an incremental (I) load depending on what has been requested or how much data is changing.
						IF @LoadType = 'F'
						BEGIN
							--	Full load target from source.

							TRUNCATE TABLE mrr_tbl.CNS_tblAbsence;

							INSERT INTO mrr_tbl.CNS_tblAbsence
							(
								[Absence_ID], [Patient_ID], [Absence_Type_ID], [AWOL_End_Reason_ID], [Address_Type_ID], [Location_ID], [Absence_Status_ID], [Planned_Start_Date], [Planned_Start_Time], [Planned_Start_Dttm], [Planned_End_Date], [Planned_End_Time], [Planned_End_Dttm], [Cancellation_Reason], [Address1], [Address2], [Address3], [Address4], [Address5], [Post_Code], [Tel_Home], [Tel_Home_Confidential_ID], [Tel_Mobile], [Tel_Mob_Confidential_ID], [Tel_Work], [Tel_Work_Confidential_ID], [Actual_Start_Date], [Actual_Start_Time], [Actual_Start_Dttm], [Actual_End_Date], [Actual_End_Time], [Actual_End_Dttm], [Sleepover_Location_ID], [Supervised_Community_Treatment_Considered_ID], [Supervised_Community_Treatment_Not_Used_Reasons_ID], [How_Did_Period_End_ID], [Conditions], [MHA_Section_Definition_ID], [Absence_RMO_ID], [S17_End_Reason_ID], [Comments], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
							)
							SELECT [Absence_ID], [Patient_ID], [Absence_Type_ID], [AWOL_End_Reason_ID], [Address_Type_ID], [Location_ID], [Absence_Status_ID], [Planned_Start_Date], [Planned_Start_Time], [Planned_Start_Dttm], [Planned_End_Date], [Planned_End_Time], [Planned_End_Dttm], [Cancellation_Reason], [Address1], [Address2], [Address3], [Address4], [Address5], [Post_Code], [Tel_Home], [Tel_Home_Confidential_ID], [Tel_Mobile], [Tel_Mob_Confidential_ID], [Tel_Work], [Tel_Work_Confidential_ID], [Actual_Start_Date], [Actual_Start_Time], [Actual_Start_Dttm], [Actual_End_Date], [Actual_End_Time], [Actual_End_Dttm], [Sleepover_Location_ID], [Supervised_Community_Treatment_Considered_ID], [Supervised_Community_Treatment_Not_Used_Reasons_ID], [How_Did_Period_End_ID], [Conditions], [MHA_Section_Definition_ID], [Absence_RMO_ID], [S17_End_Reason_ID], [Comments], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblAbsence];

							SET @Inserted = @@ROWCOUNT;

						END;
						--	Else load target incrementally...
						ELSE
						BEGIN

							--	Delete from target where target PK not in working table. --TODO We can save time by doing deletes and updated together but then we wouldn not be able to report separate counts for deleted/updated/inserted.
							DELETE tgt
							FROM mrr_tbl.CNS_tblAbsence AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNS_tblAbsence AS src
								WHERE tgt.[Absence_ID] = src.[Absence_ID]
							);
							--	How many deleted?
							SET @Deleted = @@ROWCOUNT;

							--	Delete from target where working table PK & ChangeDetectionColumn not in target.
							DELETE tgt
							FROM mrr_tbl.CNS_tblAbsence AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNS_tblAbsence AS src
								WHERE tgt.[Absence_ID] = src.[Absence_ID] AND tgt.[Updated_Dttm] = src.[Updated_Dttm]
							);
							--	How many updated?
							SET @Updated = @@ROWCOUNT;

							--		Insert into Target from source where working table PK & ChangeDetectionColumn not in target.
							INSERT INTO mrr_tbl.CNS_tblAbsence
							(
								[Absence_ID], [Patient_ID], [Absence_Type_ID], [AWOL_End_Reason_ID], [Address_Type_ID], [Location_ID], [Absence_Status_ID], [Planned_Start_Date], [Planned_Start_Time], [Planned_Start_Dttm], [Planned_End_Date], [Planned_End_Time], [Planned_End_Dttm], [Cancellation_Reason], [Address1], [Address2], [Address3], [Address4], [Address5], [Post_Code], [Tel_Home], [Tel_Home_Confidential_ID], [Tel_Mobile], [Tel_Mob_Confidential_ID], [Tel_Work], [Tel_Work_Confidential_ID], [Actual_Start_Date], [Actual_Start_Time], [Actual_Start_Dttm], [Actual_End_Date], [Actual_End_Time], [Actual_End_Dttm], [Sleepover_Location_ID], [Supervised_Community_Treatment_Considered_ID], [Supervised_Community_Treatment_Not_Used_Reasons_ID], [How_Did_Period_End_ID], [Conditions], [MHA_Section_Definition_ID], [Absence_RMO_ID], [S17_End_Reason_ID], [Comments], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
							)
							SELECT src.[Absence_ID], src.[Patient_ID], src.[Absence_Type_ID], src.[AWOL_End_Reason_ID], src.[Address_Type_ID], src.[Location_ID], src.[Absence_Status_ID], src.[Planned_Start_Date], src.[Planned_Start_Time], src.[Planned_Start_Dttm], src.[Planned_End_Date], src.[Planned_End_Time], src.[Planned_End_Dttm], src.[Cancellation_Reason], src.[Address1], src.[Address2], src.[Address3], src.[Address4], src.[Address5], src.[Post_Code], src.[Tel_Home], src.[Tel_Home_Confidential_ID], src.[Tel_Mobile], src.[Tel_Mob_Confidential_ID], src.[Tel_Work], src.[Tel_Work_Confidential_ID], src.[Actual_Start_Date], src.[Actual_Start_Time], src.[Actual_Start_Dttm], src.[Actual_End_Date], src.[Actual_End_Time], src.[Actual_End_Dttm], src.[Sleepover_Location_ID], src.[Supervised_Community_Treatment_Considered_ID], src.[Supervised_Community_Treatment_Not_Used_Reasons_ID], src.[How_Did_Period_End_ID], src.[Conditions], src.[MHA_Section_Definition_ID], src.[Absence_RMO_ID], src.[S17_End_Reason_ID], src.[Comments], src.[User_Created], src.[Create_Dttm], src.[User_Updated], src.[Updated_Dttm]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblAbsence] AS src
							INNER JOIN (SELECT wrk.[Absence_ID] FROM mrr_wrk.CNS_tblAbsence wrk
									WHERE NOT EXISTS
									(
										SELECT NULL
										FROM mrr_tbl.CNS_tblAbsence AS tgt
										WHERE wrk.[Absence_ID] = tgt.[Absence_ID]
									)
								) MissingRecs ON (MissingRecs.[Absence_ID] = src.[Absence_ID]);


							--	How many really inserted? ROWCOUNT = inserted + updated records.
							SET @Inserted = @@ROWCOUNT - @Updated;

						--		Truncate working table? --TODO decide.
						END;

						--	Update audit table.
						SET @EndTime = GETDATE();

						INSERT INTO mrr_aud.CNS_tblAbsence
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
						COMMIT TRANSACTION; -- INSERT INTO mrr_aud.CNS_tblAbsence

					END TRY
					--Catch if transaction open roll it back.
					BEGIN CATCH
						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;
						THROW;
					END CATCH;

				END;
				
GO
