SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [HIE_CNS].[tblCNS_Contacts](
	[ContactID] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[PatientID] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[UpdatedDate] [varchar](23) COLLATE Latin1_General_CI_AS NULL,
	[Rank] [varchar](3) COLLATE Latin1_General_CI_AS NOT NULL,
	[ContactType] [varchar](80) COLLATE Latin1_General_CI_AS NOT NULL,
	[Relation] [varchar](35) COLLATE Latin1_General_CI_AS NULL,
	[Title] [varchar](15) COLLATE Latin1_General_CI_AS NULL,
	[Surname] [varchar](35) COLLATE Latin1_General_CI_AS NOT NULL,
	[GivenName] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[AddressLine1] [varchar](35) COLLATE Latin1_General_CI_AS NULL,
	[AddressLine2] [varchar](35) COLLATE Latin1_General_CI_AS NULL,
	[AddressLine3] [varchar](35) COLLATE Latin1_General_CI_AS NULL,
	[AddressLine4] [varchar](35) COLLATE Latin1_General_CI_AS NULL,
	[AddressLine5] [varchar](35) COLLATE Latin1_General_CI_AS NULL,
	[PostCode] [varchar](25) COLLATE Latin1_General_CI_AS NULL,
	[Country] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[MainPhone] [varchar](45) COLLATE Latin1_General_CI_AS NULL,
	[OtherPhone] [varchar](45) COLLATE Latin1_General_CI_AS NULL,
	[MobilePhone] [varchar](45) COLLATE Latin1_General_CI_AS NULL,
	[Email] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[PreferredContactMethod] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Deleted] [int] NULL,
	[ContainsInvalidChar] [bit] NULL,
	[LoadID] [int] NULL
) ON [PRIMARY]

GO
