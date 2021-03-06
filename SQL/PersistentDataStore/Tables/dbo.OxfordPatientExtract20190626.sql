SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[OxfordPatientExtract20190626](
	[entityid] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[CaseNumber] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[NHSNumber] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Patient Name] [varchar](150) COLLATE Latin1_General_CI_AS NULL,
	[Address] [varchar](150) COLLATE Latin1_General_CI_AS NULL,
	[PostCode] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Telephone] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[PASNHSNumber] [varchar](10) COLLATE Latin1_General_CI_AS NULL,
	[MatchingOn] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Comments] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[UpdateDate] [datetime] NULL
) ON [PRIMARY]

GO
