SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[CNS_tblGP](
	[GP_ID] [int] NOT NULL,
	[GP_Code] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[First_Name] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Last_Name] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Admitting_GP_Flag_ID] [int] NULL,
	[Active_ID] [int] NULL,
	[Locally_Managed_ID] [int] NULL,
	[FHSA_Code] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[Email_Address] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Enable_Email_ID] [int] NULL,
	[Comments] [text] COLLATE Latin1_General_CI_AS NULL,
	[User_Created] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Create_Dttm] [datetime] NULL,
	[User_Updated] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Updated_Dttm] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
