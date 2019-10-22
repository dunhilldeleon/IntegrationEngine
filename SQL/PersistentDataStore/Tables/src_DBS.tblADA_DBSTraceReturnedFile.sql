SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [src_DBS].[tblADA_DBSTraceReturnedFile](
	[RecordType] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[LocalPID] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[NoMultipleMatches] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[TraceNHS] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[DOB] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[DoD] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[OldNHSNumber] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[NewNHSNumber] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Surname] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[AltSurname] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Forename] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[AltForename] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Sex] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Address1] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address2] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address3] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address4] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address5] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Postcode] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[PrevAddress1] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[PrevAddress2] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[PrevAddress3] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[PrevAddress4] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[PrevAddress5] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[PrevPostcode] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[GP] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[GPPract] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[PrevGP] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[PrevGPPract] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[ReturnedDOB] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[DateReturnedDateLastModified] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[DeadIndicator] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[DateCRLastModified] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[ReturnDateOfPosting] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[DatePostLastUpdated] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[ReturnSurname] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[DM1] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[ReturnedForename] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[DM2] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[ReturnaltSurname] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[DM3] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[ReturnOtherForename] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[DM4] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[ReturnedSex] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Match_ID] [varchar](50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]

GO
