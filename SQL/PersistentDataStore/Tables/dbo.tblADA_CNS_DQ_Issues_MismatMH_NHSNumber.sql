SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tblADA_CNS_DQ_Issues_MismatMH_NHSNumber](
	[Matching_ID] [varchar](40) COLLATE Latin1_General_CI_AS NULL,
	[MH_Patient_ID] [int] NOT NULL,
	[MH_Forename] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[MH_Surname] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[MH_DOB] [datetime] NULL,
	[MH_NHS_Number] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[MH_postcode] [varchar](8000) COLLATE Latin1_General_CI_AS NOT NULL,
	[MH_Address1] [varchar](8000) COLLATE Latin1_General_CI_AS NOT NULL,
	[MH_Tel_Home] [varchar](8000) COLLATE Latin1_General_CI_AS NOT NULL,
	[MH_Tel_Mobile] [varchar](8000) COLLATE Latin1_General_CI_AS NOT NULL,
	[MH_Tel_Work] [varchar](8000) COLLATE Latin1_General_CI_AS NOT NULL,
	[ada_Patient_ID] [uniqueidentifier] NULL,
	[ada_Forename] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ada_Surname] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ada_DOB] [datetime] NULL,
	[ada_NHS_Number] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ada_Address] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ada_Postcode] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ada_HomePhone] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ada_Mobile] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Tel_Other] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HomePhone_Matching] [varchar](8) COLLATE Latin1_General_CI_AS NOT NULL,
	[MobilePhone_Matching] [varchar](8) COLLATE Latin1_General_CI_AS NOT NULL,
	[WorkPhone_Matching] [varchar](8) COLLATE Latin1_General_CI_AS NOT NULL,
	[Address_Matching] [varchar](8) COLLATE Latin1_General_CI_AS NOT NULL,
	[PostCode_Matching] [varchar](8) COLLATE Latin1_General_CI_AS NOT NULL
) ON [PRIMARY]

GO
