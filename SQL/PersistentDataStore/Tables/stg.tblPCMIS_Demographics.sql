SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [stg].[tblPCMIS_Demographics](
	[Patient_ID] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[CaseNumber] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[CaseStart_Dttm] [datetime] NULL,
	[Forename] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[MiddleName] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Surname] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Patient_Name] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Title] [varchar](15) COLLATE Latin1_General_CI_AS NULL,
	[Date_Of_Birth] [datetime] NULL,
	[NHS_Number] [varchar](11) COLLATE Latin1_General_CI_AS NOT NULL,
	[Gender_ID] [int] NULL,
	[Address1] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address2] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address3] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address4] [varchar](512) COLLATE Latin1_General_CI_AS NULL,
	[Postcode] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[AddressType] [int] NULL,
	[DateOfDeath] [datetime] NULL,
	[PracticeCode] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[MainLanguage] [varchar](5) COLLATE Latin1_General_CI_AS NULL,
	[MaritalStatus] [varchar](2) COLLATE Latin1_General_CI_AS NULL,
	[Ethnicity] [varchar](2) COLLATE Latin1_General_CI_AS NULL,
	[Religion] [varchar](2) COLLATE Latin1_General_CI_AS NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedDate] [datetime] NULL,
	[ValidNHSNumber] [varchar](1) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]

GO
