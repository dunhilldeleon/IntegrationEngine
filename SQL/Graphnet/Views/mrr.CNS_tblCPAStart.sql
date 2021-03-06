SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE VIEW [mrr].[CNS_tblCPAStart] AS SELECT [CPA_Start_ID], [Patient_ID], [Start_Date], [Authorised_By_Staff_ID], [CPA_Tier_ID], [SW_Involved_ID], [Day_Centre_Involved_ID], [Sheltered_Work_Involved_ID], [Non_NHS_Res_Accom_ID], [Domicil_Care_Involved_ID], [CPA_Employment_Status_ID], [CPA_Weekly_Hours_Worked_ID], [CPA_Accomodation_Status_ID], [CPA_Settled_Accomodation_Indicator_ID], [Receiving_Direct_Payments_ID], [Individual_Budget_Agreed_ID], [Other_Financial_Considerations_ID], [Accommodation_Status_Date], [Employment_Status_Date], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Active_Period_End], [Smoking_Status_ID] FROM [Mirror].[mrr_tbl].[CNS_tblCPAStart];

GO
