SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [ORU_SRC].[tblORU_NTE_Notes](
	[Message_ID] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[OBR_ID] [varchar](4) COLLATE Latin1_General_CI_AS NULL,
	[OBX_ID] [varchar](4) COLLATE Latin1_General_CI_AS NULL,
	[NTE_ID] [varchar](4) COLLATE Latin1_General_CI_AS NULL,
	[Source_of_Comment] [varchar](8) COLLATE Latin1_General_CI_AS NULL,
	[Comment] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[Load_Dttm] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
