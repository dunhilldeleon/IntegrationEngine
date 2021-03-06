SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE VIEW [mrr].[CCH_ImmunisationPart] AS SELECT [Id], [CreatedDateTime], [ExpiredDateTime], [CareNotesUserId], [ChildHealthClientVersion], [ImmunisationDefinitionId], [PartNumber], [GivenConsultationTemplateId], [NotGivenConsultationTemplateId], [CohortId], [DaysScheduledInAdvance], [SchoolYearBased], [Code], [MinimumGapDays] FROM [Mirror].[mrr_tbl].[CCH_ImmunisationPart];
GO
