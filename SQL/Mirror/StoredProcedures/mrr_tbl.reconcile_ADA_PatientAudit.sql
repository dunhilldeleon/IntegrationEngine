SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_ADA_PatientAudit

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_ADA_PatientAudit]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[PatientAuditRef], [PatientRef], [AddressRef], [Forename], [Surname], [SurnamePrefix], [MaidenPrefix], [Maiden], [Initials], [DOB], [HomePhone], [MobilePhone], [OtherPhone], [Sex], [AgeOnly], [NationalCode], [Obsolete], [LastEditByUserRef], [EditDate], [AuditChange], [EthnicityRef], [HumanLanguageRef], [LocalLanguageSpoken], [NationalityRef], [ChangeReason], [CaseRef], [CaseAuditRef], [NationalCodeSource], [EmailAddress], [OtherPhoneExtn], [ExcludeFromPSQ], [IsTwin], [DemographicsSensitive], [NationalCodeSourceDatabase], [NationalCodeEditDate], [AllergyStatusRef], [ConditionStatusRef], [MedicationStatusRef], [NationalCodeEditByUserRef], [NationalCodeExtraInfo], [HomePhonePrefix], [AllergyStatusCode], [ConditionStatusCode], [MedicationStatusCode], [LatestModificationDate]
						 FROM mrr_tbl.ADA_PatientAudit
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[PatientAuditRef], [PatientRef], [AddressRef], [Forename], [Surname], [SurnamePrefix], [MaidenPrefix], [Maiden], [Initials], [DOB], [HomePhone], [MobilePhone], [OtherPhone], [Sex], [AgeOnly], [NationalCode], [Obsolete], [LastEditByUserRef], [EditDate], [AuditChange], [EthnicityRef], [HumanLanguageRef], [LocalLanguageSpoken], [NationalityRef], [ChangeReason], [CaseRef], [CaseAuditRef], [NationalCodeSource], [EmailAddress], [OtherPhoneExtn], [ExcludeFromPSQ], [IsTwin], [DemographicsSensitive], [NationalCodeSourceDatabase], [NationalCodeEditDate], [AllergyStatusRef], [ConditionStatusRef], [MedicationStatusRef], [NationalCodeEditByUserRef], [NationalCodeExtraInfo], [HomePhonePrefix], [AllergyStatusCode], [ConditionStatusCode], [MedicationStatusCode], [LatestModificationDate]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[Adastra3Oxford].[dbo].[PatientAudit])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[PatientAuditRef], [PatientRef], [AddressRef], [Forename], [Surname], [SurnamePrefix], [MaidenPrefix], [Maiden], [Initials], [DOB], [HomePhone], [MobilePhone], [OtherPhone], [Sex], [AgeOnly], [NationalCode], [Obsolete], [LastEditByUserRef], [EditDate], [AuditChange], [EthnicityRef], [HumanLanguageRef], [LocalLanguageSpoken], [NationalityRef], [ChangeReason], [CaseRef], [CaseAuditRef], [NationalCodeSource], [EmailAddress], [OtherPhoneExtn], [ExcludeFromPSQ], [IsTwin], [DemographicsSensitive], [NationalCodeSourceDatabase], [NationalCodeEditDate], [AllergyStatusRef], [ConditionStatusRef], [MedicationStatusRef], [NationalCodeEditByUserRef], [NationalCodeExtraInfo], [HomePhonePrefix], [AllergyStatusCode], [ConditionStatusCode], [MedicationStatusCode], [LatestModificationDate]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[Adastra3Oxford].[dbo].[PatientAudit]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[PatientAuditRef], [PatientRef], [AddressRef], [Forename], [Surname], [SurnamePrefix], [MaidenPrefix], [Maiden], [Initials], [DOB], [HomePhone], [MobilePhone], [OtherPhone], [Sex], [AgeOnly], [NationalCode], [Obsolete], [LastEditByUserRef], [EditDate], [AuditChange], [EthnicityRef], [HumanLanguageRef], [LocalLanguageSpoken], [NationalityRef], [ChangeReason], [CaseRef], [CaseAuditRef], [NationalCodeSource], [EmailAddress], [OtherPhoneExtn], [ExcludeFromPSQ], [IsTwin], [DemographicsSensitive], [NationalCodeSourceDatabase], [NationalCodeEditDate], [AllergyStatusRef], [ConditionStatusRef], [MedicationStatusRef], [NationalCodeEditByUserRef], [NationalCodeExtraInfo], [HomePhonePrefix], [AllergyStatusCode], [ConditionStatusCode], [MedicationStatusCode], [LatestModificationDate]
						 FROM mrr_tbl.ADA_PatientAudit))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.ADA_PatientAudit has discrepancies when compared to its source table.', 1;

				END;
				
GO
