SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tblPDS_TableTracker](
	[TABLE_NAME] [nvarchar](128) COLLATE Latin1_General_CI_AS NOT NULL,
	[ExtractDate] [datetime] NOT NULL,
	[MaxUpdateTime] [datetime] NULL,
	[LoadID] [int] NOT NULL
) ON [PRIMARY]

GO
