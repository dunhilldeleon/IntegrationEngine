SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

 CREATE PROCEDURE [dbo].[usp_InsertInto_SendTracker_Attachment](
 @SourceSystem VARCHAR(5),
 @IntegratedDocumentID varchar(50),
 @TargetSystemID varchar(20),
 @FailureReason varchar(2000)
 )
 AS 


 /*
 IMPORTANT - THIS PROCEDURE IS CALLED FROM ENOVACOM INTEGRATION ENGINE
 */
 
 
DECLARE @cnt INT 
SET @cnt = (SELECT COUNT(*) FROM dbo.tblHL7_SendTracker_Attachment WHERE IntegratedDocumentID = @IntegratedDocumentID AND SourceSystem = @SourceSystem)
	
IF @cnt = 0 
BEGIN 
	INSERT INTO  dbo.tblHL7_SendTracker_Attachment (SourceSystem, IntegratedDocumentID, FailureReason, SendDttm, TargetSystemID) 
	VALUES (@SourceSystem, @IntegratedDocumentID, @FailureReason, GETDATE(), @TargetSystemID)
END 


IF @FailureReason = '0'
 BEGIN
	UPDATE  dbo.tblHL7_SendTracker_Attachment
	SET FailureReason = '0',
	TargetSystemID  = @TargetSystemID,
	SendDttm		  =	GETDATE()
	WHERE IntegratedDocumentID = @IntegratedDocumentID
	AND SourceSystem = @SourceSystem
END 

GO
