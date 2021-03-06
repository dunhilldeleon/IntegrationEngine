SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE VIEW [mrr].[CNC_tblAttachment] AS SELECT [Attachment_ID], [Patient_ID], [Doc_Author_Staff_ID], [Doc_Date], [General_Document_Category_ID], [Doc_Title], [Attachment_Status_ID], [Attachment_Status_By_Staff_ID], [Attachment_Status_Date], [Version_Group], [Version_Number], [On_Behalf_Of_Staff_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Object_Type_ID], [Comments] FROM [Mirror].[mrr_tbl].[CNC_tblAttachment];
GO
