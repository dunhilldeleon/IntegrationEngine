SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_CNC_tblContact

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_CNC_tblContact]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[Contact_ID], [Patient_ID], [Contact_Type_ID], [Primary_Contact_ID], [Permission_To_Contact_ID], [No_Divulge_ID], [Additional_Information_ID], [Contact_Name], [Title_ID], [Forename], [Middlename], [Surname], [Salutation], [Address1], [Address2], [Address3], [Address4], [Address5], [Post_Code], [Contact_DOB], [Preferred_Method_Of_Contact_ID], [Start_Date], [End_Date], [Relationship], [Gender_ID], [First_Language_ID], [Interpreter_ID], [Home_Telephone], [Home_Telephone_Confidential_ID], [Mobile_Telephone], [Mobile_Telephone_Confidential_ID], [Work_Telephone], [Work_Telephone_Confidential_ID], [Email_Address], [Contact_NHS_Num], [Contact_Ethnicity_ID], [Contact_Other_Ref], [Contact_Soc_Serv_Ref], [Contact_NINumber], [Contact_Registered_GP_ID], [Refugee_Stateless_Person_ID], [Contact_Date_Of_Death], [Permission_To_Contact_GP_ID], [School], [School_Admin_Contact], [School_Contact], [School_Head_Teacher], [School_Telephone], [School_Fax], [Further_Information], [Permission_To_Contact_School_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Family_Parental_Responsibility_ID], [Family_Legal_Status_ID]
						 FROM mrr_tbl.CNC_tblContact
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[Contact_ID], [Patient_ID], [Contact_Type_ID], [Primary_Contact_ID], [Permission_To_Contact_ID], [No_Divulge_ID], [Additional_Information_ID], [Contact_Name], [Title_ID], [Forename], [Middlename], [Surname], [Salutation], [Address1], [Address2], [Address3], [Address4], [Address5], [Post_Code], [Contact_DOB], [Preferred_Method_Of_Contact_ID], [Start_Date], [End_Date], [Relationship], [Gender_ID], [First_Language_ID], [Interpreter_ID], [Home_Telephone], [Home_Telephone_Confidential_ID], [Mobile_Telephone], [Mobile_Telephone_Confidential_ID], [Work_Telephone], [Work_Telephone_Confidential_ID], [Email_Address], [Contact_NHS_Num], [Contact_Ethnicity_ID], [Contact_Other_Ref], [Contact_Soc_Serv_Ref], [Contact_NINumber], [Contact_Registered_GP_ID], [Refugee_Stateless_Person_ID], [Contact_Date_Of_Death], [Permission_To_Contact_GP_ID], [School], [School_Admin_Contact], [School_Contact], [School_Head_Teacher], [School_Telephone], [School_Fax], [Further_Information], [Permission_To_Contact_School_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Family_Parental_Responsibility_ID], [Family_Legal_Status_ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblContact])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[Contact_ID], [Patient_ID], [Contact_Type_ID], [Primary_Contact_ID], [Permission_To_Contact_ID], [No_Divulge_ID], [Additional_Information_ID], [Contact_Name], [Title_ID], [Forename], [Middlename], [Surname], [Salutation], [Address1], [Address2], [Address3], [Address4], [Address5], [Post_Code], [Contact_DOB], [Preferred_Method_Of_Contact_ID], [Start_Date], [End_Date], [Relationship], [Gender_ID], [First_Language_ID], [Interpreter_ID], [Home_Telephone], [Home_Telephone_Confidential_ID], [Mobile_Telephone], [Mobile_Telephone_Confidential_ID], [Work_Telephone], [Work_Telephone_Confidential_ID], [Email_Address], [Contact_NHS_Num], [Contact_Ethnicity_ID], [Contact_Other_Ref], [Contact_Soc_Serv_Ref], [Contact_NINumber], [Contact_Registered_GP_ID], [Refugee_Stateless_Person_ID], [Contact_Date_Of_Death], [Permission_To_Contact_GP_ID], [School], [School_Admin_Contact], [School_Contact], [School_Head_Teacher], [School_Telephone], [School_Fax], [Further_Information], [Permission_To_Contact_School_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Family_Parental_Responsibility_ID], [Family_Legal_Status_ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblContact]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[Contact_ID], [Patient_ID], [Contact_Type_ID], [Primary_Contact_ID], [Permission_To_Contact_ID], [No_Divulge_ID], [Additional_Information_ID], [Contact_Name], [Title_ID], [Forename], [Middlename], [Surname], [Salutation], [Address1], [Address2], [Address3], [Address4], [Address5], [Post_Code], [Contact_DOB], [Preferred_Method_Of_Contact_ID], [Start_Date], [End_Date], [Relationship], [Gender_ID], [First_Language_ID], [Interpreter_ID], [Home_Telephone], [Home_Telephone_Confidential_ID], [Mobile_Telephone], [Mobile_Telephone_Confidential_ID], [Work_Telephone], [Work_Telephone_Confidential_ID], [Email_Address], [Contact_NHS_Num], [Contact_Ethnicity_ID], [Contact_Other_Ref], [Contact_Soc_Serv_Ref], [Contact_NINumber], [Contact_Registered_GP_ID], [Refugee_Stateless_Person_ID], [Contact_Date_Of_Death], [Permission_To_Contact_GP_ID], [School], [School_Admin_Contact], [School_Contact], [School_Head_Teacher], [School_Telephone], [School_Fax], [Further_Information], [Permission_To_Contact_School_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Family_Parental_Responsibility_ID], [Family_Legal_Status_ID]
						 FROM mrr_tbl.CNC_tblContact))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.CNC_tblContact has discrepancies when compared to its source table.', 1;

				END;
				
GO
