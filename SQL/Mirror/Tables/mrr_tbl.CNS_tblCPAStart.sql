SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[CNS_tblCPAStart](
	[CPA_Start_ID] [int] NOT NULL,
	[Patient_ID] [int] NULL,
	[Start_Date] [datetime] NULL,
	[Authorised_By_Staff_ID] [int] NULL,
	[CPA_Tier_ID] [int] NULL,
	[SW_Involved_ID] [int] NULL,
	[Day_Centre_Involved_ID] [int] NULL,
	[Sheltered_Work_Involved_ID] [int] NULL,
	[Non_NHS_Res_Accom_ID] [int] NULL,
	[Domicil_Care_Involved_ID] [int] NULL,
	[CPA_Employment_Status_ID] [int] NULL,
	[CPA_Weekly_Hours_Worked_ID] [int] NULL,
	[CPA_Accomodation_Status_ID] [int] NULL,
	[CPA_Settled_Accomodation_Indicator_ID] [int] NULL,
	[Receiving_Direct_Payments_ID] [int] NULL,
	[Individual_Budget_Agreed_ID] [int] NULL,
	[Other_Financial_Considerations_ID] [int] NULL,
	[Accommodation_Status_Date] [datetime] NULL,
	[Employment_Status_Date] [datetime] NULL,
	[User_Created] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Create_Dttm] [datetime] NULL,
	[User_Updated] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Updated_Dttm] [datetime] NOT NULL,
	[Active_Period_End] [datetime] NULL,
	[Smoking_Status_ID] [int] NULL
) ON [PRIMARY]

GO
