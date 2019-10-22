SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [HIE_CNS].[tblCNS_Notes](
	[SpecialNotesID] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[PatientID] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[UpdatedDate] [varchar](23) COLLATE Latin1_General_CI_AS NULL,
	[Order] [varchar](10) COLLATE Latin1_General_CI_AS NULL,
	[CreateTime] [varchar](23) COLLATE Latin1_General_CI_AS NULL,
	[Notes] [varchar](5000) COLLATE Latin1_General_CI_AS NULL,
	[Deleted] [int] NULL,
	[ContainsInvalidChar] [bit] NULL,
	[LoadID] [int] NULL
) ON [PRIMARY]

GO
