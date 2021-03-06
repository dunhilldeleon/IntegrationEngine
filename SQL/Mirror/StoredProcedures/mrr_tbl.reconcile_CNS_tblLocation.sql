SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_CNS_tblLocation

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_CNS_tblLocation]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[Location_ID], [Location_Name], [Start_Date], [Location_Status_ID], [End_Date], [Location_Team_Ward_ID], [Location_IMC_Code_ID], [Location_Specialty_ID], [Location_Sub_Specialty_ID], [Location_Category_ID], [Location_Gender_ID], [Location_Beds], [Address1], [Address2], [Address3], [Address4], [Address5], [Post_Code], [Phone], [Location_NFF_Ward_Type], [Site_Code], [Clinical_Care_Intensity_ID], [Location_Division_ID], [Cost_Code], [CAMHS_Service_Tier], [Clinical_Team_Classification_ID], [CMHT_Administrator_Staff_ID], [Consultant_Staff_ID], [Team_Email_Address], [MHA_Administration_Offices_ID], [Default_Booking_Type_ID], [Default_PB_Contact_Type_ID], [Additional_Information], [Agency_Code], [PCT_ID], [SM_Cost_Code], [SM_Service_Code], [Ppa_Code], [Sms_Appointment_Reminders_ID], [Sms_Tail], [Location_Udf_1], [Location_Udf_2], [Location_Udf_3], [Location_Udf_4], [Location_Udf_5], [Location_Udf_6], [Location_Udf_7], [Location_Udf_8], [Location_Udf_9], [Location_Udf_10], [Prescriber_PIN], [Prescriber_Practice_Code], [Ward_Security_Level_ID], [Intended_Age_Group_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Cluster_Location_ID], [Cluster_Location_Object_Type_ID], [Mental_Health_Care_Team_Type_ID], [Admission_Setting_ID], [CCG_ID], [MHSDS_Service_Type_ID], [Ward_Locked_ID], [Place_Of_Safety_ID], [Hospital_Bed_Type_ID]
						 FROM mrr_tbl.CNS_tblLocation
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[Location_ID], [Location_Name], [Start_Date], [Location_Status_ID], [End_Date], [Location_Team_Ward_ID], [Location_IMC_Code_ID], [Location_Specialty_ID], [Location_Sub_Specialty_ID], [Location_Category_ID], [Location_Gender_ID], [Location_Beds], [Address1], [Address2], [Address3], [Address4], [Address5], [Post_Code], [Phone], [Location_NFF_Ward_Type], [Site_Code], [Clinical_Care_Intensity_ID], [Location_Division_ID], [Cost_Code], [CAMHS_Service_Tier], [Clinical_Team_Classification_ID], [CMHT_Administrator_Staff_ID], [Consultant_Staff_ID], [Team_Email_Address], [MHA_Administration_Offices_ID], [Default_Booking_Type_ID], [Default_PB_Contact_Type_ID], [Additional_Information], [Agency_Code], [PCT_ID], [SM_Cost_Code], [SM_Service_Code], [Ppa_Code], [Sms_Appointment_Reminders_ID], [Sms_Tail], [Location_Udf_1], [Location_Udf_2], [Location_Udf_3], [Location_Udf_4], [Location_Udf_5], [Location_Udf_6], [Location_Udf_7], [Location_Udf_8], [Location_Udf_9], [Location_Udf_10], [Prescriber_PIN], [Prescriber_Practice_Code], [Ward_Security_Level_ID], [Intended_Age_Group_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Cluster_Location_ID], [Cluster_Location_Object_Type_ID], [Mental_Health_Care_Team_Type_ID], [Admission_Setting_ID], [CCG_ID], [MHSDS_Service_Type_ID], [Ward_Locked_ID], [Place_Of_Safety_ID], [Hospital_Bed_Type_ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblLocation])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[Location_ID], [Location_Name], [Start_Date], [Location_Status_ID], [End_Date], [Location_Team_Ward_ID], [Location_IMC_Code_ID], [Location_Specialty_ID], [Location_Sub_Specialty_ID], [Location_Category_ID], [Location_Gender_ID], [Location_Beds], [Address1], [Address2], [Address3], [Address4], [Address5], [Post_Code], [Phone], [Location_NFF_Ward_Type], [Site_Code], [Clinical_Care_Intensity_ID], [Location_Division_ID], [Cost_Code], [CAMHS_Service_Tier], [Clinical_Team_Classification_ID], [CMHT_Administrator_Staff_ID], [Consultant_Staff_ID], [Team_Email_Address], [MHA_Administration_Offices_ID], [Default_Booking_Type_ID], [Default_PB_Contact_Type_ID], [Additional_Information], [Agency_Code], [PCT_ID], [SM_Cost_Code], [SM_Service_Code], [Ppa_Code], [Sms_Appointment_Reminders_ID], [Sms_Tail], [Location_Udf_1], [Location_Udf_2], [Location_Udf_3], [Location_Udf_4], [Location_Udf_5], [Location_Udf_6], [Location_Udf_7], [Location_Udf_8], [Location_Udf_9], [Location_Udf_10], [Prescriber_PIN], [Prescriber_Practice_Code], [Ward_Security_Level_ID], [Intended_Age_Group_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Cluster_Location_ID], [Cluster_Location_Object_Type_ID], [Mental_Health_Care_Team_Type_ID], [Admission_Setting_ID], [CCG_ID], [MHSDS_Service_Type_ID], [Ward_Locked_ID], [Place_Of_Safety_ID], [Hospital_Bed_Type_ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblLocation]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[Location_ID], [Location_Name], [Start_Date], [Location_Status_ID], [End_Date], [Location_Team_Ward_ID], [Location_IMC_Code_ID], [Location_Specialty_ID], [Location_Sub_Specialty_ID], [Location_Category_ID], [Location_Gender_ID], [Location_Beds], [Address1], [Address2], [Address3], [Address4], [Address5], [Post_Code], [Phone], [Location_NFF_Ward_Type], [Site_Code], [Clinical_Care_Intensity_ID], [Location_Division_ID], [Cost_Code], [CAMHS_Service_Tier], [Clinical_Team_Classification_ID], [CMHT_Administrator_Staff_ID], [Consultant_Staff_ID], [Team_Email_Address], [MHA_Administration_Offices_ID], [Default_Booking_Type_ID], [Default_PB_Contact_Type_ID], [Additional_Information], [Agency_Code], [PCT_ID], [SM_Cost_Code], [SM_Service_Code], [Ppa_Code], [Sms_Appointment_Reminders_ID], [Sms_Tail], [Location_Udf_1], [Location_Udf_2], [Location_Udf_3], [Location_Udf_4], [Location_Udf_5], [Location_Udf_6], [Location_Udf_7], [Location_Udf_8], [Location_Udf_9], [Location_Udf_10], [Prescriber_PIN], [Prescriber_Practice_Code], [Ward_Security_Level_ID], [Intended_Age_Group_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Cluster_Location_ID], [Cluster_Location_Object_Type_ID], [Mental_Health_Care_Team_Type_ID], [Admission_Setting_ID], [CCG_ID], [MHSDS_Service_Type_ID], [Ward_Locked_ID], [Place_Of_Safety_ID], [Hospital_Bed_Type_ID]
						 FROM mrr_tbl.CNS_tblLocation))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.CNS_tblLocation has discrepancies when compared to its source table.', 1;

				END;
				
GO
