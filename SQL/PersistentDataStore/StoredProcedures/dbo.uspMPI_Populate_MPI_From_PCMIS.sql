SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE PROCEDURE [dbo].[uspMPI_Populate_MPI_From_PCMIS]

AS

BEGIN TRY

	BEGIN TRANSACTION;

	MERGE [dbo].[tblOH_MPI] AS mpi
		USING
			( SELECT DISTINCT pcmis.[Forename]
				  , pcmis.[Surname]
				  , pcmis.[Title]
				  , pcmis.[Date_Of_Birth]
				  , tmp.[NHS_Number]
				  , pcmis.[Gender_ID]
				  , pcmis.[Address1]
				  , pcmis.[Address2]
				  , pcmis.[Address3]
				  , pcmis.[Address4]
				  , pcmis.[Postcode]
				  , pcmis.[DateOfDeath]
				  , prac.Practice_Name			AS [PracticeName]
				  , pcmis.[PracticeCode]
				  , lang.External_Code2  PrimaryLanguage
				  , pcmis.[MaritalStatus]
				  , pcmis.[Ethnicity]
				  , pcmis.[Religion]
				  , tmp.CreatedDate				AS CreatedDate
				  , tmp.[UpdatedDate]
				  , tmp.source					AS	[UpdatedSourcesystem]
				  , GETDATE()					AS [updated_Dttm]
				  , pcmis.ValidNHSNumber
			  FROM [stg].[tblPCMIS_Demographics] pcmis 
				INNER JOIN [dbo].[tblMPI_IntegratedLatestPatientDemographics] tmp
					ON pcmis.NHS_Number = tmp.NHS_Number
					AND tmp.Source = 'PCMIS'
				LEFT JOIN mrr.CNS_tblPractice prac
					ON pcmis.PracticeCode = prac.Practice_Code
				LEFT JOIN ReferenceMappingTables.[dbo].[tblCareNotesPCMISLanguage] lang
					ON pcmis.MainLanguage = lang.PCMIS_Language_ID
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
					, mpi.[PracticeName]		= src.[PracticeName]
					, mpi.[PracticeCode]		= src.[PracticeCode]
					, mpi.[PrimaryLanguage]		= src.[PrimaryLanguage]
					, mpi.[MaritalStatus]		= src.[MaritalStatus]
					, mpi.[EthnicGroup]			= src.[Ethnicity]
					, mpi.[Religion]			= src.[Religion]
					, mpi.[CreatedDttm]			= src.[CreatedDate]
					, mpi.[UpdatedDttm]			= src.[UpdatedDate]
					--, mpi.[CH_Patient_ID]		= src.[CH_Patient_ID]
					, mpi.[UpdatedSourcesystem]	= src.[UpdatedSourcesystem]
					, mpi.[UpdatedEventCode]	= 'A28' --src.[UpdatedEventCode]
					, mpi.[MPI_Dttm]			= src.[updated_Dttm]
					, mpi.[ValidNHSNumber]		= src.[ValidNHSNumber]
           
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
					  ,[PracticeName]
					  ,[PracticeCode]
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
					  ,[ValidNHSNumber]
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
					 , src.[PracticeName]
					 , src.[PracticeCode]
					 , src.[PrimaryLanguage]
					 , src.[MaritalStatus]
					 , src.[Ethnicity]
					 , src.[Religion]
					 , src.[CreatedDate]
					 , src.[UpdatedDate]
					 --, src.[CH_Patient_ID]
					 , src.[UpdatedSourcesystem]
					 , 'A31' --src.[UpdatedEventCode]
					 , src.[updated_Dttm]
					 , src.[ValidNHSNumber]
				   );

				   	COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH
 


GO
