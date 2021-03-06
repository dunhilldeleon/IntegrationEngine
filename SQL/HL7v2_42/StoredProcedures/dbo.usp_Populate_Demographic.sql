SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE PROCEDURE [dbo].[usp_Populate_Demographic]
AS
BEGIN


DECLARE @Max_Date DATETIME = ISNULL((SELECT MAX([MaxUpdateTime]) FROM [dbo].[tblHL7_TableTracker] WHERE TABLE_NAME = 'Demographic'),'1 Jan 1900')
--PRINT @Max_Date

DECLARE @LoadId int = ISNULL((SELECT MAX(LoadID) FROM [dbo].[tblHL7_TableTracker]  WHERE TABLE_NAME = 'Demographic'),0)
SET @LoadId = @LoadId + 1


--SET NOCOUNT ON;

BEGIN TRY

	BEGIN TRANSACTION;

    TRUNCATE TABLE hl7.Demographic;

    INSERT INTO hl7.Demographic
    (
        MPI_ID
      , Forename
      , Surname
      , Title
      , DateOfBirth
      , NHSNumber
      , Gender
      , Address1
      , Address2
      , Address3
      , Address4
      , Postcode
      , AddressType
      , DateOfDeath
      , PracticeName
      , PracticeCode
      , GPCode
      , GPName
      , GPPrefix
      , PrimaryLanguage
      , MaritalStatus
      , EthnicGroup
      , Religion
      , CreatedDttm
      , UpdatedDttm
      , UpdatedEventCode
      , UpdatedSourcesystem
    )
    SELECT MPI_ID
         , Forename
         , Surname
         , Title
         , TRY_CONVERT(BIGINT, IIF(Date_Of_Birth IS NULL
                                 , NULL
                                 , CONCAT(
                                             DATEPART(YEAR, Date_Of_Birth)
                                           , RIGHT(CONCAT('00', DATEPART(MONTH, Date_Of_Birth)), 2)
                                           , RIGHT(CONCAT('00', DATEPART(DAY, Date_Of_Birth)), 2)
                                         ))) AS Date_Of_Birth
         , NHS_Number
         , Gender_ID
         , Address1
         , Address2
         , Address3
         , Address4
         , Postcode
         , AddressType
         , TRY_CONVERT(BIGINT, IIF(Date_Of_Death IS NULL
                                 , NULL
                                 , CONCAT(
                                             DATEPART(YEAR, Date_Of_Death)
                                           , RIGHT(CONCAT('00', DATEPART(MONTH, Date_Of_Death)), 2)
                                           , RIGHT(CONCAT('00', DATEPART(DAY, Date_Of_Death)), 2)
                                         ))) AS Date_Of_Death
         , PracticeName
         , PracticeCode
         , GPCode
         , GPName
         , GPPrefix
         , PrimaryLanguageCode
         , MaritalStatus
         , EthnicGroup
         , Religion
         , TRY_CONVERT(DATETIME2, CreatedDttm)
         , TRY_CONVERT(DATETIME2, UpdatedDttm)
         , UpdatedEventCode
         , UpdatedSourcesystem
    FROM PersistentDataStore.dbo.tblOH_MPI
    WHERE [UpdatedDttm] > @Max_Date 

	DECLARE @NoOfRecords INT = @@ROWCOUNT

	IF @NoOfRecords > 0 
	BEGIN 
		INSERT INTO [dbo].[tblHL7_TableTracker] ([SourceSystem], [TABLE_NAME], [ExtractDate], [MaxUpdateTime], [LoadID], NoRecords)
		VALUES ( 'MPI', 'Demographic', GETDATE(), (SELECT MAX(UpdatedDttm) FROM [hl7].[Demographic]), @LoadID, @NoOfRecords)
	END 

	COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH


END;

GO
