SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE PROCEDURE [dbo].[usp_Transfer_InOut_SendEmail_V2]
AS


/*
Development Comments:
======================
This procedure is called from the Integration engine (within Transport CHIS CPOut csv scenario).
The purpose of this proedure is to send HealthVisitor Transfer In and Out data receieved from CHIS to all HV teams.
IMPORTANT - please note this procedure uses the table [dbo].[tblPractice_HealthVisitor_Mapping] to identify the HV and HV email using practice codes. 
			The mapping table is produced by Claire Elms and Nicola Taylor. 


*/

DECLARE @sql VARCHAR(max)
DECLARE @HVName varchar(100)
DECLARE @HVEmail varchar(100)
DECLARE @PracticeCode varchar(100)

DECLARE @tableHTML  NVARCHAR(MAX) 

  
DECLARE HealthVisitor_Email CURSOR FOR
  
SELECT DISTINCT REPLACE(HV_email,' ','') AS HV_email
FROM dbo.tblHealthVisitorsDetails
WHERE ISNULL(HV_email,'') <> ''
             
OPEN HealthVisitor_Email
 
FETCH NEXT FROM HealthVisitor_Email
INTO  @HVEmail  
 
WHILE @@FETCH_STATUS = 0
BEGIN 

DECLARE @cnt int = 0
SET @cnt = (	SELECT COUNT(*) 
				FROM [src_CHIS].[tblCHIS_CPOut] main
				LEFT JOIN dbo.tblHealthVisitorsDetails crntHV
					ON main.Current_Associated_HV_Code = crntHV.HV_Code
				LEFT JOIN dbo.tblHealthVisitorsDetails PrevHV
					ON main.Previous_Associated_HV_Code  = PrevHV.HV_Code
				WHERE main.EmailSent IS NULL 
				AND REPLACE(ISNULL(crntHV.[HV_email],PrevHV.[HV_email]),' ','') = REPLACE(@HVEmail,' ','') 
			)
					
IF ISNULL(@cnt,0) > 0
BEGIN 
	SET @sql = ' BEGIN TRY
 
						DECLARE @tableHTML  NVARCHAR(MAX) ; 
						SET @tableHTML =  
							''Dear Team,
						<br></br>
						<b>Do not reply to this email.</b>
						<br></br>
						We are pleased to announce the introduction of a daily demographic change report.  This will provide you with the most timely information about your 0-5 population and will include information on movements in to area, movements out of area and information on changes including addresses and names etc.  You will receive daily with effect from Wednesday 04/09/2019, which will detail demographic changes made to the CHIS system.  
						<br></br>
						The report will be split into two sections – Previous details and Current details – with any changes indicated by data items being populated in the Current section (if any of the fields in the Current section are blank it means that no change has occurred) – please refer to the guide and SOPs sent under separate cover.
						<br></br>
						<font color="red"> The table you will receive will provide you with details of movements in and out that have been made by the CHIS team in your system. The spreadsheet will also provide details of other changes; address, name, date of birth etc. which will not have been made in your system by the CHIS team. </font>
						<br></br>
						For children who are noted on the spreadsheet as moving out of your area please arrange for CHIS to receive any electronic notes.  For those moving in – CHIS will have already requested notes and will forward them to you as soon as we receive them.  
						<br></br>
						This is a really exciting development enabling CHIS to keep us fully updated about our 0-5 population.  
						<br></br>
						<b>Please find the list of this week transfer below:</b>
						<br></br>
						''
						+   N''<table border="1">'' +  
							N''<tr><tr><th>Previous_NHSNumber</th><th>Previous_Date_of_Birth</th><th>Previous_Surname</th><th>Previous_Forename</th><th>Previous_Gender</th><th>Previous_Address_Line_1</th><th>Previous_Address_Line_2</th><th>Previous_Address_Line_3</th><th>Previous_Address_Line_4</th><th>Previous_Address_Line_5</th><th>Previous_Postcode</th><th>Previous_GP_Practice</th><th>Previous_CCG</th><th>Previous_Local_Authority_Code</th><th>Previous_Trust_ODS_Code</th><th>Previous_Associated_HV_Code</th><th>Current_NHSNumber</th><th>Current_Date_of_Birth</th><th>Current_Surname</th><th>Current_Forename</th><th>Current_Gender</th><th>Current_Address_Line_1</th><th>Current_Address_Line_2</th><th>Current_Address_Line_3</th><th>Current_Address_Line_4</th><th>Current_Address_Line_5</th><th>Current_Postcode</th><th>Date_of_Address_Update</th><th>Current_GP_Practice_Code</th><th>Date_of_GP_Practice_Registration</th><th>Current_CCG_Code</th><th>Current_Local_Authority</th><th>Current_Trust_ODS_Code</th><th>Current_Associated_HV_Code</th>'' +   
						CAST ( ( SELECT   DISTINCT
									td = ISNULL([Previous_NHSNumber],'' ''), '''',
									td = ISNULL([Previous_Date_of_Birth],'' ''), '''',
									td = ISNULL([Previous_Surname],'' ''), '''',
									td = ISNULL([Previous_Forename],'' ''), '''',
									td = ISNULL([Previous_Gender],'' ''), '''',
									td = ISNULL([Previous_Address_Line_1],'' ''), '''',
									td = ISNULL([Previous_Address_Line_2],'' ''), '''',
									td = ISNULL([Previous_Address_Line_3],'' ''), '''',
									td = ISNULL([Previous_Address_Line_4],'' ''), '''',
									td = ISNULL([Previous_Address_Line_5],'' ''), '''',
									td = ISNULL([Previous_Postcode],'' ''), '''',
									td = ISNULL([Previous_GP_Practice],'' ''), '''',
									td = ISNULL([Previous_CCG],'' ''), '''',
									td = ISNULL([Previous_Local_Authority_Code],'' ''), '''',
									td = ISNULL([Previous_Trust_ODS_Code],'' ''), '''',
									td = ISNULL([Previous_Associated_HV_Code],'' ''), '''',
									td = ISNULL([Current_NHSNumber],'' ''), '''',
									td = ISNULL([Current_Date_of_Birth],'' ''), '''',
									td = ISNULL([Current_Surname],'' ''), '''',
									td = ISNULL([Current_Forename],'' ''), '''',
									td = ISNULL([Current_Gender],'' ''), '''',
									td = ISNULL([Current_Address_Line_1],'' ''), '''',
									td = ISNULL([Current_Address_Line_2],'' ''), '''',
									td = ISNULL([Current_Address_Line_3],'' ''), '''',
									td = ISNULL([Current_Address_Line_4],'' ''), '''',
									td = ISNULL([Current_Address_Line_5],'' ''), '''',
									td = ISNULL([Current_Postcode],'' ''), '''',
									td = ISNULL([Date_of_Address_Update],'' ''), '''',
									td = ISNULL([Current_GP_Practice_Code],'' ''), '''',
									td = ISNULL([Date_of_GP_Practice_Registration],'' ''), '''',
									td = ISNULL([Current_CCG_Code],'' ''), '''',
									td = ISNULL([Current_Local_Authority],'' ''), '''',
									td = ISNULL([Current_Trust_ODS_Code],'' ''), '''',
									td = ISNULL([Current_Associated_HV_Code],'' ''), ''''

								FROM [src_CHIS].[tblCHIS_CPOut] main
								LEFT JOIN dbo.tblHealthVisitorsDetails crntHV
									ON main.Current_Associated_HV_Code = crntHV.HV_Code
								LEFT JOIN dbo.tblHealthVisitorsDetails PrevHV
									ON main.Previous_Associated_HV_Code  = PrevHV.HV_Code
								WHERE main.EmailSent IS NULL 
								AND REPLACE(ISNULL(crntHV.[HV_email],PrevHV.[HV_email]),'' '','''') = '''+REPLACE(@HVEmail,' ','')+''' 
											  FOR XML PATH(''tr''), TYPE   
							) AS NVARCHAR(MAX) ) +  
							N''</table>'' 
							+
							''
						 	<br></br>
							Kind regards,

						'';  

						EXEC msdb.dbo.sp_send_dbmail 
							@profile_name = ''OHFT noreply'',
							@recipients='''+REPLACE(@HVEmail,' ','')+''',  
							@subject = ''OHFT Transfer in/Out weekly report'',  
							@body = @tableHTML,  
							@body_format = ''HTML'' ;  

			    
							UPDATE [src_CHIS].[tblCHIS_CPOut]
							SET [EmailSent] = 1,
								[EmailSent_Dttm] = GETDATE(),
								[EmailSentTo] = '''+REPLACE(@HVEmail,' ','')+'''
							FROM [src_CHIS].[tblCHIS_CPOut] main
							LEFT JOIN dbo.tblHealthVisitorsDetails crntHV
								ON main.Current_Associated_HV_Code = crntHV.HV_Code
							LEFT JOIN dbo.tblHealthVisitorsDetails PrevHV
								ON main.Previous_Associated_HV_Code  = PrevHV.HV_Code
							WHERE main.EmailSent IS NULL 
							AND REPLACE(ISNULL(crntHV.[HV_email],PrevHV.[HV_email]),'' '','''') = '''+REPLACE(@HVEmail,' ','')+''' 
				

				END TRY
				BEGIN CATCH  
					throw;
				END CATCH; 
				'
		PRINT @sql 

		EXEC (@sql)
END

FETCH NEXT FROM HealthVisitor_Email
INTO  @HVEmail -- @PracticeCode, @HVName,  
END
CLOSE HealthVisitor_Email
DEALLOCATE HealthVisitor_Email

GO
