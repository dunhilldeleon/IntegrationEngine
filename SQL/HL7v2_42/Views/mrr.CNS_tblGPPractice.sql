SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


CREATE VIEW  [mrr].[CNS_tblGPPractice] AS SELECT [GP_ID], [Practice_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm] FROM [Mirror].[mrr_tbl].[CNS_tblGPPractice];

GO
