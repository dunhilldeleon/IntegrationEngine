SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

				/*==========================================================================================================================================
				Notes:
				Template for loading Mirror table incrementally.

				TODO Is this the right place for the transactions? Should transaction handling be external to this procedure?

				Test:

				EXECUTE mrr_tbl.load_CNS_tblClinicalCommissioningGroup
				EXECUTE mrr_tbl.load_CNS_tblClinicalCommissioningGroup 'F'

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[load_CNS_tblClinicalCommissioningGroup]
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
							SELECT COUNT(*) FROM mrr_tbl.CNS_tblClinicalCommissioningGroup
						);

						--	Load working table from source.
						BEGIN TRANSACTION; -- INSERT INTO mrr_wrk.CNS_tblClinicalCommissioningGroup

						TRUNCATE TABLE mrr_wrk.CNS_tblClinicalCommissioningGroup;

						INSERT INTO mrr_wrk.CNS_tblClinicalCommissioningGroup
						(
							[CCG_ID], [Updated_Dttm]
						)
						SELECT [CCG_ID], [Updated_Dttm]
						FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblClinicalCommissioningGroup];

						--	How many records in working table?
						SET @WorkingCount = @@ROWCOUNT;

						COMMIT TRANSACTION; -- INSERT INTO mrr_wrk.CNS_tblClinicalCommissioningGroup

						--	If 0 records in target or ABS(nW-nT) > Threshold force a Truncate/Insert. --TODO not ideal test but achievable without slowing the procedure down too much.
						IF ABS(@WorkingCount - @OriginalTargetCount) >= CAST((@OriginalTargetCount * @Threshold / 100) AS INTEGER)
							SET @LoadType = 'F';

						BEGIN TRANSACTION; -- Start transaction for the load and audit.

						--	We now do either a full (F) reload of the target or an incremental (I) load depending on what has been requested or how much data is changing.
						IF @LoadType = 'F'
						BEGIN
							--	Full load target from source.

							TRUNCATE TABLE mrr_tbl.CNS_tblClinicalCommissioningGroup;

							INSERT INTO mrr_tbl.CNS_tblClinicalCommissioningGroup
							(
								[CCG_ID], [CCG_Identifier], [CCG_Name], [National_Grouping_Code], [High_Level_Health_Geography_Code], [Address_Line1], [Address_Line2], [Address_Line3], [Town], [County], [Post_Code], [Open_Date], [Close_Date], [Status], [Authorisation_Indicator], [Ammendment_Indicator], [Locally_Managed_Flag_ID], [Active_Flag_ID], [Comments], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Organisation_Sub_Type_Code], [Contact_Telephone_Number], [CCG_Record_Type_ID], [Organisation_Type_Code], [Country_Code]
							)
							SELECT [CCG_ID], [CCG_Identifier], [CCG_Name], [National_Grouping_Code], [High_Level_Health_Geography_Code], [Address_Line1], [Address_Line2], [Address_Line3], [Town], [County], [Post_Code], [Open_Date], [Close_Date], [Status], [Authorisation_Indicator], [Ammendment_Indicator], [Locally_Managed_Flag_ID], [Active_Flag_ID], [Comments], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Organisation_Sub_Type_Code], [Contact_Telephone_Number], [CCG_Record_Type_ID], [Organisation_Type_Code], [Country_Code]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblClinicalCommissioningGroup];

							SET @Inserted = @@ROWCOUNT;

						END;
						--	Else load target incrementally...
						ELSE
						BEGIN

							--	Delete from target where target PK not in working table. --TODO We can save time by doing deletes and updated together but then we wouldn not be able to report separate counts for deleted/updated/inserted.
							DELETE tgt
							FROM mrr_tbl.CNS_tblClinicalCommissioningGroup AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNS_tblClinicalCommissioningGroup AS src
								WHERE tgt.[CCG_ID] = src.[CCG_ID]
							);
							--	How many deleted?
							SET @Deleted = @@ROWCOUNT;

							--	Delete from target where working table PK & ChangeDetectionColumn not in target.
							DELETE tgt
							FROM mrr_tbl.CNS_tblClinicalCommissioningGroup AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNS_tblClinicalCommissioningGroup AS src
								WHERE tgt.[CCG_ID] = src.[CCG_ID] AND tgt.[Updated_Dttm] = src.[Updated_Dttm]
							);
							--	How many updated?
							SET @Updated = @@ROWCOUNT;

							--		Insert into Target from source where working table PK & ChangeDetectionColumn not in target.
							INSERT INTO mrr_tbl.CNS_tblClinicalCommissioningGroup
							(
								[CCG_ID], [CCG_Identifier], [CCG_Name], [National_Grouping_Code], [High_Level_Health_Geography_Code], [Address_Line1], [Address_Line2], [Address_Line3], [Town], [County], [Post_Code], [Open_Date], [Close_Date], [Status], [Authorisation_Indicator], [Ammendment_Indicator], [Locally_Managed_Flag_ID], [Active_Flag_ID], [Comments], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Organisation_Sub_Type_Code], [Contact_Telephone_Number], [CCG_Record_Type_ID], [Organisation_Type_Code], [Country_Code]
							)
							SELECT src.[CCG_ID], src.[CCG_Identifier], src.[CCG_Name], src.[National_Grouping_Code], src.[High_Level_Health_Geography_Code], src.[Address_Line1], src.[Address_Line2], src.[Address_Line3], src.[Town], src.[County], src.[Post_Code], src.[Open_Date], src.[Close_Date], src.[Status], src.[Authorisation_Indicator], src.[Ammendment_Indicator], src.[Locally_Managed_Flag_ID], src.[Active_Flag_ID], src.[Comments], src.[User_Created], src.[Create_Dttm], src.[User_Updated], src.[Updated_Dttm], src.[Organisation_Sub_Type_Code], src.[Contact_Telephone_Number], src.[CCG_Record_Type_ID], src.[Organisation_Type_Code], src.[Country_Code]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblClinicalCommissioningGroup] AS src
							INNER JOIN (SELECT wrk.[CCG_ID] FROM mrr_wrk.CNS_tblClinicalCommissioningGroup wrk
									WHERE NOT EXISTS
									(
										SELECT NULL
										FROM mrr_tbl.CNS_tblClinicalCommissioningGroup AS tgt
										WHERE wrk.[CCG_ID] = tgt.[CCG_ID]
									)
								) MissingRecs ON (MissingRecs.[CCG_ID] = src.[CCG_ID]);


							--	How many really inserted? ROWCOUNT = inserted + updated records.
							SET @Inserted = @@ROWCOUNT - @Updated;

						--		Truncate working table? --TODO decide.
						END;

						--	Update audit table.
						SET @EndTime = GETDATE();

						INSERT INTO mrr_aud.CNS_tblClinicalCommissioningGroup
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
						COMMIT TRANSACTION; -- INSERT INTO mrr_aud.CNS_tblClinicalCommissioningGroup

					END TRY
					--Catch if transaction open roll it back.
					BEGIN CATCH
						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;
						THROW;
					END CATCH;

				END;
				
GO
