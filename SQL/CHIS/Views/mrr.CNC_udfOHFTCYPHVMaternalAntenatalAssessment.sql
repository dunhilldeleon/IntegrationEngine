SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


CREATE VIEW [mrr].[CNC_udfOHFTCYPHVMaternalAntenatalAssessment] AS SELECT [OHFTCYPHVMaternalAntenatalAssessment_ID], [Patient_ID], [EstDueDate], [MHandSAScoreID], [LetterSentID], [PregnancyOngoingID], [AntenatalVisitAchievedID], [ReasonNotAchievedID], [InfantFeedingDiscussedID], [RoutineQuestionsAskedID], [NotAskedReasonID], [NotAskedReasonDetail], [PromoGuidesUsedID], [PromoGuideNotUsed], [EarlyInterventionID], [Homeless1ID], [Mental_Health_ConcernsID], [AddictionsID], [Teenage_PregnancyID], [HistoryID], [CurrentID], [Physical_DisabilityID], [Travelling_FamilliesID], [Asylum_SeekersID], [HealthChildProgrammeID], [FollowUpRequiredID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm] FROM  [Mirror].[mrr_tbl].[CNC_udfOHFTCYPHVMaternalAntenatalAssessment];

GO
