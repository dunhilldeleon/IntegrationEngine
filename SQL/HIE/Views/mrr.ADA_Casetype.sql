SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE VIEW [mrr].[ADA_Casetype] AS SELECT [CaseTypeRef], [ServiceRef], [Name], [Abbreviation], [Sort], [V2Import], [Obsolete], [Usage], [NationalCode], [Colour] FROM [Mirror].[mrr_tbl].[ADA_Casetype];

GO
