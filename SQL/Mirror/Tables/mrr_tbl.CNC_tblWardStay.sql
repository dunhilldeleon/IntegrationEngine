SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[CNC_tblWardStay](
	[Ward_Stay_ID] [int] NOT NULL,
	[Patient_ID] [int] NULL,
	[Location_ID] [int] NULL,
	[Admission_Type_ID] [int] NULL,
	[Bed_Number_ID] [int] NULL,
	[Ward_Stay_Observation_ID] [int] NULL,
	[Planned_Start_Date] [datetime] NULL,
	[Planned_Start_Time] [varchar](5) COLLATE Latin1_General_CI_AS NULL,
	[Planned_Start_Dttm] [datetime] NULL,
	[Planned_End_Date] [datetime] NULL,
	[Planned_End_Time] [varchar](5) COLLATE Latin1_General_CI_AS NULL,
	[Planned_End_Dttm] [datetime] NULL,
	[Current_Status] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Current_Ward_Stay_Status_ID] [int] NULL,
	[Actual_Start_Date] [datetime] NULL,
	[Actual_Start_Time] [varchar](5) COLLATE Latin1_General_CI_AS NULL,
	[Actual_Start_Dttm] [datetime] NULL,
	[Actual_End_Date] [datetime] NULL,
	[Actual_End_Time] [varchar](5) COLLATE Latin1_General_CI_AS NULL,
	[Actual_End_Dttm] [datetime] NULL,
	[Infection_Control_Issues_ID] [int] NULL,
	[User_Created] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Create_Dttm] [datetime] NULL,
	[User_Updated] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Updated_Dttm] [datetime] NOT NULL,
	[Hospital_Bed_Type_ID] [int] NULL
) ON [PRIMARY]

GO
