SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE VIEW [mrr].[ADA_Ethnicity] AS SELECT [EthnicityRef], [Name], [Code], [Sort], [Obsolete], [CategoryCode] FROM [Mirror].[mrr_tbl].[ADA_Ethnicity];



GO
