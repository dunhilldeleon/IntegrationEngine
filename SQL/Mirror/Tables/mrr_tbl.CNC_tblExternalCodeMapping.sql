SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[CNC_tblExternalCodeMapping](
	[External_Code_Mapping_Data_Source_ID] [int] NOT NULL,
	[Internal_Data_Key] [int] NOT NULL,
	[External_Code] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[User_Created] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Create_Dttm] [datetime] NULL,
	[User_Updated] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Updated_Dttm] [datetime] NOT NULL
) ON [PRIMARY]

GO
