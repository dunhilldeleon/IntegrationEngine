SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [hl7].[tblPatientVisit](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[PV_ID] [varchar](50) COLLATE Latin1_General_CI_AS NOT NULL,
	[MPI_ID] [bigint] NOT NULL,
	[Ward_Stay_ID] [int] NULL,
	[Patient_ID] [int] NULL,
	[Patient_Class] [nvarchar](1) COLLATE Latin1_General_CI_AS NOT NULL,
	[Ward_LocationID] [nvarchar](10) COLLATE Latin1_General_CI_AS NULL,
	[Admission_Type] [nvarchar](1) COLLATE Latin1_General_CI_AS NULL,
	[Consulting_GMC_Code] [nvarchar](20) COLLATE Latin1_General_CI_AS NULL,
	[Consulting_Surname] [nvarchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Consulting_Forename] [nvarchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Admit_Source] [nvarchar](1) COLLATE Latin1_General_CI_AS NULL,
	[Episode_ID] [varchar](15) COLLATE Latin1_General_CI_AS NULL,
	[Discharge_Method] [int] NULL,
	[Discharge_Destination_ID] [nvarchar](2) COLLATE Latin1_General_CI_AS NULL,
	[PV_Start] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[PV_End] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[Event_Type] [varchar](3) COLLATE Latin1_General_CI_AS NULL,
	[Wardstay_Updated_Dttm] [datetime] NULL,
	[SourceSystem] [varchar](10) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]

GO
