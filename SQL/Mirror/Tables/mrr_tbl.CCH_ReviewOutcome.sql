SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[CCH_ReviewOutcome](
	[Id] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NULL,
	[ExpiredDateTime] [datetime] NULL,
	[CareNotesUserId] [int] NULL,
	[ChildHealthClientVersion] [nvarchar](32) COLLATE Latin1_General_CI_AS NULL,
	[Description] [nvarchar](100) COLLATE Latin1_General_CI_AS NULL,
	[ReviewOutcomeType] [int] NULL,
	[ConsultationTemplateType] [int] NULL,
	[Code] [nvarchar](20) COLLATE Latin1_General_CI_AS NULL,
	[DoNotReschedule] [bit] NULL,
	[CyphsCode] [nvarchar](20) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]

GO
