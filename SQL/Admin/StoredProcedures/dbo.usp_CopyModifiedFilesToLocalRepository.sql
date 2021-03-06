SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE PROCEDURE [dbo].[usp_CopyModifiedFilesToLocalRepository] 

AS
BEGIN
 

 /*
 
 TEST
 ======

 EXEC [dbo].[usp_CopyModifiedFilesToLocalRepository] 
 */
 

    DECLARE @SrcFolder VARCHAR(1000)
	DECLARE @TrgtFolder VARCHAR(1000)
	DECLARE @command VARCHAR(4000)
	DECLARE @sql VARCHAR(4000)

	SET @command = ''
	DECLARE DatabaseName CURSOR FOR
  
	SELECT [Source], [Destination] FROM dbo.vw_PUSH_toGitHub

             
	OPEN DatabaseName
 
	FETCH NEXT FROM DatabaseName
	INTO @SrcFolder, @TrgtFolder
 
	WHILE @@FETCH_STATUS = 0
	BEGIN 
		
		SET @command = @command +  CHAR(10) + CHAR(13) + 'COPY  ' + @SrcFolder +' ' + @TrgtFolder +  CHAR(10) + CHAR(13) 
 
	FETCH NEXT FROM DatabaseName
	INTO  @SrcFolder, @TrgtFolder
	END
	CLOSE DatabaseName
	DEALLOCATE DatabaseName

	-- 

	SET @sql = '
	DECLARE @filename VARCHAR(255) = ''\\mhoxbit01\Extracts\CopyModifiedFilesToLocalRepository.bat''
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
