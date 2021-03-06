SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [HIE_CNC].[tblCNC_Appointments](
	[Appointment_ID] [int] NOT NULL,
	[Patient_ID] [int] NULL,
	[Appointment_DateTime] [datetime] NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[Clinic_Community_Indicator] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[Appointment Type] [varchar](55) COLLATE Latin1_General_CI_AS NULL,
	[Location] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[HCPName] [nvarchar](200) COLLATE Latin1_General_CI_AS NULL,
	[Face_to_Face_Indicator] [varchar](10) COLLATE Latin1_General_CI_AS NULL,
	[Deleted] [int] NOT NULL,
	[ContainsInvalidChar] [bit] NULL,
	[LoadID] [int] NULL
) ON [PRIMARY]

GO
