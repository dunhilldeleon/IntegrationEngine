SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE PROCEDURE dbo.uspDBS_Update_Epmty_with_NULL

AS 

DECLARE @sql VARCHAR(1000)
DECLARE @tblName varchar(100)
DECLARE @Column varchar(100)
DECLARE @tblSchema varchar(100)

DECLARE DBS_Columns CURSOR FOR
  
SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN ('tblCNS_DBSTraceReturnedFile','tblADA_DBSTraceReturnedFile','tblCNC_DBSTraceReturnedFile','tblIAPT_DBSTraceReturnedFile')
AND TABLE_SCHEMA = 'src_DBS'
ORDER BY TABLE_NAME
             
OPEN DBS_Columns
 
FETCH NEXT FROM DBS_Columns
INTO @tblSchema, @tblName, @Column
 
WHILE @@FETCH_STATUS = 0
BEGIN 

	PRINT @tblName
	SET @sql = 'UPDATE ['+@tblSchema+'].['+@tblName+'] 	SET ['+@Column+'] = NULL 	WHERE ['+@Column+'] = '''' '
	PRINT @sql 
	EXEC (@sql)
 
FETCH NEXT FROM DBS_Columns
INTO  @tblSchema, @tblName, @Column
END
CLOSE DBS_Columns
DEALLOCATE DBS_Columns


GO
