SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE VIEW [mrr].[CNC_tblAttendanceTypeValues] AS SELECT [Attendance_Type_ID], [Attendance_Type_Desc], [Appointment_Status_ID], [Active], [Default_Flag], [External_Code1], [External_Code2], [Display_Order], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Lock_For_iNurse], [Clinician_Mandatory_ID] FROM [Mirror].[mrr_tbl].[CNC_tblAttendanceTypeValues];

GO
