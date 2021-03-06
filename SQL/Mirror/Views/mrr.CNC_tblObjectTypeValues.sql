SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE VIEW [mrr].[CNC_tblObjectTypeValues] AS SELECT [Object_Type_ID], [Object_Type_Desc], [Object_Type_GUID], [Form_Title], [Allow_Instances], [Tab_ID], [Show_On_Summary_Tab_ID], [Quick_Create_Link_ID], [Virtual_Parent_Document_ID], [Default_Icon], [Assembly_Name], [Data_Class_Namespace], [Data_Class_Name], [Form_Name], [Key_Table_Name], [Key_Field_Name], [Default_View_Form], [Auto_Close_Permitted_Flag_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm] FROM [Mirror].[mrr_tbl].[CNC_tblObjectTypeValues];
GO
