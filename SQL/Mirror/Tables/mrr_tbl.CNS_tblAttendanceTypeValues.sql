SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[CNS_tblAttendanceTypeValues](
	[Attendance_Type_ID] [int] NOT NULL,
	[Attendance_Type_Desc] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Appointment_Status_ID] [int] NULL,
	[Active] [int] NULL,
	[Default_Flag] [int] NULL,
	[External_Code1] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[External_Code2] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[Display_Order] [int] NULL,
	[User_Created] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Create_Dttm] [datetime] NULL,
	[User_Updated] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Updated_Dttm] [datetime] NOT NULL,
	[Lock_For_iNurse] [varchar](1) COLLATE Latin1_General_CI_AS NULL,
	[Clinician_Mandatory_ID] [int] NULL
) ON [PRIMARY]

GO
