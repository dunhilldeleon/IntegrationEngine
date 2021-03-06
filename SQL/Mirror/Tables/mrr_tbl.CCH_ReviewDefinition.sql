SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[CCH_ReviewDefinition](
	[Id] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NULL,
	[ExpiredDateTime] [datetime] NULL,
	[CareNotesUserId] [int] NULL,
	[ChildHealthClientVersion] [nvarchar](32) COLLATE Latin1_General_CI_AS NULL,
	[ShortName] [nvarchar](50) COLLATE Latin1_General_CI_AS NULL,
	[LongName] [nvarchar](100) COLLATE Latin1_General_CI_AS NULL,
	[ReviewType] [int] NULL,
	[CarriedOutConsultationTemplateId] [uniqueidentifier] NULL,
	[NotCarriedOutConsultationTemplateId] [uniqueidentifier] NULL,
	[WarnIfMultipleInstances] [bit] NULL,
	[CohortId] [uniqueidentifier] NULL,
	[CoreProgramme] [bit] NULL,
	[IgnoreTreatmentStatus] [bit] NULL,
	[DaysScheduledInAdvance] [int] NULL,
	[Code] [nvarchar](20) COLLATE Latin1_General_CI_AS NULL,
	[IsOutcomedByOptional] [bit] NULL,
	[IsTeamLocationOptional] [bit] NULL,
	[ForceOutcomeToId] [uniqueidentifier] NULL,
	[CyphsCode] [nvarchar](20) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]

GO
