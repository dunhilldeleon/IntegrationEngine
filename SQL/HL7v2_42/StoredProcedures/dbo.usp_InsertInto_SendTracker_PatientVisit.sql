SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

 CREATE PROCEDURE [dbo].[usp_InsertInto_SendTracker_PatientVisit](
 @PV_ID VARCHAR(20),
 @ACKCode VARCHAR(2)
 )
 AS 

 DECLARE @cnt INT = 0

 /*
 IMPORTANT - THIS PROCEDURE IS CALLED FROM ENOVACOM INTEGRATION ENGINE
 */
 

 --capture failed messages to resend
 --IF @ACKCode != 'AA'
 BEGIN
	SET @cnt = (SELECT COUNT(*) FROM  [dbo].[tblHL7_SendTracker_PatientVisit] WHERE PV_ID = @PV_ID)
	
	IF @cnt = 0 
	BEGIN 
		INSERT INTO [dbo].[tblHL7_SendTracker_PatientVisit] ([SourceSystem],[PV_ID],[SendResult],[SendDttm]) 
			VALUES (   LEFT(@PV_ID,2)
					  ,@PV_ID
					  ,@ACKCode
					  ,GETDATE())
	END 
END 


--delete message resent successfully 
IF @ACKCode = 'AA'
 BEGIN
	UPDATE [dbo].[tblHL7_SendTracker_PatientVisit]
	SET [SendResult] = @ACKCode 
	WHERE PV_ID = @PV_ID
END 

GO
