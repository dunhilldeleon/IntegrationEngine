SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

 CREATE PROCEDURE [dbo].[usp_InsertInto_SendTracker_Attachment](
 @SourceSystem VARCHAR(5),
 @IntegratedDocumentID varchar(20),
 --@OHFT_Document_ID varchar(20),
 @Target_System_Doc_ID varchar(20)
 )
 AS 


 /*
 IMPORTANT - THIS PROCEDURE IS CALLED FROM ENOVACOM INTEGRATION ENGINE
 */
 
 
 INSERT INTO dbo.tblHL7_SendTracker_Attachment (SourceSystem, IntegratedDocumentID, /*Document_ID,*/ Target_System_Doc_ID) 
	VALUES (@SourceSystem, @IntegratedDocumentID, /*@OHFT_Document_ID,*/ @Target_System_Doc_ID)

GO
