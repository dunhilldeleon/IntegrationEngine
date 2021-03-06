SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [HIE_CNC].[tblCNC_Demographics](
	[PatientNo] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[UpdatedDate] [varchar](23) COLLATE Latin1_General_CI_AS NULL,
	[NHSNo] [varchar](30) COLLATE Latin1_General_CI_AS NULL,
	[Title] [varchar](15) COLLATE Latin1_General_CI_AS NOT NULL,
	[Surname] [varchar](50) COLLATE Latin1_General_CI_AS NOT NULL,
	[Forenames] [varchar](50) COLLATE Latin1_General_CI_AS NOT NULL,
	[MaritalStatus] [char](1) COLLATE Latin1_General_CI_AS NOT NULL,
	[Sex] [char](1) COLLATE Latin1_General_CI_AS NOT NULL,
	[DOB] [varchar](23) COLLATE Latin1_General_CI_AS NULL,
	[Address1] [varchar](35) COLLATE Latin1_General_CI_AS NULL,
	[Address2] [varchar](35) COLLATE Latin1_General_CI_AS NULL,
	[Address3] [varchar](35) COLLATE Latin1_General_CI_AS NULL,
	[Address4] [varchar](35) COLLATE Latin1_General_CI_AS NULL,
	[Address5] [varchar](35) COLLATE Latin1_General_CI_AS NULL,
	[PostCode] [varchar](35) COLLATE Latin1_General_CI_AS NULL,
	[HomeTelephone] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[WorkTelephone] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[MobileTelephone] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Email] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[DeathDate] [varchar](23) COLLATE Latin1_General_CI_AS NULL,
	[Deceased] [bit] NULL,
	[GPCode] [varchar](8) COLLATE Latin1_General_CI_AS NULL,
	[GPPracticeCode] [varchar](6) COLLATE Latin1_General_CI_AS NULL,
	[Religion] [varchar](4) COLLATE Latin1_General_CI_AS NULL,
	[EthnicOrigin] [varchar](2) COLLATE Latin1_General_CI_AS NULL,
	[SpokenLanguage] [varchar](250) COLLATE Latin1_General_CI_AS NULL,
	[ContainsInvalidChar] [bit] NULL,
	[LoadID] [int] NULL
) ON [PRIMARY]

GO
