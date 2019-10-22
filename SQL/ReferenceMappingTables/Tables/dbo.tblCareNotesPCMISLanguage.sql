SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tblCareNotesPCMISLanguage](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PCMIS_Language_ID] [varchar](4) COLLATE Latin1_General_CI_AS NULL,
	[PCMIS_Language] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[CareNotes_Language_ID] [int] NULL,
	[External_Code2] [varchar](5) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]

GO
