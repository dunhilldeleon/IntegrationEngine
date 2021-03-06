SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[CCH_ReportPatientImmunisation](
	[Id] [uniqueidentifier] NULL,
	[CarenotesPatientId] [int] NULL,
	[ImmPartCode] [nvarchar](20) COLLATE Latin1_General_CI_AS NULL,
	[PartNumber] [int] NULL,
	[ImmDefCode] [nvarchar](20) COLLATE Latin1_General_CI_AS NULL,
	[ShortName] [nvarchar](50) COLLATE Latin1_General_CI_AS NULL,
	[LongName] [nvarchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Parts] [int] NULL,
	[Priority] [bit] NULL,
	[CoreProgramme] [bit] NULL,
	[IgnoreTreatmentStatus] [bit] NULL,
	[CentreCode] [nvarchar](20) COLLATE Latin1_General_CI_AS NULL,
	[CentreName] [nvarchar](100) COLLATE Latin1_General_CI_AS NULL,
	[OutcomeCode] [nvarchar](20) COLLATE Latin1_General_CI_AS NULL,
	[OutcomeDescription] [nvarchar](100) COLLATE Latin1_General_CI_AS NULL,
	[DateScheduled] [datetime] NULL,
	[DateOutcome] [datetime] NULL,
	[OutcomedByStaffId] [int] NULL,
	[Provisional] [bit] NULL,
	[ConsultationId] [uniqueidentifier] NULL,
	[SuspensionReasonCode] [nvarchar](20) COLLATE Latin1_General_CI_AS NULL,
	[SuspensionReasonDescription] [nvarchar](255) COLLATE Latin1_General_CI_AS NULL,
	[SuspensionType] [int] NULL,
	[SuspensionTypeDesc] [varchar](25) COLLATE Latin1_General_CI_AS NULL,
	[SuspendUntilDate] [datetime] NULL,
	[Removed] [bit] NULL,
	[RequiredNumberOfReminders] [int] NULL,
	[SuspensionResumeReasonCode] [nvarchar](20) COLLATE Latin1_General_CI_AS NULL,
	[SuspensionResumeReasonDesc] [nvarchar](255) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]

GO
