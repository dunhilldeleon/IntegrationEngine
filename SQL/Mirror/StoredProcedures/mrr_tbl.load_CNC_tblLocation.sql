SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

				/*==========================================================================================================================================
				Notes:
				Template for loading Mirror table incrementally.

				TODO Is this the right place for the transactions? Should transaction handling be external to this procedure?

				Test:

				EXECUTE mrr_tbl.load_CNC_tblLocation
				EXECUTE mrr_tbl.load_CNC_tblLocation 'F'

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[load_CNC_tblLocation]
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
							SELECT COUNT(*) FROM mrr_tbl.CNC_tblLocation
						);

						--	Load working table from source.
						BEGIN TRANSACTION; -- INSERT INTO mrr_wrk.CNC_tblLocation

						TRUNCATE TABLE mrr_wrk.CNC_tblLocation;

						INSERT INTO mrr_wrk.CNC_tblLocation
						(
							[Location_ID], [Updated_Dttm]
						)
						SELECT [Location_ID], [Updated_Dttm]
						FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblLocation];

						--	How many records in working table?
						SET @WorkingCount = @@ROWCOUNT;

						COMMIT TRANSACTION; -- INSERT INTO mrr_wrk.CNC_tblLocation

						--	If 0 records in target or ABS(nW-nT) > Threshold force a Truncate/Insert. --TODO not ideal test but achievable without slowing the procedure down too much.
						IF ABS(@WorkingCount - @OriginalTargetCount) >= CAST((@OriginalTargetCount * @Threshold / 100) AS INTEGER)
							SET @LoadType = 'F';

						BEGIN TRANSACTION; -- Start transaction for the load and audit.

						--	We now do either a full (F) reload of the target or an incremental (I) load depending on what has been requested or how much data is changing.
						IF @LoadType = 'F'
						BEGIN
							--	Full load target from source.

							TRUNCATE TABLE mrr_tbl.CNC_tblLocation;

							INSERT INTO mrr_tbl.CNC_tblLocation
							(
								[Location_ID], [Location_Name], [Start_Date], [Location_Status_ID], [End_Date], [Location_Team_Ward_ID], [Location_IMC_Code_ID], [Location_Specialty_ID], [Location_Sub_Specialty_ID], [Location_Category_ID], [Location_Gender_ID], [Location_Beds], [Address1], [Address2], [Address3], [Address4], [Address5], [Post_Code], [Phone], [Location_NFF_Ward_Type], [Site_Code], [Clinical_Care_Intensity_ID], [Location_Division_ID], [Cost_Code], [CAMHS_Service_Tier], [Clinical_Team_Classification_ID], [CMHT_Administrator_Staff_ID], [Consultant_Staff_ID], [Team_Email_Address], [MHA_Administration_Offices_ID], [Default_Booking_Type_ID], [Default_PB_Contact_Type_ID], [Additional_Information], [Location_Notes], [Agency_Code], [PCT_ID], [SM_Cost_Code], [SM_Service_Code], [Ppa_Code], [Sms_Appointment_Reminders_ID], [Sms_Tail], [Location_Udf_1], [Location_Udf_2], [Location_Udf_3], [Location_Udf_4], [Location_Udf_5], [Location_Udf_6], [Location_Udf_7], [Location_Udf_8], [Location_Udf_9], [Location_Udf_10], [Prescriber_PIN], [Prescriber_Practice_Code], [Ward_Security_Level_ID], [Intended_Age_Group_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Cluster_Location_ID], [Cluster_Location_Object_Type_ID], [Mental_Health_Care_Team_Type_ID], [Admission_Setting_ID], [CCG_ID], [MHSDS_Service_Type_ID], [Ward_Locked_ID], [Place_Of_Safety_ID], [Hospital_Bed_Type_ID]
							)
							SELECT [Location_ID], [Location_Name], [Start_Date], [Location_Status_ID], [End_Date], [Location_Team_Ward_ID], [Location_IMC_Code_ID], [Location_Specialty_ID], [Location_Sub_Specialty_ID], [Location_Category_ID], [Location_Gender_ID], [Location_Beds], [Address1], [Address2], [Address3], [Address4], [Address5], [Post_Code], [Phone], [Location_NFF_Ward_Type], [Site_Code], [Clinical_Care_Intensity_ID], [Location_Division_ID], [Cost_Code], [CAMHS_Service_Tier], [Clinical_Team_Classification_ID], [CMHT_Administrator_Staff_ID], [Consultant_Staff_ID], [Team_Email_Address], [MHA_Administration_Offices_ID], [Default_Booking_Type_ID], [Default_PB_Contact_Type_ID], [Additional_Information], [Location_Notes], [Agency_Code], [PCT_ID], [SM_Cost_Code], [SM_Service_Code], [Ppa_Code], [Sms_Appointment_Reminders_ID], [Sms_Tail], [Location_Udf_1], [Location_Udf_2], [Location_Udf_3], [Location_Udf_4], [Location_Udf_5], [Location_Udf_6], [Location_Udf_7], [Location_Udf_8], [Location_Udf_9], [Location_Udf_10], [Prescriber_PIN], [Prescriber_Practice_Code], [Ward_Security_Level_ID], [Intended_Age_Group_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Cluster_Location_ID], [Cluster_Location_Object_Type_ID], [Mental_Health_Care_Team_Type_ID], [Admission_Setting_ID], [CCG_ID], [MHSDS_Service_Type_ID], [Ward_Locked_ID], [Place_Of_Safety_ID], [Hospital_Bed_Type_ID]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblLocation];

							SET @Inserted = @@ROWCOUNT;

						END;
						--	Else load target incrementally...
						ELSE
						BEGIN

							--	Delete from target where target PK not in working table. --TODO We can save time by doing deletes and updated together but then we wouldn not be able to report separate counts for deleted/updated/inserted.
							DELETE tgt
							FROM mrr_tbl.CNC_tblLocation AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNC_tblLocation AS src
								WHERE tgt.[Location_ID] = src.[Location_ID]
							);
							--	How many deleted?
							SET @Deleted = @@ROWCOUNT;

							--	Delete from target where working table PK & ChangeDetectionColumn not in target.
							DELETE tgt
							FROM mrr_tbl.CNC_tblLocation AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNC_tblLocation AS src
								WHERE tgt.[Location_ID] = src.[Location_ID] AND tgt.[Updated_Dttm] = src.[Updated_Dttm]
							);
							--	How many updated?
							SET @Updated = @@ROWCOUNT;

							--		Insert into Target from source where working table PK & ChangeDetectionColumn not in target.
							INSERT INTO mrr_tbl.CNC_tblLocation
							(
								[Location_ID], [Location_Name], [Start_Date], [Location_Status_ID], [End_Date], [Location_Team_Ward_ID], [Location_IMC_Code_ID], [Location_Specialty_ID], [Location_Sub_Specialty_ID], [Location_Category_ID], [Location_Gender_ID], [Location_Beds], [Address1], [Address2], [Address3], [Address4], [Address5], [Post_Code], [Phone], [Location_NFF_Ward_Type], [Site_Code], [Clinical_Care_Intensity_ID], [Location_Division_ID], [Cost_Code], [CAMHS_Service_Tier], [Clinical_Team_Classification_ID], [CMHT_Administrator_Staff_ID], [Consultant_Staff_ID], [Team_Email_Address], [MHA_Administration_Offices_ID], [Default_Booking_Type_ID], [Default_PB_Contact_Type_ID], [Additional_Information], [Location_Notes], [Agency_Code], [PCT_ID], [SM_Cost_Code], [SM_Service_Code], [Ppa_Code], [Sms_Appointment_Reminders_ID], [Sms_Tail], [Location_Udf_1], [Location_Udf_2], [Location_Udf_3], [Location_Udf_4], [Location_Udf_5], [Location_Udf_6], [Location_Udf_7], [Location_Udf_8], [Location_Udf_9], [Location_Udf_10], [Prescriber_PIN], [Prescriber_Practice_Code], [Ward_Security_Level_ID], [Intended_Age_Group_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Cluster_Location_ID], [Cluster_Location_Object_Type_ID], [Mental_Health_Care_Team_Type_ID], [Admission_Setting_ID], [CCG_ID], [MHSDS_Service_Type_ID], [Ward_Locked_ID], [Place_Of_Safety_ID], [Hospital_Bed_Type_ID]
							)
							SELECT src.[Location_ID], src.[Location_Name], src.[Start_Date], src.[Location_Status_ID], src.[End_Date], src.[Location_Team_Ward_ID], src.[Location_IMC_Code_ID], src.[Location_Specialty_ID], src.[Location_Sub_Specialty_ID], src.[Location_Category_ID], src.[Location_Gender_ID], src.[Location_Beds], src.[Address1], src.[Address2], src.[Address3], src.[Address4], src.[Address5], src.[Post_Code], src.[Phone], src.[Location_NFF_Ward_Type], src.[Site_Code], src.[Clinical_Care_Intensity_ID], src.[Location_Division_ID], src.[Cost_Code], src.[CAMHS_Service_Tier], src.[Clinical_Team_Classification_ID], src.[CMHT_Administrator_Staff_ID], src.[Consultant_Staff_ID], src.[Team_Email_Address], src.[MHA_Administration_Offices_ID], src.[Default_Booking_Type_ID], src.[Default_PB_Contact_Type_ID], src.[Additional_Information], src.[Location_Notes], src.[Agency_Code], src.[PCT_ID], src.[SM_Cost_Code], src.[SM_Service_Code], src.[Ppa_Code], src.[Sms_Appointment_Reminders_ID], src.[Sms_Tail], src.[Location_Udf_1], src.[Location_Udf_2], src.[Location_Udf_3], src.[Location_Udf_4], src.[Location_Udf_5], src.[Location_Udf_6], src.[Location_Udf_7], src.[Location_Udf_8], src.[Location_Udf_9], src.[Location_Udf_10], src.[Prescriber_PIN], src.[Prescriber_Practice_Code], src.[Ward_Security_Level_ID], src.[Intended_Age_Group_ID], src.[User_Created], src.[Create_Dttm], src.[User_Updated], src.[Updated_Dttm], src.[Cluster_Location_ID], src.[Cluster_Location_Object_Type_ID], src.[Mental_Health_Care_Team_Type_ID], src.[Admission_Setting_ID], src.[CCG_ID], src.[MHSDS_Service_Type_ID], src.[Ward_Locked_ID], src.[Place_Of_Safety_ID], src.[Hospital_Bed_Type_ID]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblLocation] AS src
							INNER JOIN (SELECT wrk.[Location_ID] FROM mrr_wrk.CNC_tblLocation wrk
									WHERE NOT EXISTS
									(
										SELECT NULL
										FROM mrr_tbl.CNC_tblLocation AS tgt
										WHERE wrk.[Location_ID] = tgt.[Location_ID]
									)
								) MissingRecs ON (MissingRecs.[Location_ID] = src.[Location_ID]);


							--	How many really inserted? ROWCOUNT = inserted + updated records.
							SET @Inserted = @@ROWCOUNT - @Updated;

						--		Truncate working table? --TODO decide.
						END;

						--	Update audit table.
						SET @EndTime = GETDATE();

						INSERT INTO mrr_aud.CNC_tblLocation
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
						COMMIT TRANSACTION; -- INSERT INTO mrr_aud.CNC_tblLocation

					END TRY
					--Catch if transaction open roll it back.
					BEGIN CATCH
						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;
						THROW;
					END CATCH;

				END;
				
GO
