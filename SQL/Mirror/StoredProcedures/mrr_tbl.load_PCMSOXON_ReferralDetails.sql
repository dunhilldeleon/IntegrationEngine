SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

				/*==========================================================================================================================================
				Notes:
				Template for loading Mirror table in full load mode only.

				TODO Is this the right place for the transactions? Should transaction handling be external to this procedure?

				Test:

				EXECUTE mrr_tbl.load_PCMSOXON_ReferralDetails
				EXECUTE mrr_tbl.load_PCMSOXON_ReferralDetails 'F'

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[load_PCMSOXON_ReferralDetails]
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

						TRUNCATE TABLE mrr_tbl.PCMSOXON_ReferralDetails;

						INSERT INTO mrr_tbl.PCMSOXON_ReferralDetails
						(
							[CaseNumber], [PatientID], [DateOfOnset], [PrimaryProb], [SecondaryProb], [PresentingProb], [PrimaryDiagnosis], [SecondaryDiagnosis], [OtherProb], [Referrer], [ResponsibleCommissioner], [WorkerName], [Profession], [Consent], [GPCode], [GPName], [Custom1], [Custom2], [Custom3], [EndOfCareDate], [ReferralAccepted], [OtherCaseNumber], [ServiceReqAccept], [PatientConsent2], [EndOfCareReason], [ReferredToService]
						)
						SELECT [CaseNumber], [PatientID], [DateOfOnset], [PrimaryProb], [SecondaryProb], [PresentingProb], [PrimaryDiagnosis], [SecondaryDiagnosis], [OtherProb], [Referrer], [ResponsibleCommissioner], [WorkerName], [Profession], [Consent], [GPCode], [GPName], [Custom1], [Custom2], [Custom3], [EndOfCareDate], [ReferralAccepted], [OtherCaseNumber], [ServiceReqAccept], [PatientConsent2], [EndOfCareReason], [ReferredToService]
						FROM [OXONPCMIS].[public_hspcmis12].[dbo].[ReferralDetails];

						SET @Inserted = @@ROWCOUNT;
						SET @Deleted = @Inserted; -- TODO This is not right but as we do TRUNCATE rather than DELETE it is the best we can do for now.

						--	Update audit table.
						SET @EndTime = GETDATE();

						INSERT INTO mrr_aud.PCMSOXON_ReferralDetails
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
						COMMIT TRANSACTION; -- INSERT INTO mrr_aud.PCMSOXON_ReferralDetails

					END TRY
					--Catch if transaction open roll it back.
					BEGIN CATCH
						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;
							THROW;
					END CATCH;

				END;
				
GO
