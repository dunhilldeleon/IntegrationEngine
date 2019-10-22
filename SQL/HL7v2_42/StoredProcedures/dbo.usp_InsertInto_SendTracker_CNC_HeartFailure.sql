SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

 CREATE PROCEDURE [dbo].[usp_InsertInto_SendTracker_CNC_HeartFailure](
 @HeartFailureID varchar(20),
 @FailureReason varchar(1000)
 )
 AS 


 /*
 IMPORTANT - THIS PROCEDURE IS CALLED FROM ENOVACOM INTEGRATION ENGINE
 */

 
DECLARE @cnt INT = 0

IF @FailureReason != '0'
 BEGIN
	SET @cnt = (SELECT COUNT(*) FROM [dbo].[tblHL7_SendTracker_CNC_HeartFailure] WHERE HeartFailureID = @HeartFailureID)
	
	IF @cnt = 0 
	BEGIN 
		INSERT INTO  [dbo].[tblHL7_SendTracker_CNC_HeartFailure] (HeartFailureID, FailureReason, SendDttm) 
		VALUES ( @HeartFailureID, @FailureReason, GETDATE())
	END 
END 


--delete message resent successfully 
IF @FailureReason = '0'
 BEGIN
	DELETE FROM  [dbo].[tblHL7_SendTracker_CNC_HeartFailure]
	WHERE HeartFailureID = @HeartFailureID
END 
GO
