SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE VIEW [mrr].[ADA_Location] AS SELECT [LocationRef], [Name], [Obsolete], [V2Import], [Sort], [Abbreviation], [LocationSpecificStatusDefault], [AddressRef], [Longitude], [Latitude], [LocationDescription], [MobileLocation], [PagerNumber], [MobilePhone], [FaxNumber], [PhoneNumber], [PBXRef], [BaseLocationRef], [TextDirections], [AremoteDeviceRef], [PaknetAddress], [DefaultOrganisationCode], [LoginOrganisationCodes], [OrganisationGroupRef], [NationalCode], [PathwaysSiteId], [MigIdentifier], [CDAMsgCallbackTelephoneNumber], [CDAMsgCallbackLocationName], [CDAMsgCallbackAssociatedPerson], [CDAMsgUseLocationCallbackDetails] FROM [Mirror].[mrr_tbl].[ADA_Location];
GO
