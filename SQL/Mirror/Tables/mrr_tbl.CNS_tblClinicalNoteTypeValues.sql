SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[CNS_tblClinicalNoteTypeValues](
	[Clinical_Note_Type_ID] [int] NOT NULL,
	[Clinical_Note_Type_Desc] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Active] [int] NULL,
	[Default_Flag] [int] NULL,
	[External_Code1] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[External_Code2] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[Display_Order] [int] NULL,
	[User_Created] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Create_Dttm] [datetime] NULL,
	[User_Updated] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Updated_Dttm] [datetime] NOT NULL
) ON [PRIMARY]

GO
