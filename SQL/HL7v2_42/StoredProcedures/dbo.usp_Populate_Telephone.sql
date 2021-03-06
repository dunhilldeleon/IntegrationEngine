SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE PROCEDURE [dbo].[usp_Populate_Telephone]
AS
BEGIN

BEGIN TRY

	BEGIN TRANSACTION;

		TRUNCATE TABLE hl7.TelephoneDetails;


		INSERT INTO [hl7].[TelephoneDetails]
		(
			 [MPI_ID]
			,[NokContact_ID]
			,[Telephone_Number]
			,[PhoneType]
			,[UseCode]
			,[ContactRole]
			,[Updated_Dttm]
			,[Main_Number_Flag]
		)
		SELECT 
			  fd.[MPI_ID]
			, fd.[NokContact_ID]
			, fd.[Telephone_Number]
			, fd.[PhoneTypeCode] AS [PhoneType]
			, fd.[UseCode]
			, fd.[ContactRole]
			, d.[UpdatedDttm]
			, fd.[Main_Number_Flag]
		FROM [PersistentDataStore].[dbo].[tblOH_MPI_TelephoneDetails] fd
		INNER JOIN [hl7].[Demographic] d 
			ON fd.MPI_ID = d.MPI_ID

	COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH

END;

GO
