SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

				/*==========================================================================================================================================
				Notes:
				Template for loading Mirror table incrementally.

				TODO Is this the right place for the transactions? Should transaction handling be external to this procedure?

				Test:

				EXECUTE mrr_tbl.load_CNS_udfOHFTGENRiskAssessment
				EXECUTE mrr_tbl.load_CNS_udfOHFTGENRiskAssessment 'F'

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[load_CNS_udfOHFTGENRiskAssessment]
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
							SELECT COUNT(*) FROM mrr_tbl.CNS_udfOHFTGENRiskAssessment
						);

						--	Load working table from source.
						BEGIN TRANSACTION; -- INSERT INTO mrr_wrk.CNS_udfOHFTGENRiskAssessment

						TRUNCATE TABLE mrr_wrk.CNS_udfOHFTGENRiskAssessment;

						INSERT INTO mrr_wrk.CNS_udfOHFTGENRiskAssessment
						(
							[OHFTGENRiskAssessment_ID], [Updated_Dttm]
						)
						SELECT [OHFTGENRiskAssessment_ID], [Updated_Dttm]
						FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[udfOHFTGENRiskAssessment];

						--	How many records in working table?
						SET @WorkingCount = @@ROWCOUNT;

						COMMIT TRANSACTION; -- INSERT INTO mrr_wrk.CNS_udfOHFTGENRiskAssessment

						--	If 0 records in target or ABS(nW-nT) > Threshold force a Truncate/Insert. --TODO not ideal test but achievable without slowing the procedure down too much.
						IF ABS(@WorkingCount - @OriginalTargetCount) >= CAST((@OriginalTargetCount * @Threshold / 100) AS INTEGER)
							SET @LoadType = 'F';

						BEGIN TRANSACTION; -- Start transaction for the load and audit.

						--	We now do either a full (F) reload of the target or an incremental (I) load depending on what has been requested or how much data is changing.
						IF @LoadType = 'F'
						BEGIN
							--	Full load target from source.

							TRUNCATE TABLE mrr_tbl.CNS_udfOHFTGENRiskAssessment;

							INSERT INTO mrr_tbl.CNS_udfOHFTGENRiskAssessment
							(
								[OHFTGENRiskAssessment_ID], [Patient_ID], [OriginalAuthorID], [StartDate], [EndDate], [RiskHistory], [AggressionAndViolence612ID], [AggressionAndViolenceEverID], [SubstanceMisuse612ID], [SubstanceMisuseEverID], [ActWithSuicidalIntent612ID], [ActWithSuicidalIntentEverID], [PhysicalHealth612ID], [PhysicalHealthEverID], [SuicidalIdeation612ID], [SuicidalIdeationEverID], [NonConcordance612ID], [NonConcordanceEverID], [SevereSelfNeglect612ID], [SevereSelfNeglectEverID], [Disengagement612ID], [DisengagementEverID], [SelfHarm612ID], [SelfHarmEverID], [Relapse612ID], [RelapseEverID], [RiskToChildrenAdults612ID], [RiskToChildrenAdultsEverID], [Exploitation612ID], [ExploitationEverID], [RisksIdentifiedComments], [AbscondingEscapingEverID], [PhoneCallsEverID], [DamageToPropertyEverID], [TheftEverID], [IncidentsInvolvingPoliceEverID], [RiskEvidenceGeneralComments], [AccidentalHarmOutsideHomeEverID], [FireEverID], [DrivingRoadSafetyEverID], [UnsafeUseMedicationEverID], [FallsEverID], [AccidentsComments], [ArsonEverID], [ProbationServiceInvolvementEverID], [ExpliotationFinancialEmotionalEverID], [RiskToChildrenEverID], [HostageTakingEverID], [RiskToVulnrableAdultsEverID], [MAPPAEverID], [StalkingEverID], [WeaponsEverID], [HarmToOthersComments], [ConvictedOfSexOffenceAgainstChildYoungPersonEverID], [ConvictedOfSexualAssaultEverID], [SexOffendersAct2003EverID], [SexualOffencesComments], [familyEverID], [OtherClientsEverID], [GeneralPublicEverID], [StaffEverID], [ViolenceTowardsOthersComments], [CPPForSelfOrOtherEverID], [RiskOfNeglectEverID], [RiskCausedByMedicationsServicesTreatmentEverID], [RiskOfPhysicalHarmEverID], [RiskOfEmotionalPsychologicalAbuseEverID], [RiskOfUnlawfulRestrictionsEverID], [RiskOfFinancialAbuseEverID], [RiskOfSexualExploitationEverID], [HarmFromOthersComments], [AttemptedSuicideWithIntentEverID], [SelfNeglectEverID], [ParaSuicideEverID], [SuicidalIdeationHarmToSelfEverID], [SelfInjuryOrHarmEverID], [HarmToSelfComments], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
							)
							SELECT [OHFTGENRiskAssessment_ID], [Patient_ID], [OriginalAuthorID], [StartDate], [EndDate], [RiskHistory], [AggressionAndViolence612ID], [AggressionAndViolenceEverID], [SubstanceMisuse612ID], [SubstanceMisuseEverID], [ActWithSuicidalIntent612ID], [ActWithSuicidalIntentEverID], [PhysicalHealth612ID], [PhysicalHealthEverID], [SuicidalIdeation612ID], [SuicidalIdeationEverID], [NonConcordance612ID], [NonConcordanceEverID], [SevereSelfNeglect612ID], [SevereSelfNeglectEverID], [Disengagement612ID], [DisengagementEverID], [SelfHarm612ID], [SelfHarmEverID], [Relapse612ID], [RelapseEverID], [RiskToChildrenAdults612ID], [RiskToChildrenAdultsEverID], [Exploitation612ID], [ExploitationEverID], [RisksIdentifiedComments], [AbscondingEscapingEverID], [PhoneCallsEverID], [DamageToPropertyEverID], [TheftEverID], [IncidentsInvolvingPoliceEverID], [RiskEvidenceGeneralComments], [AccidentalHarmOutsideHomeEverID], [FireEverID], [DrivingRoadSafetyEverID], [UnsafeUseMedicationEverID], [FallsEverID], [AccidentsComments], [ArsonEverID], [ProbationServiceInvolvementEverID], [ExpliotationFinancialEmotionalEverID], [RiskToChildrenEverID], [HostageTakingEverID], [RiskToVulnrableAdultsEverID], [MAPPAEverID], [StalkingEverID], [WeaponsEverID], [HarmToOthersComments], [ConvictedOfSexOffenceAgainstChildYoungPersonEverID], [ConvictedOfSexualAssaultEverID], [SexOffendersAct2003EverID], [SexualOffencesComments], [familyEverID], [OtherClientsEverID], [GeneralPublicEverID], [StaffEverID], [ViolenceTowardsOthersComments], [CPPForSelfOrOtherEverID], [RiskOfNeglectEverID], [RiskCausedByMedicationsServicesTreatmentEverID], [RiskOfPhysicalHarmEverID], [RiskOfEmotionalPsychologicalAbuseEverID], [RiskOfUnlawfulRestrictionsEverID], [RiskOfFinancialAbuseEverID], [RiskOfSexualExploitationEverID], [HarmFromOthersComments], [AttemptedSuicideWithIntentEverID], [SelfNeglectEverID], [ParaSuicideEverID], [SuicidalIdeationHarmToSelfEverID], [SelfInjuryOrHarmEverID], [HarmToSelfComments], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[udfOHFTGENRiskAssessment];

							SET @Inserted = @@ROWCOUNT;

						END;
						--	Else load target incrementally...
						ELSE
						BEGIN

							--	Delete from target where target PK not in working table. --TODO We can save time by doing deletes and updated together but then we wouldn not be able to report separate counts for deleted/updated/inserted.
							DELETE tgt
							FROM mrr_tbl.CNS_udfOHFTGENRiskAssessment AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNS_udfOHFTGENRiskAssessment AS src
								WHERE tgt.[OHFTGENRiskAssessment_ID] = src.[OHFTGENRiskAssessment_ID]
							);
							--	How many deleted?
							SET @Deleted = @@ROWCOUNT;

							--	Delete from target where working table PK & ChangeDetectionColumn not in target.
							DELETE tgt
							FROM mrr_tbl.CNS_udfOHFTGENRiskAssessment AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNS_udfOHFTGENRiskAssessment AS src
								WHERE tgt.[OHFTGENRiskAssessment_ID] = src.[OHFTGENRiskAssessment_ID] AND tgt.[Updated_Dttm] = src.[Updated_Dttm]
							);
							--	How many updated?
							SET @Updated = @@ROWCOUNT;

							--		Insert into Target from source where working table PK & ChangeDetectionColumn not in target.
							INSERT INTO mrr_tbl.CNS_udfOHFTGENRiskAssessment
							(
								[OHFTGENRiskAssessment_ID], [Patient_ID], [OriginalAuthorID], [StartDate], [EndDate], [RiskHistory], [AggressionAndViolence612ID], [AggressionAndViolenceEverID], [SubstanceMisuse612ID], [SubstanceMisuseEverID], [ActWithSuicidalIntent612ID], [ActWithSuicidalIntentEverID], [PhysicalHealth612ID], [PhysicalHealthEverID], [SuicidalIdeation612ID], [SuicidalIdeationEverID], [NonConcordance612ID], [NonConcordanceEverID], [SevereSelfNeglect612ID], [SevereSelfNeglectEverID], [Disengagement612ID], [DisengagementEverID], [SelfHarm612ID], [SelfHarmEverID], [Relapse612ID], [RelapseEverID], [RiskToChildrenAdults612ID], [RiskToChildrenAdultsEverID], [Exploitation612ID], [ExploitationEverID], [RisksIdentifiedComments], [AbscondingEscapingEverID], [PhoneCallsEverID], [DamageToPropertyEverID], [TheftEverID], [IncidentsInvolvingPoliceEverID], [RiskEvidenceGeneralComments], [AccidentalHarmOutsideHomeEverID], [FireEverID], [DrivingRoadSafetyEverID], [UnsafeUseMedicationEverID], [FallsEverID], [AccidentsComments], [ArsonEverID], [ProbationServiceInvolvementEverID], [ExpliotationFinancialEmotionalEverID], [RiskToChildrenEverID], [HostageTakingEverID], [RiskToVulnrableAdultsEverID], [MAPPAEverID], [StalkingEverID], [WeaponsEverID], [HarmToOthersComments], [ConvictedOfSexOffenceAgainstChildYoungPersonEverID], [ConvictedOfSexualAssaultEverID], [SexOffendersAct2003EverID], [SexualOffencesComments], [familyEverID], [OtherClientsEverID], [GeneralPublicEverID], [StaffEverID], [ViolenceTowardsOthersComments], [CPPForSelfOrOtherEverID], [RiskOfNeglectEverID], [RiskCausedByMedicationsServicesTreatmentEverID], [RiskOfPhysicalHarmEverID], [RiskOfEmotionalPsychologicalAbuseEverID], [RiskOfUnlawfulRestrictionsEverID], [RiskOfFinancialAbuseEverID], [RiskOfSexualExploitationEverID], [HarmFromOthersComments], [AttemptedSuicideWithIntentEverID], [SelfNeglectEverID], [ParaSuicideEverID], [SuicidalIdeationHarmToSelfEverID], [SelfInjuryOrHarmEverID], [HarmToSelfComments], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
							)
							SELECT src.[OHFTGENRiskAssessment_ID], src.[Patient_ID], src.[OriginalAuthorID], src.[StartDate], src.[EndDate], src.[RiskHistory], src.[AggressionAndViolence612ID], src.[AggressionAndViolenceEverID], src.[SubstanceMisuse612ID], src.[SubstanceMisuseEverID], src.[ActWithSuicidalIntent612ID], src.[ActWithSuicidalIntentEverID], src.[PhysicalHealth612ID], src.[PhysicalHealthEverID], src.[SuicidalIdeation612ID], src.[SuicidalIdeationEverID], src.[NonConcordance612ID], src.[NonConcordanceEverID], src.[SevereSelfNeglect612ID], src.[SevereSelfNeglectEverID], src.[Disengagement612ID], src.[DisengagementEverID], src.[SelfHarm612ID], src.[SelfHarmEverID], src.[Relapse612ID], src.[RelapseEverID], src.[RiskToChildrenAdults612ID], src.[RiskToChildrenAdultsEverID], src.[Exploitation612ID], src.[ExploitationEverID], src.[RisksIdentifiedComments], src.[AbscondingEscapingEverID], src.[PhoneCallsEverID], src.[DamageToPropertyEverID], src.[TheftEverID], src.[IncidentsInvolvingPoliceEverID], src.[RiskEvidenceGeneralComments], src.[AccidentalHarmOutsideHomeEverID], src.[FireEverID], src.[DrivingRoadSafetyEverID], src.[UnsafeUseMedicationEverID], src.[FallsEverID], src.[AccidentsComments], src.[ArsonEverID], src.[ProbationServiceInvolvementEverID], src.[ExpliotationFinancialEmotionalEverID], src.[RiskToChildrenEverID], src.[HostageTakingEverID], src.[RiskToVulnrableAdultsEverID], src.[MAPPAEverID], src.[StalkingEverID], src.[WeaponsEverID], src.[HarmToOthersComments], src.[ConvictedOfSexOffenceAgainstChildYoungPersonEverID], src.[ConvictedOfSexualAssaultEverID], src.[SexOffendersAct2003EverID], src.[SexualOffencesComments], src.[familyEverID], src.[OtherClientsEverID], src.[GeneralPublicEverID], src.[StaffEverID], src.[ViolenceTowardsOthersComments], src.[CPPForSelfOrOtherEverID], src.[RiskOfNeglectEverID], src.[RiskCausedByMedicationsServicesTreatmentEverID], src.[RiskOfPhysicalHarmEverID], src.[RiskOfEmotionalPsychologicalAbuseEverID], src.[RiskOfUnlawfulRestrictionsEverID], src.[RiskOfFinancialAbuseEverID], src.[RiskOfSexualExploitationEverID], src.[HarmFromOthersComments], src.[AttemptedSuicideWithIntentEverID], src.[SelfNeglectEverID], src.[ParaSuicideEverID], src.[SuicidalIdeationHarmToSelfEverID], src.[SelfInjuryOrHarmEverID], src.[HarmToSelfComments], src.[User_Created], src.[Create_Dttm], src.[User_Updated], src.[Updated_Dttm]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[udfOHFTGENRiskAssessment] AS src
							INNER JOIN (SELECT wrk.[OHFTGENRiskAssessment_ID] FROM mrr_wrk.CNS_udfOHFTGENRiskAssessment wrk
									WHERE NOT EXISTS
									(
										SELECT NULL
										FROM mrr_tbl.CNS_udfOHFTGENRiskAssessment AS tgt
										WHERE wrk.[OHFTGENRiskAssessment_ID] = tgt.[OHFTGENRiskAssessment_ID]
									)
								) MissingRecs ON (MissingRecs.[OHFTGENRiskAssessment_ID] = src.[OHFTGENRiskAssessment_ID]);


							--	How many really inserted? ROWCOUNT = inserted + updated records.
							SET @Inserted = @@ROWCOUNT - @Updated;

						--		Truncate working table? --TODO decide.
						END;

						--	Update audit table.
						SET @EndTime = GETDATE();

						INSERT INTO mrr_aud.CNS_udfOHFTGENRiskAssessment
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
						COMMIT TRANSACTION; -- INSERT INTO mrr_aud.CNS_udfOHFTGENRiskAssessment

					END TRY
					--Catch if transaction open roll it back.
					BEGIN CATCH
						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;
						THROW;
					END CATCH;

				END;
				
GO
