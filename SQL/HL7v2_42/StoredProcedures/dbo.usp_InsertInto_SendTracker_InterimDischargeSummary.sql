SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

 CREATE PROCEDURE [dbo].[usp_InsertInto_SendTracker_InterimDischargeSummary](
 @SourceSystem VARCHAR(5),
 @IntegratedDocumentID varchar(20),
 @FailureReason varchar(1000)
 )
 AS 


DECLARE @cnt INT = 0

 /*
 IMPORTANT - THIS PROCEDURE IS CALLED FROM ENOVACOM INTEGRATION ENGINE
 */
 

 --capture failed messages to resend
 --IF @FailureReason != '0'
 BEGIN
	SET @cnt = (SELECT COUNT(*) FROM [dbo].[tblHL7_SendTracker_InterimDischargeSummary] WHERE IntegratedDocumentID = @IntegratedDocumentID)
	
	IF @cnt = 0 
	BEGIN 
		INSERT INTO  [dbo].[tblHL7_SendTracker_InterimDischargeSummary] (SourceSystem, IntegratedDocumentID, FailureReason, SendDttm) 
		VALUES (@SourceSystem, @IntegratedDocumentID, @FailureReason, GETDATE())
	END 
END 


--delete message resent successfully 
IF @FailureReason = '0'
 BEGIN
	UPDATE  [dbo].[tblHL7_SendTracker_InterimDischargeSummary]
	SET FailureReason = '0'
	WHERE IntegratedDocumentID = @IntegratedDocumentID
END 
GO
