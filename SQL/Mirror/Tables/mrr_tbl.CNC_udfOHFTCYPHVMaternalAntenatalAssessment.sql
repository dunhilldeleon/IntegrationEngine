SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[CNC_udfOHFTCYPHVMaternalAntenatalAssessment](
	[OHFTCYPHVMaternalAntenatalAssessment_ID] [int] NOT NULL,
	[Patient_ID] [int] NULL,
	[EstDueDate] [datetime] NULL,
	[MHandSAScoreID] [int] NULL,
	[LetterSentID] [int] NULL,
	[PregnancyOngoingID] [int] NULL,
	[AntenatalVisitAchievedID] [int] NULL,
	[ReasonNotAchievedID] [int] NULL,
	[InfantFeedingDiscussedID] [int] NULL,
	[RoutineQuestionsAskedID] [int] NULL,
	[NotAskedReasonID] [int] NULL,
	[NotAskedReasonDetail] [text] COLLATE Latin1_General_CI_AS NULL,
	[PromoGuidesUsedID] [int] NULL,
	[PromoGuideNotUsed] [text] COLLATE Latin1_General_CI_AS NULL,
	[EarlyInterventionID] [int] NULL,
	[Homeless1ID] [int] NULL,
	[Mental_Health_ConcernsID] [int] NULL,
	[AddictionsID] [int] NULL,
	[Teenage_PregnancyID] [int] NULL,
	[HistoryID] [int] NULL,
	[CurrentID] [int] NULL,
	[Physical_DisabilityID] [int] NULL,
	[Travelling_FamilliesID] [int] NULL,
	[Asylum_SeekersID] [int] NULL,
	[HealthChildProgrammeID] [int] NULL,
	[FollowUpRequiredID] [int] NULL,
	[User_Created] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Create_Dttm] [datetime] NULL,
	[User_Updated] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Updated_Dttm] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
