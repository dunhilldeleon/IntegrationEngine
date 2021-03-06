SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE VIEW [mrr].[CCH_PatientReview] AS SELECT [Idx], [Id], [CreatedDateTime], [ExpiredDateTime], [CareNotesUserId], [ChildHealthClientVersion], [PatientId], [ReviewDefinitionId], [ReviewOutcomeId], [DateScheduled], [DateOutcome], [Removed], [OutcomedByStaffId], [CentreId], [ReviewLocationId], [ConsultationId], [OriginalReviewId], [RemovalReasonId], [FromElectronicInterface], [ConsultationIdx], [IsScheduledBySystem], [ConsultationRevisionTag] FROM [Mirror].[mrr_tbl].[CCH_PatientReview];
GO
