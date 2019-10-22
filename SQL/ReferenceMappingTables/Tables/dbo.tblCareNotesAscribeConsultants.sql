SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tblCareNotesAscribeConsultants](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GMCCode] [varchar](10) COLLATE Latin1_General_CI_AS NULL,
	[Alias] [varchar](10) COLLATE Latin1_General_CI_AS NULL,
	[Forename] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Surname] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Name] [varchar](100) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]

GO
