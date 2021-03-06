SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_CNS_tblWardStay

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_CNS_tblWardStay]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[Ward_Stay_ID], [Patient_ID], [Location_ID], [Admission_Type_ID], [Bed_Number_ID], [Ward_Stay_Observation_ID], [Planned_Start_Date], [Planned_Start_Time], [Planned_Start_Dttm], [Planned_End_Date], [Planned_End_Time], [Planned_End_Dttm], [Current_Status], [Current_Ward_Stay_Status_ID], [Actual_Start_Date], [Actual_Start_Time], [Actual_Start_Dttm], [Actual_End_Date], [Actual_End_Time], [Actual_End_Dttm], [Infection_Control_Issues_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Hospital_Bed_Type_ID]
						 FROM mrr_tbl.CNS_tblWardStay
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[Ward_Stay_ID], [Patient_ID], [Location_ID], [Admission_Type_ID], [Bed_Number_ID], [Ward_Stay_Observation_ID], [Planned_Start_Date], [Planned_Start_Time], [Planned_Start_Dttm], [Planned_End_Date], [Planned_End_Time], [Planned_End_Dttm], [Current_Status], [Current_Ward_Stay_Status_ID], [Actual_Start_Date], [Actual_Start_Time], [Actual_Start_Dttm], [Actual_End_Date], [Actual_End_Time], [Actual_End_Dttm], [Infection_Control_Issues_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Hospital_Bed_Type_ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblWardStay])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[Ward_Stay_ID], [Patient_ID], [Location_ID], [Admission_Type_ID], [Bed_Number_ID], [Ward_Stay_Observation_ID], [Planned_Start_Date], [Planned_Start_Time], [Planned_Start_Dttm], [Planned_End_Date], [Planned_End_Time], [Planned_End_Dttm], [Current_Status], [Current_Ward_Stay_Status_ID], [Actual_Start_Date], [Actual_Start_Time], [Actual_Start_Dttm], [Actual_End_Date], [Actual_End_Time], [Actual_End_Dttm], [Infection_Control_Issues_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Hospital_Bed_Type_ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblWardStay]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[Ward_Stay_ID], [Patient_ID], [Location_ID], [Admission_Type_ID], [Bed_Number_ID], [Ward_Stay_Observation_ID], [Planned_Start_Date], [Planned_Start_Time], [Planned_Start_Dttm], [Planned_End_Date], [Planned_End_Time], [Planned_End_Dttm], [Current_Status], [Current_Ward_Stay_Status_ID], [Actual_Start_Date], [Actual_Start_Time], [Actual_Start_Dttm], [Actual_End_Date], [Actual_End_Time], [Actual_End_Dttm], [Infection_Control_Issues_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Hospital_Bed_Type_ID]
						 FROM mrr_tbl.CNS_tblWardStay))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.CNS_tblWardStay has discrepancies when compared to its source table.', 1;

				END;
				
GO
