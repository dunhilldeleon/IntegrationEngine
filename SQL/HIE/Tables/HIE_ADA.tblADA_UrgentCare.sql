SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [HIE_ADA].[tblADA_UrgentCare](
	[CaseRef] [uniqueidentifier] NOT NULL,
	[Patient] [varchar](101) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Caseno] [int] NULL,
	[Gender] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DOB] [datetime] NULL,
	[Age] [numeric](18, 0) NULL,
	[NHSNumber] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceName] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrentPhone] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrentAddress] [varchar](357) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HomeAddress] [varchar](357) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HomePhone] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CaseType] [varchar](35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Location] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CallOrigin] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReportedCondition] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AdastraConsultBy] [varchar](72) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Role] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Consult Start] [datetime] NULL,
	[StartingType] [varchar](240) COLLATE Latin1_General_CI_AS NULL,
	[EndingType] [varchar](240) COLLATE Latin1_General_CI_AS NULL,
	[ConsultEnd] [datetime] NULL,
	[History] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Examination] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Diagnosis] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Treatment] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Prescriptions] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[ClinicalCodes] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[InformationalOutcomes] [varchar](8000) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
