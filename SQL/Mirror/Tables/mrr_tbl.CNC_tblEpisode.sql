SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[CNC_tblEpisode](
	[Episode_ID] [int] NOT NULL,
	[Episode_Type_ID] [int] NULL,
	[Patient_ID] [int] NULL,
	[Referral_Date] [datetime] NULL,
	[Referral_Time] [varchar](5) COLLATE Latin1_General_CI_AS NULL,
	[Referral_Received_Date] [datetime] NULL,
	[Last_Contact_Date] [datetime] NULL,
	[Referral_Source_ID] [int] NULL,
	[Referral_Source_Type_ID] [int] NULL,
	[Agency_ID] [int] NULL,
	[Contact_Name] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Contact_Job_Title] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Contact_Telephone] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[GP_ID] [int] NULL,
	[Practice_ID] [int] NULL,
	[GP_Code] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[Practice_Code] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[School_ID] [int] NULL,
	[Contact_ID] [int] NULL,
	[Staff_ID] [int] NULL,
	[Episode_Priority_ID] [int] NULL,
	[Referral_Reason_ID] [int] NULL,
	[Presentation_Reason_ID] [int] NULL,
	[Referrer_Address1] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Referrer_Address2] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Referrer_Address3] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Referrer_Address4] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Referrer_Address5] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Referrer_Post_Code] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[Referrer_Telephone] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Referrer_Fax] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Referrer_Email] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Referrer_PCT_Code] [varchar](10) COLLATE Latin1_General_CI_AS NULL,
	[Referrer_PCT_Name] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Service_ID] [int] NULL,
	[Location_ID] [int] NULL,
	[Client_Normally_Seen_At_Location_ID] [int] NULL,
	[Referral_Format_ID] [int] NULL,
	[Referral_Status_ID] [int] NULL,
	[Referral_Admin_Status_ID] [int] NULL,
	[Referral_Administrative_Category_ID] [int] NULL,
	[Episode_Admin_Priority_ID] [int] NULL,
	[Accepted_Date] [datetime] NULL,
	[Accepted_By_Staff_ID] [int] NULL,
	[Accepted_By_Staff_Name] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Wait_Weeks] [int] NULL,
	[Open_Weeks] [int] NULL,
	[Start_Date] [datetime] NULL,
	[Accommodation_ID] [int] NULL,
	[Employment_ID] [int] NULL,
	[Administration_Comments] [text] COLLATE Latin1_General_CI_AS NULL,
	[Rejection_Date] [datetime] NULL,
	[Rejection_Reason_ID] [int] NULL,
	[Rejection_Detail] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Rejected_By_Staff_ID] [int] NULL,
	[Rejected_By_Staff_Name] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Discharge_Date] [datetime] NULL,
	[Discharge_Time] [varchar](5) COLLATE Latin1_General_CI_AS NULL,
	[Discharge_Method_Episode_ID] [int] NULL,
	[Discharge_Destination_ID] [int] NULL,
	[Healthcare_Resource_Group_ID] [int] NULL,
	[Discharge_Agreed_By_Staff_ID] [int] NULL,
	[Discharge_Agreed_By_Staff_Name] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Discharge_Detail] [text] COLLATE Latin1_General_CI_AS NULL,
	[Comments] [text] COLLATE Latin1_General_CI_AS NULL,
	[Transport_Required_ID] [int] NULL,
	[User_Created] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Create_Dttm] [datetime] NULL,
	[User_Updated] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Updated_Dttm] [datetime] NOT NULL,
	[Referrer_CCG_Code] [varchar](3) COLLATE Latin1_General_CI_AS NULL,
	[Referrer_CCG_Name] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Referral_Received_Time] [varchar](5) COLLATE Latin1_General_CI_AS NULL,
	[Agency_Staff_Category_ID] [int] NULL,
	[Staff_Professional_Group_ID] [int] NULL,
	[Discharge_Letter_Issued_Date] [datetime] NULL,
	[Referral_Closure_Reason_ID] [int] NULL,
	[NHS_Service_Agreement_Line_Number] [varchar](10) COLLATE Latin1_General_CI_AS NULL,
	[Reason_For_Out_Of_Area_Referral_ID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
