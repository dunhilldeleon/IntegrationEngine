SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE PROCEDURE [dbo].[uspMPI_Populate_tblCNC_Demographics]

AS


BEGIN TRY

	BEGIN TRANSACTION;

IF OBJECT_ID ('stg.tblCNC_Demographics','U')  IS NULL 
	BEGIN	
		CREATE TABLE [stg].[tblCNC_Demographics](
			[Patient_ID] [INT] NOT NULL,
			[Forename] [VARCHAR](50) NULL,
			[Surname] [VARCHAR](50) NULL,
			[Patient_Name] [VARCHAR](255) NULL,
			[Title] VARCHAR(10) NULL,
			[Date_Of_Birth] [DATETIME] NULL,
			[NHS_Number] [VARCHAR](11) PRIMARY Key,
			[Gender_ID] [INT] NULL,
			[Address1] [VARCHAR](255) NULL,
			[Address2] [VARCHAR](255) NULL,
			[Address3] [VARCHAR](255) NULL,
			[Address4] [VARCHAR](512) NULL,
			[Postcode] [VARCHAR](50) NULL,
			[AddressType] [INT] NULL,
			[Date_Of_Death] [DATETIME] NULL,
			[PracticeName] [VARCHAR](255) NULL,
			[PracticeCode] [VARCHAR](20) NULL,
			[GPCode] [VARCHAR](20) NULL,
			[GPName] [VARCHAR](201) NULL,
			[GPPrefix] [INT] NULL,
			[PrimaryLanguage] [VARCHAR](50) NULL,
			[MaritalStatus] VARCHAR(10) NULL,
			[EthnicGroup] VARCHAR(10) NULL,
			[Religion] VARCHAR(10) NULL,
			[CreatedDate] [DATETIME] NULL,
			[UpdatedDate] [DATETIME] NULL,
			[ValidNHSNumber] [VARCHAR](1) NULL
		) 
	END
	ELSE
    BEGIN
		TRUNCATE TABLE [stg].[tblCNC_Demographics]
    END 

		--inscope

		if OBJECT_ID ('dbo.tmpmpiCNCinscope','U') is not null 
		DROP TABLE dbo.tmpmpiCNCinscope

		;WITH Ad
		AS (
		   SELECT ROW_NUMBER() OVER (PARTITION BY Patient_ID ORDER BY Updated_Dttm DESC) AS rn
				, Patient_ID
				, Address1
				, Address2
				, Address3
				, Address4
				, Address5
				, Post_Code
				, Address_Type_ID
				, Updated_Dttm
		   FROM mrr.CNC_tblAddress-- mrr.CNC_tblAddress
		   WHERE Address_Confidential_Flag_ID = 0
		)
		   select p.NHS_Number 
			 , (
				   SELECT MAX(Updated_Dttm)
				   FROM
				   (
					   VALUES
						   (p.Updated_Dttm)
						 , (gpd.Updated_Dttm)
						 , (gp.Updated_Dttm)
						 , (pr.Updated_Dttm)
						 , (a.Updated_Dttm)
				   ) AS alldates (Updated_Dttm)
			   )     AS UpdatedDate
		into dbo.tmpmpiCNCinscope
		FROM mrr.CNC_tblPatient							   p 
			LEFT OUTER JOIN Ad                             a
				ON a.Patient_ID = p.Patient_ID
				   AND a.rn = 1
			LEFT OUTER JOIN mrr.CNC_tblGPDetail            gpd
				ON gpd.Patient_ID = p.Patient_ID
				   AND gpd.End_Date IS NULL
			LEFT OUTER JOIN mrr.CNC_tblGP                  gp
				ON gp.GP_ID = gpd.GP_ID
			LEFT OUTER JOIN mrr.CNC_tblPractice            pr
				ON pr.Practice_ID = gpd.Practice_ID
 			--inner join [dbo].[tblOH_MPI] mpi
				--on p.NHS_Number = mpi.NHS_Number
				--and (
		  --         SELECT MAX(Updated_Dttm)
		  --         FROM
		  --         (
		  --             VALUES
		  --                 (p.Updated_Dttm)
		  --               , (gpd.Updated_Dttm)
		  --               , (gp.Updated_Dttm)
		  --               , (pr.Updated_Dttm)
		  --               , (a.Updated_Dttm)
		  --         ) AS alldates (Updated_Dttm)
		  --     ) > mpi.UpdatedDttm
		 WHERE (
				   SELECT MAX(Updated_Dttm)
				   FROM
				   (
					   VALUES
						   (p.Updated_Dttm)
						 , (gpd.Updated_Dttm)
						 , (gp.Updated_Dttm)
						 , (pr.Updated_Dttm)
						 , (a.Updated_Dttm)
				   ) AS alldates (Updated_Dttm)
			   ) > ISNULL((SELECT MAX([MaxUpdateTime]) max_datetime FROM [dbo].[tblPDS_TableTracker] WHERE TABLE_NAME = 'tblOH_MPI'),'1 Jan 1900')  ;                             



		;WITH extMap AS 
		(
			SELECT   ECM.Internal_Data_Key ,ECMV.External_Code_Mapping_Context_Key,
					COALESCE(ECM.External_Code,
								ECMDS.External_Code_Mapping_Default_Value,
								ECMV.External_Code_Mapping_Default_Value) AS External_Code ,
					ECMDS.External_Code_Mapping_Data_Source_Key AS DataType
			FROM     mrr.CNC_tblExternalCodeMappingContextValues ECMV
					LEFT OUTER JOIN mrr.CNC_tblExternalCodeMappingDataSource ECMDS ON ECMV.External_Code_Mapping_Context_ID = ECMDS.External_Code_Mapping_Context_ID
					LEFT OUTER JOIN mrr.CNC_tblExternalCodeMapping ECM ON ECMDS.External_Code_Mapping_Data_Source_ID = ECM.External_Code_Mapping_Data_Source_ID
			WHERE      ECMV.External_Code_Mapping_Context_Key = 'MHMDS' 
			AND ECMDS.External_Code_Mapping_Data_Source_Key IN ('Gender')
		)
		INSERT INTO [stg].[tblCNC_Demographics](
			   [Patient_ID]
			  ,[Forename]
			  ,[Surname]
			  ,[Patient_Name]
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
			  ,[CreatedDate]
			  ,[UpdatedDate]
			  --,[ValidNHSNumber]
		)
		SELECT distinct [Patient_ID]
			  ,[Forename]
			  ,[Surname]
			  ,[Patient_Name]
			  , CASE WHEN Title_Desc LIKE 'D%R' THEN 'Dr'
					WHEN Title_Desc LIKE 'M%S%T%' THEN 'Master'
					WHEN Title_Desc LIKE 'Prof%' THEN 'Prof'
					WHEN Title_Desc LIKE '%REV%' THEN 'Rev'
					ELSE REPLACE(Title_Desc,'.','')  
				END  AS Title
			  ,[Date_Of_Birth]
			  ,cnc.[NHS_Number]
			  ,extMap.External_Code  AS 	[Gender]
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
			  ,[CreatedDate]
			  ,cnc.[UpdatedDate]
			  --, CASE WHEN dbo.udf_ValidateNHSNumber([NHS_Number]) = 0 THEN 'Y' ELSE 'N' END 
		  FROM [src].[vwCNC_Demographics] cnc
			LEFT JOIN extMap 
			ON extMap.Internal_Data_Key = cnc.Gender_ID
			AND extMap.DataType = 'Gender'
  			LEFT JOIN mrr.CNC_tblTitleValues ttl
				ON cnc.Title_ID = ttl.Title_ID
			  inner join dbo.tmpmpicncinscope inscope
			on cnc.NHS_Number = inscope.NHS_Number

		  WHERE LEN(cnc.[NHS_Number]) = 10 
		  --and cnc.NHS_Number = '7134563782'



		-- populate [ValidNHSNumber] column
		  update [stg].[tblCNC_Demographics]
		  set [ValidNHSNumber] = CASE WHEN dbo.udf_ValidateNHSNumber([NHS_Number]) = 0 THEN 'Y' ELSE 'N' END


	COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH


  if OBJECT_ID ('dbo.tmpmpiCNCinscope','U') is not null 
DROP TABLE dbo.tmpmpiCNCinscope
GO
