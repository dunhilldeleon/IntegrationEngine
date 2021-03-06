SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

				/*==========================================================================================================================================
				Notes:
				Template for loading Mirror table in full load mode only.

				TODO Is this the right place for the transactions? Should transaction handling be external to this procedure?

				Test:

				EXECUTE mrr_tbl.load_ADA_Consultation
				EXECUTE mrr_tbl.load_ADA_Consultation 'F'

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[load_ADA_Consultation]
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


						--10/06/2019 TK added as port of the incremental load implementation 
						DECLARE @MaxDate DATETIME = ISNULL((SELECT MAX(StartDate)  FROM mrr_tbl.ADA_Consultation ),'1 Jan 1900')

						IF OBJECT_ID('dbo.tmpADAConsultation6789','U') IS NOT NULL
						DROP TABLE dbo.tmpADAConsultation6789

						SELECT [ConsultationRef]
						INTO dbo.tmpADAConsultation6789
						FROM [MHOXCARESQL01\MHOXCARESQL01].Adastra3Oxford.dbo.[Consultation] 
						WHERE StartDate > @MaxDate

						--TRUNCATE TABLE mrr_tbl.ADA_Consultation;

						DELETE FROM mrr_tbl.ADA_Consultation
						FROM mrr_tbl.ADA_Consultation pat
						WHERE EXISTS (SELECT 1 FROM dbo.tmpADAConsultation6789 tmp WHERE tmp.ConsultationRef = pat.ConsultationRef)

						INSERT INTO mrr_tbl.ADA_Consultation
						(
							[ConsultationRef], [CaseRef], [History], [Examination], [Diagnosis], [Treatment], [StartDate], [EndDate], [ProviderRef], [CaseTypeRef], [PriorityRef], [Outcome], [BeforeCaseTypeRef], [AfterStatus], [BeforeStatus], [LocationRef], [Obsolete], [InitialAssessment], [ButtonScreen], [ConfigurationSet], [LanguageScreen]
						)
						SELECT con.[ConsultationRef], [CaseRef], [History], [Examination], [Diagnosis], [Treatment], [StartDate], [EndDate], [ProviderRef], [CaseTypeRef], [PriorityRef], [Outcome], [BeforeCaseTypeRef], [AfterStatus], [BeforeStatus], [LocationRef], [Obsolete], [InitialAssessment], [ButtonScreen], [ConfigurationSet], [LanguageScreen]
						FROM [MHOXCARESQL01\MHOXCARESQL01].[Adastra3Oxford].[dbo].[Consultation] con
						INNER JOIN dbo.tmpADAConsultation6789 tmp ON tmp.[ConsultationRef] = con.[ConsultationRef];

						SET @Inserted = @@ROWCOUNT;
						SET @Deleted = @Inserted; -- TODO This is not right but as we do TRUNCATE rather than DELETE it is the best we can do for now.

						--	Update audit table.
						SET @EndTime = GETDATE();

						INSERT INTO mrr_aud.ADA_Consultation
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
						COMMIT TRANSACTION; -- INSERT INTO mrr_aud.ADA_Consultation

					END TRY
					--Catch if transaction open roll it back.
					BEGIN CATCH
						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;
							THROW;
					END CATCH;

				END;
				
GO
