SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE PROCEDURE [dbo].[usp_Populate_NextOfKin]
AS
BEGIN

BEGIN TRY

	BEGIN TRANSACTION;

    TRUNCATE TABLE hl7.NextOfKin;


    INSERT INTO hl7.NextOfKin
    (
        MPI_ID
      , Contact_ID
      , Forename
      , Surname
      , Title
      , Gender
      , PrimaryLanguage
      , Relationship
      , Address1
      , Address2
      , Address3
      , Address4
      , Postcode
      , StartDate
      , EndDate
      , Updated_Dttm
    )
	SELECT  nk.[MPI_ID]
		  , nk.[Contact_ID]
		  , nk.[Forename]
		  , nk.[Surname]
		  , nk.[Title]
		  , nk.[Gender]
		  , nk.[PrimaryLanguage]
		  , nk.[Relationship_HL7]
		  , nk.[Address1]
		  , nk.[Address2]
		  , nk.[Address3]
		  , nk.[Address4]
		  , nk.[Postcode]
		  , nk.[StartDate]
		  , nk.[EndDate]
		  , nk.[Updated_Dttm]
	  FROM [PersistentDataStore].[dbo].[tblOH_MPI_NextOfKin] nk
	  	INNER JOIN [hl7].[Demographic] d --[PersistentDataStore].dbo.tblOH_MPI mpi
		ON nk.MPI_ID = d.MPI_ID

	COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH


END;

GO
