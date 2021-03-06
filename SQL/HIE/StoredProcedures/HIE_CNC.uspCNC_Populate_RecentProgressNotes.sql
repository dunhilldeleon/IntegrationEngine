SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE PROCEDURE [HIE_CNC].[uspCNC_Populate_RecentProgressNotes]
AS
 
/*
test Script:

EXEC [HIE_CNC].[uspCNC_Populate_RecentProgressNotes]

--select * from  [HIE_CNC].[tblCNC_RecentProgressNotes]

select * from [dbo].[TableTracker]

*/



DECLARE @ExtractDate DATETIME = GETDATE();

DECLARE @Max_Date DATETIME

SET @Max_Date = ISNULL((SELECT MAX(MaxUpdateTime)  FROM [dbo].[TableTracker] WHERE TABLE_NAME = 'tblCNC_RecentProgressNotes'),'1 Jan 1900')

DECLARE @LoadId int = ISNULL((SELECT MAX(LoadID)  FROM [dbo].[TableTracker] WHERE TABLE_NAME = 'tblCNC_RecentProgressNotes'),0)
SET @LoadId = @LoadId + 1

SET NOCOUNT ON;

BEGIN TRY

	BEGIN TRANSACTION;

	TRUNCATE TABLE [HIE_CNC].[tblCNC_RecentProgressNotes]

	INSERT INTO [HIE_CNC].[tblCNC_RecentProgressNotes]
	SELECT   [SpecialNotesID]
			,[PatientID]
			,[UpdatedDate]
			,[Order]
			,[CreateTime]
			,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE([Notes], CHAR(13),''),CHAR(10),''),'?',''),'>',''),'&',''),'<',''),'*',''),'!',''),'^',''),'$',''),'(',''),')',''),'"',''),'£',''),'%','') AS  [Notes] 
			,[Deleted]
			, 0 AS [ContainsInvalidChar]
			, @LoadId
	FROM [HIE_CNC].[vwCNC_RecentProgressNotes]
	WHERE [UpdatedDate] > @Max_Date

	
	-- delete from Tracker table 
	DECLARE @newRecords INT = @@ROWCOUNT

	--SET @newRecords = (SELECT COUNT(*) FROM [HIE_CNC].[tblCNC_RecentProgressNotes] WHERE LoadID = @LoadId)

	IF @newRecords > 0
	BEGIN 
		INSERT INTO [dbo].[TableTracker] VALUES ('HIE_CNC', 'tblCNC_RecentProgressNotes',@ExtractDate, (SELECT ISNULL(MAX([UpdatedDate]),GETDATE()) FROM [HIE_CNC].[tblCNC_RecentProgressNotes]), @LoadId, @newRecords)
	END

	COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH

 
GO
