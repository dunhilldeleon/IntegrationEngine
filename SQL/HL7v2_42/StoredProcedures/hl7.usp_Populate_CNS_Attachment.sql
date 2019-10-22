SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

-- To extract all Children who have had a 9-12 Month Review completed
-- This is found in the Child Health Module
-- The Row_NUmber SQL is to order the 9-12 Month Review by whether it has been completed and the date to make
-- sure only those completed and the first one of these for each child is extracted


CREATE PROCEDURE  [hl7].[usp_Populate_CNS_Attachment]
AS

/*
test Script:

EXEC [HL7].[usp_Populate_CNS_Attachment]


SELECT * FROM [chis].[tblCHIS_TableTracker] 

*/



BEGIN TRY

	BEGIN TRANSACTION;

		DECLARE @LoadId int = (SELECT ISNULL(MAX(LoadID),0) FROM [dbo].[tblHL7_TableTracker] WHERE TABLE_NAME = 'CNS_tblAttachment' AND SourceSystem = 'CNS')
		SET @LoadId = @LoadId + 1

		DELETE FROM att
		FROM [hl7].[tblAttachments] att
		INNER JOIN [dbo].[tblHL7_SendTracker_Attachment] tr
			ON att.[IntegratedDocumentID] = tr.[IntegratedDocumentID]
		WHERE att.[sourceSystem] = 'CNS'


		INSERT INTO [hl7].[tblAttachments](
				[Attachment_ID]
			  ,[Attachment_File_ID]
			  ,[UpdatedDate]
			  ,[sourceSystem]
			  ,[DocumentDate]
			  ,[MsgSender]
			  ,[MsgRecipient]
			  ,[IdType]
			  ,[IdValue]
			  ,[PersonNameType]
			  ,[Surname]
			  ,[Forename]
			  ,[Date_Of_Birth]
			  ,[Gender_ID]
			  ,[RecpHcpCode]
			  ,[RecpHcpDescription]
			  ,[RecpPracticeCode]
			  ,[RecpPracticeName]
			  ,[SendHCPCode]
			  ,[SendHCPDesc]
			  ,[SendDepartment]
			  ,[OrgCode]
			  ,[OrgName]
			  ,[DocumentID]
			  ,[ReportType]
			  ,[EventDate]
			  ,[EventDateEnd]
			  ,[DocCreationDate]
			  ,[Attachment_File_Name]
			  ,[Doc_Title]
			  ,[Attachment_File_Body]
			  ,[IntegratedDocumentID]
			  ,[FileExtension]
		)
		SELECT [Attachment_ID]
			  ,[Attachment_File_ID]
			  ,[UpdatedDate]
			  ,[sourceSystem]
			  ,[DocumentDate]
			  ,[MsgSender]
			  ,[MsgRecipient]
			  ,[IdType]
			  ,[IdValue]
			  ,[PersonNameType]
			  ,[Surname]
			  ,[Forename]
			  ,[Date_Of_Birth]
			  ,[Gender_ID]
			  ,[RecpHcpCode]
			  ,[RecpHcpDescription]
			  ,[RecpPracticeCode]
			  ,[RecpPracticeName]
			  ,[SendHCPCode]
			  ,[SendHCPDesc]
			  ,[SendDepartment]
			  ,[OrgCode]
			  ,[OrgName]
			  ,[DocumentID]
			  ,[ReportType]
			  ,[EventDate]
			  ,[EventDateEnd]
			  ,[DocCreationDate]
			  ,[Attachment_File_Name]
			  ,[Doc_Title]
			  ,[Attachment_File_Body]
			  ,[IntegratedDocumentID]
			  ,[FileExtension]
		  FROM [hl7].[vw_CNS_Attachment] att
		  WHERE NOT EXISTS ( SELECT 1 FROM [hl7].[tblAttachments] tr WHERE att.[IntegratedDocumentID] = tr.[IntegratedDocumentID])


		-- delete from Tracker table 
			DECLARE @NoOfRecords INT = @@ROWCOUNT

			IF @NoOfRecords > 0
			BEGIN 
				INSERT INTO [dbo].[tblHL7_TableTracker] 
					VALUES 
					(	  'CNS'
						, 'CNS_tblAttachment'
						, getdate() 
						, (SELECT ISNULL(MAX([MaxUpdateTime]),0) FROM [dbo].[tblHL7_TableTracker] WHERE TABLE_NAME = 'CNS_tblAttachment' AND SourceSystem = 'CNS')
						, @LoadId
						,@NoOfRecords
					)
			END 

	COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH

GO
