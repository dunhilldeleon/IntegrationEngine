SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE VIEW [mrr].[CCH_ChildHealthCentre] AS SELECT [Idx], [Id], [CreatedDateTime], [ExpiredDateTime], [CareNotesUserId], [ChildHealthClientVersion], [Name], [CarenotesTeamId], [StartSchedulingDate], [EndSchedulingDate], [Code], [LabCode], [CarenotesPracticeId], [CarenotesSchoolId], [CarenotesClinicGroupId], [ExcludeFromCarenotesTeamAutoAssign], [Removed] FROM [Mirror].[mrr_tbl].[CCH_ChildHealthCentre];
GO
