SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON



CREATE VIEW [dbo].[vwCNS_DischargeSummary_SocialContext]
AS
SELECT ids.OHFTDischargeNotificationSummaryV3_ID
, mha.fldGenAssessSocCirc AS HouseholeComposition
, mha.fldGenAssessPersHist AS OccupationalEducationalHistory
, mha.fldAlcDrugUsage AS AlcoholDrugUse
FROM mrr.CNS_udfMHAssessmentV9 mha
LEFT JOIN mrr.CNS_tblCNDocument cnd ON cnd.CN_Object_ID = mha.MHAssessmentV9_ID AND cnd.Object_Type_ID = 10000308
INNER JOIN [dbo].[CNS_tblInscopeDischargeSummary] ids 
	ON ids.Referral_ID = cnd.Referral_ID 
LEFT JOIN mrr.CNS_tblInvalidatedDocuments id ON id.CN_Doc_ID = cnd.CN_Doc_ID
WHERE id.CN_Doc_ID IS NULL
AND mha.startdate BETWEEN ids.fldDateAdm AND ids.flddatedis

GO
