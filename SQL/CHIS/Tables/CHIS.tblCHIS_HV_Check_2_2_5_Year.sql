SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [CHIS].[tblCHIS_HV_Check_2_2_5_Year](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[NHS_Number] [varchar](10) COLLATE Latin1_General_CI_AS NULL,
	[forename] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[surname] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Child_DOB] [date] NULL,
	[Child_Gender] [varchar](10) COLLATE Latin1_General_CI_AS NULL,
	[Date_of_contact] [date] NULL,
	[Review_Location_Desc] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Created_Dttm] [datetime] NULL,
	[Sent] [bit] NULL,
	[Sent_Dttm] [datetime2](7) NULL,
	[LoadID] [int] NULL
) ON [PRIMARY]

GO
