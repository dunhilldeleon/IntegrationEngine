SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE VIEW [mrr].[CNS_tblStaffJobRoleCodeValues] AS SELECT [Staff_Job_Role_Code_ID], [Staff_Job_Role_Code_Desc], [Active], [Default_Flag], [External_Code1], [External_Code2], [Display_Order], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm] FROM [Mirror].[mrr_tbl].[CNS_tblStaffJobRoleCodeValues];
GO
