SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE PROCEDURE [dbo].[uspDBS_Populate_Match_IDs]

AS 

DECLARE @sql VARCHAR(1000)
DECLARE @tblName varchar(100)
--DECLARE @Column varchar(100)
DECLARE @tblSchema varchar(100)

BEGIN TRY

	BEGIN TRANSACTION;

			DECLARE DBS_Columns CURSOR FOR
  
			SELECT TABLE_SCHEMA, TABLE_NAME
			FROM INFORMATION_SCHEMA.TABLES
			WHERE TABLE_NAME IN ('tblCNS_DBSTraceReturnedFile','tblADA_DBSTraceReturnedFile','tblCNC_DBSTraceReturnedFile'/*,'tblIAPT_DBSTraceReturnedFile'*/)
			AND TABLE_SCHEMA = 'src_DBS'
			ORDER BY TABLE_NAME
             
			OPEN DBS_Columns
 
			FETCH NEXT FROM DBS_Columns
			INTO @tblSchema, @tblName
 
			WHILE @@FETCH_STATUS = 0
			BEGIN 

				PRINT @tblName
				SET @sql = 'UPDATE ['+@tblSchema+'].['+@tblName+'] 	
							SET Match_ID = (SOUNDEX(REPLACE(REPLACE(REPLACE(UPPER(ISNULL(ReturnedForename, Forename)),'' '',''''),''-'',''''),'''''''','''')) 
											+ SOUNDEX(REPLACE(REPLACE(REPLACE(UPPER(ISNULL(ReturnSurname, Surname)),'' '',''''),''-'',''''),'''''''','''')) 
											+ CONVERT(VARCHAR(10),ISNULL(ReturnedDOB,DOB),112 ) 
											+ REPLACE(UPPER(ISNULL(Postcode,'''')),'' '','''')) 
							'
				PRINT @sql 
				EXEC (@sql)
 
			FETCH NEXT FROM DBS_Columns
			INTO  @tblSchema, @tblName
			END
			CLOSE DBS_Columns
			DEALLOCATE DBS_Columns

	COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH
GO
