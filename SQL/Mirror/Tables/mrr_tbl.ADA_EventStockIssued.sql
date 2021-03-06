SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[ADA_EventStockIssued](
	[EventStockIssuedRef] [uniqueidentifier] NOT NULL,
	[IssueDate] [datetime] NULL,
	[CaseRef] [uniqueidentifier] NULL,
	[PrescriptionChargeExemptionStatusRef] [uniqueidentifier] NULL,
	[PersonallyAdministered] [bit] NULL,
	[ImmediateTreatment] [bit] NULL,
	[Obsolete] [bit] NULL
) ON [PRIMARY]

GO
