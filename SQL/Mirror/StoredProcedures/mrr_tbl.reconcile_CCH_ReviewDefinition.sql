SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_CCH_ReviewDefinition

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_CCH_ReviewDefinition]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[Id], [CreatedDateTime], [ExpiredDateTime], [CareNotesUserId], [ChildHealthClientVersion], [ShortName], [LongName], [ReviewType], [CarriedOutConsultationTemplateId], [NotCarriedOutConsultationTemplateId], [WarnIfMultipleInstances], [CohortId], [CoreProgramme], [IgnoreTreatmentStatus], [DaysScheduledInAdvance], [Code], [IsOutcomedByOptional], [IsTeamLocationOptional], [ForceOutcomeToId], [CyphsCode]
						 FROM mrr_tbl.CCH_ReviewDefinition
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[Id], [CreatedDateTime], [ExpiredDateTime], [CareNotesUserId], [ChildHealthClientVersion], [ShortName], [LongName], [ReviewType], [CarriedOutConsultationTemplateId], [NotCarriedOutConsultationTemplateId], [WarnIfMultipleInstances], [CohortId], [CoreProgramme], [IgnoreTreatmentStatus], [DaysScheduledInAdvance], [Code], [IsOutcomedByOptional], [IsTeamLocationOptional], [ForceOutcomeToId], [CyphsCode]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CNChildHealth-OxfordCCHealth-Live].[dbo].[ReviewDefinition])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[Id], [CreatedDateTime], [ExpiredDateTime], [CareNotesUserId], [ChildHealthClientVersion], [ShortName], [LongName], [ReviewType], [CarriedOutConsultationTemplateId], [NotCarriedOutConsultationTemplateId], [WarnIfMultipleInstances], [CohortId], [CoreProgramme], [IgnoreTreatmentStatus], [DaysScheduledInAdvance], [Code], [IsOutcomedByOptional], [IsTeamLocationOptional], [ForceOutcomeToId], [CyphsCode]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CNChildHealth-OxfordCCHealth-Live].[dbo].[ReviewDefinition]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[Id], [CreatedDateTime], [ExpiredDateTime], [CareNotesUserId], [ChildHealthClientVersion], [ShortName], [LongName], [ReviewType], [CarriedOutConsultationTemplateId], [NotCarriedOutConsultationTemplateId], [WarnIfMultipleInstances], [CohortId], [CoreProgramme], [IgnoreTreatmentStatus], [DaysScheduledInAdvance], [Code], [IsOutcomedByOptional], [IsTeamLocationOptional], [ForceOutcomeToId], [CyphsCode]
						 FROM mrr_tbl.CCH_ReviewDefinition))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.CCH_ReviewDefinition has discrepancies when compared to its source table.', 1;

				END;
				
GO
