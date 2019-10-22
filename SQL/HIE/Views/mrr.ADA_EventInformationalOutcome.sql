SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE VIEW [mrr].[ADA_EventInformationalOutcome] AS SELECT [EventInformationalOutcomeRef], [CaseRef], [InformationalOutcomeRef], [Summary], [Obsolete] FROM [Mirror].[mrr_tbl].[ADA_EventInformationalOutcome];

GO
