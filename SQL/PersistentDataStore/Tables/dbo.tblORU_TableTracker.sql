SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tblORU_TableTracker](
	[TABLE_NAME] [nvarchar](128) COLLATE Latin1_General_CI_AS NOT NULL,
	[ExtractDate] [datetime] NOT NULL,
	[MaxUpdateTime] [datetime] NOT NULL
) ON [PRIMARY]

GO
