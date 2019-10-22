SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE VIEW [mrr].[CNS_tblClinicalNoteCategoryValues] AS SELECT [Clinical_Note_Category_ID], [Clinical_Note_Category_Desc], [Active], [Default_Flag], [External_Code1], [External_Code2], [Display_Order], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm] FROM [Mirror].[mrr_tbl].[CNS_tblClinicalNoteCategoryValues];

GO
