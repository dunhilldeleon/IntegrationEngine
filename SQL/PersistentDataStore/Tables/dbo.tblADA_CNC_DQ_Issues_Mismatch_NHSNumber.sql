SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tblADA_CNC_DQ_Issues_Mismatch_NHSNumber](
	[Matching_ID] [varchar](40) COLLATE Latin1_General_CI_AS NULL,
	[CH_Patient_ID] [int] NOT NULL,
	[CH_Forename] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[CH_Surname] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[CH_DOB] [datetime] NULL,
	[CH_NHS_Number] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[CH_postcode] [varchar](8000) COLLATE Latin1_General_CI_AS NOT NULL,
	[CH_Address1] [varchar](8000) COLLATE Latin1_General_CI_AS NOT NULL,
	[CH_Tel_Home] [varchar](8000) COLLATE Latin1_General_CI_AS NOT NULL,
	[CH_Tel_Mobile] [varchar](8000) COLLATE Latin1_General_CI_AS NOT NULL,
	[CH_Tel_Work] [varchar](8000) COLLATE Latin1_General_CI_AS NOT NULL,
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
