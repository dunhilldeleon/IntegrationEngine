SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE VIEW [mrr].[CCH_ReviewOutcome] AS SELECT [Id], [CreatedDateTime], [ExpiredDateTime], [CareNotesUserId], [ChildHealthClientVersion], [Description], [ReviewOutcomeType], [ConsultationTemplateType], [Code], [DoNotReschedule], [CyphsCode] FROM  [Mirror].[mrr_tbl].[CCH_ReviewOutcome];

GO
