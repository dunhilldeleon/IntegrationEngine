SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[CNC_tblSchool](
	[School_ID] [int] NOT NULL,
	[Active_ID] [int] NULL,
	[School_Name] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address1] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address2] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address3] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address4] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address5] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Post_Code] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Telephone] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Fax] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Email_Address] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Web_Site] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Head_Teacher_Name] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Administrative_Contact_Name] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[SENCO_Name] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Education_Psychologist_Staff_ID] [int] NULL,
	[National_School_Code] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[School_Category_ID] [int] NULL,
	[User_Created] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Create_Dttm] [datetime] NULL,
	[User_Updated] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Updated_Dttm] [datetime] NOT NULL
) ON [PRIMARY]

GO
