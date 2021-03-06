SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE PROCEDURE [dbo].[uspMPI_Populate_IntegratedLatestPatientDemographics]

AS 

--IF OBJECT_ID('dbo.MPI_tmpUpdatedRecord','U') IS NOT NULL
--DROP TABLE dbo.MPI_tmpUpdatedRecord

BEGIN TRY

	BEGIN TRANSACTION;


		IF OBJECT_ID('dbo.tblMPI_IntegratedLatestPatientDemographics','U') IS NULL
			BEGIN
					CREATE TABLE [dbo].[tblMPI_IntegratedLatestPatientDemographics](
						[Source_PatientID] [VARCHAR](50)  NOT NULL,
						[NHS_Number] [VARCHAR](11) NOT NULL PRIMARY KEY,
						[UpdatedDate] [DATETIME] NULL,
						[source] [VARCHAR](5) NOT NULL,
						[CreatedDate] [DATETIME] NULL,
						[rn] [BIGINT] NULL
					) ON [PRIMARY]
			END
		ELSE
			BEGIN
				TRUNCATE TABLE [dbo].[tblMPI_IntegratedLatestPatientDemographics]
			END

		; WITH AllNHSNo AS
		(
			SELECT CAST(CNC.Patient_ID AS VARCHAR(50)) AS Source_PatientID, CNC.NHS_Number, CNC.UpdatedDate, 'CNC' AS source 
			FROM stg.tblCNC_Demographics CNC 
			WHERE ISNULL(CNC.NHS_Number,'') <> ''
			AND NOT EXISTS (SELECT 1 FROM [dbo].[tblMPI_Excluded_NHSNumbers] ex WHERE ex.NHSNumber = CNC.NHS_Number)

			UNION 
			SELECT CAST(CNS.Patient_ID AS VARCHAR(50)) AS Source_PatientID, CNS.NHS_Number, CNS.UpdatedDate, 'CNS' AS source
			FROM stg.tblCNS_Demographics CNS 
			WHERE ISNULL(CNS.NHS_Number,'') <> ''
			AND NOT EXISTS (SELECT 1 FROM [dbo].[tblMPI_Excluded_NHSNumbers] ex WHERE ex.NHSNumber = CNS.NHS_Number)

			UNION 
			SELECT CAST(ADA.Patient_ID AS VARCHAR(50)) AS Source_PatientID, ADA.NHS_Number , ADA.UpdatedDate, 'ADA' AS source
			FROM stg.tblADA_Demographics  ADA
			WHERE ISNULL(ADA.NHS_Number,'') <> ''
			AND NOT EXISTS (SELECT 1 FROM [dbo].[tblMPI_Excluded_NHSNumbers] ex WHERE ex.NHSNumber = ADA.NHS_Number)
			--UNION
		 --   SELECT PCMIS.NHS_Number , PCMIS.UpdatedDate, 'PCMIS' AS source
			--FROM stg.tblPCMIS_Demographics  PCMIS
			--WHERE ISNULL(PCMIS.NHS_Number,'') <> ''
			--AND NOT EXISTS (SELECT 1 FROM [dbo].[tblMPI_Excluded_NHSNumbers] ex WHERE ex.NHSNumber = PCMIS.NHS_Number)
		)
		, All_CreatedDttm AS  -- Identify when is a patient first created in all systems
		(
			SELECT CNC.NHS_Number , CNC.[CreatedDate] 
			FROM stg.tblCNC_Demographics CNC 
			WHERE ISNULL(CNC.NHS_Number,'') <> ''
			UNION 
			SELECT CNS.NHS_Number , CNS.[CreatedDate] 
			FROM stg.tblCNS_Demographics CNS 
			WHERE ISNULL(CNS.NHS_Number,'') <> ''
			--UNION 
		 --   SELECT PCMIS.NHS_Number , PCMIS.[CreatedDate]
			--FROM stg.tblPCMIS_Demographics  PCMIS
			--WHERE ISNULL(PCMIS.NHS_Number,'') <> ''
			UNION 
			SELECT ADA.NHS_Number , ADA.[CreatedDate]
			FROM stg.tblADA_Demographics  ADA
			WHERE ISNULL(ADA.NHS_Number,'') <> ''
		)
		, Min_CreatedDttm AS  -- select the earliest date the patient record was created in the Trust
		(
			SELECT NHS_Number, MIN([CreatedDate]) AS [CreatedDate]
			FROM All_CreatedDttm
			GROUP BY NHS_Number
		)
		, UpdatedRecords AS
		(
			SELECT DISTINCT AllNHSNo.*,Min_CreatedDttm.[CreatedDate], ROW_NUMBER() OVER(PARTITION BY AllNHSNo.NHS_Number ORDER BY AllNHSNo.UpdatedDate DESC) as rn
			FROM AllNHSNo
			INNER JOIN Min_CreatedDttm 
				ON Min_CreatedDttm.NHS_Number = AllNHSNo.NHS_Number

		)
		INSERT INTO dbo.tblMPI_IntegratedLatestPatientDemographics
		SELECT ur.* 
		FROM UpdatedRecords  ur
		WHERE rn = 1

		---- Add PCMIS Data
		--INSERT INTO dbo.tblMPI_IntegratedLatestPatientDemographics
		--SELECT DISTINCT CAST(PCMIS.Patient_ID AS VARCHAR(20)) AS Source_PatientID, PCMIS.NHS_Number , PCMIS.UpdatedDate, 'PCMIS' AS source, PCMIS.[CreatedDate], 1
		--FROM stg.tblPCMIS_Demographics  PCMIS
		--WHERE ISNULL(PCMIS.NHS_Number,'') <> ''
		--AND [ValidNHSNumber] = 'Y'
		--AND NOT EXISTS (SELECT 1 FROM dbo.tblMPI_IntegratedLatestPatientDemographics  ilpd WHERE PCMIS.NHS_Number = ilpd.NHS_Number)
		--AND NOT EXISTS (SELECT 1 FROM dbo.tblOH_MPI  mpi  WHERE PCMIS.NHS_Number = mpi.NHS_Number)

			COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH


---- UPDATE EventType
----=====================
--ALTER TABLE dbo.MPI_tmpUpdatedRecord ADD EventType VARCHAR(3)


--UPDATE tmp 
--SET EventType = 'A28'
--FROM dbo.MPI_tmpUpdatedRecord tmp
--WHERE NOT EXISTS (SELECT 1 FROM [dbo].[tblOH_MPI] mpi WHERE mpi.NHS_Number = tmp.NHS_Number)


--SELECT * FROM dbo.MPI_tmpUpdatedRecord
--WHERE NHS_Number = '4824213444'
GO
