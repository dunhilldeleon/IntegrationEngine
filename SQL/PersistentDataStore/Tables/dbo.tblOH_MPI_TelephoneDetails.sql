SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tblOH_MPI_TelephoneDetails](
	[MPI_ID] [bigint] NOT NULL,
	[NokContact_ID] [bigint] NULL,
	[Telephone_Number] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[PhoneTypeCode] [varchar](10) COLLATE Latin1_General_CI_AS NULL,
	[UseCode] [varchar](3) COLLATE Latin1_General_CI_AS NULL,
	[ContactRole] [varchar](10) COLLATE Latin1_General_CI_AS NULL,
	[PhoneType] [varchar](10) COLLATE Latin1_General_CI_AS NULL,
	[Main_Number_Flag] [bit] NULL,
	[Updated_Dttm] [datetime] NULL
) ON [PRIMARY]

GO
