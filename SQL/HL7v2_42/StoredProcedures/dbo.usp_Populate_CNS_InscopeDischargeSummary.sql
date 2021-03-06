SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE PROCEDURE [dbo].[usp_Populate_CNS_InscopeDischargeSummary]

AS


IF OBJECT_ID('dbo.CNS_tblInscopeDischargeSummary','U') IS NULL 
BEGIN
	CREATE TABLE [dbo].[CNS_tblInscopeDischargeSummary](
		OHFTDischargeNotificationSummaryV3_ID  BIGINT NOT NULL ,
		[Patient_ID] [INT] NOT NULL,
		Episode_ID INT  NULL ,
		Referral_ID INT NOT NULL
	) 
END
ELSE
BEGIN
	TRUNCATE TABLE [dbo].[CNS_tblInscopeDischargeSummary]
END 

DECLARE @MaxDate DATETIME = ISNULL((SELECT [MaxUpdateTime] AS [MaxUpdateTime] FROM [dbo].[tblHL7_TableTracker] WHERE SourceSystem = 'CNS' AND TABLE_NAME = 'CNS_tblDischargeSummary'),'1 Jan 1900')
PRINT @MaxDate

INSERT INTO [dbo].[CNS_tblInscopeDischargeSummary]
SELECT OHFTDischargeNotificationSummaryV3_ID , dns.Patient_ID, cnd.Episode_ID, cnd.Referral_ID
FROM mrr.CNS_udfOHFTDischargeNotificationSummaryV3  dns
LEFT JOIN mrr.CNS_tblCNDocument                cnd
    ON dns.OHFTDischargeNotificationSummaryV3_ID = cnd.CN_Object_ID
        AND cnd.Object_Type_ID = 10000284
LEFT OUTER JOIN mrr.CNS_tblInvalidatedDocuments id
    ON cnd.CN_Doc_ID = id.CN_Doc_ID
WHERE dns.Patient_ID = 317172
AND  id.CN_Doc_ID IS NULL
AND cnd.Episode_ID IS NOT NULL
AND cnd.Referral_ID IS NOT NULL 
AND dns.Updated_Dttm > @MaxDate

GO
