SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

				/*==========================================================================================================================================
				Notes:
				Template for loading Mirror table in full load mode only.

				TODO Is this the right place for the transactions? Should transaction handling be external to this procedure?

				Test:

				EXECUTE mrr_tbl.load_ADA_Patient
				EXECUTE mrr_tbl.load_ADA_Patient 'F'

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.
				12/04/2019 OBMH\Fathi.Saad change TRUNCATE to delete from latest Datetime

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[load_ADA_Patient]
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

						DECLARE @MaxDate DATETIME = ISNULL((SELECT MAX(EditDate)  FROM mrr_tbl.ADA_Patient ),'1 Jan 1900')

						IF OBJECT_ID('dbo.tmpadapat123','U') IS NOT NULL
						DROP TABLE dbo.tmpadapat123

						SELECT [PatientRef]
						INTO dbo.tmpadapat123
						FROM [MHOXCARESQL01\MHOXCARESQL01].Adastra3Oxford.dbo.Patient 
						WHERE EditDate > @MaxDate

						--12/04/2019
						--TRUNCATE TABLE mrr_tbl.ADA_Patient;
						DELETE FROM mrr_tbl.ADA_Patient 
						FROM mrr_tbl.ADA_Patient pat
						WHERE EXISTS (SELECT 1 FROM dbo.tmpadapat123 tmp WHERE tmp.PatientRef = pat.PatientRef)

						INSERT INTO mrr_tbl.ADA_Patient
						(
							[PatientRef], [AddressRef], [Forename], [Surname], [SurnamePrefix], [MaidenPrefix], [Maiden], [Initials], [DOB], [HomePhone], [MobilePhone], [OtherPhone], [Sex], [AgeOnly], [NationalCode], [Obsolete], [LastEditByUserRef], [EditDate], [EthnicityRef], [HumanLanguageRef], [LocalLanguageSpoken], [NationalityRef], [NationalCodeSource], [EmailAddress], [OtherPhoneExtn], [ExcludeFromPSQ], [LastCaseDate], [IsTwin], [DemographicsSensitive], [NationalCodeSourceDatabase], [NationalCodeEditDate], [NationalCodeEditByUserRef], [LocalID], [NationalCodeExtraInfo], [HomePhonePrefix], [AllergyStatusCode], [ConditionStatusCode], [MedicationStatusCode], [LatestModificationDate]
						)
						SELECT pat.[PatientRef], [AddressRef], [Forename], [Surname], [SurnamePrefix], [MaidenPrefix], [Maiden], [Initials], [DOB], [HomePhone], [MobilePhone], [OtherPhone], [Sex], [AgeOnly], [NationalCode], [Obsolete], [LastEditByUserRef], [EditDate], [EthnicityRef], [HumanLanguageRef], [LocalLanguageSpoken], [NationalityRef], [NationalCodeSource], [EmailAddress], [OtherPhoneExtn], [ExcludeFromPSQ], [LastCaseDate], [IsTwin], [DemographicsSensitive], [NationalCodeSourceDatabase], [NationalCodeEditDate], [NationalCodeEditByUserRef], [LocalID], [NationalCodeExtraInfo], [HomePhonePrefix], [AllergyStatusCode], [ConditionStatusCode], [MedicationStatusCode], [LatestModificationDate]
						FROM [MHOXCARESQL01\MHOXCARESQL01].[Adastra3Oxford].[dbo].[Patient] pat 
						INNER JOIN dbo.tmpadapat123 tmp ON  tmp.PatientRef = pat.PatientRef ;

						SET @Inserted = @@ROWCOUNT;
						SET @Deleted = @Inserted; -- TODO This is not right but as we do TRUNCATE rather than DELETE it is the best we can do for now.

						--	Update audit table.
						SET @EndTime = GETDATE();

						INSERT INTO mrr_aud.ADA_Patient
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

						IF OBJECT_ID('dbo.tmpadapat123','U') IS NOT NULL
						DROP TABLE dbo.tmpadapat123
						
						
						COMMIT TRANSACTION; -- INSERT INTO mrr_aud.ADA_Patient

					END TRY
					--Catch if transaction open roll it back.
					BEGIN CATCH
						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;
							THROW;
					END CATCH;

				END;
				
GO
