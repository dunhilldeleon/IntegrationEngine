SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_CNS_tblGPDetail

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_CNS_tblGPDetail]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[GP_Detail_ID], [Patient_ID], [Permission_To_Contact_ID], [Start_Date], [End_Date], [GP_ID], [Practice_ID], [Contact_GP_ID], [Further_Information], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [CCG_ID], [Assumed_GP_ID], [PDS_ID]
						 FROM mrr_tbl.CNS_tblGPDetail
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[GP_Detail_ID], [Patient_ID], [Permission_To_Contact_ID], [Start_Date], [End_Date], [GP_ID], [Practice_ID], [Contact_GP_ID], [Further_Information], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [CCG_ID], [Assumed_GP_ID], [PDS_ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblGPDetail])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[GP_Detail_ID], [Patient_ID], [Permission_To_Contact_ID], [Start_Date], [End_Date], [GP_ID], [Practice_ID], [Contact_GP_ID], [Further_Information], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [CCG_ID], [Assumed_GP_ID], [PDS_ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblGPDetail]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[GP_Detail_ID], [Patient_ID], [Permission_To_Contact_ID], [Start_Date], [End_Date], [GP_ID], [Practice_ID], [Contact_GP_ID], [Further_Information], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [CCG_ID], [Assumed_GP_ID], [PDS_ID]
						 FROM mrr_tbl.CNS_tblGPDetail))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.CNS_tblGPDetail has discrepancies when compared to its source table.', 1;

				END;
				
GO
