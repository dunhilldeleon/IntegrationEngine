SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [stg].[tblADA_Demographics](
	[Patient_ID] [uniqueidentifier] NOT NULL,
	[LocalID] [bigint] NULL,
	[Forename] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Surname] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Date_Of_Birth] [datetime] NULL,
	[NHS_Number] [varchar](11) COLLATE Latin1_General_CI_AS NULL,
	[Gender] [varchar](1) COLLATE Latin1_General_CI_AS NULL,
	[Address1] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address2] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address3] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address4] [varchar](512) COLLATE Latin1_General_CI_AS NULL,
	[Postcode] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[AddressType] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[Practice_Code] [varchar](10) COLLATE Latin1_General_CI_AS NULL,
	[Date_Of_Death] [datetime] NULL,
	[PrimaryLanguage] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[EthnicGroup] [varchar](5) COLLATE Latin1_General_CI_AS NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedDate] [datetime] NULL,
	[ValidNHSNumber] [varchar](1) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]

GO
