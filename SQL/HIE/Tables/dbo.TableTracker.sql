SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TableTracker](
	[SourceSystem] [nvarchar](10) COLLATE Latin1_General_CI_AS NOT NULL,
	[TABLE_NAME] [nvarchar](128) COLLATE Latin1_General_CI_AS NOT NULL,
	[ExtractDate] [datetime] NOT NULL,
	[MaxUpdateTime] [datetime] NULL,
	[LoadID] [int] NOT NULL,
	[No_Of_Records] [int] NULL
) ON [PRIMARY]

GO
