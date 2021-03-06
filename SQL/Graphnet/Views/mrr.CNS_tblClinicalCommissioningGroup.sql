SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE VIEW [mrr].[CNS_tblClinicalCommissioningGroup] AS SELECT [CCG_ID], [CCG_Identifier], [CCG_Name], [National_Grouping_Code], [High_Level_Health_Geography_Code], [Address_Line1], [Address_Line2], [Address_Line3], [Town], [County], [Post_Code], [Open_Date], [Close_Date], [Status], [Authorisation_Indicator], [Ammendment_Indicator], [Locally_Managed_Flag_ID], [Active_Flag_ID], [Comments], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Organisation_Sub_Type_Code], [Contact_Telephone_Number], [CCG_Record_Type_ID], [Organisation_Type_Code], [Country_Code] FROM [Mirror].[mrr_tbl].[CNS_tblClinicalCommissioningGroup];

GO
