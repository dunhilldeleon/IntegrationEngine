SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE VIEW [mrr].[CNC_tblAppointmentOutcomeValues] AS SELECT [Appointment_Outcome_ID], [Appointment_Outcome_Desc], [Active], [Default_Flag], [External_Code1], [External_Code2], [Display_Order], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm] FROM [Mirror].[mrr_tbl].[CNC_tblAppointmentOutcomeValues];

GO
