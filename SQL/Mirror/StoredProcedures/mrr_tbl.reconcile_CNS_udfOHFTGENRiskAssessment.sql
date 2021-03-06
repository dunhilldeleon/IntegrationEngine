SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_CNS_udfOHFTGENRiskAssessment

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_CNS_udfOHFTGENRiskAssessment]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[OHFTGENRiskAssessment_ID], [Patient_ID], [OriginalAuthorID], [StartDate], [EndDate], [AggressionAndViolence612ID], [AggressionAndViolenceEverID], [SubstanceMisuse612ID], [SubstanceMisuseEverID], [ActWithSuicidalIntent612ID], [ActWithSuicidalIntentEverID], [PhysicalHealth612ID], [PhysicalHealthEverID], [SuicidalIdeation612ID], [SuicidalIdeationEverID], [NonConcordance612ID], [NonConcordanceEverID], [SevereSelfNeglect612ID], [SevereSelfNeglectEverID], [Disengagement612ID], [DisengagementEverID], [SelfHarm612ID], [SelfHarmEverID], [Relapse612ID], [RelapseEverID], [RiskToChildrenAdults612ID], [RiskToChildrenAdultsEverID], [Exploitation612ID], [ExploitationEverID], [AbscondingEscapingEverID], [PhoneCallsEverID], [DamageToPropertyEverID], [TheftEverID], [IncidentsInvolvingPoliceEverID], [AccidentalHarmOutsideHomeEverID], [FireEverID], [DrivingRoadSafetyEverID], [UnsafeUseMedicationEverID], [FallsEverID], [ArsonEverID], [ProbationServiceInvolvementEverID], [ExpliotationFinancialEmotionalEverID], [RiskToChildrenEverID], [HostageTakingEverID], [RiskToVulnrableAdultsEverID], [MAPPAEverID], [StalkingEverID], [WeaponsEverID], [ConvictedOfSexOffenceAgainstChildYoungPersonEverID], [ConvictedOfSexualAssaultEverID], [SexOffendersAct2003EverID], [familyEverID], [OtherClientsEverID], [GeneralPublicEverID], [StaffEverID], [CPPForSelfOrOtherEverID], [RiskOfNeglectEverID], [RiskCausedByMedicationsServicesTreatmentEverID], [RiskOfPhysicalHarmEverID], [RiskOfEmotionalPsychologicalAbuseEverID], [RiskOfUnlawfulRestrictionsEverID], [RiskOfFinancialAbuseEverID], [RiskOfSexualExploitationEverID], [AttemptedSuicideWithIntentEverID], [SelfNeglectEverID], [ParaSuicideEverID], [SuicidalIdeationHarmToSelfEverID], [SelfInjuryOrHarmEverID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
						 FROM mrr_tbl.CNS_udfOHFTGENRiskAssessment
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[OHFTGENRiskAssessment_ID], [Patient_ID], [OriginalAuthorID], [StartDate], [EndDate], [AggressionAndViolence612ID], [AggressionAndViolenceEverID], [SubstanceMisuse612ID], [SubstanceMisuseEverID], [ActWithSuicidalIntent612ID], [ActWithSuicidalIntentEverID], [PhysicalHealth612ID], [PhysicalHealthEverID], [SuicidalIdeation612ID], [SuicidalIdeationEverID], [NonConcordance612ID], [NonConcordanceEverID], [SevereSelfNeglect612ID], [SevereSelfNeglectEverID], [Disengagement612ID], [DisengagementEverID], [SelfHarm612ID], [SelfHarmEverID], [Relapse612ID], [RelapseEverID], [RiskToChildrenAdults612ID], [RiskToChildrenAdultsEverID], [Exploitation612ID], [ExploitationEverID], [AbscondingEscapingEverID], [PhoneCallsEverID], [DamageToPropertyEverID], [TheftEverID], [IncidentsInvolvingPoliceEverID], [AccidentalHarmOutsideHomeEverID], [FireEverID], [DrivingRoadSafetyEverID], [UnsafeUseMedicationEverID], [FallsEverID], [ArsonEverID], [ProbationServiceInvolvementEverID], [ExpliotationFinancialEmotionalEverID], [RiskToChildrenEverID], [HostageTakingEverID], [RiskToVulnrableAdultsEverID], [MAPPAEverID], [StalkingEverID], [WeaponsEverID], [ConvictedOfSexOffenceAgainstChildYoungPersonEverID], [ConvictedOfSexualAssaultEverID], [SexOffendersAct2003EverID], [familyEverID], [OtherClientsEverID], [GeneralPublicEverID], [StaffEverID], [CPPForSelfOrOtherEverID], [RiskOfNeglectEverID], [RiskCausedByMedicationsServicesTreatmentEverID], [RiskOfPhysicalHarmEverID], [RiskOfEmotionalPsychologicalAbuseEverID], [RiskOfUnlawfulRestrictionsEverID], [RiskOfFinancialAbuseEverID], [RiskOfSexualExploitationEverID], [AttemptedSuicideWithIntentEverID], [SelfNeglectEverID], [ParaSuicideEverID], [SuicidalIdeationHarmToSelfEverID], [SelfInjuryOrHarmEverID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[udfOHFTGENRiskAssessment])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[OHFTGENRiskAssessment_ID], [Patient_ID], [OriginalAuthorID], [StartDate], [EndDate], [AggressionAndViolence612ID], [AggressionAndViolenceEverID], [SubstanceMisuse612ID], [SubstanceMisuseEverID], [ActWithSuicidalIntent612ID], [ActWithSuicidalIntentEverID], [PhysicalHealth612ID], [PhysicalHealthEverID], [SuicidalIdeation612ID], [SuicidalIdeationEverID], [NonConcordance612ID], [NonConcordanceEverID], [SevereSelfNeglect612ID], [SevereSelfNeglectEverID], [Disengagement612ID], [DisengagementEverID], [SelfHarm612ID], [SelfHarmEverID], [Relapse612ID], [RelapseEverID], [RiskToChildrenAdults612ID], [RiskToChildrenAdultsEverID], [Exploitation612ID], [ExploitationEverID], [AbscondingEscapingEverID], [PhoneCallsEverID], [DamageToPropertyEverID], [TheftEverID], [IncidentsInvolvingPoliceEverID], [AccidentalHarmOutsideHomeEverID], [FireEverID], [DrivingRoadSafetyEverID], [UnsafeUseMedicationEverID], [FallsEverID], [ArsonEverID], [ProbationServiceInvolvementEverID], [ExpliotationFinancialEmotionalEverID], [RiskToChildrenEverID], [HostageTakingEverID], [RiskToVulnrableAdultsEverID], [MAPPAEverID], [StalkingEverID], [WeaponsEverID], [ConvictedOfSexOffenceAgainstChildYoungPersonEverID], [ConvictedOfSexualAssaultEverID], [SexOffendersAct2003EverID], [familyEverID], [OtherClientsEverID], [GeneralPublicEverID], [StaffEverID], [CPPForSelfOrOtherEverID], [RiskOfNeglectEverID], [RiskCausedByMedicationsServicesTreatmentEverID], [RiskOfPhysicalHarmEverID], [RiskOfEmotionalPsychologicalAbuseEverID], [RiskOfUnlawfulRestrictionsEverID], [RiskOfFinancialAbuseEverID], [RiskOfSexualExploitationEverID], [AttemptedSuicideWithIntentEverID], [SelfNeglectEverID], [ParaSuicideEverID], [SuicidalIdeationHarmToSelfEverID], [SelfInjuryOrHarmEverID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[udfOHFTGENRiskAssessment]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[OHFTGENRiskAssessment_ID], [Patient_ID], [OriginalAuthorID], [StartDate], [EndDate], [AggressionAndViolence612ID], [AggressionAndViolenceEverID], [SubstanceMisuse612ID], [SubstanceMisuseEverID], [ActWithSuicidalIntent612ID], [ActWithSuicidalIntentEverID], [PhysicalHealth612ID], [PhysicalHealthEverID], [SuicidalIdeation612ID], [SuicidalIdeationEverID], [NonConcordance612ID], [NonConcordanceEverID], [SevereSelfNeglect612ID], [SevereSelfNeglectEverID], [Disengagement612ID], [DisengagementEverID], [SelfHarm612ID], [SelfHarmEverID], [Relapse612ID], [RelapseEverID], [RiskToChildrenAdults612ID], [RiskToChildrenAdultsEverID], [Exploitation612ID], [ExploitationEverID], [AbscondingEscapingEverID], [PhoneCallsEverID], [DamageToPropertyEverID], [TheftEverID], [IncidentsInvolvingPoliceEverID], [AccidentalHarmOutsideHomeEverID], [FireEverID], [DrivingRoadSafetyEverID], [UnsafeUseMedicationEverID], [FallsEverID], [ArsonEverID], [ProbationServiceInvolvementEverID], [ExpliotationFinancialEmotionalEverID], [RiskToChildrenEverID], [HostageTakingEverID], [RiskToVulnrableAdultsEverID], [MAPPAEverID], [StalkingEverID], [WeaponsEverID], [ConvictedOfSexOffenceAgainstChildYoungPersonEverID], [ConvictedOfSexualAssaultEverID], [SexOffendersAct2003EverID], [familyEverID], [OtherClientsEverID], [GeneralPublicEverID], [StaffEverID], [CPPForSelfOrOtherEverID], [RiskOfNeglectEverID], [RiskCausedByMedicationsServicesTreatmentEverID], [RiskOfPhysicalHarmEverID], [RiskOfEmotionalPsychologicalAbuseEverID], [RiskOfUnlawfulRestrictionsEverID], [RiskOfFinancialAbuseEverID], [RiskOfSexualExploitationEverID], [AttemptedSuicideWithIntentEverID], [SelfNeglectEverID], [ParaSuicideEverID], [SuicidalIdeationHarmToSelfEverID], [SelfInjuryOrHarmEverID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
						 FROM mrr_tbl.CNS_udfOHFTGENRiskAssessment))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.CNS_udfOHFTGENRiskAssessment has discrepancies when compared to its source table.', 1;

				END;
				
GO
