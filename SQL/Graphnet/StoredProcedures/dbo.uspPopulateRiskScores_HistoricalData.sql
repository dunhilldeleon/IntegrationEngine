SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE PROCEDURE dbo.uspPopulateRiskScores_HistoricalData
AS 


TRUNCATE TABLE [dbo].[RiskScores_HistoricalData]


INSERT INTO [dbo].[RiskScores_HistoricalData]
SELECT * FROM [Graphnet].[vwRiskScores_HistoricalData]
GO
