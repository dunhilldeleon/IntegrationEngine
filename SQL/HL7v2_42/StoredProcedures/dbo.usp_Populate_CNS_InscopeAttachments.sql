SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


CREATE PROCEDURE [dbo].[usp_Populate_CNS_InscopeAttachments]
AS

BEGIN TRY

	BEGIN TRANSACTION;

		TRUNCATE TABLE [dbo].[CNS_tblInscopeAttachments]

		INSERT INTO [dbo].[CNS_tblInscopeAttachments]
		SELECT [Attachment_ID]
			, [Attachment_File_ID]
			, [SourceSystem]
			, [Patient_ID]
			, [Practice_Code]
		FROM [dbo].[vwCNS_InscopeAttachment]

	COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH;

GO
