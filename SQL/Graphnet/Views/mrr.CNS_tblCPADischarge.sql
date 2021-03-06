SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE VIEW [mrr].[CNS_tblCPADischarge] AS SELECT [CPA_Discharge_ID], [Patient_ID], [CPA_Start_ID], [CPA_Review_ID], [CPA_Discharge_Date], [CPA_Discharge_Time], [CPA_Discharge_Dttm], [Authorised_By_Staff_ID], [CPA_Discharge_Type_ID], [Moved_To], [Contact_Info], [Responsibility_Of], [SW_Involved_ID], [Day_Centre_Involved_ID], [Sheltered_Work_Involved_ID], [Non_NHS_Res_Accom_ID], [Domicil_Care_Involved_ID], [CPA_Employment_Status_ID], [CPA_Weekly_Hours_Worked_ID], [CPA_Accomodation_Status_ID], [CPA_Settled_Accomodation_Indicator_ID], [Receiving_Direct_Payments_ID], [Individual_Budget_Agreed_ID], [Other_Financial_Considerations_ID], [Comments], [Accommodation_Status_Date], [Employment_Status_Date], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Active_Period_End] FROM [Mirror].[mrr_tbl].[CNS_tblCPADischarge];

GO
