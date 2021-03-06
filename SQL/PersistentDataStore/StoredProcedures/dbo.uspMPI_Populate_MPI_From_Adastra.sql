SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE PROCEDURE [dbo].[uspMPI_Populate_MPI_From_Adastra]

AS

BEGIN TRY

	BEGIN TRANSACTION;

 	MERGE [dbo].[tblOH_MPI] AS mpi
		USING
			( SELECT DISTINCT ada.[Forename]
				  , ada.[Surname]
				  , ada.[Date_Of_Birth] 
				  , tmp.[NHS_Number]
				  , ada.[Gender] 
				  , ada.[Address1] 
				  , ada.[Address2]
				  , ada.[Address3]
				  , ada.[Address4]
				  , ada.[Postcode]
				  , ada.Practice_Code
				  , ada.[PrimaryLanguage]
				  , ada.[EthnicGroup]
				  , tmp.CreatedDate			AS CreatedDate
				  , tmp.[UpdatedDate]
				  , tmp.source				AS	[UpdatedSourcesystem]
				  , GETDATE()				AS Updated_Dttm
				  , ada.ValidNHSNumber
			  FROM [stg].[tblADA_Demographics] ada 
				INNER JOIN [dbo].[tblMPI_IntegratedLatestPatientDemographics] tmp
				ON ada.NHS_Number = tmp.NHS_Number COLLATE SQL_Latin1_General_CP1_CI_AS
				AND tmp.Source = 'ADA'
			) src
		ON mpi.[NHS_Number] = src.NHS_Number
		WHEN MATCHED THEN
			UPDATE SET
					  mpi.[Forename]			= src.[Forename]
					, mpi.[Surname]				= src.[Surname]
					, mpi.[Date_Of_Birth]		= src.[Date_Of_Birth]
					, mpi.[NHS_Number]			= src.[NHS_Number]
					, mpi.[Gender_ID]			= src.[Gender]
					, mpi.[Address1]			= src.[Address1]
					, mpi.[Address2]			= src.[Address2]
					, mpi.[Address3]			= src.[Address3]
					, mpi.[Address4]			= src.[Address4]
					, mpi.[Postcode]			= src.[Postcode]
					, mpi.PracticeCode			= src.Practice_Code
					, mpi.[PrimaryLanguage]		= src.[PrimaryLanguage]
					, mpi.[EthnicGroup]			= src.[EthnicGroup]
					, mpi.[CreatedDttm]			= src.[CreatedDate]
					, mpi.[UpdatedDttm]			= src.[UpdatedDate]
					, mpi.[UpdatedSourcesystem]	= src.[UpdatedSourcesystem]
					, mpi.[UpdatedEventCode]	= 'A28' 
					, mpi.[MPI_Dttm]			= src.[updated_Dttm]
					, mpi.[ValidNHSNumber]		= src.[ValidNHSNumber]
           
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (   [Forename]
					  ,[Surname]
					  ,[Date_Of_Birth]
					  ,[NHS_Number]
					  ,[Gender_ID]
					  ,[Address1]
					  ,[Address2]
					  ,[Address3]
					  ,[Address4]
					  ,[Postcode]
					  ,[PracticeCode]
					  ,[PrimaryLanguage]
					  ,[EthnicGroup]
					  ,[CreatedDttm]
					  ,[UpdatedDttm]
					  ,[UpdatedSourcesystem]
					  ,[UpdatedEventCode]
					  ,MPI_Dttm 
					  ,[ValidNHSNumber]
				)
			VALUES (   src.[Forename]
					 , src.[Surname]
					 , src.[Date_Of_Birth]
					 , src.[NHS_Number]
					 , src.[Gender]
					 , src.[Address1]
					 , src.[Address2]
					 , src.[Address3]
					 , src.[Address4]
					 , src.[Postcode]
					 , src.Practice_Code
					 , src.[PrimaryLanguage]
					 , src.[EthnicGroup]
					 , src.[CreatedDate]
					 , src.[UpdatedDate]
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
