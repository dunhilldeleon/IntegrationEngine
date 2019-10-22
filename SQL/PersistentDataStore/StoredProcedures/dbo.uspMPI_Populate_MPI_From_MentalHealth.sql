SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE PROCEDURE [dbo].[uspMPI_Populate_MPI_From_MentalHealth]

AS

BEGIN TRY

	BEGIN TRANSACTION;

	MERGE [dbo].[tblOH_MPI] AS mpi
		USING
			( SELECT DISTINCT  CNS.[Forename]
				  , CNS.[Surname]
				  , CNS.[Title]
				  , CNS.[Date_Of_Birth]
				  , CNS.[NHS_Number]
				  , CNS.[Gender_ID]
				  , LEFT(CNS.[Address1], 100) AS [Address1]
				  , CNS.[Address2]
				  , CNS.[Address3]
				  , CNS.[Address4]
				  , CASE WHEN LEN(CNS.[Postcode]) > 10 THEN LTRIM(RTRIM(LEFT(CNS.[Postcode], 9))) ELSE  CNS.[Postcode] END AS [Postcode]
				  , CNS.[AddressType]
				  , CNS.[Date_Of_Death]
				  , CNS.[PracticeName]
				  , CNS.[PracticeCode]
				  , CNS.[GPCode]
				  , CNS.[GPName]
				  , CNS.[GPPrefix]
				  , CNS.[PrimaryLanguage]
				  , CNS.[MaritalStatus]
				  , CNS.[EthnicGroup]
				  , CNS.[Religion]
				  , tmp.CreatedDate				AS CreatedDate
				  , tmp.[UpdatedDate]
				  --, tmp.CH_PatientID			AS	[CH_Patient_ID]
				  , tmp.source					AS	[UpdatedSourcesystem]
				  , GETDATE()					AS updated_Dttm
			  FROM [stg].[tblCNS_Demographics] CNS
			  INNER JOIN [dbo].[tblMPI_IntegratedLatestPatientDemographics] tmp
				ON CNS.NHS_Number = tmp.NHS_Number
				AND tmp.Source = 'CNS'
			) src
		ON mpi.[NHS_Number] = src.NHS_Number
		WHEN MATCHED THEN
			UPDATE SET
					  mpi.[Forename]			= src.[Forename]
					, mpi.[Surname]				= src.[Surname]
					, mpi.[Title]				= src.[Title]
					, mpi.[Date_Of_Birth]		= src.[Date_Of_Birth]
					, mpi.[NHS_Number]			= src.[NHS_Number]
					, mpi.[Gender_ID]			= src.[Gender_ID]
					, mpi.[Address1]			= src.[Address1]
					, mpi.[Address2]			= src.[Address2]
					, mpi.[Address3]			= src.[Address3]
					, mpi.[Address4]			= src.[Address4]
					, mpi.[Postcode]			= src.[Postcode]
					, mpi.[AddressType]			= src.[AddressType]
					, mpi.[Date_Of_Death]		= src.[Date_Of_Death]
					, mpi.[PracticeName]		= src.[PracticeName]
					, mpi.[PracticeCode]		= src.[PracticeCode]
					, mpi.[GPCode]				= src.[GPCode]
					, mpi.[GPName]				= src.[GPName]
					, mpi.[GPPrefix]			= src.[GPPrefix]
					, mpi.[PrimaryLanguage]		= src.[PrimaryLanguage]
					, mpi.[MaritalStatus]		= src.[MaritalStatus]
					, mpi.[EthnicGroup]			= src.[EthnicGroup]
					, mpi.[Religion]			= src.[Religion]
					, mpi.[CreatedDttm]			= src.[CreatedDate]
					, mpi.[UpdatedDttm]			= src.[UpdatedDate]
					--, mpi.[CH_Patient_ID]		= src.[CH_Patient_ID]
					, mpi.[UpdatedSourcesystem]	= src.[UpdatedSourcesystem]
					, mpi.[UpdatedEventCode]	= 'A28' --src.[UpdatedEventCode]
					, mpi.[MPI_Dttm]			= src.[updated_Dttm]
           
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (   [Forename]
					  ,[Surname]
					  ,[Title]
					  ,[Date_Of_Birth]
					  ,[NHS_Number]
					  ,[Gender_ID]
					  ,[Address1]
					  ,[Address2]
					  ,[Address3]
					  ,[Address4]
					  ,[Postcode]
					  ,[AddressType]
					  ,[Date_Of_Death]
					  ,[PracticeName]
					  ,[PracticeCode]
					  ,[GPCode]
					  ,[GPName]
					  ,[GPPrefix]
					  ,[PrimaryLanguage]
					  ,[MaritalStatus]
					  ,[EthnicGroup]
					  ,[Religion]
					  ,[CreatedDttm]
					  ,[UpdatedDttm]
					  --,[CH_Patient_ID]
					  ,[UpdatedSourcesystem]
					  ,[UpdatedEventCode]
					  ,MPI_Dttm 
				)
			VALUES (   src.[Forename]
					 , src.[Surname]
					 , src.[Title]
					 , src.[Date_Of_Birth]
					 , src.[NHS_Number]
					 , src.[Gender_ID]
					 , src.[Address1]
					 , src.[Address2]
					 , src.[Address3]
					 , src.[Address4]
					 , src.[Postcode]
					 , src.[AddressType]
					 , src.[Date_Of_Death]
					 , src.[PracticeName]
					 , src.[PracticeCode]
					 , src.[GPCode]
					 , src.[GPName]
					 , src.[GPPrefix]
					 , src.[PrimaryLanguage]
					 , src.[MaritalStatus]
					 , src.[EthnicGroup]
					 , src.[Religion]
					 , src.[CreatedDate]
					 , src.[UpdatedDate]
					 --, src.[CH_Patient_ID]
					 , src.[UpdatedSourcesystem]
					 , 'A31' --src.[UpdatedEventCode]
					 , src.[updated_Dttm]
				   );

		  	COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH

GO
