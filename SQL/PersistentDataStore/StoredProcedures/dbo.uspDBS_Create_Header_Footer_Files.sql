SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE PROCEDURE [dbo].[uspDBS_Create_Header_Footer_Files](
@folder varchar(1000),
@dataSource VARCHAR(10),
@headerFooter VARCHAR(10)
)
AS

	IF @headerFooter IN ('header','footer') AND @dataSource IN ('CNS','CNC','ADA','PCMIS')
	BEGIN
		--DECLARE @folder varchar(1000) = '''\\mhoxbit01\Extracts\DBS\'
		DECLARE @filename varchar(100) =  CASE WHEN @dataSource = 'CNC' THEN 'CH_DBS_IE_Extract_'+@headerFooter+'.csv'
													WHEN @dataSource = 'CNS' THEN 'MH_DBS_IE_Extract_'+@headerFooter+'.csv'
													WHEN @dataSource = 'ADA' THEN 'ADA_DBS_IE_Extract_'+@headerFooter+'.csv'
													WHEN @dataSource = 'PCMIS' THEN 'PCMIS_DBS_IE_Extract_'+@headerFooter+'.csv'
											  END 
											
		DECLARE @SequenceNumber BIGINT = (SELECT MAX(ExtractID) FROM [dbo].[tblDBSExtractsAudit])
		DECLARE @sql varchar(max)
		DECLARE @cnt BIGINT 
		SET @cnt = CASE WHEN @dataSource = 'CNC' THEN (SELECT COUNT(*) FROM mrr.CNC_tblPatient)
						WHEN @dataSource = 'CNS' THEN (SELECT COUNT(*) FROM mrr.CNS_tblPatient)
						WHEN @dataSource = 'ADA' THEN (SELECT COUNT(*) FROM mrr.ADA_Patient)
						WHEN @dataSource = 'PCMIS' THEN (SELECT SUM(a.cnt) FROM (SELECT COUNT(*) cnt FROM [src].[vwPCMIS_Bucks_Demographics]
																				UNION 
																				SELECT COUNT(*) FROM [src].[vwPCMIS_Oxon_Demographics]) a
														)
					END 

		DECLARE @header VARCHAR(100) = '0001011RNU           DBS           '+REPLACE(CONVERT(VARCHAR,GETDATE(),108),':','')+CONVERT(VARCHAR(8),GETDATE(), 112)+'000'+CAST(@SequenceNumber AS VARCHAR)+CAST(@cnt AS VARCHAR)
		DECLARE @footer VARCHAR(100) = '990101RNU           DBS           '+REPLACE(CONVERT(VARCHAR,GETDATE(),108),':','')+CONVERT(VARCHAR(8),GETDATE(), 112)+'000'+CAST(@SequenceNumber AS VARCHAR)+CAST(@cnt AS VARCHAR)


			SET @sql = '
			DECLARE @filename VARCHAR(255) = '''+@folder+@filename+'''
			DECLARE   @Object int
			DECLARE   @rc int
			DECLARE   @FileID Int

			EXEC @rc = sp_OACreate ''Scripting.FileSystemObject'', @Object OUT
			EXEC @rc = sp_OAMethod @Object , ''OpenTextFile'' , @FileID OUT , @Filename , 2 , 1
			EXEC @rc = sp_OAMethod @FileID , ''WriteLine'' , Null , '''+ CASE WHEN @headerFooter = 'header' THEN @header ELSE @footer END +'''
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
    ELSE
	BEGIN
		RAISERROR ('HeaderFooter parameter should be either "header" or "footer", data source should be in ("CNS","CNC","ADA","PCMIS") ', 0, 1) --WITH NOWAIT
    END 

GO
