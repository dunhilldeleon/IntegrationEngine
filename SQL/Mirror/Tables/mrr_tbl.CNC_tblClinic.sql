SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[CNC_tblClinic](
	[Clinic_ID] [int] NOT NULL,
	[Clinic_Name] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Administrator_Staff_ID] [int] NULL,
	[Clinic_Location_ID] [int] NULL,
	[Clinic_Type_ID] [int] NULL,
	[Active_Flag_ID] [int] NULL,
	[External_Code1] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[External_Code2] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[Allow_First_Appointments_Flag_ID] [int] NULL,
	[Start_Time] [varchar](5) COLLATE Latin1_General_CI_AS NULL,
	[End_Time] [varchar](5) COLLATE Latin1_General_CI_AS NULL,
	[Clinic_Schedule_Type_ID] [int] NULL,
	[Number_Of_Weeks] [int] NULL,
	[Clinic_Period_Start_Date] [datetime] NULL,
	[Clinic_Period_End_Date] [datetime] NULL,
	[Slot_Size_Minutes] [int] NULL,
	[SMS_Appointment_Reminders_Flag_ID] [int] NULL,
	[SMS_Message_Tail] [text] COLLATE Latin1_General_CI_AS NULL,
	[User_Created] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Create_Dttm] [datetime] NULL,
	[User_Updated] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Updated_Dttm] [datetime] NOT NULL,
	[Colour_Code] [int] NULL,
	[Clinic_Group_ID] [int] NULL,
	[Referral_Required_Flag_ID] [int] NULL,
	[Multi_Patient_Required_Flag_ID] [int] NULL,
	[Auto_Generate_Overbook_Slots_ID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
