BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Generate Blood Results  Inset into .sql file', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'OBMH\SVC_Enovacom', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Generate INSERT INTO script', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=4, 
		@on_fail_step_id=4, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'
if OBJECT_ID(''dbo.tblInsertIntoScript'',''U'') IS NULL
BEGIN

	CREATE TABLE [dbo].[tblInsertIntoScript](
		[script] [varchar](2850) NULL
	) 
END
ELSE
BEGIN
	TRUNCATE TABLE dbo.tblInsertIntoScript
END 

exec [dbo].[usp_PopulateInsertIntoSQLTable] ''ORU_SRC'', ''tblORU_NTE_Notes''
go
exec [dbo].[usp_PopulateInsertIntoSQLTable] ''ORU_SRC'', ''tblORU_OBR_ObservationRequest''
go
exec [dbo].[usp_PopulateInsertIntoSQLTable] ''ORU_SRC'', ''tblORU_OBR_OrderingDoctors''
go
exec [dbo].[usp_PopulateInsertIntoSQLTable] ''ORU_SRC'', ''tblORU_OBX_Observation''
go
exec [dbo].[usp_PopulateInsertIntoSQLTable] ''ORU_SRC'', ''tblORU_ORC_CommonOrder''
go
exec [dbo].[usp_PopulateInsertIntoSQLTable] ''ORU_SRC'', ''tblORU_PatientResults''
go
exec [dbo].[usp_PopulateInsertIntoSQLTable] ''ORU_SRC'', ''tblORU_PV1_PatientVisitDoctors''
go
exec [dbo].[usp_PopulateInsertIntoSQLTable] ''ORU_SRC'', ''tblORU_PV1_PatientVisits''

', 
		@database_name=N'PersistentDataStore', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Delete existing .sql file', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=4, 
		@on_fail_step_id=4, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'DEL \\mhoxbit01\Extracts\ORUBloodResult\SQLFiles\*.sql /F', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Generate .sql file', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=4, 
		@on_fail_step_id=4, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'

 EXEC [dbo].[usp_CreateInsertIntoSQLFile] ''\\mhoxbit01\Extracts\ORUBloodResult\SQLFiles\'' ,''InsertIntoBloodResults''', 
		@database_name=N'PersistentDataStore', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Email when fail', 
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=2, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DECLARE @tableHTML  NVARCHAR(MAX) ;  

SET @tableHTML =  ''Dear Integration Engine Admin,
				<br></br>
				<b>The Generate INSERT INTO .sql file for Blood Result  job has failed. Please investigate. </b>
				''

EXEC msdb.dbo.sp_send_dbmail 
	@profile_name = ''Integration Engine Data Load'',
	@recipients= ''IEDev@oxfordhealth.nhs.uk'',  
	@subject = ''Generate INSERT INTO .sql file for Blood Result  job has failed'',  
	@body = @tableHTML,  
	@body_format = ''HTML'' ;', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

