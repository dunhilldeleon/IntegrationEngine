SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE PROCEDURE [dbo].[uspDBS_Load_Adastra_DBSFiles]
AS

DECLARE @sql VARCHAR(MAX)
DECLARE @cnt VARCHAR(10) = ISNULL((SELECT NumberOfRecord + 1 FROM [dbo].[tblDBSExtractsAudit] WHERE ExtractID = (SELECT MAX(ExtractID) FROM [dbo].[tblDBSExtractsAudit] WHERE DataSource = 'ADA') ),0)

SET @sql = '
BEGIN TRY
	BEGIN TRANSACTION;

	TRUNCATE TABLE [src_DBS].[tblADA_DBSTraceReturnedFile]

	BULK INSERT [src_DBS].[vwADA_DBSTraceReturnedFile]
			FROM ''\\mhoxbit01\Extracts\DBS\DBSResponse\ADA_DBS_IE_Extract_Final.csv''
			WITH
		(    --FORMATFILE= ''\\mhoxbit01\Extracts\DBS\DBS_Adstra.fmt''
		      CODEPAGE =  ''1252''
			, FIRSTROW = 2
			, LASTROW = '+@cnt+'
			,  FIELDTERMINATOR = ''","''
			, ROWTERMINATOR = ''0x0a''
		)
	COMMIT TRANSACTION

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH;
'
PRINT @sql 
EXEC (@sql)


GO
