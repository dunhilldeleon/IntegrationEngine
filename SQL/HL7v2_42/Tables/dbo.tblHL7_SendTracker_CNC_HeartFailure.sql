SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tblHL7_SendTracker_CNC_HeartFailure](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[HeartFailureID] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[FailureReason] [varchar](1000) COLLATE Latin1_General_CI_AS NOT NULL,
	[SendDttm] [datetime] NULL
) ON [PRIMARY]

GO
