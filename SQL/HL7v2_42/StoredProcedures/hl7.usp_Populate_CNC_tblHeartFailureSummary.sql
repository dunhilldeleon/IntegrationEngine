SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


CREATE PROCEDURE  [hl7].[usp_Populate_CNC_tblHeartFailureSummary]
AS

/*
test Script:

EXEC [HL7].[usp_Populate_CNC_HeartFailureSummary]


SELECT * FROM [dbo].[tblHL7_TableTracker]
 WHERE TABLE_NAME = 'CNC_tblHeartFailureSummary'

*/

	DECLARE @LoadId int = ISNULL((SELECT MAX(LoadID) FROM [dbo].[tblHL7_TableTracker] WHERE TABLE_NAME = 'CNC_tblHeartFailureSummary' AND SourceSystem = 'CNC'),0)
	SET @LoadId = @LoadId + 1

	DECLARE @MaxDate DATETIME = ISNULL((SELECT MAX(MaxUpdateTime) FROM [dbo].[tblHL7_TableTracker] WHERE TABLE_NAME = 'CNC_tblHeartFailureSummary' AND SourceSystem = 'CNC'),'1 Jan 1900')
	PRINT @MaxDate

BEGIN TRY

	BEGIN TRANSACTION;

		TRUNCATE TABLE [hl7].[CNC_tblHeartFailureSummary]

		INSERT INTO [hl7].[CNC_tblHeartFailureSummary](
			[MsgIssueDate]
			  ,[MsgSender]
			  ,[MsgRecipient]
			  ,[IdType]
			  ,[IdValue]
			  ,[PersonNameType]
			  ,[RecpHcpCode]
			  ,[RecpHcpDescription]
			  ,[RecpPracticeCode]
			  ,[RecpPracticeName]
			  ,[SendHCPCode]
			  ,[SendHCPDesc]
			  ,[SendDepartment]
			  ,[OrgCode]
			  ,[OrgName]
			  ,[IntegratedDocumentID]
			  ,[ReportType]
			  ,[EventDate]
			  ,[EventDateEnd]
			  ,[DocCreationDate]
			  ,[FileExtension]
			  ,[Patient_ID]
			  ,[Gender]
			  ,[NHS_Number]
			  ,[Surname]
			  ,[Forename]
			  ,[DOB]
			  ,[Gender_ID]
			  ,[Age]
			  ,[Patient_Current_Address]
			  ,[GP_Code]
			  ,[Practice_Code]
			  ,[GP_Name]
			  ,[Practice_Desc]
			  ,[GP_Address]
			  ,[Enable_EDT_Hub_ID]
			  ,[Object_Type_ID]
			  ,[CurrentDate]
			  ,[CN_Doc_ID]
			  ,[HeartFailurev4_ID]
			  ,[Staff_Name]
			  ,[StartDate]
			  ,[EnteredDate]
			  ,[SessionType]
			  ,[fldPatInfo]
			  ,[DNACPR]
			  ,[LVSD]
			  ,[EchoFind]
			  ,[EchoOut]
			  ,[Aetiology]
			  ,[Ischaemic]
			  ,[fldIschHeartDetails]
			  ,[Valve]
			  ,[fldValveDiseaseDetails]
			  ,[Hypertension]
			  ,[fldHypertensionDetails]
			  ,[Arrhythmia]
			  ,[fldArrhythmiaDetails]
			  ,[Diabetes]
			  ,[fldDiabetesDetails]
			  ,[ChronKidney]
			  ,[fldChronKidDiseaseDetails]
			  ,[Asthma]
			  ,[fldAsthmaDetails]
			  ,[COPD]
			  ,[fldCOPDDetails]
			  ,[Cerebrovasc]
			  ,[fldCerebroAccDetails]
			  ,[Perivasc]
			  ,[fldPeriVascDiseaseDetails]
			  ,[Anaemia]
			  ,[fldAnaemiaDetails]
			  ,[fldOthrMedHist]
			  ,[Device]
			  ,[fldDeviceDate]
			  ,[fldDeviceDetails]
			  ,[CoronaryAng]
			  ,[fldCoroAngioDetails]
			  ,[PCI]
			  ,[fldPCIDetails]
			  ,[CABG]
			  ,[fldCABGDetails]
			  ,[Medi1]
			  ,[flddose1]
			  ,[fldfreq1]
			  ,[Route1]
			  ,[Pres1]
			  ,[fldcomm1]
			  ,[Medi2]
			  ,[flddose2]
			  ,[fldfreq2]
			  ,[Route2]
			  ,[Pres2]
			  ,[fldcomm2]
			  ,[Medi3]
			  ,[flddose3]
			  ,[fldfreq3]
			  ,[Route3]
			  ,[Pres3]
			  ,[fldcomm3]
			  ,[Medi4]
			  ,[flddose4]
			  ,[fldfreq4]
			  ,[Route4]
			  ,[Pres4]
			  ,[fldcomm4]
			  ,[Medi5]
			  ,[flddose5]
			  ,[fldfreq5]
			  ,[Route5]
			  ,[Pres5]
			  ,[fldcomm5]
			  ,[Medi6]
			  ,[flddose6]
			  ,[fldfreq6]
			  ,[Route6]
			  ,[Pres6]
			  ,[fldcomm6]
			  ,[Medi7]
			  ,[flddose7]
			  ,[fldfreq7]
			  ,[Route7]
			  ,[Pres7]
			  ,[fldcomm7]
			  ,[Medi8]
			  ,[flddose8]
			  ,[fldfreq8]
			  ,[Route8]
			  ,[Pres8]
			  ,[fldcomm8]
			  ,[Medi9]
			  ,[flddose9]
			  ,[fldfreq9]
			  ,[Route9]
			  ,[Pres9]
			  ,[fldcomm9]
			  ,[Medi10]
			  ,[flddose10]
			  ,[fldfreq10]
			  ,[Route10]
			  ,[Pres10]
			  ,[fldcomm10]
			  ,[Medi11]
			  ,[flddose11]
			  ,[fldfreq11]
			  ,[Route11]
			  ,[Pres11]
			  ,[fldcomm11]
			  ,[Medi12]
			  ,[flddose12]
			  ,[fldfreq12]
			  ,[Route12]
			  ,[Pres12]
			  ,[fldcomm12]
			  ,[Medi13]
			  ,[flddose13]
			  ,[fldfreq13]
			  ,[Route13]
			  ,[Pres13]
			  ,[fldcomm13]
			  ,[Medi14]
			  ,[flddose14]
			  ,[fldfreq14]
			  ,[Route14]
			  ,[Pres14]
			  ,[fldcomm14]
			  ,[Medi15]
			  ,[flddose15]
			  ,[fldfreq15]
			  ,[Route15]
			  ,[Pres15]
			  ,[fldcomm15]
			  ,[Medi16]
			  ,[flddose16]
			  ,[fldfreq16]
			  ,[Route16]
			  ,[Pres16]
			  ,[fldcomm16]
			  ,[Medi17]
			  ,[flddose17]
			  ,[fldfreq17]
			  ,[Route17]
			  ,[Pres17]
			  ,[fldcomm17]
			  ,[Medi18]
			  ,[flddose18]
			  ,[fldfreq18]
			  ,[Route18]
			  ,[Pres18]
			  ,[fldcomm18]
			  ,[Medi19]
			  ,[flddose19]
			  ,[fldfreq19]
			  ,[Route19]
			  ,[Pres19]
			  ,[fldcomm19]
			  ,[Medi20]
			  ,[flddose20]
			  ,[fldfreq20]
			  ,[Route20]
			  ,[Pres20]
			  ,[fldcomm20]
			  ,[Medi21]
			  ,[flddose21]
			  ,[fldfreq21]
			  ,[Route21]
			  ,[Pres21]
			  ,[fldcomm21]
			  ,[Medi22]
			  ,[flddose22]
			  ,[fldfreq22]
			  ,[Route22]
			  ,[Pres22]
			  ,[fldcomm22]
			  ,[Medi23]
			  ,[flddose23]
			  ,[fldfreq23]
			  ,[Route23]
			  ,[Pres23]
			  ,[fldcomm23]
			  ,[Medi24]
			  ,[flddose24]
			  ,[fldfreq24]
			  ,[Route24]
			  ,[Pres24]
			  ,[fldcomm24]
			  ,[Medi25]
			  ,[flddose25]
			  ,[fldfreq25]
			  ,[Route25]
			  ,[Pres25]
			  ,[fldcomm25]
			  ,[fldFutureMeds]
			  ,[fldHeartFailMed]
			  ,[fldOthrRelMed]
			  ,[fldBreathlessness]
			  ,[fldMobLimit]
			  ,[fldOrthopnoea]
			  ,[fldPND]
			  ,[fldOedema]
			  ,[fldAscites]
			  ,[fldChest]
			  ,[fldCough]
			  ,[fldFldIntake]
			  ,[fldAngina]
			  ,[fldPalpitations]
			  ,[fldDizziness]
			  ,[fldFatigue]
			  ,[fldECGFind]
			  ,[CardRehab]
			  ,[CBT]
			  ,[fldWeight]
			  ,[fldSittingBP]
			  ,[fldStandingBP]
			  ,[HeartRyth]
			  ,[fldPulse]
			  ,[fldResp]
			  ,[fldSpO2]
			  ,[fldTemp]
			  ,[NewYork]
			  ,[fldMUST]
			  ,[fldBraden]
			  ,[fldDetsPlanAction]
			  ,[Confirm_Date]
		)
		SELECT [MsgIssueDate]
			  ,[MsgSender]
			  ,[MsgRecipient]
			  ,[IdType]
			  ,[IdValue]
			  ,[PersonNameType]
			  ,[RecpHcpCode]
			  ,[RecpHcpDescription]
			  ,[RecpPracticeCode]
			  ,[RecpPracticeName]
			  ,[SendHCPCode]
			  ,[SendHCPDesc]
			  ,[SendDepartment]
			  ,[OrgCode]
			  ,[OrgName]
			  ,[IntegratedDocumentID]
			  ,[ReportType]
			  ,[EventDate]
			  ,[EventDateEnd]
			  ,[DocCreationDate]
			  ,[FileExtension]
			  ,[Patient_ID]
			  ,[Gender]
			  ,[NHS_Number]
			  ,[Surname]
			  ,[Forename]
			  ,[DOB]
			  ,[Gender_ID]
			  ,[Age]
			  ,[Patient_Current_Address]
			  ,[GP_Code]
			  ,[Practice_Code]
			  ,[GP_Name]
			  ,[Practice_Desc]
			  ,[GP_Address]
			  ,[Enable_EDT_Hub_ID]
			  ,[Object_Type_ID]
			  ,[CurrentDate]
			  ,[CN_Doc_ID]
			  ,[HeartFailurev4_ID]
			  ,[Staff_Name]
			  ,[StartDate]
			  ,[EnteredDate]
			  ,[SessionType]
			  ,[fldPatInfo]
			  ,[DNACPR]
			  ,[LVSD]
			  ,[EchoFind]
			  ,[EchoOut]
			  ,[Aetiology]
			  ,[Ischaemic]
			  ,[fldIschHeartDetails]
			  ,[Valve]
			  ,[fldValveDiseaseDetails]
			  ,[Hypertension]
			  ,[fldHypertensionDetails]
			  ,[Arrhythmia]
			  ,[fldArrhythmiaDetails]
			  ,[Diabetes]
			  ,[fldDiabetesDetails]
			  ,[ChronKidney]
			  ,[fldChronKidDiseaseDetails]
			  ,[Asthma]
			  ,[fldAsthmaDetails]
			  ,[COPD]
			  ,[fldCOPDDetails]
			  ,[Cerebrovasc]
			  ,[fldCerebroAccDetails]
			  ,[Perivasc]
			  ,[fldPeriVascDiseaseDetails]
			  ,[Anaemia]
			  ,[fldAnaemiaDetails]
			  ,[fldOthrMedHist]
			  ,[Device]
			  ,[fldDeviceDate]
			  ,[fldDeviceDetails]
			  ,[CoronaryAng]
			  ,[fldCoroAngioDetails]
			  ,[PCI]
			  ,[fldPCIDetails]
			  ,[CABG]
			  ,[fldCABGDetails]
			  ,[Medi1]
			  ,[flddose1]
			  ,[fldfreq1]
			  ,[Route1]
			  ,[Pres1]
			  ,[fldcomm1]
			  ,[Medi2]
			  ,[flddose2]
			  ,[fldfreq2]
			  ,[Route2]
			  ,[Pres2]
			  ,[fldcomm2]
			  ,[Medi3]
			  ,[flddose3]
			  ,[fldfreq3]
			  ,[Route3]
			  ,[Pres3]
			  ,[fldcomm3]
			  ,[Medi4]
			  ,[flddose4]
			  ,[fldfreq4]
			  ,[Route4]
			  ,[Pres4]
			  ,[fldcomm4]
			  ,[Medi5]
			  ,[flddose5]
			  ,[fldfreq5]
			  ,[Route5]
			  ,[Pres5]
			  ,[fldcomm5]
			  ,[Medi6]
			  ,[flddose6]
			  ,[fldfreq6]
			  ,[Route6]
			  ,[Pres6]
			  ,[fldcomm6]
			  ,[Medi7]
			  ,[flddose7]
			  ,[fldfreq7]
			  ,[Route7]
			  ,[Pres7]
			  ,[fldcomm7]
			  ,[Medi8]
			  ,[flddose8]
			  ,[fldfreq8]
			  ,[Route8]
			  ,[Pres8]
			  ,[fldcomm8]
			  ,[Medi9]
			  ,[flddose9]
			  ,[fldfreq9]
			  ,[Route9]
			  ,[Pres9]
			  ,[fldcomm9]
			  ,[Medi10]
			  ,[flddose10]
			  ,[fldfreq10]
			  ,[Route10]
			  ,[Pres10]
			  ,[fldcomm10]
			  ,[Medi11]
			  ,[flddose11]
			  ,[fldfreq11]
			  ,[Route11]
			  ,[Pres11]
			  ,[fldcomm11]
			  ,[Medi12]
			  ,[flddose12]
			  ,[fldfreq12]
			  ,[Route12]
			  ,[Pres12]
			  ,[fldcomm12]
			  ,[Medi13]
			  ,[flddose13]
			  ,[fldfreq13]
			  ,[Route13]
			  ,[Pres13]
			  ,[fldcomm13]
			  ,[Medi14]
			  ,[flddose14]
			  ,[fldfreq14]
			  ,[Route14]
			  ,[Pres14]
			  ,[fldcomm14]
			  ,[Medi15]
			  ,[flddose15]
			  ,[fldfreq15]
			  ,[Route15]
			  ,[Pres15]
			  ,[fldcomm15]
			  ,[Medi16]
			  ,[flddose16]
			  ,[fldfreq16]
			  ,[Route16]
			  ,[Pres16]
			  ,[fldcomm16]
			  ,[Medi17]
			  ,[flddose17]
			  ,[fldfreq17]
			  ,[Route17]
			  ,[Pres17]
			  ,[fldcomm17]
			  ,[Medi18]
			  ,[flddose18]
			  ,[fldfreq18]
			  ,[Route18]
			  ,[Pres18]
			  ,[fldcomm18]
			  ,[Medi19]
			  ,[flddose19]
			  ,[fldfreq19]
			  ,[Route19]
			  ,[Pres19]
			  ,[fldcomm19]
			  ,[Medi20]
			  ,[flddose20]
			  ,[fldfreq20]
			  ,[Route20]
			  ,[Pres20]
			  ,[fldcomm20]
			  ,[Medi21]
			  ,[flddose21]
			  ,[fldfreq21]
			  ,[Route21]
			  ,[Pres21]
			  ,[fldcomm21]
			  ,[Medi22]
			  ,[flddose22]
			  ,[fldfreq22]
			  ,[Route22]
			  ,[Pres22]
			  ,[fldcomm22]
			  ,[Medi23]
			  ,[flddose23]
			  ,[fldfreq23]
			  ,[Route23]
			  ,[Pres23]
			  ,[fldcomm23]
			  ,[Medi24]
			  ,[flddose24]
			  ,[fldfreq24]
			  ,[Route24]
			  ,[Pres24]
			  ,[fldcomm24]
			  ,[Medi25]
			  ,[flddose25]
			  ,[fldfreq25]
			  ,[Route25]
			  ,[Pres25]
			  ,[fldcomm25]
			  ,[fldFutureMeds]
			  ,[fldHeartFailMed]
			  ,[fldOthrRelMed]
			  ,[fldBreathlessness]
			  ,[fldMobLimit]
			  ,[fldOrthopnoea]
			  ,[fldPND]
			  ,[fldOedema]
			  ,[fldAscites]
			  ,[fldChest]
			  ,[fldCough]
			  ,[fldFldIntake]
			  ,[fldAngina]
			  ,[fldPalpitations]
			  ,[fldDizziness]
			  ,[fldFatigue]
			  ,[fldECGFind]
			  ,[CardRehab]
			  ,[CBT]
			  ,[fldWeight]
			  ,[fldSittingBP]
			  ,[fldStandingBP]
			  ,[HeartRyth]
			  ,[fldPulse]
			  ,[fldResp]
			  ,[fldSpO2]
			  ,[fldTemp]
			  ,[NewYork]
			  ,[fldMUST]
			  ,[fldBraden]
			  ,[fldDetsPlanAction]
			  ,[Confirm_Date]
		  FROM [HL7v2_42].[hl7].[vwCNC_HeartFailureSummary]
		  WHERE Confirm_Date > @MaxDate 
		  AND Practice_Code IS NOT NULL
		  AND Practice_Code NOT LIKE 'V9%'
		  AND Surname LIKE '%XX%TEST%'
		  --NOT EXISTS ( SELECT 1 FROM [hl7].[CNC_tblHeartFailureSummary] tr WHERE ds.[IntegratedDocumentID] = tr.[IntegratedDocumentID])


		-- delete from Tracker table 
			DECLARE @newRecords INT = @@ROWCOUNT

			IF @newRecords > 0
			BEGIN 
				INSERT INTO [dbo].[tblHL7_TableTracker] 
					VALUES 
					(	  'CNC'
						, 'CNC_tblHeartFailureSummary'
						, getdate() 
						, ISNULL((SELECT MAX([Confirm_Date]) FROM [hl7].[CNC_tblHeartFailureSummary] ),'1 Jan 1900')
						, @LoadId
						,@newRecords
					)
			END 

	COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH

GO
