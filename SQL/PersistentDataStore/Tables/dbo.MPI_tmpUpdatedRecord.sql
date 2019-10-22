SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[MPI_tmpUpdatedRecord](
	[NHS_Number] [varchar](11) COLLATE Latin1_General_CI_AS NULL,
	[UpdatedDate] [datetime] NULL,
	[source] [varchar](5) COLLATE Latin1_General_CI_AS NOT NULL,
	[CreatedDate] [datetime] NULL,
	[rn] [bigint] NULL
) ON [PRIMARY]

GO
