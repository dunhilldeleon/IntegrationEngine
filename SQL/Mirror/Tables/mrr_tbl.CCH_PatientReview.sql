SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[CCH_PatientReview](
	[Idx] [int] NOT NULL,
	[Id] [uniqueidentifier] NULL,
	[CreatedDateTime] [datetime] NULL,
	[ExpiredDateTime] [datetime] NULL,
	[CareNotesUserId] [int] NULL,
	[ChildHealthClientVersion] [nvarchar](32) COLLATE Latin1_General_CI_AS NULL,
	[PatientId] [uniqueidentifier] NULL,
	[ReviewDefinitionId] [uniqueidentifier] NULL,
	[ReviewOutcomeId] [uniqueidentifier] NULL,
	[DateScheduled] [datetime] NULL,
	[DateOutcome] [datetime] NULL,
	[Removed] [bit] NULL,
	[OutcomedByStaffId] [int] NULL,
	[CentreId] [uniqueidentifier] NULL,
	[ReviewLocationId] [uniqueidentifier] NULL,
	[ConsultationId] [uniqueidentifier] NULL,
	[OriginalReviewId] [uniqueidentifier] NULL,
	[RemovalReasonId] [uniqueidentifier] NULL,
	[FromElectronicInterface] [bit] NULL,
	[ConsultationIdx] [int] NULL,
	[IsScheduledBySystem] [bit] NULL,
	[ConsultationRevisionTag] [uniqueidentifier] NULL
) ON [PRIMARY]

GO
