SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_CNC_tblEpisode

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_CNC_tblEpisode]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[Episode_ID], [Episode_Type_ID], [Patient_ID], [Referral_Date], [Referral_Time], [Referral_Received_Date], [Last_Contact_Date], [Referral_Source_ID], [Referral_Source_Type_ID], [Agency_ID], [Contact_Name], [Contact_Job_Title], [Contact_Telephone], [GP_ID], [Practice_ID], [GP_Code], [Practice_Code], [School_ID], [Contact_ID], [Staff_ID], [Episode_Priority_ID], [Referral_Reason_ID], [Presentation_Reason_ID], [Referrer_Address1], [Referrer_Address2], [Referrer_Address3], [Referrer_Address4], [Referrer_Address5], [Referrer_Post_Code], [Referrer_Telephone], [Referrer_Fax], [Referrer_Email], [Referrer_PCT_Code], [Referrer_PCT_Name], [Service_ID], [Location_ID], [Client_Normally_Seen_At_Location_ID], [Referral_Format_ID], [Referral_Status_ID], [Referral_Admin_Status_ID], [Referral_Administrative_Category_ID], [Episode_Admin_Priority_ID], [Accepted_Date], [Accepted_By_Staff_ID], [Accepted_By_Staff_Name], [Wait_Weeks], [Open_Weeks], [Start_Date], [Accommodation_ID], [Employment_ID], [Rejection_Date], [Rejection_Reason_ID], [Rejection_Detail], [Rejected_By_Staff_ID], [Rejected_By_Staff_Name], [Discharge_Date], [Discharge_Time], [Discharge_Method_Episode_ID], [Discharge_Destination_ID], [Healthcare_Resource_Group_ID], [Discharge_Agreed_By_Staff_ID], [Discharge_Agreed_By_Staff_Name], [Transport_Required_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Referrer_CCG_Code], [Referrer_CCG_Name], [Referral_Received_Time], [Agency_Staff_Category_ID], [Staff_Professional_Group_ID], [Discharge_Letter_Issued_Date], [Referral_Closure_Reason_ID], [NHS_Service_Agreement_Line_Number], [Reason_For_Out_Of_Area_Referral_ID]
						 FROM mrr_tbl.CNC_tblEpisode
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[Episode_ID], [Episode_Type_ID], [Patient_ID], [Referral_Date], [Referral_Time], [Referral_Received_Date], [Last_Contact_Date], [Referral_Source_ID], [Referral_Source_Type_ID], [Agency_ID], [Contact_Name], [Contact_Job_Title], [Contact_Telephone], [GP_ID], [Practice_ID], [GP_Code], [Practice_Code], [School_ID], [Contact_ID], [Staff_ID], [Episode_Priority_ID], [Referral_Reason_ID], [Presentation_Reason_ID], [Referrer_Address1], [Referrer_Address2], [Referrer_Address3], [Referrer_Address4], [Referrer_Address5], [Referrer_Post_Code], [Referrer_Telephone], [Referrer_Fax], [Referrer_Email], [Referrer_PCT_Code], [Referrer_PCT_Name], [Service_ID], [Location_ID], [Client_Normally_Seen_At_Location_ID], [Referral_Format_ID], [Referral_Status_ID], [Referral_Admin_Status_ID], [Referral_Administrative_Category_ID], [Episode_Admin_Priority_ID], [Accepted_Date], [Accepted_By_Staff_ID], [Accepted_By_Staff_Name], [Wait_Weeks], [Open_Weeks], [Start_Date], [Accommodation_ID], [Employment_ID], [Rejection_Date], [Rejection_Reason_ID], [Rejection_Detail], [Rejected_By_Staff_ID], [Rejected_By_Staff_Name], [Discharge_Date], [Discharge_Time], [Discharge_Method_Episode_ID], [Discharge_Destination_ID], [Healthcare_Resource_Group_ID], [Discharge_Agreed_By_Staff_ID], [Discharge_Agreed_By_Staff_Name], [Transport_Required_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Referrer_CCG_Code], [Referrer_CCG_Name], [Referral_Received_Time], [Agency_Staff_Category_ID], [Staff_Professional_Group_ID], [Discharge_Letter_Issued_Date], [Referral_Closure_Reason_ID], [NHS_Service_Agreement_Line_Number], [Reason_For_Out_Of_Area_Referral_ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblEpisode])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[Episode_ID], [Episode_Type_ID], [Patient_ID], [Referral_Date], [Referral_Time], [Referral_Received_Date], [Last_Contact_Date], [Referral_Source_ID], [Referral_Source_Type_ID], [Agency_ID], [Contact_Name], [Contact_Job_Title], [Contact_Telephone], [GP_ID], [Practice_ID], [GP_Code], [Practice_Code], [School_ID], [Contact_ID], [Staff_ID], [Episode_Priority_ID], [Referral_Reason_ID], [Presentation_Reason_ID], [Referrer_Address1], [Referrer_Address2], [Referrer_Address3], [Referrer_Address4], [Referrer_Address5], [Referrer_Post_Code], [Referrer_Telephone], [Referrer_Fax], [Referrer_Email], [Referrer_PCT_Code], [Referrer_PCT_Name], [Service_ID], [Location_ID], [Client_Normally_Seen_At_Location_ID], [Referral_Format_ID], [Referral_Status_ID], [Referral_Admin_Status_ID], [Referral_Administrative_Category_ID], [Episode_Admin_Priority_ID], [Accepted_Date], [Accepted_By_Staff_ID], [Accepted_By_Staff_Name], [Wait_Weeks], [Open_Weeks], [Start_Date], [Accommodation_ID], [Employment_ID], [Rejection_Date], [Rejection_Reason_ID], [Rejection_Detail], [Rejected_By_Staff_ID], [Rejected_By_Staff_Name], [Discharge_Date], [Discharge_Time], [Discharge_Method_Episode_ID], [Discharge_Destination_ID], [Healthcare_Resource_Group_ID], [Discharge_Agreed_By_Staff_ID], [Discharge_Agreed_By_Staff_Name], [Transport_Required_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Referrer_CCG_Code], [Referrer_CCG_Name], [Referral_Received_Time], [Agency_Staff_Category_ID], [Staff_Professional_Group_ID], [Discharge_Letter_Issued_Date], [Referral_Closure_Reason_ID], [NHS_Service_Agreement_Line_Number], [Reason_For_Out_Of_Area_Referral_ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblEpisode]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[Episode_ID], [Episode_Type_ID], [Patient_ID], [Referral_Date], [Referral_Time], [Referral_Received_Date], [Last_Contact_Date], [Referral_Source_ID], [Referral_Source_Type_ID], [Agency_ID], [Contact_Name], [Contact_Job_Title], [Contact_Telephone], [GP_ID], [Practice_ID], [GP_Code], [Practice_Code], [School_ID], [Contact_ID], [Staff_ID], [Episode_Priority_ID], [Referral_Reason_ID], [Presentation_Reason_ID], [Referrer_Address1], [Referrer_Address2], [Referrer_Address3], [Referrer_Address4], [Referrer_Address5], [Referrer_Post_Code], [Referrer_Telephone], [Referrer_Fax], [Referrer_Email], [Referrer_PCT_Code], [Referrer_PCT_Name], [Service_ID], [Location_ID], [Client_Normally_Seen_At_Location_ID], [Referral_Format_ID], [Referral_Status_ID], [Referral_Admin_Status_ID], [Referral_Administrative_Category_ID], [Episode_Admin_Priority_ID], [Accepted_Date], [Accepted_By_Staff_ID], [Accepted_By_Staff_Name], [Wait_Weeks], [Open_Weeks], [Start_Date], [Accommodation_ID], [Employment_ID], [Rejection_Date], [Rejection_Reason_ID], [Rejection_Detail], [Rejected_By_Staff_ID], [Rejected_By_Staff_Name], [Discharge_Date], [Discharge_Time], [Discharge_Method_Episode_ID], [Discharge_Destination_ID], [Healthcare_Resource_Group_ID], [Discharge_Agreed_By_Staff_ID], [Discharge_Agreed_By_Staff_Name], [Transport_Required_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Referrer_CCG_Code], [Referrer_CCG_Name], [Referral_Received_Time], [Agency_Staff_Category_ID], [Staff_Professional_Group_ID], [Discharge_Letter_Issued_Date], [Referral_Closure_Reason_ID], [NHS_Service_Agreement_Line_Number], [Reason_For_Out_Of_Area_Referral_ID]
						 FROM mrr_tbl.CNC_tblEpisode))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.CNC_tblEpisode has discrepancies when compared to its source table.', 1;

				END;
				
GO
