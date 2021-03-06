SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE PROCEDURE [dbo].[usp_CreateInsertIntoSQLFile](
@folder varchar(1000),
@filename varchar(100)
)

AS
BEGIN
 

 /*
 
 TEST
 ======

 EXEC [dbo].[usp_CreateInsertIntoSQLFile] '\\mhoxbit01\Extracts\','InsertIntoBloodResults'
 */
 
	DECLARE @Script VARCHAR(max)
	DECLARE @command VARCHAR(max)
	DECLARE @sql varchar(max)

	SET @command = 'BEGIN TRY
	BEGIN TRANSACTION;	
	
	'
	DECLARE TableName CURSOR FOR
  
	SELECT replace(replace(script,'''',''''''),'"','') as script FROM dbo.tblInsertIntoScript

             
	OPEN TableName
 
	FETCH NEXT FROM TableName
	INTO @Script
 
	WHILE @@FETCH_STATUS = 0
	BEGIN 
		
		SET @command = @command +   @Script +  CHAR(10) + CHAR(13) 
 
	FETCH NEXT FROM TableName
	INTO  @Script
	END
	CLOSE TableName
	DEALLOCATE TableName


	SET @command = @command + '	COMMIT TRANSACTION; 


	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
			THROW;
	END CATCH;'
	
	

	SET @sql = '
	DECLARE @filename VARCHAR(255) = '+@folder+@filename+'_'+CONVERT(varchar,getdate(),112)+'.sql''
    DECLARE   @Object int
    DECLARE   @rc int
    DECLARE   @FileID Int

    EXEC @rc = sp_OACreate ''Scripting.FileSystemObject'', @Object OUT
    EXEC @rc = sp_OAMethod @Object , ''OpenTextFile'' , @FileID OUT , @Filename , 2 , 1
    EXEC @rc = sp_OAMethod @FileID , ''WriteLine'' , Null , '''+ @command+'''
    EXEC @rc = dbo.sp_OADestroy @FileID

    DECLARE @Append BIT 

    SELECT  @Append = 0

    IF  @rc <> 0
    BEGIN 
        EXEC  @rc = dbo.sp_OAMethod @Object, ''SaveFile'',null,'' '' ,@Filename,@Append
    END 

    EXEC  @rc = dbo.sp_OADestroy @Object'

	PRINT (@sql)
	EXEC (@sql)

END 

GO
