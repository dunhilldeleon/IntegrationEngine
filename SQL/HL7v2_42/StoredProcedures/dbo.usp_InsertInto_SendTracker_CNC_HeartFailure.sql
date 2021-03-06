SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

 CREATE PROCEDURE [dbo].[usp_InsertInto_SendTracker_CNC_HeartFailure](
 @HeartFailureID varchar(50),
 @FailureReason varchar(2000),
 @TargetSystemID VARCHAR(50)
 )
 AS 


 /*
 IMPORTANT - THIS PROCEDURE IS CALLED FROM ENOVACOM INTEGRATION ENGINE
 */

 
DECLARE @cnt INT = 0


SET @cnt = (SELECT COUNT(*) FROM [dbo].[tblHL7_SendTracker_CNC_HeartFailure] WHERE HeartFailureID = @HeartFailureID)
	
IF @cnt = 0 
BEGIN 
	INSERT INTO  [dbo].[tblHL7_SendTracker_CNC_HeartFailure] (HeartFailureID, FailureReason, SendDttm, TargetSystemID) 
	VALUES ( @HeartFailureID, @FailureReason, GETDATE(), @TargetSystemID)
END 



--delete message resent successfully 
IF @FailureReason = '0'
 BEGIN
	UPDATE [dbo].[tblHL7_SendTracker_CNC_HeartFailure]
	SET FailureReason	= '0',
		TargetSystemID  = @TargetSystemID,
		SendDttm		=	GETDATE()
	WHERE HeartFailureID = @HeartFailureID
END 



GO
