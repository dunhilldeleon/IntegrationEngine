SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE PROCEDURE dbo.uspPopulateRiskAssessment_HistoricalData
AS 


TRUNCATE TABLE [dbo].[RiskAssessment_HistoricalData]

INSERT INTO [dbo].[RiskAssessment_HistoricalData]
SELECT * FROM [Graphnet].[vwRiskAssessment_HistoricalData]
GO
