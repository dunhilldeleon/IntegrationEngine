SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CNS_tblInscopeAttachments](
	[Attachment_ID] [int] NOT NULL,
	[Attachment_File_ID] [int] NULL,
	[SourceSystem] [varchar](3) COLLATE Latin1_General_CI_AS NOT NULL,
	[Patient_ID] [int] NULL,
	[Practice_Code] [varchar](20) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]

GO
