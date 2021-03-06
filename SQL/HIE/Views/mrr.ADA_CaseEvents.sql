SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE VIEW [mrr].[ADA_CaseEvents] AS SELECT [EventRef], [CaseRef], [EventType], [EntryDate], [StartDate], [FinishDate], [Summary], [Ref], [UserComments], [UserRef], [UserDescription], [SyncRequired], [EventDescription], [MasterEventRef], [CaseStatus], [Obsolete], [ObsoleteByRef], [ObsoleteByDescription], [ObsoleteDate], [ObsoleteMasterEventRef], [CreationDate], [LocationRef], [Editable], [CaseAuditRef], [BeforeCaseAuditRef], [AremoteDeviceRef], [SessionRef] FROM [Mirror].[mrr_tbl].[ADA_CaseEvents];

GO
