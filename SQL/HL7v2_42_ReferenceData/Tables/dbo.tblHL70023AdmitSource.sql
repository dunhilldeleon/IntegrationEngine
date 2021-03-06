SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tblHL70023AdmitSource](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [int] NULL,
	[Description] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Active] [bit] NULL,
	[PicklistID] [int] NULL,
	[SourceSystem] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[TableName] [varchar](100) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]

GO
