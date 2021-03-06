SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

				/*==========================================================================================================================================
				Notes:
				Template for loading Mirror table incrementally.

				TODO Is this the right place for the transactions? Should transaction handling be external to this procedure?

				Test:

				EXECUTE mrr_tbl.load_CNS_udfMHAssessmentV9
				EXECUTE mrr_tbl.load_CNS_udfMHAssessmentV9 'F'

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[load_CNS_udfMHAssessmentV9]
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
							SELECT COUNT(*) FROM mrr_tbl.CNS_udfMHAssessmentV9
						);

						--	Load working table from source.
						BEGIN TRANSACTION; -- INSERT INTO mrr_wrk.CNS_udfMHAssessmentV9

						TRUNCATE TABLE mrr_wrk.CNS_udfMHAssessmentV9;

						INSERT INTO mrr_wrk.CNS_udfMHAssessmentV9
						(
							[MHAssessmentV9_ID], [Updated_Dttm]
						)
						SELECT [MHAssessmentV9_ID], [Updated_Dttm]
						FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[udfMHAssessmentV9];

						--	How many records in working table?
						SET @WorkingCount = @@ROWCOUNT;

						COMMIT TRANSACTION; -- INSERT INTO mrr_wrk.CNS_udfMHAssessmentV9

						--	If 0 records in target or ABS(nW-nT) > Threshold force a Truncate/Insert. --TODO not ideal test but achievable without slowing the procedure down too much.
						IF ABS(@WorkingCount - @OriginalTargetCount) >= CAST((@OriginalTargetCount * @Threshold / 100) AS INTEGER)
							SET @LoadType = 'F';

						BEGIN TRANSACTION; -- Start transaction for the load and audit.

						--	We now do either a full (F) reload of the target or an incremental (I) load depending on what has been requested or how much data is changing.
						IF @LoadType = 'F'
						BEGIN
							--	Full load target from source.

							TRUNCATE TABLE mrr_tbl.CNS_udfMHAssessmentV9;

							INSERT INTO mrr_tbl.CNS_udfMHAssessmentV9
							(
								[MHAssessmentV9_ID], [Patient_ID], [Confirm_Flag_ID], [Confirm_Date], [Confirm_Time], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [OriginalAuthorID], [fldEnteredDate], [fldEnteredTime], [StartDate], [StartTime], [ReplanRequested], [DocumentGroupIdentifier], [PreviousCNObjectID], [fldServiceSettingID], [fldGenAssessPresSit], [fldGenAssessHistComp], [fldGenAssessPastMedHist], [fldGenAssessCurrMeds], [fldGenAssessPastPsycHist], [fldGenAssessPersHist], [fldGenAssessFamHist], [fldGenAssessFrsicHist], [fldGenAssessSocCirc], [fldAlcDrugUsage], [fldGenAssessSpiritNeeds], [fldGenAssessIsACarer], [fldGenAssessPreMorbid], [fldSafeguardingStatusID], [fldDependentsID], [fldDependentsDetails], [fldGenAssessCapcityAtTime], [fldGenAssessAppearance], [fldGenAssessBehaviour], [fldGenAssessSpeech], [fldGenAssessMood], [fldGenAssessThoughts], [fldGenAssessPerception], [fldGenAssessCognition], [fldGenAssessInsight], [fldEatingBehaviours], [fldSchool], [fldEngagement], [fldDevHistory], [fldObsBehaviour], [fldManagingNutritionID], [fldManagingNutritionDetails], [fldPersonalHygieneID], [fldPersonalHygieneDetails], [fldToiletNeedsID], [fldToiletNeedsDetails], [fldAppropriateClothID], [fldAppropriateClothDetails], [fldAdultsHomeID], [fldAdultsHomeDetails], [fldHomeEnvironmentID], [fldHomeEnvironmentDetails], [fldOtherPersonalRelationshipsID], [fldOtherPersonalRelationshipsDetails], [fldAccessAndEngageID], [fldAccessAndEngageDetails], [fldFacilitiesOrServicesID], [fldFacilitiesOrServicesDetails], [fldCaringResponsibilitiesID], [fldCaringResponsibilitiesDetails], [fldPsychoTherapiesNeededID], [fldPsychoTherapiesNeededDetails], [fldPresenting], [fldPrecipitating], [fldPredisposing], [fldPerpetuating], [fldProtective], [fldAnnualHealthCheckID], [fldAnnualHealthCheckDetails], [fldHospActionPlanID], [fldHospActionPlanDetails], [fldHospPassportID], [fldHospPassportDetails], [fldEyeTestID], [fldEyeTestDetails], [fldDentalCheckUpID], [fldDentalCheckUpDetails], [fldHealthScreeningID], [fldHealthScreeningDetails], [fldCommunication], [fldMobilityFalls], [fldOccupation], [fldEatingAndDrinking], [fldSleep], [fldEpilepsyID], [fldChkPhysicalHealthID], [fldChkMentalHealthID], [fldChkForensicsID], [fldChkEpilepsyID], [fldChkChallengingBehaviourID], [fldChkDementiaID], [fldChkAutismID], [fldMaternityObstetic], [fldCurrentlyPregnantID], [fldDueDate], [fldPrevPregnancies], [fldPregnancyAndDeliveryDetails], [fldRelationshipUnbornChild], [fldChkPresentingID], [fldChkEstrangementID], [fldChkSuddenID], [fldChkPreviousID], [fldChkViolentID], [fldChkHarmID], [fldThirdPartyInfo], [fldMedChangesID], [fldMedChangesFurtherDetails], [fldGPActionsID], [fldGPActionsFurtherDetails], [fldClinicalReviewID], [fldClinicalReviewFurtherDetails], [fldAdditionalPlansID], [fldAdditionalPlansFurtherDetails], [fldContactedByResearchID], [fldAssessmentLetterID], [fldReceiveCopyID], [flgChkReplanned], [flgChkSaved], [flgExistingForm], [flgValidParent], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [fldChkAbsconsionID]
							)
							SELECT [MHAssessmentV9_ID], [Patient_ID], [Confirm_Flag_ID], [Confirm_Date], [Confirm_Time], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [OriginalAuthorID], [fldEnteredDate], [fldEnteredTime], [StartDate], [StartTime], [ReplanRequested], [DocumentGroupIdentifier], [PreviousCNObjectID], [fldServiceSettingID], [fldGenAssessPresSit], [fldGenAssessHistComp], [fldGenAssessPastMedHist], [fldGenAssessCurrMeds], [fldGenAssessPastPsycHist], [fldGenAssessPersHist], [fldGenAssessFamHist], [fldGenAssessFrsicHist], [fldGenAssessSocCirc], [fldAlcDrugUsage], [fldGenAssessSpiritNeeds], [fldGenAssessIsACarer], [fldGenAssessPreMorbid], [fldSafeguardingStatusID], [fldDependentsID], [fldDependentsDetails], [fldGenAssessCapcityAtTime], [fldGenAssessAppearance], [fldGenAssessBehaviour], [fldGenAssessSpeech], [fldGenAssessMood], [fldGenAssessThoughts], [fldGenAssessPerception], [fldGenAssessCognition], [fldGenAssessInsight], [fldEatingBehaviours], [fldSchool], [fldEngagement], [fldDevHistory], [fldObsBehaviour], [fldManagingNutritionID], [fldManagingNutritionDetails], [fldPersonalHygieneID], [fldPersonalHygieneDetails], [fldToiletNeedsID], [fldToiletNeedsDetails], [fldAppropriateClothID], [fldAppropriateClothDetails], [fldAdultsHomeID], [fldAdultsHomeDetails], [fldHomeEnvironmentID], [fldHomeEnvironmentDetails], [fldOtherPersonalRelationshipsID], [fldOtherPersonalRelationshipsDetails], [fldAccessAndEngageID], [fldAccessAndEngageDetails], [fldFacilitiesOrServicesID], [fldFacilitiesOrServicesDetails], [fldCaringResponsibilitiesID], [fldCaringResponsibilitiesDetails], [fldPsychoTherapiesNeededID], [fldPsychoTherapiesNeededDetails], [fldPresenting], [fldPrecipitating], [fldPredisposing], [fldPerpetuating], [fldProtective], [fldAnnualHealthCheckID], [fldAnnualHealthCheckDetails], [fldHospActionPlanID], [fldHospActionPlanDetails], [fldHospPassportID], [fldHospPassportDetails], [fldEyeTestID], [fldEyeTestDetails], [fldDentalCheckUpID], [fldDentalCheckUpDetails], [fldHealthScreeningID], [fldHealthScreeningDetails], [fldCommunication], [fldMobilityFalls], [fldOccupation], [fldEatingAndDrinking], [fldSleep], [fldEpilepsyID], [fldChkPhysicalHealthID], [fldChkMentalHealthID], [fldChkForensicsID], [fldChkEpilepsyID], [fldChkChallengingBehaviourID], [fldChkDementiaID], [fldChkAutismID], [fldMaternityObstetic], [fldCurrentlyPregnantID], [fldDueDate], [fldPrevPregnancies], [fldPregnancyAndDeliveryDetails], [fldRelationshipUnbornChild], [fldChkPresentingID], [fldChkEstrangementID], [fldChkSuddenID], [fldChkPreviousID], [fldChkViolentID], [fldChkHarmID], [fldThirdPartyInfo], [fldMedChangesID], [fldMedChangesFurtherDetails], [fldGPActionsID], [fldGPActionsFurtherDetails], [fldClinicalReviewID], [fldClinicalReviewFurtherDetails], [fldAdditionalPlansID], [fldAdditionalPlansFurtherDetails], [fldContactedByResearchID], [fldAssessmentLetterID], [fldReceiveCopyID], [flgChkReplanned], [flgChkSaved], [flgExistingForm], [flgValidParent], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [fldChkAbsconsionID]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[udfMHAssessmentV9];

							SET @Inserted = @@ROWCOUNT;

						END;
						--	Else load target incrementally...
						ELSE
						BEGIN

							--	Delete from target where target PK not in working table. --TODO We can save time by doing deletes and updated together but then we wouldn not be able to report separate counts for deleted/updated/inserted.
							DELETE tgt
							FROM mrr_tbl.CNS_udfMHAssessmentV9 AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNS_udfMHAssessmentV9 AS src
								WHERE tgt.[MHAssessmentV9_ID] = src.[MHAssessmentV9_ID]
							);
							--	How many deleted?
							SET @Deleted = @@ROWCOUNT;

							--	Delete from target where working table PK & ChangeDetectionColumn not in target.
							DELETE tgt
							FROM mrr_tbl.CNS_udfMHAssessmentV9 AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNS_udfMHAssessmentV9 AS src
								WHERE tgt.[MHAssessmentV9_ID] = src.[MHAssessmentV9_ID] AND tgt.[Updated_Dttm] = src.[Updated_Dttm]
							);
							--	How many updated?
							SET @Updated = @@ROWCOUNT;

							--		Insert into Target from source where working table PK & ChangeDetectionColumn not in target.
							INSERT INTO mrr_tbl.CNS_udfMHAssessmentV9
							(
								[MHAssessmentV9_ID], [Patient_ID], [Confirm_Flag_ID], [Confirm_Date], [Confirm_Time], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [OriginalAuthorID], [fldEnteredDate], [fldEnteredTime], [StartDate], [StartTime], [ReplanRequested], [DocumentGroupIdentifier], [PreviousCNObjectID], [fldServiceSettingID], [fldGenAssessPresSit], [fldGenAssessHistComp], [fldGenAssessPastMedHist], [fldGenAssessCurrMeds], [fldGenAssessPastPsycHist], [fldGenAssessPersHist], [fldGenAssessFamHist], [fldGenAssessFrsicHist], [fldGenAssessSocCirc], [fldAlcDrugUsage], [fldGenAssessSpiritNeeds], [fldGenAssessIsACarer], [fldGenAssessPreMorbid], [fldSafeguardingStatusID], [fldDependentsID], [fldDependentsDetails], [fldGenAssessCapcityAtTime], [fldGenAssessAppearance], [fldGenAssessBehaviour], [fldGenAssessSpeech], [fldGenAssessMood], [fldGenAssessThoughts], [fldGenAssessPerception], [fldGenAssessCognition], [fldGenAssessInsight], [fldEatingBehaviours], [fldSchool], [fldEngagement], [fldDevHistory], [fldObsBehaviour], [fldManagingNutritionID], [fldManagingNutritionDetails], [fldPersonalHygieneID], [fldPersonalHygieneDetails], [fldToiletNeedsID], [fldToiletNeedsDetails], [fldAppropriateClothID], [fldAppropriateClothDetails], [fldAdultsHomeID], [fldAdultsHomeDetails], [fldHomeEnvironmentID], [fldHomeEnvironmentDetails], [fldOtherPersonalRelationshipsID], [fldOtherPersonalRelationshipsDetails], [fldAccessAndEngageID], [fldAccessAndEngageDetails], [fldFacilitiesOrServicesID], [fldFacilitiesOrServicesDetails], [fldCaringResponsibilitiesID], [fldCaringResponsibilitiesDetails], [fldPsychoTherapiesNeededID], [fldPsychoTherapiesNeededDetails], [fldPresenting], [fldPrecipitating], [fldPredisposing], [fldPerpetuating], [fldProtective], [fldAnnualHealthCheckID], [fldAnnualHealthCheckDetails], [fldHospActionPlanID], [fldHospActionPlanDetails], [fldHospPassportID], [fldHospPassportDetails], [fldEyeTestID], [fldEyeTestDetails], [fldDentalCheckUpID], [fldDentalCheckUpDetails], [fldHealthScreeningID], [fldHealthScreeningDetails], [fldCommunication], [fldMobilityFalls], [fldOccupation], [fldEatingAndDrinking], [fldSleep], [fldEpilepsyID], [fldChkPhysicalHealthID], [fldChkMentalHealthID], [fldChkForensicsID], [fldChkEpilepsyID], [fldChkChallengingBehaviourID], [fldChkDementiaID], [fldChkAutismID], [fldMaternityObstetic], [fldCurrentlyPregnantID], [fldDueDate], [fldPrevPregnancies], [fldPregnancyAndDeliveryDetails], [fldRelationshipUnbornChild], [fldChkPresentingID], [fldChkEstrangementID], [fldChkSuddenID], [fldChkPreviousID], [fldChkViolentID], [fldChkHarmID], [fldThirdPartyInfo], [fldMedChangesID], [fldMedChangesFurtherDetails], [fldGPActionsID], [fldGPActionsFurtherDetails], [fldClinicalReviewID], [fldClinicalReviewFurtherDetails], [fldAdditionalPlansID], [fldAdditionalPlansFurtherDetails], [fldContactedByResearchID], [fldAssessmentLetterID], [fldReceiveCopyID], [flgChkReplanned], [flgChkSaved], [flgExistingForm], [flgValidParent], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [fldChkAbsconsionID]
							)
							SELECT src.[MHAssessmentV9_ID], src.[Patient_ID], src.[Confirm_Flag_ID], src.[Confirm_Date], src.[Confirm_Time], src.[Confirm_Staff_Name], src.[Confirm_Staff_Job_Title], src.[OriginalAuthorID], src.[fldEnteredDate], src.[fldEnteredTime], src.[StartDate], src.[StartTime], src.[ReplanRequested], src.[DocumentGroupIdentifier], src.[PreviousCNObjectID], src.[fldServiceSettingID], src.[fldGenAssessPresSit], src.[fldGenAssessHistComp], src.[fldGenAssessPastMedHist], src.[fldGenAssessCurrMeds], src.[fldGenAssessPastPsycHist], src.[fldGenAssessPersHist], src.[fldGenAssessFamHist], src.[fldGenAssessFrsicHist], src.[fldGenAssessSocCirc], src.[fldAlcDrugUsage], src.[fldGenAssessSpiritNeeds], src.[fldGenAssessIsACarer], src.[fldGenAssessPreMorbid], src.[fldSafeguardingStatusID], src.[fldDependentsID], src.[fldDependentsDetails], src.[fldGenAssessCapcityAtTime], src.[fldGenAssessAppearance], src.[fldGenAssessBehaviour], src.[fldGenAssessSpeech], src.[fldGenAssessMood], src.[fldGenAssessThoughts], src.[fldGenAssessPerception], src.[fldGenAssessCognition], src.[fldGenAssessInsight], src.[fldEatingBehaviours], src.[fldSchool], src.[fldEngagement], src.[fldDevHistory], src.[fldObsBehaviour], src.[fldManagingNutritionID], src.[fldManagingNutritionDetails], src.[fldPersonalHygieneID], src.[fldPersonalHygieneDetails], src.[fldToiletNeedsID], src.[fldToiletNeedsDetails], src.[fldAppropriateClothID], src.[fldAppropriateClothDetails], src.[fldAdultsHomeID], src.[fldAdultsHomeDetails], src.[fldHomeEnvironmentID], src.[fldHomeEnvironmentDetails], src.[fldOtherPersonalRelationshipsID], src.[fldOtherPersonalRelationshipsDetails], src.[fldAccessAndEngageID], src.[fldAccessAndEngageDetails], src.[fldFacilitiesOrServicesID], src.[fldFacilitiesOrServicesDetails], src.[fldCaringResponsibilitiesID], src.[fldCaringResponsibilitiesDetails], src.[fldPsychoTherapiesNeededID], src.[fldPsychoTherapiesNeededDetails], src.[fldPresenting], src.[fldPrecipitating], src.[fldPredisposing], src.[fldPerpetuating], src.[fldProtective], src.[fldAnnualHealthCheckID], src.[fldAnnualHealthCheckDetails], src.[fldHospActionPlanID], src.[fldHospActionPlanDetails], src.[fldHospPassportID], src.[fldHospPassportDetails], src.[fldEyeTestID], src.[fldEyeTestDetails], src.[fldDentalCheckUpID], src.[fldDentalCheckUpDetails], src.[fldHealthScreeningID], src.[fldHealthScreeningDetails], src.[fldCommunication], src.[fldMobilityFalls], src.[fldOccupation], src.[fldEatingAndDrinking], src.[fldSleep], src.[fldEpilepsyID], src.[fldChkPhysicalHealthID], src.[fldChkMentalHealthID], src.[fldChkForensicsID], src.[fldChkEpilepsyID], src.[fldChkChallengingBehaviourID], src.[fldChkDementiaID], src.[fldChkAutismID], src.[fldMaternityObstetic], src.[fldCurrentlyPregnantID], src.[fldDueDate], src.[fldPrevPregnancies], src.[fldPregnancyAndDeliveryDetails], src.[fldRelationshipUnbornChild], src.[fldChkPresentingID], src.[fldChkEstrangementID], src.[fldChkSuddenID], src.[fldChkPreviousID], src.[fldChkViolentID], src.[fldChkHarmID], src.[fldThirdPartyInfo], src.[fldMedChangesID], src.[fldMedChangesFurtherDetails], src.[fldGPActionsID], src.[fldGPActionsFurtherDetails], src.[fldClinicalReviewID], src.[fldClinicalReviewFurtherDetails], src.[fldAdditionalPlansID], src.[fldAdditionalPlansFurtherDetails], src.[fldContactedByResearchID], src.[fldAssessmentLetterID], src.[fldReceiveCopyID], src.[flgChkReplanned], src.[flgChkSaved], src.[flgExistingForm], src.[flgValidParent], src.[User_Created], src.[Create_Dttm], src.[User_Updated], src.[Updated_Dttm], src.[fldChkAbsconsionID]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[udfMHAssessmentV9] AS src
							INNER JOIN (SELECT wrk.[MHAssessmentV9_ID] FROM mrr_wrk.CNS_udfMHAssessmentV9 wrk
									WHERE NOT EXISTS
									(
										SELECT NULL
										FROM mrr_tbl.CNS_udfMHAssessmentV9 AS tgt
										WHERE wrk.[MHAssessmentV9_ID] = tgt.[MHAssessmentV9_ID]
									)
								) MissingRecs ON (MissingRecs.[MHAssessmentV9_ID] = src.[MHAssessmentV9_ID]);


							--	How many really inserted? ROWCOUNT = inserted + updated records.
							SET @Inserted = @@ROWCOUNT - @Updated;

						--		Truncate working table? --TODO decide.
						END;

						--	Update audit table.
						SET @EndTime = GETDATE();

						INSERT INTO mrr_aud.CNS_udfMHAssessmentV9
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
						COMMIT TRANSACTION; -- INSERT INTO mrr_aud.CNS_udfMHAssessmentV9

					END TRY
					--Catch if transaction open roll it back.
					BEGIN CATCH
						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;
						THROW;
					END CATCH;

				END;
				
GO
