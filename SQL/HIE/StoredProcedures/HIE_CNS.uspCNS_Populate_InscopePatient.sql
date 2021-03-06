SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE PROCEDURE [HIE_CNS].[uspCNS_Populate_InscopePatient]
AS

/*
test Script:

EXEC HIE_CNS.uspCNS_Populate_InscopePatient

SELECT * FROM [chis].[tblCHIS_TableTracker] 

*/


SET NOCOUNT ON;

BEGIN TRY

	BEGIN TRANSACTION;

	TRUNCATE TABLE [HIE_CNS].[tblCNS_InscopePatient]

	INSERT INTO [HIE_CNS].[tblCNS_InscopePatient]
	SELECT   [PatientNo]
	FROM [HIE_CNS].[vwCNS_InscopePatient] 

	COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH

 
GO
