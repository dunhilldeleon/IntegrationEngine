SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [HIE_CNC].[tblCNC_School_Immunisation](
	[NHSNumber] [varchar](11) COLLATE Latin1_General_CI_AS NULL,
	[Surname] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Forename] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[DateOfBirth] [date] NULL,
	[Gender] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[DateAttended] [date] NULL,
	[Venue] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[VaccineName] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Site] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[BatchNumber] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[LoadID] [int] NULL
) ON [PRIMARY]

GO
