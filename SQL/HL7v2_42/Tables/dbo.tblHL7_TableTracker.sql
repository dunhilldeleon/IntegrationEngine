SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tblHL7_TableTracker](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SourceSystem] [varchar](5) COLLATE Latin1_General_CI_AS NOT NULL,
	[TABLE_NAME] [nvarchar](128) COLLATE Latin1_General_CI_AS NOT NULL,
	[ExtractDate] [datetime] NOT NULL,
	[MaxUpdateTime] [datetime] NULL,
	[LoadID] [int] NOT NULL,
	[NoRecords] [int] NULL
) ON [PRIMARY]

GO
