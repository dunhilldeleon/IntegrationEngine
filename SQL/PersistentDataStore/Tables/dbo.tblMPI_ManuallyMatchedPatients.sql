SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tblMPI_ManuallyMatchedPatients](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SourceSystem] [varchar](10) COLLATE Latin1_General_CI_AS NULL,
	[Patient_ID1] [varchar](40) COLLATE Latin1_General_CI_AS NULL,
	[Patient_ID2] [varchar](40) COLLATE Latin1_General_CI_AS NULL,
	[MatchResult] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[MatchedBy] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Entered_Dttm] [datetime] NULL,
	[Comments] [varchar](4000) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]

GO
