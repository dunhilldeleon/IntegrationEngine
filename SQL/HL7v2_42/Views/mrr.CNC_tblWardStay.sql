SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


CREATE VIEW  [mrr].[CNC_tblWardStay] AS SELECT [Ward_Stay_ID], [Patient_ID], [Location_ID], [Admission_Type_ID], [Bed_Number_ID], [Ward_Stay_Observation_ID], [Planned_Start_Date], [Planned_Start_Time], [Planned_Start_Dttm], [Planned_End_Date], [Planned_End_Time], [Planned_End_Dttm], [Current_Status], [Current_Ward_Stay_Status_ID], [Actual_Start_Date], [Actual_Start_Time], [Actual_Start_Dttm], [Actual_End_Date], [Actual_End_Time], [Actual_End_Dttm], [Infection_Control_Issues_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Hospital_Bed_Type_ID] FROM [Mirror].[mrr_tbl].[CNC_tblWardStay];

GO
