SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE VIEW [mrr].[ADA_EventStockIssuedItem] AS SELECT [EventStockIssuedItemRef], [EventStockIssuedRef], [StockItemRef], [IssueType], [BatchNo], [ExpiryDate] FROM [Mirror].[mrr_tbl].[ADA_EventStockIssuedItem];

GO
