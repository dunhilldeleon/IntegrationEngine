SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_CNS_udfMHCarePlanv1

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_CNS_udfMHCarePlanv1]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[MHCarePlanv1_ID], [Patient_ID], [Confirm_Flag_ID], [Confirm_Date], [Confirm_Time], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [OriginalAuthorID], [flstrtdate], [flrevdate], [Hidden_items], [Icd_10], [Cluster_lvl], [fldcpcopyID], [fldshrdate], [flgrb], [flgnd1], [flgnd2], [flgnd3], [flgnd4], [flgnd5], [flgnd6], [flgnd7], [flgnd8], [flgnd9], [flgnd10], [flgnd11], [flgnd12], [flgnd13], [flgnd14], [flgnd15], [flgnd16], [flgnd17], [flgnd18], [flgnd19], [flgnd20], [ReplanRequested], [DocumentGroupIdentifier], [PreviousCNObjectID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [fldEnteredDate], [fldEnteredTime], [StartDate], [StartTime], [fldSafetyPlanFileName], [fldSafetyPlan], [fldCarePlanType1ID], [fldCarePlanType2ID], [fldCarePlanType3ID], [fldCarePlanType4ID], [fldCarePlanType5ID], [fldCarePlanType6ID], [fldCarePlanAgreed1ID], [fldCarePlanAgreed2ID], [fldCarePlanAgreed3ID], [fldCarePlanAgreed4ID], [fldCarePlanAgreed5ID], [fldCarePlanAgreed6ID], [fldCarePlanAgreed7ID]
						 FROM mrr_tbl.CNS_udfMHCarePlanv1
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[MHCarePlanv1_ID], [Patient_ID], [Confirm_Flag_ID], [Confirm_Date], [Confirm_Time], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [OriginalAuthorID], [flstrtdate], [flrevdate], [Hidden_items], [Icd_10], [Cluster_lvl], [fldcpcopyID], [fldshrdate], [flgrb], [flgnd1], [flgnd2], [flgnd3], [flgnd4], [flgnd5], [flgnd6], [flgnd7], [flgnd8], [flgnd9], [flgnd10], [flgnd11], [flgnd12], [flgnd13], [flgnd14], [flgnd15], [flgnd16], [flgnd17], [flgnd18], [flgnd19], [flgnd20], [ReplanRequested], [DocumentGroupIdentifier], [PreviousCNObjectID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [fldEnteredDate], [fldEnteredTime], [StartDate], [StartTime], [fldSafetyPlanFileName], [fldSafetyPlan], [fldCarePlanType1ID], [fldCarePlanType2ID], [fldCarePlanType3ID], [fldCarePlanType4ID], [fldCarePlanType5ID], [fldCarePlanType6ID], [fldCarePlanAgreed1ID], [fldCarePlanAgreed2ID], [fldCarePlanAgreed3ID], [fldCarePlanAgreed4ID], [fldCarePlanAgreed5ID], [fldCarePlanAgreed6ID], [fldCarePlanAgreed7ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[udfMHCarePlanv1])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[MHCarePlanv1_ID], [Patient_ID], [Confirm_Flag_ID], [Confirm_Date], [Confirm_Time], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [OriginalAuthorID], [flstrtdate], [flrevdate], [Hidden_items], [Icd_10], [Cluster_lvl], [fldcpcopyID], [fldshrdate], [flgrb], [flgnd1], [flgnd2], [flgnd3], [flgnd4], [flgnd5], [flgnd6], [flgnd7], [flgnd8], [flgnd9], [flgnd10], [flgnd11], [flgnd12], [flgnd13], [flgnd14], [flgnd15], [flgnd16], [flgnd17], [flgnd18], [flgnd19], [flgnd20], [ReplanRequested], [DocumentGroupIdentifier], [PreviousCNObjectID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [fldEnteredDate], [fldEnteredTime], [StartDate], [StartTime], [fldSafetyPlanFileName], [fldSafetyPlan], [fldCarePlanType1ID], [fldCarePlanType2ID], [fldCarePlanType3ID], [fldCarePlanType4ID], [fldCarePlanType5ID], [fldCarePlanType6ID], [fldCarePlanAgreed1ID], [fldCarePlanAgreed2ID], [fldCarePlanAgreed3ID], [fldCarePlanAgreed4ID], [fldCarePlanAgreed5ID], [fldCarePlanAgreed6ID], [fldCarePlanAgreed7ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[udfMHCarePlanv1]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[MHCarePlanv1_ID], [Patient_ID], [Confirm_Flag_ID], [Confirm_Date], [Confirm_Time], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [OriginalAuthorID], [flstrtdate], [flrevdate], [Hidden_items], [Icd_10], [Cluster_lvl], [fldcpcopyID], [fldshrdate], [flgrb], [flgnd1], [flgnd2], [flgnd3], [flgnd4], [flgnd5], [flgnd6], [flgnd7], [flgnd8], [flgnd9], [flgnd10], [flgnd11], [flgnd12], [flgnd13], [flgnd14], [flgnd15], [flgnd16], [flgnd17], [flgnd18], [flgnd19], [flgnd20], [ReplanRequested], [DocumentGroupIdentifier], [PreviousCNObjectID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [fldEnteredDate], [fldEnteredTime], [StartDate], [StartTime], [fldSafetyPlanFileName], [fldSafetyPlan], [fldCarePlanType1ID], [fldCarePlanType2ID], [fldCarePlanType3ID], [fldCarePlanType4ID], [fldCarePlanType5ID], [fldCarePlanType6ID], [fldCarePlanAgreed1ID], [fldCarePlanAgreed2ID], [fldCarePlanAgreed3ID], [fldCarePlanAgreed4ID], [fldCarePlanAgreed5ID], [fldCarePlanAgreed6ID], [fldCarePlanAgreed7ID]
						 FROM mrr_tbl.CNS_udfMHCarePlanv1))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.CNS_udfMHCarePlanv1 has discrepancies when compared to its source table.', 1;

				END;
				
GO
