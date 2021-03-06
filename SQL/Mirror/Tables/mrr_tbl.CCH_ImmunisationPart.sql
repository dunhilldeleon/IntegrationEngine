SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[CCH_ImmunisationPart](
	[Id] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NULL,
	[ExpiredDateTime] [datetime] NULL,
	[CareNotesUserId] [int] NULL,
	[ChildHealthClientVersion] [nvarchar](32) COLLATE Latin1_General_CI_AS NULL,
	[ImmunisationDefinitionId] [uniqueidentifier] NULL,
	[PartNumber] [int] NULL,
	[GivenConsultationTemplateId] [uniqueidentifier] NULL,
	[NotGivenConsultationTemplateId] [uniqueidentifier] NULL,
	[CohortId] [uniqueidentifier] NULL,
	[DaysScheduledInAdvance] [int] NULL,
	[SchoolYearBased] [bit] NULL,
	[Code] [nvarchar](20) COLLATE Latin1_General_CI_AS NULL,
	[MinimumGapDays] [int] NULL
) ON [PRIMARY]

GO
