SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE VIEW [mrr].[ADA_clinicalCodeHotlist] AS SELECT [ExaminationCategoryRef], [Code], [Description], [Usage], [Sort], [CodingSystem] FROM [Mirror].[mrr_tbl].[ADA_clinicalCodeHotlist];

GO
