SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
 

CREATE VIEW  [mrr].[CNC_tblMedicine] AS SELECT [Medicine_ID], [Generic_Name], [Guidance_Notes], [Active_Flag_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm] FROM [Mirror].[mrr_tbl].[CNC_tblMedicine];

GO
