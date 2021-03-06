SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [HIE_CNC].[tblCNC_Referrals](
	[ReferralID] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[PatientID] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[UpdatedDate] [varchar](23) COLLATE Latin1_General_CI_AS NULL,
	[ReferralSource] [varchar](99) COLLATE Latin1_General_CI_AS NULL,
	[Referrer] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[RefOrgCode] [varchar](80) COLLATE Latin1_General_CI_AS NULL,
	[ContactNumber] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[ReferralDate] [varchar](23) COLLATE Latin1_General_CI_AS NULL,
	[Urgency] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[ReferralReason] [varchar](80) COLLATE Latin1_General_CI_AS NULL,
	[TeamReferredTo] [varchar](80) COLLATE Latin1_General_CI_AS NULL,
	[HCPReferredTo] [varchar](80) COLLATE Latin1_General_CI_AS NULL,
	[Specialty] [varchar](3) COLLATE Latin1_General_CI_AS NOT NULL,
	[DateReceived] [varchar](23) COLLATE Latin1_General_CI_AS NULL,
	[CareSetting] [varchar](80) COLLATE Latin1_General_CI_AS NULL,
	[DateAccepted] [varchar](23) COLLATE Latin1_General_CI_AS NULL,
	[DischargeDate] [varchar](23) COLLATE Latin1_General_CI_AS NULL,
	[DischargeHCP] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[DischargeReason] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Deleted] [int] NULL,
	[ContainsInvalidChar] [bit] NULL,
	[LoadID] [int] NULL
) ON [PRIMARY]

GO
