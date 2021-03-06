SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CNS_tblInscopeAttachments](
	[Attachment_ID] [int] NOT NULL,
	[Attachment_File_ID] [int] NULL,
	[SourceSystem] [varchar](3) COLLATE Latin1_General_CI_AS NOT NULL,
	[Patient_ID] [int] NULL,
	[Practice_Code] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[Practice_Name] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[GP_Code] [varchar](10) COLLATE Latin1_General_CI_AS NULL,
	[GP_Name] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[NHS_Number] [varchar](11) COLLATE Latin1_General_CI_AS NULL,
	[Surname] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Forename] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Date_Of_Birth] [date] NULL,
	[Gender_ID] [int] NULL
) ON [PRIMARY]

GO
