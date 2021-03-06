SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tblHL70063Relationship](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](3) COLLATE Latin1_General_CI_AS NULL,
	[Description] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[PicklistID] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[SourceSystem] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[TableName] [varchar](100) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]

GO
