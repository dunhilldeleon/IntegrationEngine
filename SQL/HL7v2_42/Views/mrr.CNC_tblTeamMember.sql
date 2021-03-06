SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE VIEW  [mrr].[CNC_tblTeamMember] AS SELECT [Team_Member_ID], [Patient_ID], [Staff_ID], [Team_Member_Role_ID], [Start_Date], [End_Date], [Location_ID], [Sub_Specialty_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Staff_Occupation_Code_ID], [Mental_Health_Responsible_Clinician_ID] FROM [Mirror].[mrr_tbl].[CNC_tblTeamMember];

GO
