SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[ACCNC_TemplateSubmission](
	[PatientId] [uniqueidentifier] NULL,
	[TemplateId] [uniqueidentifier] NULL,
	[TemplateIdx] [int] NULL,
	[EventTypeId] [uniqueidentifier] NULL,
	[EventDate] [datetime2](7) NULL,
	[Obsolete] [bit] NULL,
	[Numeric] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[Text] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[Date] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[DateTime] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[Time] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[Checkbox] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[Combobox] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[Radio] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[BloodPressure] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[Bmi] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[BmiInfant] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[Administration] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[_idx] [int] NOT NULL,
	[_createdDate] [datetime2](7) NOT NULL,
	[_expiredDate] [datetime2](7) NULL,
	[Id] [uniqueidentifier] NULL,
	[_version] [varchar](32) COLLATE Latin1_General_CI_AS NULL,
	[RevisionTag] [uniqueidentifier] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
