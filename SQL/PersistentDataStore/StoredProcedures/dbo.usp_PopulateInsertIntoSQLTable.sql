SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE PROCEDURE [dbo].[usp_PopulateInsertIntoSQLTable](
@tableSchema varchar(200),
@tableName varchar(200)
)


/*

TEST
======
EXEC [dbo].[usp_PopulateInsertIntoSQLTable] 'ORU_SRC','tblORU_OBX_Observation'

*/



AS
BEGIN

--DECLARE @tableName varchar(200) = 'tblORU_OBX_Observation'
--DECLARE @tableSchema varchar(200) = 'ORU_SRC'


DECLARE TablesCursor CURSOR FAST_FORWARD FOR 
SELECT column_name,data_type FROM information_schema.columns 
    WHERE table_name = @tableName

OPEN TablesCursor

DECLARE @string varchar(8000) --for storing the first half of INSERT statement
DECLARE @stringData varchar(8000) --for storing the data (VALUES) related statement
DECLARE @dataType varchar(1000) --data types returned for respective columns

SET @string='INSERT INTO '+@tableSchema+'.'+@tableName+'('
SET @stringData=''

DECLARE @colName varchar(150)

FETCH NEXT FROM TablesCursor INTO @colName,@dataType

IF @@fetch_status<>0
    BEGIN
    print 'Table '+@tableSchema+'.'+@tableName+' not found, processing skipped.'
    close TablesCursor
    deallocate TablesCursor
    return
END

WHILE @@FETCH_STATUS=0
BEGIN
IF @dataType in ('varchar','char','nchar','varchar')
BEGIN
    SET @stringData=@stringData+'''''''''+
	['+@colName+']+'''''',''+'
END
ELSE
if @dataType in ('text','ntext') --if the datatype 
                                 --is text or something else 
BEGIN
    SET @stringData=@stringData+'''''''''+
	isnull(cast('+@colName+' as varchar(2000)),'''')+'''''',''+'
END
ELSE
IF @dataType = 'money' --because money doesn't get converted from varchar implicitly
BEGIN
    SET @stringData=@stringData+'''convert(money,''''''+
	isnull(cast('+@colName+' as varchar(200)),''0.0000'')+''''''),''+'
END
ELSE 
IF @dataType='datetime'
BEGIN
    SET @stringData=@stringData+'''convert(datetime,''''''+
	isnull(cast('+@colName+' as varchar(200)),''0'')+''''''),''+'
END
ELSE 
IF @dataType='image' 
BEGIN
    SET @stringData=@stringData+'''''''''+
	isnull(cast(convert(varbinary,'+@colName+') 
	as varchar(6)),''0'')+'''''',''+'
END
ELSE --presuming the data type is int,bit,numeric,decimal 
BEGIN
    SET @stringData=@stringData+'''''''''+
	isnull(cast('+@colName+' as varchar(200)),''0'')+'''''',''+'
END

SET @string=@string+@colName+','


FETCH NEXT FROM TablesCursor INTO @colName,@dataType
END

CLOSE TablesCursor
DEALLOCATE TablesCursor


DECLARE @Query nvarchar(4000) -- provide for the whole query, 
                              -- you may increase the size
 
SET @query ='INSERT INTO dbo.tblInsertIntoScript SELECT * FROM (SELECT '''+substring(@string,0,len(@string)) + ') 
  VALUES(''+ ' + substring(@stringData,0,len(@stringData)-2)+'''+'')'' as script 
  FROM '+@tableSchema+'.'+@tableName+') a'

print @query

exec sp_executesql @query --load and run the built query 


END 

GO
