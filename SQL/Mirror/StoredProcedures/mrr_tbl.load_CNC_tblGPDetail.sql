SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

				/*==========================================================================================================================================
				Notes:
				Template for loading Mirror table incrementally.

				TODO Is this the right place for the transactions? Should transaction handling be external to this procedure?

				Test:

				EXECUTE mrr_tbl.load_CNC_tblGPDetail
				EXECUTE mrr_tbl.load_CNC_tblGPDetail 'F'

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[load_CNC_tblGPDetail]
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
							SELECT COUNT(*) FROM mrr_tbl.CNC_tblGPDetail
						);

						--	Load working table from source.
						BEGIN TRANSACTION; -- INSERT INTO mrr_wrk.CNC_tblGPDetail

						TRUNCATE TABLE mrr_wrk.CNC_tblGPDetail;

						INSERT INTO mrr_wrk.CNC_tblGPDetail
						(
							[GP_Detail_ID], [Updated_Dttm]
						)
						SELECT [GP_Detail_ID], [Updated_Dttm]
						FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblGPDetail];

						--	How many records in working table?
						SET @WorkingCount = @@ROWCOUNT;

						COMMIT TRANSACTION; -- INSERT INTO mrr_wrk.CNC_tblGPDetail

						--	If 0 records in target or ABS(nW-nT) > Threshold force a Truncate/Insert. --TODO not ideal test but achievable without slowing the procedure down too much.
						IF ABS(@WorkingCount - @OriginalTargetCount) >= CAST((@OriginalTargetCount * @Threshold / 100) AS INTEGER)
							SET @LoadType = 'F';

						BEGIN TRANSACTION; -- Start transaction for the load and audit.

						--	We now do either a full (F) reload of the target or an incremental (I) load depending on what has been requested or how much data is changing.
						IF @LoadType = 'F'
						BEGIN
							--	Full load target from source.

							TRUNCATE TABLE mrr_tbl.CNC_tblGPDetail;

							INSERT INTO mrr_tbl.CNC_tblGPDetail
							(
								[GP_Detail_ID], [Patient_ID], [Permission_To_Contact_ID], [Start_Date], [End_Date], [GP_ID], [Practice_ID], [Contact_GP_ID], [Further_Information], [Comments], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [CCG_ID], [Assumed_GP_ID], [PDS_ID]
							)
							SELECT [GP_Detail_ID], [Patient_ID], [Permission_To_Contact_ID], [Start_Date], [End_Date], [GP_ID], [Practice_ID], [Contact_GP_ID], [Further_Information], [Comments], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [CCG_ID], [Assumed_GP_ID], [PDS_ID]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblGPDetail];

							SET @Inserted = @@ROWCOUNT;

						END;
						--	Else load target incrementally...
						ELSE
						BEGIN

							--	Delete from target where target PK not in working table. --TODO We can save time by doing deletes and updated together but then we wouldn not be able to report separate counts for deleted/updated/inserted.
							DELETE tgt
							FROM mrr_tbl.CNC_tblGPDetail AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNC_tblGPDetail AS src
								WHERE tgt.[GP_Detail_ID] = src.[GP_Detail_ID]
							);
							--	How many deleted?
							SET @Deleted = @@ROWCOUNT;

							--	Delete from target where working table PK & ChangeDetectionColumn not in target.
							DELETE tgt
							FROM mrr_tbl.CNC_tblGPDetail AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNC_tblGPDetail AS src
								WHERE tgt.[GP_Detail_ID] = src.[GP_Detail_ID] AND tgt.[Updated_Dttm] = src.[Updated_Dttm]
							);
							--	How many updated?
							SET @Updated = @@ROWCOUNT;

							--		Insert into Target from source where working table PK & ChangeDetectionColumn not in target.
							INSERT INTO mrr_tbl.CNC_tblGPDetail
							(
								[GP_Detail_ID], [Patient_ID], [Permission_To_Contact_ID], [Start_Date], [End_Date], [GP_ID], [Practice_ID], [Contact_GP_ID], [Further_Information], [Comments], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [CCG_ID], [Assumed_GP_ID], [PDS_ID]
							)
							SELECT src.[GP_Detail_ID], src.[Patient_ID], src.[Permission_To_Contact_ID], src.[Start_Date], src.[End_Date], src.[GP_ID], src.[Practice_ID], src.[Contact_GP_ID], src.[Further_Information], src.[Comments], src.[User_Created], src.[Create_Dttm], src.[User_Updated], src.[Updated_Dttm], src.[CCG_ID], src.[Assumed_GP_ID], src.[PDS_ID]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblGPDetail] AS src
							INNER JOIN (SELECT wrk.[GP_Detail_ID] FROM mrr_wrk.CNC_tblGPDetail wrk
									WHERE NOT EXISTS
									(
										SELECT NULL
										FROM mrr_tbl.CNC_tblGPDetail AS tgt
										WHERE wrk.[GP_Detail_ID] = tgt.[GP_Detail_ID]
									)
								) MissingRecs ON (MissingRecs.[GP_Detail_ID] = src.[GP_Detail_ID]);


							--	How many really inserted? ROWCOUNT = inserted + updated records.
							SET @Inserted = @@ROWCOUNT - @Updated;

						--		Truncate working table? --TODO decide.
						END;

						--	Update audit table.
						SET @EndTime = GETDATE();

						INSERT INTO mrr_aud.CNC_tblGPDetail
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
						COMMIT TRANSACTION; -- INSERT INTO mrr_aud.CNC_tblGPDetail

					END TRY
					--Catch if transaction open roll it back.
					BEGIN CATCH
						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;
						THROW;
					END CATCH;

				END;
				
GO
