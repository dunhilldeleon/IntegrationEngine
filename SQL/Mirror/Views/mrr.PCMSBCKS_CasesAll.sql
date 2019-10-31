SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE VIEW [mrr].[PCMSBCKS_CasesAll] AS SELECT [CaseNumber], [ReferralDate], [CreateDate], [WorkerName], [CaseStatus], [LocationCode], [CaseType], [CurrentlyPaused], [PauseID], [LastReassignedDate], [PathwayID] FROM [Mirror].[mrr_tbl].[PCMSBCKS_CasesAll];
GO
