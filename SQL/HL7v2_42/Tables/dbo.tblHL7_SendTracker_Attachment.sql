SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tblHL7_SendTracker_Attachment](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IntegratedDocumentID] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[Document_ID] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[Target_System_Doc_ID] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[SendDttm] [datetime] NULL,
	[SourceSystem] [varchar](5) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]

GO
