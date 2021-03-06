SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [src_CHIS].[tblCHIS_Vaccine](
	[NHS_Number] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Date_of_Immunisation] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[ImmunisationVenueType] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Immunisation_Venue_Code] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Vaccine_1_Code] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Vaccine_1_Name] [varchar](150) COLLATE Latin1_General_CI_AS NULL,
	[Part_1] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Vaccine_1_Batch_Number] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Vaccine_2_Code] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Part_2] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Vaccine_2_Batch_Number] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Vaccine_3_Code] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Part_3] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Vaccine_3_Batch_Number] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Vaccine_4_Code] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Part_4] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Vaccine_4_Batch_Number] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Vaccine_5_Code] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Part_5] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Vaccine_5_Batch_Number] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Load_Dttm] [datetime] NULL
) ON [PRIMARY]

GO
