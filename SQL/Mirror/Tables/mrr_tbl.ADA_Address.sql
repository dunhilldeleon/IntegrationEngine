SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[ADA_Address](
	[AddressRef] [uniqueidentifier] NOT NULL,
	[Building] [varchar](55) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BuildingExtension] [varchar](55) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Street] [varchar](55) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Locality] [varchar](55) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Town] [varchar](55) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[County] [varchar](55) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Postcode] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddressType] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Directions] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Country] [varchar](55) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountryRef] [uniqueidentifier] NULL,
	[Longitude] [decimal](9, 6) NULL,
	[Latitude] [decimal](9, 6) NULL,
	[MapReference] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StatusRef] [uniqueidentifier] NULL,
	[UPRN] [varchar](12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
