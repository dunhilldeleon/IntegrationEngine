SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


CREATE PROCEDURE [dbo].[uspMPI_Populate_MPI_NextOfKin]
AS


BEGIN TRY

	BEGIN TRANSACTION;

		IF OBJECT_ID('dbo.tblOH_MPI_NextOfKin','U') IS NULL
		BEGIN 
			CREATE TABLE [dbo].[tblOH_MPI_NextOfKin](
				[MPI_ID] [BIGINT] NOT NULL,
				[Contact_ID] [BIGINT]  NULL,
				[Forename] [VARCHAR](100) NULL,
				[Surname] [VARCHAR](100) NULL,
				[Title] [VARCHAR](20) NULL,
				[Gender] [VARCHAR](20) NULL,
				[PrimaryLanguage] [VARCHAR](20) NULL,
				[Relationship] [VARCHAR](50) NULL,
				[Relationship_HL7] [VARCHAR](3) NULL,
				[Address1] [VARCHAR](255) NULL,
				[Address2] [VARCHAR](255) NULL,
				[Address3] [VARCHAR](255) NULL,
				[Address4] [VARCHAR](255) NULL,
				[Postcode] [VARCHAR](50) NULL,
				[StartDate] [DATETIME] NULL,
				[EndDate] [DATETIME] NULL,
				[Updated_Dttm] [DATETIME] NOT NULL
			)
		END 
		ELSE 
		BEGIN
			-- delete old data
			DELETE FROM dbo.tblOH_MPI_NextOfKin
			FROM dbo.tblOH_MPI_NextOfKin mpi
			INNER JOIN dbo.tmpmpiNewData123 tmp
			ON mpi.MPI_ID = tmp.MPI_ID
		END


		--=================
		-- Load from CNC
		--=================
		INSERT INTO dbo.tblOH_MPI_NextOfKin
		(
				  [MPI_ID] 
				, [Contact_ID] 
				, [Forename] 
				, [Surname]
				, [Title] 
				, [Gender] 
				, [PrimaryLanguage]
				, [Relationship] 
				, [Relationship_HL7]
				, [Address1] 
				, [Address2] 
				, [Address3]
				, [Address4] 
				, [Postcode] 
				, [StartDate] 
				, [EndDate] 
				, [Updated_Dttm] 
		)
		SELECT tmp.[MPI_ID]
			  ,nk.[Contact_ID]
			  ,nk.[Forename]
			  ,nk.[Surname]
			  ,nk.[Title]
			  ,nk.[Gender_ID]
			  ,nk.[First_Language_ID]
			  ,nk.[Relationship]
			  ,nk.[Relationship_HL7]
			  ,nk.[Address1]
			  ,nk.[Address2]
			  ,nk.[Address3]
			  ,nk.[Address4]
			  ,nk.[Post_Code]
			  ,nk.[Start_Date]
			  ,nk.[End_Date]
			  ,nk.[UpdatedDate]
		  FROM dbo.tmpmpiNewData123 tmp
		  LEFT JOIN [src].[vwCNC_NextOfKin] nk
			ON tmp.CH_Patient_ID = nk.Patient_ID
		  WHERE nk.[UpdatedDate] IS NOT NULL 

		--=================
		-- Load from CNS
		--=================
		INSERT INTO dbo.tblOH_MPI_NextOfKin
		(
				  [MPI_ID] 
				, [Contact_ID] 
				, [Forename] 
				, [Surname]
				, [Title] 
				, [Gender] 
				, [PrimaryLanguage]
				, [Relationship] 
				, [Relationship_HL7]
				, [Address1] 
				, [Address2] 
				, [Address3]
				, [Address4] 
				, [Postcode] 
				, [StartDate] 
				, [EndDate] 
				, [Updated_Dttm] 
		)
		SELECT [MPI_ID]
			  ,[Contact_ID]
			  ,[Forename]
			  ,[Surname]
			  ,[Title]
			  ,[Gender_ID]
			  ,[First_Language_ID]
			  ,[Relationship]
			  ,[Relationship_HL7]
			  ,[Address1]
			  ,[Address2]
			  ,[Address3]
			  ,[Address4]
			  ,[Post_Code]
			  ,[Start_Date]
			  ,[End_Date]
			  ,[UpdatedDate]
		  FROM dbo.tmpmpiNewData123 tmp
		  LEFT JOIN [src].[vwCNS_NextOfKin] nk
			ON tmp.MH_Patient_ID = nk.Patient_ID
		WHERE nk.[UpdatedDate] IS NOT NULL 


	COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH;



GO
