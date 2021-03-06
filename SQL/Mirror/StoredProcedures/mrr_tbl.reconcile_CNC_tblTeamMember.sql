SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_CNC_tblTeamMember

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_CNC_tblTeamMember]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[Team_Member_ID], [Patient_ID], [Staff_ID], [Team_Member_Role_ID], [Start_Date], [End_Date], [Location_ID], [Sub_Specialty_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Staff_Occupation_Code_ID], [Mental_Health_Responsible_Clinician_ID]
						 FROM mrr_tbl.CNC_tblTeamMember
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[Team_Member_ID], [Patient_ID], [Staff_ID], [Team_Member_Role_ID], [Start_Date], [End_Date], [Location_ID], [Sub_Specialty_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Staff_Occupation_Code_ID], [Mental_Health_Responsible_Clinician_ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblTeamMember])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[Team_Member_ID], [Patient_ID], [Staff_ID], [Team_Member_Role_ID], [Start_Date], [End_Date], [Location_ID], [Sub_Specialty_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Staff_Occupation_Code_ID], [Mental_Health_Responsible_Clinician_ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblTeamMember]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[Team_Member_ID], [Patient_ID], [Staff_ID], [Team_Member_Role_ID], [Start_Date], [End_Date], [Location_ID], [Sub_Specialty_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Staff_Occupation_Code_ID], [Mental_Health_Responsible_Clinician_ID]
						 FROM mrr_tbl.CNC_tblTeamMember))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.CNC_tblTeamMember has discrepancies when compared to its source table.', 1;

				END;
				
GO
