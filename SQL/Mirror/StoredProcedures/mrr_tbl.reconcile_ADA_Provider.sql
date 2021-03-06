SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_ADA_Provider

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_ADA_Provider]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[ProviderRef], [OrganisationGroupRef], [RotaGroupRef], [Forename], [Surname], [SurnamePrefix], [Maiden], [Lookup], [ProviderType], [PagerNumber], [Sex], [AlternativeKey], [Interlinkage], [Email], [Initials], [HomePhone], [MobilePhone], [OtherPhone], [EDIAddress], [V2LastUpdate], [AddressRef], [V2Import], [Obsolete], [Member], [IndemnityNumber], [IndemnityRenewal], [ApprovedForService], [XXX_LastAppraisalDate], [XXX_Audited], [XXX_LastAuditDate], [PSQOversamplingEndDate], [ContactDetails], [PagerFormat], [NationalProviderCode], [AremoteDeviceRef], [ProviderPaymentGroupRef], [ProviderBillingGroupRef], [WorkOptOut], [RetainerPercentage], [ApprovedForServiceByUserRef], [ApprovedForServiceDate], [AverageHoursWorkedOutsideOrganisation], [PCTPerformersList], [PCTPerformersListLastCheckDate], [IndemnityInsuranceProviderRef], [DefaultAvailabilityPatternRef], [ApprovedOnBehalfOfUserRef]
						 FROM mrr_tbl.ADA_Provider
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[ProviderRef], [OrganisationGroupRef], [RotaGroupRef], [Forename], [Surname], [SurnamePrefix], [Maiden], [Lookup], [ProviderType], [PagerNumber], [Sex], [AlternativeKey], [Interlinkage], [Email], [Initials], [HomePhone], [MobilePhone], [OtherPhone], [EDIAddress], [V2LastUpdate], [AddressRef], [V2Import], [Obsolete], [Member], [IndemnityNumber], [IndemnityRenewal], [ApprovedForService], [XXX_LastAppraisalDate], [XXX_Audited], [XXX_LastAuditDate], [PSQOversamplingEndDate], [ContactDetails], [PagerFormat], [NationalProviderCode], [AremoteDeviceRef], [ProviderPaymentGroupRef], [ProviderBillingGroupRef], [WorkOptOut], [RetainerPercentage], [ApprovedForServiceByUserRef], [ApprovedForServiceDate], [AverageHoursWorkedOutsideOrganisation], [PCTPerformersList], [PCTPerformersListLastCheckDate], [IndemnityInsuranceProviderRef], [DefaultAvailabilityPatternRef], [ApprovedOnBehalfOfUserRef]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[Adastra3Oxford].[dbo].[Provider])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[ProviderRef], [OrganisationGroupRef], [RotaGroupRef], [Forename], [Surname], [SurnamePrefix], [Maiden], [Lookup], [ProviderType], [PagerNumber], [Sex], [AlternativeKey], [Interlinkage], [Email], [Initials], [HomePhone], [MobilePhone], [OtherPhone], [EDIAddress], [V2LastUpdate], [AddressRef], [V2Import], [Obsolete], [Member], [IndemnityNumber], [IndemnityRenewal], [ApprovedForService], [XXX_LastAppraisalDate], [XXX_Audited], [XXX_LastAuditDate], [PSQOversamplingEndDate], [ContactDetails], [PagerFormat], [NationalProviderCode], [AremoteDeviceRef], [ProviderPaymentGroupRef], [ProviderBillingGroupRef], [WorkOptOut], [RetainerPercentage], [ApprovedForServiceByUserRef], [ApprovedForServiceDate], [AverageHoursWorkedOutsideOrganisation], [PCTPerformersList], [PCTPerformersListLastCheckDate], [IndemnityInsuranceProviderRef], [DefaultAvailabilityPatternRef], [ApprovedOnBehalfOfUserRef]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[Adastra3Oxford].[dbo].[Provider]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[ProviderRef], [OrganisationGroupRef], [RotaGroupRef], [Forename], [Surname], [SurnamePrefix], [Maiden], [Lookup], [ProviderType], [PagerNumber], [Sex], [AlternativeKey], [Interlinkage], [Email], [Initials], [HomePhone], [MobilePhone], [OtherPhone], [EDIAddress], [V2LastUpdate], [AddressRef], [V2Import], [Obsolete], [Member], [IndemnityNumber], [IndemnityRenewal], [ApprovedForService], [XXX_LastAppraisalDate], [XXX_Audited], [XXX_LastAuditDate], [PSQOversamplingEndDate], [ContactDetails], [PagerFormat], [NationalProviderCode], [AremoteDeviceRef], [ProviderPaymentGroupRef], [ProviderBillingGroupRef], [WorkOptOut], [RetainerPercentage], [ApprovedForServiceByUserRef], [ApprovedForServiceDate], [AverageHoursWorkedOutsideOrganisation], [PCTPerformersList], [PCTPerformersListLastCheckDate], [IndemnityInsuranceProviderRef], [DefaultAvailabilityPatternRef], [ApprovedOnBehalfOfUserRef]
						 FROM mrr_tbl.ADA_Provider))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.ADA_Provider has discrepancies when compared to its source table.', 1;

				END;
				
GO
