SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[CNC_tblGenderValues](
	[Gender_ID] [int] NOT NULL,
	[Gender_Desc] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Active] [int] NULL,
	[Default_Flag] [int] NULL,
	[External_Code1] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[External_Code2] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[Display_Order] [int] NULL,
	[User_Created] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Create_Dttm] [datetime] NULL,
	[User_Updated] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Updated_Dttm] [datetime] NOT NULL
) ON [PRIMARY]

GO
