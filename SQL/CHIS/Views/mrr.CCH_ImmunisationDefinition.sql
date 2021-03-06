SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE VIEW [mrr].[CCH_ImmunisationDefinition] AS SELECT [Id], [CreatedDateTime], [ExpiredDateTime], [CareNotesUserId], [ChildHealthClientVersion], [ShortName], [LongName], [Parts], [Priority], [CoreProgramme], [IgnoreTreatmentStatus], [Code], [GpiusCode] FROM  [Mirror].[mrr_tbl].[CCH_ImmunisationDefinition];

GO
