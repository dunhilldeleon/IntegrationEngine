SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[CNS_tblAlert](
	[Alert_ID] [int] NOT NULL,
	[Patient_ID] [int] NULL,
	[Start_Date] [datetime] NULL,
	[Start_Time] [varchar](5) COLLATE Latin1_General_CI_AS NULL,
	[Start_Authorised_By_Staff_ID] [int] NULL,
	[Review_Date] [datetime] NULL,
	[Responsibility_Of_Staff_ID] [int] NULL,
	[End_Date] [datetime] NULL,
	[End_Time] [varchar](5) COLLATE Latin1_General_CI_AS NULL,
	[End_Authorised_By_Staff_ID] [int] NULL,
	[Alert_Type_ID] [int] NULL,
	[Alert_Description] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Alert_Comment] [text] COLLATE Latin1_General_CI_AS NULL,
	[User_Created] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Create_Dttm] [datetime] NULL,
	[User_Updated] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Updated_Dttm] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
