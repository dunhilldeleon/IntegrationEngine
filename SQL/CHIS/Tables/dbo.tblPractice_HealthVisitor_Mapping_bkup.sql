SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tblPractice_HealthVisitor_Mapping_bkup](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PracticeCode] [varchar](9) COLLATE Latin1_General_CI_AS NOT NULL,
	[HV_Location_ID] [int] NULL,
	[HV_Name] [varchar](250) COLLATE Latin1_General_CI_AS NULL,
	[HV_email] [varchar](100) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]

GO
