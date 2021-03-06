SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[ADA_Location](
	[LocationRef] [uniqueidentifier] NOT NULL,
	[Name] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Obsolete] [bit] NULL,
	[V2Import] [bit] NULL,
	[Sort] [int] NULL,
	[Abbreviation] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LocationSpecificStatusDefault] [bit] NULL,
	[AddressRef] [uniqueidentifier] NULL,
	[Longitude] [decimal](9, 6) NULL,
	[Latitude] [decimal](9, 6) NULL,
	[LocationDescription] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MobileLocation] [bit] NULL,
	[PagerNumber] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MobilePhone] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FaxNumber] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhoneNumber] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PBXRef] [uniqueidentifier] NULL,
	[BaseLocationRef] [uniqueidentifier] NULL,
	[TextDirections] [varchar](512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AremoteDeviceRef] [uniqueidentifier] NULL,
	[PaknetAddress] [varchar](14) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DefaultOrganisationCode] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LoginOrganisationCodes] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OrganisationGroupRef] [uniqueidentifier] NULL,
	[NationalCode] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PathwaysSiteId] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MigIdentifier] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CDAMsgCallbackTelephoneNumber] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CDAMsgCallbackLocationName] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CDAMsgCallbackAssociatedPerson] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CDAMsgUseLocationCallbackDetails] [bit] NULL
) ON [PRIMARY]

GO
