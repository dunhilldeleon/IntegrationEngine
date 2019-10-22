SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [HIE_CNS].[tblCNS_MentalHealthAct](
	[MHAID] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[PatientID] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[UpdatedDate] [varchar](23) COLLATE Latin1_General_CI_AS NOT NULL,
	[MHASection] [text] COLLATE Latin1_General_CI_AS NOT NULL,
	[SectionStartDate] [varchar](23) COLLATE Latin1_General_CI_AS NOT NULL,
	[SectionEndDate] [varchar](23) COLLATE Latin1_General_CI_AS NULL,
	[LeaveStartDate] [varchar](23) COLLATE Latin1_General_CI_AS NULL,
	[LeaveEndDate] [varchar](23) COLLATE Latin1_General_CI_AS NULL,
	[LeaveStatus] [varchar](5) COLLATE Latin1_General_CI_AS NULL,
	[Deleted] [int] NULL,
	[ContainsInvalidChar] [bit] NOT NULL,
	[LoadID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
