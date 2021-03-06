SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_CNS_tblPractice

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_CNS_tblPractice]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[Practice_ID], [Practice_Code], [Active_ID], [Locally_Managed_ID], [Practice_Name], [PCT_ID], [Fundholder_Code], [Address1], [Address2], [Address3], [Address4], [Address5], [Post_Code], [Telephone], [Fax], [Email_Address], [Enable_Email_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [CCG_ID]
						 FROM mrr_tbl.CNS_tblPractice
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[Practice_ID], [Practice_Code], [Active_ID], [Locally_Managed_ID], [Practice_Name], [PCT_ID], [Fundholder_Code], [Address1], [Address2], [Address3], [Address4], [Address5], [Post_Code], [Telephone], [Fax], [Email_Address], [Enable_Email_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [CCG_ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblPractice])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[Practice_ID], [Practice_Code], [Active_ID], [Locally_Managed_ID], [Practice_Name], [PCT_ID], [Fundholder_Code], [Address1], [Address2], [Address3], [Address4], [Address5], [Post_Code], [Telephone], [Fax], [Email_Address], [Enable_Email_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [CCG_ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblPractice]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[Practice_ID], [Practice_Code], [Active_ID], [Locally_Managed_ID], [Practice_Name], [PCT_ID], [Fundholder_Code], [Address1], [Address2], [Address3], [Address4], [Address5], [Post_Code], [Telephone], [Fax], [Email_Address], [Enable_Email_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [CCG_ID]
						 FROM mrr_tbl.CNS_tblPractice))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.CNS_tblPractice has discrepancies when compared to its source table.', 1;

				END;
				
GO
