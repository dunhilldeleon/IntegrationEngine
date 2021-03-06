SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON








CREATE VIEW  [dbo].[vwCNS_InscopeAttachment]
AS 

SELECT  att.Attachment_ID
	, af.Attachment_File_ID 
	, 'CNS' AS SourceSystem
	, p.Patient_ID
	, prac.Practice_Code
	, LEFT(prac.Practice_Name, 100) AS Practice_Name
	, gp.GP_Code
	, LEFT(IIF(ISNULL(gp.First_Name, '')='', gp.Last_Name, gp.First_Name + ' ' + gp.Last_Name), 100) AS GP_Name
	, p.NHS_Number	
	, p.Surname 
	, p.Forename 
	, p.Date_Of_Birth 
	, p.Gender_ID 					 
FROM mrr.CNS_tblAttachment		att
LEFT JOIN [MHOXCARESQL01\MHOXCARESQL01].CareNotesOxfordLive.dbo.tblAttachmentFile af 
	ON af.Attachment_ID = att.Attachment_ID
LEFT JOIN mrr.CNS_tblPatient								p 
	ON p.Patient_ID = att.Patient_ID
LEFT JOIN mrr.CNS_tblGPDetail								gpd
	ON gpd.Patient_ID = p.Patient_ID 
	AND gpd.End_Date IS NULL 
	--AND att.Doc_Date BETWEEN gpd.Start_Date 
	--AND COALESCE(gpd.End_Date, '20991231')
LEFT JOIN mrr.CNS_tblPractice							prac 
	ON prac.Practice_ID = gpd.Practice_ID
LEFT JOIN mrr.CNS_tblAttachmentStatusValues			asv
	ON asv.Attachment_Status_ID = att.Attachment_Status_ID
LEFT JOIN mrr.CNS_tblGP									gp 
		ON gp.GP_ID = gpd.GP_ID
WHERE 
(	(
        SELECT MAX(Updated_Dttm)
        FROM
        (
            VALUES
                (att.Updated_Dttm)
                , (af.Updated_Dttm)
        ) AS alldates (Updated_Dttm)
    )  > ISNULL((SELECT [MaxUpdateTime] AS [MaxUpdateTime] FROM [dbo].[tblHL7_TableTracker] WHERE SourceSystem = 'CNS' AND TABLE_NAME = 'CNS_tblAttachment') ,'1 Jan 1900')
	AND asv.Attachment_Status_Desc LIKE '%Approved%'
	AND prac.Practice_Code IS NOT NULL 
	AND prac.Practice_Code NOT LIKE 'V9%'
	AND p.Patient_Name LIKE '%XX%TEST%' 
	AND p.Patient_Name NOT LIKE '%DO%NOT%USE%' 
)
OR EXISTS (SELECT 1 FROM [dbo].[tblHL7_SendTracker_Attachment] tr WHERE 'MH'+'_'+CAST(af.Attachment_ID AS VARCHAR)+'_'+prac.Practice_Code = tr.IntegratedDocumentID AND tr.[SourceSystem] = 'CNS' AND tr.FailureReason <> '0') 





GO
