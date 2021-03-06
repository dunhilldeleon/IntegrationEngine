SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_CNS_tblAddress

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_CNS_tblAddress]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[Address_ID], [Patient_ID], [Usual_Address_Flag_ID], [Address1], [Address2], [Address3], [Address4], [Address5], [Post_Code], [City_ID], [Main_Phone_Number_Type_ID], [Main_Telephone_Number], [Tel_Home], [Tel_Home_Confidential_Flag_ID], [Tel_Mobile], [Tel_SMS], [Tel_Mobile_Confidential_Flag_ID], [Tel_Work], [Tel_Work_Confidential_Flag_ID], [Email_Address], [SMS_Reminders_Flag_ID], [Address_Type_ID], [Address_Confidential_Flag_ID], [Start_Date], [End_Date], [Health_Authority], [Commissioning_Contract_Number_ID], [Local_Authority], [Electoral_Ward], [District_Of_Residence], [Residence_PCT_ID], [DAT_Of_Residence_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Method_Of_Contact_Other], [PCT_Of_Index_Offence_ID], [CCG_ID], [PDS_ID]
						 FROM mrr_tbl.CNS_tblAddress
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[Address_ID], [Patient_ID], [Usual_Address_Flag_ID], [Address1], [Address2], [Address3], [Address4], [Address5], [Post_Code], [City_ID], [Main_Phone_Number_Type_ID], [Main_Telephone_Number], [Tel_Home], [Tel_Home_Confidential_Flag_ID], [Tel_Mobile], [Tel_SMS], [Tel_Mobile_Confidential_Flag_ID], [Tel_Work], [Tel_Work_Confidential_Flag_ID], [Email_Address], [SMS_Reminders_Flag_ID], [Address_Type_ID], [Address_Confidential_Flag_ID], [Start_Date], [End_Date], [Health_Authority], [Commissioning_Contract_Number_ID], [Local_Authority], [Electoral_Ward], [District_Of_Residence], [Residence_PCT_ID], [DAT_Of_Residence_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Method_Of_Contact_Other], [PCT_Of_Index_Offence_ID], [CCG_ID], [PDS_ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblAddress])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[Address_ID], [Patient_ID], [Usual_Address_Flag_ID], [Address1], [Address2], [Address3], [Address4], [Address5], [Post_Code], [City_ID], [Main_Phone_Number_Type_ID], [Main_Telephone_Number], [Tel_Home], [Tel_Home_Confidential_Flag_ID], [Tel_Mobile], [Tel_SMS], [Tel_Mobile_Confidential_Flag_ID], [Tel_Work], [Tel_Work_Confidential_Flag_ID], [Email_Address], [SMS_Reminders_Flag_ID], [Address_Type_ID], [Address_Confidential_Flag_ID], [Start_Date], [End_Date], [Health_Authority], [Commissioning_Contract_Number_ID], [Local_Authority], [Electoral_Ward], [District_Of_Residence], [Residence_PCT_ID], [DAT_Of_Residence_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Method_Of_Contact_Other], [PCT_Of_Index_Offence_ID], [CCG_ID], [PDS_ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblAddress]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[Address_ID], [Patient_ID], [Usual_Address_Flag_ID], [Address1], [Address2], [Address3], [Address4], [Address5], [Post_Code], [City_ID], [Main_Phone_Number_Type_ID], [Main_Telephone_Number], [Tel_Home], [Tel_Home_Confidential_Flag_ID], [Tel_Mobile], [Tel_SMS], [Tel_Mobile_Confidential_Flag_ID], [Tel_Work], [Tel_Work_Confidential_Flag_ID], [Email_Address], [SMS_Reminders_Flag_ID], [Address_Type_ID], [Address_Confidential_Flag_ID], [Start_Date], [End_Date], [Health_Authority], [Commissioning_Contract_Number_ID], [Local_Authority], [Electoral_Ward], [District_Of_Residence], [Residence_PCT_ID], [DAT_Of_Residence_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Method_Of_Contact_Other], [PCT_Of_Index_Offence_ID], [CCG_ID], [PDS_ID]
						 FROM mrr_tbl.CNS_tblAddress))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.CNS_tblAddress has discrepancies when compared to its source table.', 1;

				END;
				
GO
