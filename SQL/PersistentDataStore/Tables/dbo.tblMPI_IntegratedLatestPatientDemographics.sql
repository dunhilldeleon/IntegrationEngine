SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tblMPI_IntegratedLatestPatientDemographics](
	[Source_PatientID] [varchar](50) COLLATE Latin1_General_CI_AS NOT NULL,
	[NHS_Number] [varchar](11) COLLATE Latin1_General_CI_AS NOT NULL,
	[UpdatedDate] [datetime] NULL,
	[source] [varchar](5) COLLATE Latin1_General_CI_AS NOT NULL,
	[CreatedDate] [datetime] NULL,
	[rn] [bigint] NULL
) ON [PRIMARY]

GO
