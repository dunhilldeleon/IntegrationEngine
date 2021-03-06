SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[ADA_Ethnicity](
	[EthnicityRef] [uniqueidentifier] NOT NULL,
	[Name] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Code] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Sort] [int] NULL,
	[Obsolete] [bit] NULL,
	[CategoryCode] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]

GO
