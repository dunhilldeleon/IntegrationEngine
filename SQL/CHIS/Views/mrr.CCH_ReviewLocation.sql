SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE VIEW [mrr].[CCH_ReviewLocation] AS SELECT [Id], [CreatedDateTime], [ExpiredDateTime], [CareNotesUserId], [ChildHealthClientVersion], [Description], [Code], [CyphsCode] FROM  [Mirror].[mrr_tbl].[CCH_ReviewLocation];

GO
