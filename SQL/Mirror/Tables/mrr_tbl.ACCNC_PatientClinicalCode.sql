SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[ACCNC_PatientClinicalCode](
	[PatientId] [uniqueidentifier] NULL,
	[EventId] [uniqueidentifier] NULL,
	[TemplateSubmissionIdx] [int] NULL,
	[SnomedCode] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[SnomedValue] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[EventDate] [datetime2](7) NULL,
	[_idx] [int] NOT NULL,
	[_createdDate] [datetime2](7) NOT NULL,
	[_expiredDate] [datetime2](7) NULL,
	[Id] [uniqueidentifier] NULL,
	[_version] [varchar](32) COLLATE Latin1_General_CI_AS NULL,
	[EventTypeId] [uniqueidentifier] NULL,
	[GroupId] [uniqueidentifier] NULL,
	[Numeric] [float] NULL,
	[Unit] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[SectionGroupId] [uniqueidentifier] NULL
) ON [PRIMARY]

GO
