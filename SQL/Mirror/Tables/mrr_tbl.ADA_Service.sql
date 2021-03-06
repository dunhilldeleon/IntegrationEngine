SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[ADA_Service](
	[ServiceRef] [uniqueidentifier] NOT NULL,
	[Name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Sort] [int] NULL,
	[V2Import] [bit] NULL,
	[Obsolete] [bit] NULL,
	[Abbreviation] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Usage] [varchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceVisibility] [int] NULL,
	[OtherServiceVisibility] [int] NULL,
	[IncludeInDashboardExport] [bit] NULL
) ON [PRIMARY]

GO
