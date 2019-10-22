SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [hl7].[CNC_tblHeartFailureSummary](
	[MsgIssueDate] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[MsgSender] [varchar](11) COLLATE Latin1_General_CI_AS NOT NULL,
	[MsgRecipient] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[IdType] [varchar](3) COLLATE Latin1_General_CI_AS NOT NULL,
	[IdValue] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[PersonNameType] [varchar](2) COLLATE Latin1_General_CI_AS NOT NULL,
	[RecpHcpCode] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[RecpHcpDescription] [varchar](201) COLLATE Latin1_General_CI_AS NULL,
	[RecpPracticeCode] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[RecpPracticeName] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[SendHCPCode] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[SendHCPDesc] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[SendDepartment] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[OrgCode] [varchar](3) COLLATE Latin1_General_CI_AS NOT NULL,
	[OrgName] [varchar](13) COLLATE Latin1_General_CI_AS NOT NULL,
	[IntegratedDocumentID] [varchar](12) COLLATE Latin1_General_CI_AS NULL,
	[ReportType] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[EventDate] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[EventDateEnd] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[DocCreationDate] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[FileExtension] [varchar](3) COLLATE Latin1_General_CI_AS NOT NULL,
	[Patient_ID] [int] NULL,
	[Gender] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[NHS_Number] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Surname] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Forename] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[DOB] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[Gender_ID] [int] NULL,
	[Age] [int] NULL,
	[Patient_Current_Address] [varchar](1330) COLLATE Latin1_General_CI_AS NULL,
	[GP_Code] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[Practice_Code] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[GP_Name] [varchar](201) COLLATE Latin1_General_CI_AS NULL,
	[Practice_Desc] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[GP_Address] [varchar](1532) COLLATE Latin1_General_CI_AS NULL,
	[Enable_EDT_Hub_ID] [int] NULL,
	[Object_Type_ID] [int] NULL,
	[CurrentDate] [varchar](10) COLLATE Latin1_General_CI_AS NULL,
	[CN_Doc_ID] [int] NULL,
	[HeartFailurev4_ID] [int] NOT NULL,
	[Staff_Name] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[StartDate] [varchar](30) COLLATE Latin1_General_CI_AS NULL,
	[EnteredDate] [varchar](30) COLLATE Latin1_General_CI_AS NULL,
	[SessionType] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[fldPatInfo] [text] COLLATE Latin1_General_CI_AS NULL,
	[DNACPR] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[LVSD] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[EchoFind] [varchar](11) COLLATE Latin1_General_CI_AS NULL,
	[EchoOut] [varchar](15) COLLATE Latin1_General_CI_AS NULL,
	[Aetiology] [varchar](223) COLLATE Latin1_General_CI_AS NULL,
	[Ischaemic] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldIschHeartDetails] [text] COLLATE Latin1_General_CI_AS NULL,
	[Valve] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldValveDiseaseDetails] [text] COLLATE Latin1_General_CI_AS NULL,
	[Hypertension] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldHypertensionDetails] [text] COLLATE Latin1_General_CI_AS NULL,
	[Arrhythmia] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldArrhythmiaDetails] [text] COLLATE Latin1_General_CI_AS NULL,
	[Diabetes] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldDiabetesDetails] [text] COLLATE Latin1_General_CI_AS NULL,
	[ChronKidney] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldChronKidDiseaseDetails] [text] COLLATE Latin1_General_CI_AS NULL,
	[Asthma] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldAsthmaDetails] [text] COLLATE Latin1_General_CI_AS NULL,
	[COPD] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldCOPDDetails] [text] COLLATE Latin1_General_CI_AS NULL,
	[Cerebrovasc] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldCerebroAccDetails] [text] COLLATE Latin1_General_CI_AS NULL,
	[Perivasc] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldPeriVascDiseaseDetails] [text] COLLATE Latin1_General_CI_AS NULL,
	[Anaemia] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldAnaemiaDetails] [text] COLLATE Latin1_General_CI_AS NULL,
	[fldOthrMedHist] [text] COLLATE Latin1_General_CI_AS NULL,
	[Device] [varchar](55) COLLATE Latin1_General_CI_AS NULL,
	[fldDeviceDate] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldDeviceDetails] [text] COLLATE Latin1_General_CI_AS NULL,
	[CoronaryAng] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldCoroAngioDetails] [text] COLLATE Latin1_General_CI_AS NULL,
	[PCI] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldPCIDetails] [text] COLLATE Latin1_General_CI_AS NULL,
	[CABG] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldCABGDetails] [text] COLLATE Latin1_General_CI_AS NULL,
	[Medi1] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose1] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldfreq1] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Route1] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[Pres1] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm1] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Medi2] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose2] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldfreq2] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Route2] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[Pres2] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm2] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Medi3] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose3] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldfreq3] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Route3] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[Pres3] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm3] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Medi4] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose4] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldfreq4] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Route4] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[Pres4] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm4] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Medi5] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose5] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldfreq5] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Route5] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[Pres5] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm5] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Medi6] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose6] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldfreq6] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Route6] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[Pres6] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm6] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Medi7] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose7] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldfreq7] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Route7] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[Pres7] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm7] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Medi8] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose8] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldfreq8] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Route8] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[Pres8] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm8] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Medi9] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose9] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldfreq9] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Route9] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[Pres9] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm9] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Medi10] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose10] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldfreq10] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Route10] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[Pres10] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm10] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Medi11] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose11] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldfreq11] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Route11] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[Pres11] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm11] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Medi12] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose12] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldfreq12] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Route12] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[Pres12] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm12] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Medi13] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose13] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldfreq13] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Route13] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[Pres13] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm13] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Medi14] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose14] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldfreq14] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Route14] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[Pres14] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm14] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Medi15] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose15] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldfreq15] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Route15] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[Pres15] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm15] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Medi16] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose16] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldfreq16] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Route16] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[Pres16] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm16] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Medi17] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose17] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldfreq17] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Route17] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[Pres17] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm17] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Medi18] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose18] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldfreq18] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Route18] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[Pres18] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm18] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Medi19] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose19] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldfreq19] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Route19] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[Pres19] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm19] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Medi20] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose20] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldfreq20] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Route20] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[Pres20] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm20] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Medi21] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose21] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldfreq21] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Route21] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[Pres21] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm21] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Medi22] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose22] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldfreq22] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Route22] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[Pres22] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm22] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Medi23] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose23] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldfreq23] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Route23] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[Pres23] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm23] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Medi24] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose24] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldfreq24] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Route24] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[Pres24] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm24] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Medi25] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose25] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldfreq25] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Route25] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[Pres25] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm25] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldFutureMeds] [text] COLLATE Latin1_General_CI_AS NULL,
	[fldHeartFailMed] [text] COLLATE Latin1_General_CI_AS NULL,
	[fldOthrRelMed] [text] COLLATE Latin1_General_CI_AS NULL,
	[fldBreathlessness] [text] COLLATE Latin1_General_CI_AS NULL,
	[fldMobLimit] [text] COLLATE Latin1_General_CI_AS NULL,
	[fldOrthopnoea] [text] COLLATE Latin1_General_CI_AS NULL,
	[fldPND] [text] COLLATE Latin1_General_CI_AS NULL,
	[fldOedema] [text] COLLATE Latin1_General_CI_AS NULL,
	[fldAscites] [text] COLLATE Latin1_General_CI_AS NULL,
	[fldChest] [text] COLLATE Latin1_General_CI_AS NULL,
	[fldCough] [text] COLLATE Latin1_General_CI_AS NULL,
	[fldFldIntake] [text] COLLATE Latin1_General_CI_AS NULL,
	[fldAngina] [text] COLLATE Latin1_General_CI_AS NULL,
	[fldPalpitations] [text] COLLATE Latin1_General_CI_AS NULL,
	[fldDizziness] [text] COLLATE Latin1_General_CI_AS NULL,
	[fldFatigue] [text] COLLATE Latin1_General_CI_AS NULL,
	[fldECGFind] [text] COLLATE Latin1_General_CI_AS NULL,
	[CardRehab] [varchar](26) COLLATE Latin1_General_CI_AS NULL,
	[CBT] [varchar](26) COLLATE Latin1_General_CI_AS NULL,
	[fldWeight] [text] COLLATE Latin1_General_CI_AS NULL,
	[fldSittingBP] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldStandingBP] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[HeartRyth] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldPulse] [int] NULL,
	[fldResp] [int] NULL,
	[fldSpO2] [int] NULL,
	[fldTemp] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[NewYork] [varchar](14) COLLATE Latin1_General_CI_AS NULL,
	[fldMUST] [text] COLLATE Latin1_General_CI_AS NULL,
	[fldBraden] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldDetsPlanAction] [text] COLLATE Latin1_General_CI_AS NULL,
	[Confirm_Date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
