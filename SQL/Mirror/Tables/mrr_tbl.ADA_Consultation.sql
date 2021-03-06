SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[ADA_Consultation](
	[ConsultationRef] [uniqueidentifier] NOT NULL,
	[CaseRef] [uniqueidentifier] NULL,
	[History] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Examination] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Diagnosis] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Treatment] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[ProviderRef] [uniqueidentifier] NULL,
	[CaseTypeRef] [uniqueidentifier] NULL,
	[PriorityRef] [uniqueidentifier] NULL,
	[Outcome] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BeforeCaseTypeRef] [uniqueidentifier] NULL,
	[AfterStatus] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BeforeStatus] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LocationRef] [uniqueidentifier] NULL,
	[Obsolete] [bit] NULL,
	[InitialAssessment] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ButtonScreen] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConfigurationSet] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LanguageScreen] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
