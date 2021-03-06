SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[ADA_EventInformationalOutcome](
	[EventInformationalOutcomeRef] [uniqueidentifier] NOT NULL,
	[CaseRef] [uniqueidentifier] NULL,
	[InformationalOutcomeRef] [uniqueidentifier] NULL,
	[Summary] [varchar](512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Obsolete] [bit] NULL
) ON [PRIMARY]

GO
