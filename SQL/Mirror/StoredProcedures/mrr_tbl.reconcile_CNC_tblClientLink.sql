SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_CNC_tblClientLink

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_CNC_tblClientLink]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[Client_Link_ID], [Patient_ID], [Start_Date], [Start_Authorised_By_Staff_ID], [Relationship_ID], [Linked_Patient_ID], [Reciprocal_Client_Link_ID], [Review_Date], [Responsibility_Of_Staff_ID], [End_Date], [End_Authorised_By_Staff_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Family_Parental_Responsibility_ID], [Family_Legal_Status_ID]
						 FROM mrr_tbl.CNC_tblClientLink
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[Client_Link_ID], [Patient_ID], [Start_Date], [Start_Authorised_By_Staff_ID], [Relationship_ID], [Linked_Patient_ID], [Reciprocal_Client_Link_ID], [Review_Date], [Responsibility_Of_Staff_ID], [End_Date], [End_Authorised_By_Staff_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Family_Parental_Responsibility_ID], [Family_Legal_Status_ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblClientLink])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[Client_Link_ID], [Patient_ID], [Start_Date], [Start_Authorised_By_Staff_ID], [Relationship_ID], [Linked_Patient_ID], [Reciprocal_Client_Link_ID], [Review_Date], [Responsibility_Of_Staff_ID], [End_Date], [End_Authorised_By_Staff_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Family_Parental_Responsibility_ID], [Family_Legal_Status_ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblClientLink]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[Client_Link_ID], [Patient_ID], [Start_Date], [Start_Authorised_By_Staff_ID], [Relationship_ID], [Linked_Patient_ID], [Reciprocal_Client_Link_ID], [Review_Date], [Responsibility_Of_Staff_ID], [End_Date], [End_Authorised_By_Staff_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Family_Parental_Responsibility_ID], [Family_Legal_Status_ID]
						 FROM mrr_tbl.CNC_tblClientLink))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.CNC_tblClientLink has discrepancies when compared to its source table.', 1;

				END;
				
GO
