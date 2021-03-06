SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[ADA_Patient](
	[PatientRef] [uniqueidentifier] NOT NULL,
	[AddressRef] [uniqueidentifier] NULL,
	[Forename] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Surname] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SurnamePrefix] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MaidenPrefix] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Maiden] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Initials] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DOB] [datetime] NULL,
	[HomePhone] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MobilePhone] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OtherPhone] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Sex] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AgeOnly] [bit] NULL,
	[NationalCode] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Obsolete] [bit] NULL,
	[LastEditByUserRef] [uniqueidentifier] NULL,
	[EditDate] [datetime] NULL,
	[EthnicityRef] [uniqueidentifier] NULL,
	[HumanLanguageRef] [uniqueidentifier] NULL,
	[LocalLanguageSpoken] [bit] NULL,
	[NationalityRef] [uniqueidentifier] NULL,
	[NationalCodeSource] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmailAddress] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OtherPhoneExtn] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ExcludeFromPSQ] [bit] NULL,
	[LastCaseDate] [datetime] NULL,
	[IsTwin] [bit] NULL,
	[DemographicsSensitive] [bit] NULL,
	[NationalCodeSourceDatabase] [char](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NationalCodeEditDate] [datetime] NULL,
	[NationalCodeEditByUserRef] [uniqueidentifier] NULL,
	[LocalID] [int] NULL,
	[NationalCodeExtraInfo] [varchar](512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HomePhonePrefix] [varchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AllergyStatusCode] [bigint] NULL,
	[ConditionStatusCode] [bigint] NULL,
	[MedicationStatusCode] [bigint] NULL,
	[LatestModificationDate] [bigint] NULL
) ON [PRIMARY]

GO
