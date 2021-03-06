SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

				/*==========================================================================================================================================
				Notes:
				Template for loading Mirror table incrementally.

				TODO Is this the right place for the transactions? Should transaction handling be external to this procedure?

				Test:

				EXECUTE mrr_tbl.load_CNS_tblPatient
				EXECUTE mrr_tbl.load_CNS_tblPatient 'F'

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[load_CNS_tblPatient]
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
							SELECT COUNT(*) FROM mrr_tbl.CNS_tblPatient
						);

						--	Load working table from source.
						BEGIN TRANSACTION; -- INSERT INTO mrr_wrk.CNS_tblPatient

						TRUNCATE TABLE mrr_wrk.CNS_tblPatient;

						INSERT INTO mrr_wrk.CNS_tblPatient
						(
							[Patient_ID], [Updated_Dttm]
						)
						SELECT [Patient_ID], [Updated_Dttm]
						FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblPatient];

						--	How many records in working table?
						SET @WorkingCount = @@ROWCOUNT;

						COMMIT TRANSACTION; -- INSERT INTO mrr_wrk.CNS_tblPatient

						--	If 0 records in target or ABS(nW-nT) > Threshold force a Truncate/Insert. --TODO not ideal test but achievable without slowing the procedure down too much.
						IF ABS(@WorkingCount - @OriginalTargetCount) >= CAST((@OriginalTargetCount * @Threshold / 100) AS INTEGER)
							SET @LoadType = 'F';

						BEGIN TRANSACTION; -- Start transaction for the load and audit.

						--	We now do either a full (F) reload of the target or an incremental (I) load depending on what has been requested or how much data is changing.
						IF @LoadType = 'F'
						BEGIN
							--	Full load target from source.

							TRUNCATE TABLE mrr_tbl.CNS_tblPatient;

							INSERT INTO mrr_tbl.CNS_tblPatient
							(
								[Patient_ID], [Access_Restricted_ID], [NHS_Number], [Health_Card_Number1], [Health_Card_Number2], [DATIS_Key], [Title_ID], [Forename], [Middle_Name], [Surname], [Last_Name_At_Birth], [Patient_Name], [Date_Of_Birth], [Estimated_Year_Of_Birth], [Date_Of_Death], [Other_ID1], [Other_ID2], [Other_ID3], [Other_ID4], [Other_PJS_ID], [Cnv3_Unid], [Social_Service_ID], [National_Insurance_Number], [First_Year_Of_Care_Date], [First_Year_Of_Care_Text], [Accomodation_ID], [First_Language_ID], [Gender_ID], [Sexuality_ID], [Religion_ID], [Marital_Status_ID], [Lives_With_ID], [Ethnicity_ID], [Country_Of_Origin_ID], [Place_Of_Birth], [CAHMS_Care_Status_ID], [Copy_Letters_To_Client_ID], [Registered_Sex_Offender_ID], [NHS_Trace_Flag], [Employment_ID], [Welfare_Benefits_Client_ID], [Mobility_Problem_ID], [Hearing_Impairment_ID], [Visual_Impairment_ID], [DAT_Of_Residence_ID], [Housing_Status], [Is_Interpreter_Needed_ID], [Occupation_ID], [Overseas_Visitor_ID], [Asylum_Seeker_ID], [Has_A_Twin_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Patient_User_Field3_ID], [Patient_User_Field4_ID], [PDS_Patient_ID], [Withheld_Identity_Reason_ID], [NHS_Number_Verified_ID], [Preferred_Location_Of_Death_ID], [Soundex_Surname], [Soundex_Forename], [Risk_Unexpected_Death_ID], [Safeguarding_Vulnerability_Factors_ID], [Ex_British_Armed_Forces_ID], [Offence_History_Indication_ID]
							)
							SELECT [Patient_ID], [Access_Restricted_ID], [NHS_Number], [Health_Card_Number1], [Health_Card_Number2], [DATIS_Key], [Title_ID], [Forename], [Middle_Name], [Surname], [Last_Name_At_Birth], [Patient_Name], [Date_Of_Birth], [Estimated_Year_Of_Birth], [Date_Of_Death], [Other_ID1], [Other_ID2], [Other_ID3], [Other_ID4], [Other_PJS_ID], [Cnv3_Unid], [Social_Service_ID], [National_Insurance_Number], [First_Year_Of_Care_Date], [First_Year_Of_Care_Text], [Accomodation_ID], [First_Language_ID], [Gender_ID], [Sexuality_ID], [Religion_ID], [Marital_Status_ID], [Lives_With_ID], [Ethnicity_ID], [Country_Of_Origin_ID], [Place_Of_Birth], [CAHMS_Care_Status_ID], [Copy_Letters_To_Client_ID], [Registered_Sex_Offender_ID], [NHS_Trace_Flag], [Employment_ID], [Welfare_Benefits_Client_ID], [Mobility_Problem_ID], [Hearing_Impairment_ID], [Visual_Impairment_ID], [DAT_Of_Residence_ID], [Housing_Status], [Is_Interpreter_Needed_ID], [Occupation_ID], [Overseas_Visitor_ID], [Asylum_Seeker_ID], [Has_A_Twin_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Patient_User_Field3_ID], [Patient_User_Field4_ID], [PDS_Patient_ID], [Withheld_Identity_Reason_ID], [NHS_Number_Verified_ID], [Preferred_Location_Of_Death_ID], [Soundex_Surname], [Soundex_Forename], [Risk_Unexpected_Death_ID], [Safeguarding_Vulnerability_Factors_ID], [Ex_British_Armed_Forces_ID], [Offence_History_Indication_ID]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblPatient];

							SET @Inserted = @@ROWCOUNT;

						END;
						--	Else load target incrementally...
						ELSE
						BEGIN

							--	Delete from target where target PK not in working table. --TODO We can save time by doing deletes and updated together but then we wouldn not be able to report separate counts for deleted/updated/inserted.
							DELETE tgt
							FROM mrr_tbl.CNS_tblPatient AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNS_tblPatient AS src
								WHERE tgt.[Patient_ID] = src.[Patient_ID]
							);
							--	How many deleted?
							SET @Deleted = @@ROWCOUNT;

							--	Delete from target where working table PK & ChangeDetectionColumn not in target.
							DELETE tgt
							FROM mrr_tbl.CNS_tblPatient AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNS_tblPatient AS src
								WHERE tgt.[Patient_ID] = src.[Patient_ID] AND tgt.[Updated_Dttm] = src.[Updated_Dttm]
							);
							--	How many updated?
							SET @Updated = @@ROWCOUNT;

							--		Insert into Target from source where working table PK & ChangeDetectionColumn not in target.
							INSERT INTO mrr_tbl.CNS_tblPatient
							(
								[Patient_ID], [Access_Restricted_ID], [NHS_Number], [Health_Card_Number1], [Health_Card_Number2], [DATIS_Key], [Title_ID], [Forename], [Middle_Name], [Surname], [Last_Name_At_Birth], [Patient_Name], [Date_Of_Birth], [Estimated_Year_Of_Birth], [Date_Of_Death], [Other_ID1], [Other_ID2], [Other_ID3], [Other_ID4], [Other_PJS_ID], [Cnv3_Unid], [Social_Service_ID], [National_Insurance_Number], [First_Year_Of_Care_Date], [First_Year_Of_Care_Text], [Accomodation_ID], [First_Language_ID], [Gender_ID], [Sexuality_ID], [Religion_ID], [Marital_Status_ID], [Lives_With_ID], [Ethnicity_ID], [Country_Of_Origin_ID], [Place_Of_Birth], [CAHMS_Care_Status_ID], [Copy_Letters_To_Client_ID], [Registered_Sex_Offender_ID], [NHS_Trace_Flag], [Employment_ID], [Welfare_Benefits_Client_ID], [Mobility_Problem_ID], [Hearing_Impairment_ID], [Visual_Impairment_ID], [DAT_Of_Residence_ID], [Housing_Status], [Is_Interpreter_Needed_ID], [Occupation_ID], [Overseas_Visitor_ID], [Asylum_Seeker_ID], [Has_A_Twin_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Patient_User_Field3_ID], [Patient_User_Field4_ID], [PDS_Patient_ID], [Withheld_Identity_Reason_ID], [NHS_Number_Verified_ID], [Preferred_Location_Of_Death_ID], [Soundex_Surname], [Soundex_Forename], [Risk_Unexpected_Death_ID], [Safeguarding_Vulnerability_Factors_ID], [Ex_British_Armed_Forces_ID], [Offence_History_Indication_ID]
							)
							SELECT src.[Patient_ID], src.[Access_Restricted_ID], src.[NHS_Number], src.[Health_Card_Number1], src.[Health_Card_Number2], src.[DATIS_Key], src.[Title_ID], src.[Forename], src.[Middle_Name], src.[Surname], src.[Last_Name_At_Birth], src.[Patient_Name], src.[Date_Of_Birth], src.[Estimated_Year_Of_Birth], src.[Date_Of_Death], src.[Other_ID1], src.[Other_ID2], src.[Other_ID3], src.[Other_ID4], src.[Other_PJS_ID], src.[Cnv3_Unid], src.[Social_Service_ID], src.[National_Insurance_Number], src.[First_Year_Of_Care_Date], src.[First_Year_Of_Care_Text], src.[Accomodation_ID], src.[First_Language_ID], src.[Gender_ID], src.[Sexuality_ID], src.[Religion_ID], src.[Marital_Status_ID], src.[Lives_With_ID], src.[Ethnicity_ID], src.[Country_Of_Origin_ID], src.[Place_Of_Birth], src.[CAHMS_Care_Status_ID], src.[Copy_Letters_To_Client_ID], src.[Registered_Sex_Offender_ID], src.[NHS_Trace_Flag], src.[Employment_ID], src.[Welfare_Benefits_Client_ID], src.[Mobility_Problem_ID], src.[Hearing_Impairment_ID], src.[Visual_Impairment_ID], src.[DAT_Of_Residence_ID], src.[Housing_Status], src.[Is_Interpreter_Needed_ID], src.[Occupation_ID], src.[Overseas_Visitor_ID], src.[Asylum_Seeker_ID], src.[Has_A_Twin_ID], src.[User_Created], src.[Create_Dttm], src.[User_Updated], src.[Updated_Dttm], src.[Patient_User_Field3_ID], src.[Patient_User_Field4_ID], src.[PDS_Patient_ID], src.[Withheld_Identity_Reason_ID], src.[NHS_Number_Verified_ID], src.[Preferred_Location_Of_Death_ID], src.[Soundex_Surname], src.[Soundex_Forename], src.[Risk_Unexpected_Death_ID], src.[Safeguarding_Vulnerability_Factors_ID], src.[Ex_British_Armed_Forces_ID], src.[Offence_History_Indication_ID]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblPatient] AS src
							INNER JOIN (SELECT wrk.[Patient_ID] FROM mrr_wrk.CNS_tblPatient wrk
									WHERE NOT EXISTS
									(
										SELECT NULL
										FROM mrr_tbl.CNS_tblPatient AS tgt
										WHERE wrk.[Patient_ID] = tgt.[Patient_ID]
									)
								) MissingRecs ON (MissingRecs.[Patient_ID] = src.[Patient_ID]);


							--	How many really inserted? ROWCOUNT = inserted + updated records.
							SET @Inserted = @@ROWCOUNT - @Updated;

						--		Truncate working table? --TODO decide.
						END;

						--	Update audit table.
						SET @EndTime = GETDATE();

						INSERT INTO mrr_aud.CNS_tblPatient
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
						COMMIT TRANSACTION; -- INSERT INTO mrr_aud.CNS_tblPatient

					END TRY
					--Catch if transaction open roll it back.
					BEGIN CATCH
						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;
						THROW;
					END CATCH;

				END;
				
GO
