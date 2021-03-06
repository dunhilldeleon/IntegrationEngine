SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_CNS_udfOHFTGENRiskAssessmentv3

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_CNS_udfOHFTGENRiskAssessmentv3]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[OHFTGENRiskAssessmentv3_ID], [Patient_ID], [Confirm_Flag_ID], [Confirm_Date], [Confirm_Time], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [OriginalAuthorID], [aRole], [StartDate], [EndDate], [fldRiskAssessSlfHrmID], [fldRiskAssessSuicideID], [fldRiskAssessSlfNgtID], [fldRiskAssessHthFallsID], [fldRiskAssessMUsfMedID], [fldRiskAssessSubMisID], [fldRiskAssessActHrmID], [fldRiskAssessDisengID], [fldRiskAssessRskFOtrID], [fldRiskAssessAggVioID], [fldRiskAssessFireSetID], [fldRiskAssessSexOffID], [fldRiskAssessRskTOtrID], [fldRiskAssessRskCdnID], [fldRiskAssessDmgPrpID], [fldRiskAssessMAPPAID], [fldRiskAssessULawRstID], [fldRiskAssessAsbEscID], [fldRiskAssessCPPID], [ReplanRequested], [DocumentGroupIdentifier], [PreviousCNObjectID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [StartTime], [fldRefSocCareID], [fldRefSocDate], [fldRefReasonID], [fldRiskAssessLACID], [flgchkChildRisk], [flgchkSocialCare], [flgchkSocialCareComm], [flgchkendborder], [flgchkGen0], [flgchkGen1], [flgchkGen2], [flgchkGen3], [flgchkGen4], [flgchkGen5], [flgchkGen6], [flgchkGen7], [flgchkGen8], [flgchkGen9], [flgchkGen10], [flgchkGen11], [flgchkGen12], [flgchkGen13], [flgchkGen14], [flgchkGen15], [flgchkGen16], [flgchkGen17], [flgchkGen18], [flgchkGen19], [fldEnteredDate], [fldEnteredTime]
						 FROM mrr_tbl.CNS_udfOHFTGENRiskAssessmentv3
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[OHFTGENRiskAssessmentv3_ID], [Patient_ID], [Confirm_Flag_ID], [Confirm_Date], [Confirm_Time], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [OriginalAuthorID], [aRole], [StartDate], [EndDate], [fldRiskAssessSlfHrmID], [fldRiskAssessSuicideID], [fldRiskAssessSlfNgtID], [fldRiskAssessHthFallsID], [fldRiskAssessMUsfMedID], [fldRiskAssessSubMisID], [fldRiskAssessActHrmID], [fldRiskAssessDisengID], [fldRiskAssessRskFOtrID], [fldRiskAssessAggVioID], [fldRiskAssessFireSetID], [fldRiskAssessSexOffID], [fldRiskAssessRskTOtrID], [fldRiskAssessRskCdnID], [fldRiskAssessDmgPrpID], [fldRiskAssessMAPPAID], [fldRiskAssessULawRstID], [fldRiskAssessAsbEscID], [fldRiskAssessCPPID], [ReplanRequested], [DocumentGroupIdentifier], [PreviousCNObjectID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [StartTime], [fldRefSocCareID], [fldRefSocDate], [fldRefReasonID], [fldRiskAssessLACID], [flgchkChildRisk], [flgchkSocialCare], [flgchkSocialCareComm], [flgchkendborder], [flgchkGen0], [flgchkGen1], [flgchkGen2], [flgchkGen3], [flgchkGen4], [flgchkGen5], [flgchkGen6], [flgchkGen7], [flgchkGen8], [flgchkGen9], [flgchkGen10], [flgchkGen11], [flgchkGen12], [flgchkGen13], [flgchkGen14], [flgchkGen15], [flgchkGen16], [flgchkGen17], [flgchkGen18], [flgchkGen19], [fldEnteredDate], [fldEnteredTime]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[udfOHFTGENRiskAssessmentv3])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[OHFTGENRiskAssessmentv3_ID], [Patient_ID], [Confirm_Flag_ID], [Confirm_Date], [Confirm_Time], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [OriginalAuthorID], [aRole], [StartDate], [EndDate], [fldRiskAssessSlfHrmID], [fldRiskAssessSuicideID], [fldRiskAssessSlfNgtID], [fldRiskAssessHthFallsID], [fldRiskAssessMUsfMedID], [fldRiskAssessSubMisID], [fldRiskAssessActHrmID], [fldRiskAssessDisengID], [fldRiskAssessRskFOtrID], [fldRiskAssessAggVioID], [fldRiskAssessFireSetID], [fldRiskAssessSexOffID], [fldRiskAssessRskTOtrID], [fldRiskAssessRskCdnID], [fldRiskAssessDmgPrpID], [fldRiskAssessMAPPAID], [fldRiskAssessULawRstID], [fldRiskAssessAsbEscID], [fldRiskAssessCPPID], [ReplanRequested], [DocumentGroupIdentifier], [PreviousCNObjectID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [StartTime], [fldRefSocCareID], [fldRefSocDate], [fldRefReasonID], [fldRiskAssessLACID], [flgchkChildRisk], [flgchkSocialCare], [flgchkSocialCareComm], [flgchkendborder], [flgchkGen0], [flgchkGen1], [flgchkGen2], [flgchkGen3], [flgchkGen4], [flgchkGen5], [flgchkGen6], [flgchkGen7], [flgchkGen8], [flgchkGen9], [flgchkGen10], [flgchkGen11], [flgchkGen12], [flgchkGen13], [flgchkGen14], [flgchkGen15], [flgchkGen16], [flgchkGen17], [flgchkGen18], [flgchkGen19], [fldEnteredDate], [fldEnteredTime]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[udfOHFTGENRiskAssessmentv3]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[OHFTGENRiskAssessmentv3_ID], [Patient_ID], [Confirm_Flag_ID], [Confirm_Date], [Confirm_Time], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [OriginalAuthorID], [aRole], [StartDate], [EndDate], [fldRiskAssessSlfHrmID], [fldRiskAssessSuicideID], [fldRiskAssessSlfNgtID], [fldRiskAssessHthFallsID], [fldRiskAssessMUsfMedID], [fldRiskAssessSubMisID], [fldRiskAssessActHrmID], [fldRiskAssessDisengID], [fldRiskAssessRskFOtrID], [fldRiskAssessAggVioID], [fldRiskAssessFireSetID], [fldRiskAssessSexOffID], [fldRiskAssessRskTOtrID], [fldRiskAssessRskCdnID], [fldRiskAssessDmgPrpID], [fldRiskAssessMAPPAID], [fldRiskAssessULawRstID], [fldRiskAssessAsbEscID], [fldRiskAssessCPPID], [ReplanRequested], [DocumentGroupIdentifier], [PreviousCNObjectID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [StartTime], [fldRefSocCareID], [fldRefSocDate], [fldRefReasonID], [fldRiskAssessLACID], [flgchkChildRisk], [flgchkSocialCare], [flgchkSocialCareComm], [flgchkendborder], [flgchkGen0], [flgchkGen1], [flgchkGen2], [flgchkGen3], [flgchkGen4], [flgchkGen5], [flgchkGen6], [flgchkGen7], [flgchkGen8], [flgchkGen9], [flgchkGen10], [flgchkGen11], [flgchkGen12], [flgchkGen13], [flgchkGen14], [flgchkGen15], [flgchkGen16], [flgchkGen17], [flgchkGen18], [flgchkGen19], [fldEnteredDate], [fldEnteredTime]
						 FROM mrr_tbl.CNS_udfOHFTGENRiskAssessmentv3))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.CNS_udfOHFTGENRiskAssessmentv3 has discrepancies when compared to its source table.', 1;

				END;
				
GO
