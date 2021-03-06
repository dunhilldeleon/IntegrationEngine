SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[CCH_ChildHealthRecord](
	[Idx] [int] NOT NULL,
	[Id] [uniqueidentifier] NULL,
	[CreatedDateTime] [datetime] NULL,
	[ExpiredDateTime] [datetime] NULL,
	[CareNotesUserId] [int] NULL,
	[ChildHealthClientVersion] [nvarchar](32) COLLATE Latin1_General_CI_AS NULL,
	[ImmunisationCentreId] [uniqueidentifier] NULL,
	[ExaminationCentreId] [uniqueidentifier] NULL,
	[CarenotesPatientId] [int] NULL,
	[LookedAfterChildrenStatusConsultationId] [uniqueidentifier] NULL,
	[RegisterMessageSent] [datetime] NULL
) ON [PRIMARY]

GO
