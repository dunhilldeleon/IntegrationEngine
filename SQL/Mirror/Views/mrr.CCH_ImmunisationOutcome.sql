SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE VIEW [mrr].[CCH_ImmunisationOutcome] AS SELECT [Id], [CreatedDateTime], [ExpiredDateTime], [CareNotesUserId], [ChildHealthClientVersion], [Description], [ImmunisationOutcomeType], [ConsultationTemplateType], [SuspensionType], [Code], [DoNotReschedule], [ClinicOutcome], [ClinicNextStep] FROM [Mirror].[mrr_tbl].[CCH_ImmunisationOutcome];
GO
