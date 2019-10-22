SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tblHL7_SendTracker_InterimDischargeSummary](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SourceSystem] [varchar](10) COLLATE Latin1_General_CI_AS NOT NULL,
	[IntegratedDocumentID] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[FailureReason] [varchar](1000) COLLATE Latin1_General_CI_AS NULL,
	[SendDttm] [datetime] NULL
) ON [PRIMARY]

GO
