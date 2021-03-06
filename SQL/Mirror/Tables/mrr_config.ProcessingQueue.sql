SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_config].[ProcessingQueue](
	[QueueID] [bigint] IDENTITY(1,1) NOT NULL,
	[QueueType] [nvarchar](128) COLLATE Latin1_General_CI_AS NULL,
	[Item] [nvarchar](128) COLLATE Latin1_General_CI_AS NULL,
	[ItemStatus] [nvarchar](10) COLLATE Latin1_General_CI_AS NOT NULL,
	[ItemStatusChangeDate] [datetime2](7) NOT NULL,
	[StreamName] [nvarchar](128) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]

GO
