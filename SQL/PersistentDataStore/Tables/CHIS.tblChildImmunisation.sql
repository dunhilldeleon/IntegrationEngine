SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [CHIS].[tblChildImmunisation](
	[Id] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Patient_ID] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[CareNotesPatient_ID] [int] NULL,
	[ImmunisationPartNo] [int] NULL,
	[ImmunisationPartDescription] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[TreatmentCentre] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[GivenBy] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[DateOccurred] [date] NULL,
	[Outcome] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[WhereGiven] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[BatchNumber] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[BatchExpiryDate] [date] NULL,
	[Route] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[SITE] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Comments] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[CreatedDateTime] [datetime] NULL,
	[LoadID] [int] NULL
) ON [PRIMARY]

GO
