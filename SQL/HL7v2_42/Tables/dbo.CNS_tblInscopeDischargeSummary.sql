SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CNS_tblInscopeDischargeSummary](
	[OHFTDischargeNotificationSummaryV3_ID] [bigint] NOT NULL,
	[Patient_ID] [int] NOT NULL,
	[Episode_ID] [int] NULL,
	[Referral_ID] [int] NOT NULL
) ON [PRIMARY]

GO
