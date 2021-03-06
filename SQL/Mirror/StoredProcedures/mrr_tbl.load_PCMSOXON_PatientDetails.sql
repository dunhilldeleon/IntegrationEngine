SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

				/*==========================================================================================================================================
				Notes:
				Template for loading Mirror table in full load mode only.

				TODO Is this the right place for the transactions? Should transaction handling be external to this procedure?

				Test:

				EXECUTE mrr_tbl.load_PCMSOXON_PatientDetails
				EXECUTE mrr_tbl.load_PCMSOXON_PatientDetails 'F'

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[load_PCMSOXON_PatientDetails]
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

						TRUNCATE TABLE mrr_tbl.PCMSOXON_PatientDetails;

						INSERT INTO mrr_tbl.PCMSOXON_PatientDetails
						(
							[PatientID], [Title], [FirstName], [MiddleName], [LastName], [DOB], [Nationality], [Gender], [Ethnicity], [Address1], [Address2], [Address3], [TownCity], [County], [PostCode], [TelHome], [TelMobile], [TelWork], [NHSNumber], [FamilyName], [PreviousName], [PreviousAddress1], [PreviousAddress2], [PreviousAddress3], [PreviousTownCity], [PreviousCounty], [PreviousPostCode], [AccomodationType], [SingleOccupancy], [MaritalStatus], [MainLanguage], [Sexuality], [Mobility], [DateOfDeath], [Email], [Alerts], [Disability], [Reminders], [Religion], [DependantChildren], [ChildDetails1], [ChildDetails2], [ChildDetails3], [ChildDetails4], [ChildDetails5], [ChildDetails6], [ChildDetails7], [ChildDetails8], [ChildDetails9], [ChildDetails10], [CarerDetails1], [CarerDetails2], [CarerDetails3], [VoicemailHome], [VoicemailMobile], [VoicemailWork], [NHSNumberVerified], [TelGP], [PriorIllness], [PriorTreatment], [Medicated], [DateOfMedication], [EndOfMedication], [NotifyBySMS], [ArmedForcesCode], [LastNameAlias], [FirstNameAlias], [DisplayName], [Interpreter], [InterpreterLanguage], [PrimaryMUS], [IntIAPTConsent]
						)
						SELECT [PatientID], [Title], [FirstName], [MiddleName], [LastName], [DOB], [Nationality], [Gender], [Ethnicity], [Address1], [Address2], [Address3], [TownCity], [County], [PostCode], [TelHome], [TelMobile], [TelWork], [NHSNumber], [FamilyName], [PreviousName], [PreviousAddress1], [PreviousAddress2], [PreviousAddress3], [PreviousTownCity], [PreviousCounty], [PreviousPostCode], [AccomodationType], [SingleOccupancy], [MaritalStatus], [MainLanguage], [Sexuality], [Mobility], [DateOfDeath], [Email], [Alerts], [Disability], [Reminders], [Religion], [DependantChildren], [ChildDetails1], [ChildDetails2], [ChildDetails3], [ChildDetails4], [ChildDetails5], [ChildDetails6], [ChildDetails7], [ChildDetails8], [ChildDetails9], [ChildDetails10], [CarerDetails1], [CarerDetails2], [CarerDetails3], [VoicemailHome], [VoicemailMobile], [VoicemailWork], [NHSNumberVerified], [TelGP], [PriorIllness], [PriorTreatment], [Medicated], [DateOfMedication], [EndOfMedication], [NotifyBySMS], [ArmedForcesCode], [LastNameAlias], [FirstNameAlias], [DisplayName], [Interpreter], [InterpreterLanguage], [PrimaryMUS], [IntIAPTConsent]
						FROM [OXONPCMIS].[public_hspcmis12].[dbo].[PatientDetails];

						SET @Inserted = @@ROWCOUNT;
						SET @Deleted = @Inserted; -- TODO This is not right but as we do TRUNCATE rather than DELETE it is the best we can do for now.

						--	Update audit table.
						SET @EndTime = GETDATE();

						INSERT INTO mrr_aud.PCMSOXON_PatientDetails
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
						COMMIT TRANSACTION; -- INSERT INTO mrr_aud.PCMSOXON_PatientDetails

					END TRY
					--Catch if transaction open roll it back.
					BEGIN CATCH
						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;
							THROW;
					END CATCH;

				END;
				
GO
