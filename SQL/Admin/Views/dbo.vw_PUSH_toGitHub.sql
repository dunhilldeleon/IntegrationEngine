SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE  VIEW vw_PUSH_toGitHub 
AS


SELECT * 
, '"\\Mhoxbit01\e$\SQLObjectBackups\MHOXBIT01\'+ CONVERT(VARCHAR, GETDATE(), 112)+'\'+[Database] +'\'+CASE WHEN ObjectType = 'SQL_STORED_PROCEDURE' THEN 'StoredProcedures\'
	 WHEN ObjectType = 'USER_TABLE' THEN 'Tables\'
	 WHEN ObjectType = 'VIEW' THEN 'Views\'
	 WHEN ObjectType = 'SQL_SCALAR_FUNCTION' THEN 'UserDefinedFunctions\'
	 ELSE ''
END + CASE WHEN ObjectType != 'Jobs' THEN [Schema]+'.' ELSE '' END + ObjectName +'.sql"' AS [Source]
, '"\\Mhoxbit01\e$\GitHubRepository\IntegrationEngine\SQL\'+ [Database]  +'\'+CASE WHEN ObjectType = 'SQL_STORED_PROCEDURE' THEN 'StoredProcedures\'
	 WHEN ObjectType = 'USER_TABLE' THEN 'Tables\'
	 WHEN ObjectType = 'VIEW' THEN 'Views\'
	 WHEN ObjectType = 'SQL_SCALAR_FUNCTION' THEN 'UserDefinedFunctions\'
	 ELSE ''
END +CASE WHEN ObjectType != 'Jobs' THEN [Schema]+'.' ELSE '' END + ObjectName + '.sql"'AS [Destination]
FROM dbo.tblObjects_ToPushToGitHub
WHERE ObjectName NOT LIKE 'tmp%'


GO
