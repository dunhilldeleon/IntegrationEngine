SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [hl7].[CNS_tblInterimDischargeSummary](
	[MsgIssueDate] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[SourceSystem] [varchar](2) COLLATE Latin1_General_CI_AS NOT NULL,
	[MsgSender] [varchar](11) COLLATE Latin1_General_CI_AS NOT NULL,
	[MsgRecipient] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[IdType] [varchar](3) COLLATE Latin1_General_CI_AS NOT NULL,
	[IdValue] [varchar](11) COLLATE Latin1_General_CI_AS NULL,
	[PersonNameType] [varchar](2) COLLATE Latin1_General_CI_AS NOT NULL,
	[Gender_ID] [int] NULL,
	[RecpHcpCode] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[RecpHcpDescription] [varchar](201) COLLATE Latin1_General_CI_AS NULL,
	[RecpPracticeCode] [varchar](10) COLLATE Latin1_General_CI_AS NULL,
	[RecpPracticeName] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[SendHCPCode] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[SendHCPDesc] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[SendDepartment] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[OrgCode] [varchar](3) COLLATE Latin1_General_CI_AS NOT NULL,
	[OrgName] [varchar](13) COLLATE Latin1_General_CI_AS NOT NULL,
	[IntegratedDocumentID] [int] NOT NULL,
	[ReportType] [varchar](17) COLLATE Latin1_General_CI_AS NOT NULL,
	[EventDate] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[EventDateEnd] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[DocCreationDate] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[FileExtension] [varchar](3) COLLATE Latin1_General_CI_AS NOT NULL,
	[Attachment_File_Name] [varchar](38) COLLATE Latin1_General_CI_AS NOT NULL,
	[CompletedByStaffDesc] [varchar](101) COLLATE Latin1_General_CI_AS NULL,
	[NHS_Number] [varchar](11) COLLATE Latin1_General_CI_AS NULL,
	[Forename] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Surname] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Date_of_Birth] [datetime] NULL,
	[Age] [int] NULL,
	[Address1] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address2] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address3] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address4] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address5] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Post_code] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[GP_Name] [varchar](201) COLLATE Latin1_General_CI_AS NULL,
	[Practice_Name] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Practice_Address1] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Practice_Address2] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Practice_Address3] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Practice_Address4] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Practice_Address5] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Practice_Postcode] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[fldDisLoc] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldDisLocTele] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldConsult] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldCareCoord] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldDateAdm] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldDateDis] [nvarchar](10) COLLATE Latin1_General_CI_AS NULL,
	[fldMHAStat] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[StartDate] [datetime] NULL,
	[DisIssued] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[ohftStaff] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[CN_Doc_ID] [int] NULL,
	[Staff_Name] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[OHFTDischargeNotificationSummaryV3_ID] [int] NOT NULL,
	[Confirm_Flag_ID] [int] NULL,
	[fldDiagnosis] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldSecDiagnosis0] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldSecDiagnosis1] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldSecDiagnosis2] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldSecDiagnosis3] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldSecDiagnosis4] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldBriefSumm] [text] COLLATE Latin1_General_CI_AS NOT NULL,
	[fldDisPlan] [text] COLLATE Latin1_General_CI_AS NOT NULL,
	[fldDisComments] [text] COLLATE Latin1_General_CI_AS NULL,
	[fldDateNotIss] [datetime] NULL,
	[SevenDayStaff] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fld7DayFollowComm] [text] COLLATE Latin1_General_CI_AS NULL,
	[MedName1] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[MedName2] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[MedName3] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[MedName4] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[MedName5] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[MedName6] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[MedName7] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[MedName8] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[MedName9] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[MedName10] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[MedName11] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[MedName12] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[MedName13] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[MedName14] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[MedName15] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[MedName16] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[MedName17] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[MedName18] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[MedName19] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[MedName20] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[MedName21] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[MedName22] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[MedName23] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[MedName24] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[MedName25] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose1] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose2] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose3] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose4] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose5] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose6] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose7] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose8] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose9] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose10] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose11] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose12] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose13] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose14] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose15] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose16] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose17] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose18] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose19] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose20] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose21] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose22] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose23] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose24] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[flddose25] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[routeDesc1] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[routeDesc2] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[routeDesc3] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[routeDesc4] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[routeDesc5] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[routeDesc6] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[routeDesc7] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[routeDesc8] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[routeDesc9] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[routeDesc10] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[routeDesc11] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[routeDesc12] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[routeDesc13] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[routeDesc14] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[routeDesc15] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[routeDesc16] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[routeDesc17] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[routeDesc18] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[routeDesc19] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[routeDesc20] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[routeDesc21] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[routeDesc22] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[routeDesc23] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[routeDesc24] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[routeDesc25] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm1] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm2] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm3] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm4] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm5] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm6] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm7] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm8] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm9] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm10] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm11] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm12] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm13] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm14] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm15] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm16] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm17] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm18] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm19] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm20] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm21] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm22] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm23] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm24] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fldcomm25] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[prescDesc1] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[prescDesc2] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[prescDesc3] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[prescDesc4] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[prescDesc5] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[prescDesc6] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[prescDesc7] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[prescDesc8] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[prescDesc9] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[prescDesc10] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[prescDesc11] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[prescDesc12] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[prescDesc13] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[prescDesc14] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[prescDesc15] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[prescDesc16] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[prescDesc17] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[prescDesc18] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[prescDesc19] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[prescDesc20] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[prescDesc21] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[prescDesc22] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[prescDesc23] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[prescDesc24] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[prescDesc25] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[CompletedBy] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[fld7DayFollowYNID] [int] NOT NULL,
	[fld7DayFollowID] [int] NULL,
	[Confirm_Date] [datetime] NULL,
	[SevenDayFollowupStaff] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Create_Dttm] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
