SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ZZZtmpCNSNULLNHSnumber](
	[Patient_ID] [int] NOT NULL,
	[NHS_Number] [varchar](11) COLLATE Latin1_General_CI_AS NULL,
	[Source] [varchar](5) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]

GO
