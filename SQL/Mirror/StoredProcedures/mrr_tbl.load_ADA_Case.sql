SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

				/*==========================================================================================================================================
				Notes:
				Template for loading Mirror table in full load mode only.

				TODO Is this the right place for the transactions? Should transaction handling be external to this procedure?

				Test:

				EXECUTE mrr_tbl.load_ADA_Case
				EXECUTE mrr_tbl.load_ADA_Case 'F'

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.
				12/04/2019 OBMH\Fathi.Saad change TRUNCATE to delete from latest Datetime

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[load_ADA_Case]
					-- Add the parameters for the stored procedure here
					@LoadType NVARCHAR(1) = 'F' -- I= Incremental, F=Truncate/Insert, value ignored for full load only loaders
				AS
				BEGIN
					DECLARE @Inserted INTEGER = 0,
							@Updated INTEGER = 0,
							@Deleted INTEGER = 0,
							@StartTime DATETIME2 = GETDATE(),
							@EndTime DATETIME2;

					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;
					--Try...
					BEGIN TRY
						BEGIN TRANSACTION;

						--12/04/2019  FS added
						DECLARE @MaxDate DATETIME = ISNULL((SELECT MAX(EditDate)  FROM mrr_tbl.ADA_Case ),'1 Jan 1900')

						IF OBJECT_ID('dbo.tmpADACase6789','U') IS NOT NULL
						DROP TABLE dbo.tmpADACase6789

						SELECT [CaseRef]
						INTO dbo.tmpADACase6789
						FROM [MHOXCARESQL01\MHOXCARESQL01].Adastra3Oxford.dbo.[Case] 
						WHERE EditDate > @MaxDate

						--12/04/2019
						--TRUNCATE TABLE mrr_tbl.ADA_Case;
						DELETE FROM mrr_tbl.ADA_Case 
						FROM mrr_tbl.ADA_Case pat
						WHERE EXISTS (SELECT 1 FROM dbo.tmpADACase6789 tmp WHERE tmp.CaseRef = pat.CaseRef)

						INSERT INTO mrr_tbl.ADA_Case
						(
							c.[CaseRef], [EditDate], [ServiceRef], [OrganisationGroupRef], [CurrentLocationRef], [PatientRef], [ProviderRef], [CaseNo], [ActiveDate], [EntryDate], [ContactPhone], [CurrentLocationPhone], [Forename], [Surname], [SurnamePrefix], [Maiden], [MaidenPrefix], [CaseTypeRef], [CallerRelationshipRef], [CallerName], [CallerPhone], [CallerExtn], [ProviderGroupRef], [Summary], [BookedDate], [ProviderAdditionalText], [InsuranceType], [InsuranceSource], [InsuranceCompanyRef], [InsuranceNumber], [LocationRef], [FinalOutcomeRef], [Cancelled], [Testcall], [PatientAuditRef], [SpecialismRef], [DutyStationRef], [CurrentLocationExpiry], [ProviderGroupAdditionalText], [RegistrationTypeRef], [Initials], [Confidential], [MultipleCallMasterCaseRef], [CoverRef], [InvoiceAddressRef], [ActivePerformanceManagementRef], [SpecialismTypeRef], [PassProviderRef], [RequiresUserAcknowledgement], [UserAcknowledged], [AcknowledgementMessageRef], [LastEditByUserRef], [ProviderType], [WalkIn], [AlertAcknowledgementDate], [CaseTagRef], [NoteRematchRequired], [SensitiveCase], [CurrentLocationPhoneExtn], [ContactPhoneExtn], [NationalProviderCode], [NationalProviderGroupCode], [InsuranceStartDate], [InsuranceEndDate], [NationalNumberStatus], [FutureCase], [ServiceVisibility], [OtherServiceVisibility], [CallerPhonePrefix], [ContactPhonePrefix], [CurrentLocationPhonePrefix], [NationalRepeatCallerStatus], [SequenceNumber], [UpdateReference]
						)
						SELECT c.[CaseRef], [EditDate], [ServiceRef], [OrganisationGroupRef], [CurrentLocationRef], [PatientRef], [ProviderRef], [CaseNo], [ActiveDate], [EntryDate], [ContactPhone], [CurrentLocationPhone], [Forename], [Surname], [SurnamePrefix], [Maiden], [MaidenPrefix], [CaseTypeRef], [CallerRelationshipRef], [CallerName], [CallerPhone], [CallerExtn], [ProviderGroupRef], [Summary], [BookedDate], [ProviderAdditionalText], [InsuranceType], [InsuranceSource], [InsuranceCompanyRef], [InsuranceNumber], [LocationRef], [FinalOutcomeRef], [Cancelled], [Testcall], [PatientAuditRef], [SpecialismRef], [DutyStationRef], [CurrentLocationExpiry], [ProviderGroupAdditionalText], [RegistrationTypeRef], [Initials], [Confidential], [MultipleCallMasterCaseRef], [CoverRef], [InvoiceAddressRef], [ActivePerformanceManagementRef], [SpecialismTypeRef], [PassProviderRef], [RequiresUserAcknowledgement], [UserAcknowledged], [AcknowledgementMessageRef], [LastEditByUserRef], [ProviderType], [WalkIn], [AlertAcknowledgementDate], [CaseTagRef], [NoteRematchRequired], [SensitiveCase], [CurrentLocationPhoneExtn], [ContactPhoneExtn], [NationalProviderCode], [NationalProviderGroupCode], [InsuranceStartDate], [InsuranceEndDate], [NationalNumberStatus], [FutureCase], [ServiceVisibility], [OtherServiceVisibility], [CallerPhonePrefix], [ContactPhonePrefix], [CurrentLocationPhonePrefix], [NationalRepeatCallerStatus], [SequenceNumber], [UpdateReference]
						FROM [MHOXCARESQL01\MHOXCARESQL01].[Adastra3Oxford].[dbo].[Case] c
						INNER JOIN dbo.tmpADACase6789 tmp ON  tmp.CaseRef = c.CaseRef;

						SET @Inserted = @@ROWCOUNT;
						SET @Deleted = @Inserted; -- TODO This is not right but as we do TRUNCATE rather than DELETE it is the best we can do for now.

						--	Update audit table.
						SET @EndTime = GETDATE();

						INSERT INTO mrr_aud.ADA_Case
						(
							LoadType,
							RunByUser,
							StartTime,
							EndTime,
							Inserted,
							Updated,
							Deleted
						)
						VALUES
						(   @LoadType,   -- LoadType - nvarchar(1)
							SYSTEM_USER, -- RunByUser - nvarchar(128)
							@StartTime,  -- StartTime - datetime2(7)
							@EndTime,    -- EndTime - datetime2(7)
							@Inserted,   -- Inserted - int
							@Updated,    -- Updated - int
							@Deleted     -- Deleted - int
							);

						
						IF OBJECT_ID('dbo.tmpADACase6789','U') IS NOT NULL
						DROP TABLE dbo.tmpADACase6789


						COMMIT TRANSACTION; -- INSERT INTO mrr_aud.ADA_Case

					END TRY
					--Catch if transaction open roll it back.
					BEGIN CATCH
						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;
							THROW;
					END CATCH;

				END;
				
GO
