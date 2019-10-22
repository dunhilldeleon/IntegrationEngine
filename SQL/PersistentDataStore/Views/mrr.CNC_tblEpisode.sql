SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE VIEW [mrr].[CNC_tblEpisode] as select [Episode_ID], [Episode_Type_ID], [Patient_ID], [Referral_Date], [Referral_Time], [Referral_Received_Date], [Last_Contact_Date], [Referral_Source_ID], [Referral_Source_Type_ID], [Agency_ID], [Contact_Name], [Contact_Job_Title], [Contact_Telephone], [GP_ID], [Practice_ID], [GP_Code], [Practice_Code], [School_ID], [Contact_ID], [Staff_ID], [Episode_Priority_ID], [Referral_Reason_ID], [Presentation_Reason_ID], [Referrer_Address1], [Referrer_Address2], [Referrer_Address3], [Referrer_Address4], [Referrer_Address5], [Referrer_Post_Code], [Referrer_Telephone], [Referrer_Fax], [Referrer_Email], [Referrer_PCT_Code], [Referrer_PCT_Name], [Service_ID], [Location_ID], [Client_Normally_Seen_At_Location_ID], [Referral_Format_ID], [Referral_Status_ID], [Referral_Admin_Status_ID], [Referral_Administrative_Category_ID], [Episode_Admin_Priority_ID], [Accepted_Date], [Accepted_By_Staff_ID], [Accepted_By_Staff_Name], [Wait_Weeks], [Open_Weeks], [Start_Date], [Accommodation_ID], [Employment_ID], [Administration_Comments], [Rejection_Date], [Rejection_Reason_ID], [Rejection_Detail], [Rejected_By_Staff_ID], [Rejected_By_Staff_Name], [Discharge_Date], [Discharge_Time], [Discharge_Method_Episode_ID], [Discharge_Destination_ID], [Healthcare_Resource_Group_ID], [Discharge_Agreed_By_Staff_ID], [Discharge_Agreed_By_Staff_Name], [Discharge_Detail], [Comments], [Transport_Required_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Referrer_CCG_Code], [Referrer_CCG_Name], [Referral_Received_Time], [Agency_Staff_Category_ID], [Staff_Professional_Group_ID], [Discharge_Letter_Issued_Date], [Referral_Closure_Reason_ID], [NHS_Service_Agreement_Line_Number] 
from [Mirror].[mrr_tbl].[CNC_tblEpisode];


GO
