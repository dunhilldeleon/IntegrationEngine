SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CNS_tblInscopePatientVisit](
	[Patient_ID] [int] NOT NULL,
	[Episode_ID] [int] NULL,
	[Ward_Stay_ID] [int] NOT NULL,
	[WardStay_Updated_Dttm] [datetime] NOT NULL
) ON [PRIMARY]

GO
