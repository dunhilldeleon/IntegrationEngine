SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [hl7].[Demographic](
	[MPI_ID] [bigint] NOT NULL,
	[Forename] [nvarchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Surname] [nvarchar](50) COLLATE Latin1_General_CI_AS NOT NULL,
	[Title] [nvarchar](20) COLLATE Latin1_General_CI_AS NULL,
	[DateOfBirth] [bigint] NULL,
	[NHSNumber] [nvarchar](11) COLLATE Latin1_General_CI_AS NOT NULL,
	[Gender] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Address1] [nvarchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address2] [nvarchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address3] [nvarchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address4] [nvarchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address5] [nvarchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Postcode] [nvarchar](50) COLLATE Latin1_General_CI_AS NULL,
	[AddressType] [char](3) COLLATE Latin1_General_CI_AS NULL,
	[DateOfDeath] [bigint] NULL,
	[PracticeName] [nvarchar](255) COLLATE Latin1_General_CI_AS NULL,
	[PracticeCode] [nvarchar](20) COLLATE Latin1_General_CI_AS NULL,
	[GPCode] [nvarchar](20) COLLATE Latin1_General_CI_AS NULL,
	[GPName] [nvarchar](250) COLLATE Latin1_General_CI_AS NULL,
	[GPPrefix] [nvarchar](20) COLLATE Latin1_General_CI_AS NULL,
	[PrimaryLanguage] [nvarchar](50) COLLATE Latin1_General_CI_AS NULL,
	[MaritalStatus] [nvarchar](50) COLLATE Latin1_General_CI_AS NULL,
	[EthnicGroup] [nvarchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Religion] [nvarchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Email] [nvarchar](255) COLLATE Latin1_General_CI_AS NULL,
	[CreatedDttm] [datetime2](7) NULL,
	[UpdatedDttm] [datetime2](7) NULL,
	[UpdatedEventCode] [nvarchar](3) COLLATE Latin1_General_CI_AS NULL,
	[UpdatedSourcesystem] [nvarchar](5) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]

GO
