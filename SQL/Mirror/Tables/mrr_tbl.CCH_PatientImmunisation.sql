SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[CCH_PatientImmunisation](
	[Idx] [int] NOT NULL,
	[Id] [uniqueidentifier] NULL,
	[CreatedDateTime] [datetime] NULL,
	[ExpiredDateTime] [datetime] NULL,
	[CareNotesUserId] [int] NULL,
	[ChildHealthClientVersion] [nvarchar](32) COLLATE Latin1_General_CI_AS NULL,
	[PatientId] [uniqueidentifier] NULL,
	[ImmunisationPartId] [uniqueidentifier] NULL,
	[CentreId] [uniqueidentifier] NULL,
	[ImmunisationOutcomeId] [uniqueidentifier] NULL,
	[DateScheduled] [datetime] NULL,
	[DateOutcome] [datetime] NULL,
	[Removed] [bit] NULL,
	[OutcomedByStaffId] [int] NULL,
	[RemovalReasonId] [uniqueidentifier] NULL,
	[Provisional] [bit] NULL,
	[ConsultationId] [uniqueidentifier] NULL,
	[SuspensionReasonId] [uniqueidentifier] NULL,
	[SuspendUntilDate] [datetime] NULL,
	[ConsultationIdx] [int] NULL,
	[IsScheduledBySystem] [bit] NULL,
	[ResumeReasonId] [uniqueidentifier] NULL,
	[RequiredNumberOfReminders] [int] NULL,
	[ConsultationRevisionTag] [uniqueidentifier] NULL
) ON [PRIMARY]

GO
