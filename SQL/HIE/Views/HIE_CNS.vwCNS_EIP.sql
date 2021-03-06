SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


CREATE VIEW [HIE_CNS].[vwCNS_EIP]
AS
SELECT REPLACE(CAST(epi.Episode_ID AS VARCHAR(20)), '|', '') AS EIPID
     , REPLACE(CAST(epi.Patient_ID AS VARCHAR(20)), '|', '')           AS PatientID
     , 125                                                             AS TenancyID
     , CONVERT(VARCHAR(23)
             , (
                   SELECT MAX(Updated_Dttm)
                   FROM
                   (
                       VALUES
                           (epi.Updated_Dttm)
                         , (stf.Updated_Dttm)
						 , (loc.Updated_Dttm)
                   ) AS alldates (Updated_Dttm)
               )
             , 21
              )															AS UpdatedDate
     , 1																AS ActiveEIP
     , REPLACE(stf.Staff_Name, '|', '')									AS MainContact
     , NULL																AS ContactNumber
     , CONVERT(VARCHAR(23), epi.Start_Date , 21)						AS EIPStartDate
     , NULL                                                             AS CarePlan
     , IIF(invDoc.CN_Doc_ID IS NULL, 0, 1)								AS Deleted
FROM mrr.CNS_tblEpisode											epi
    INNER JOIN HIE_CNS.tblCNS_InscopePatient      scope
        ON scope.PatientNo = epi.Patient_ID
    LEFT JOIN mrr.CNS_tblStaff                                  stf
        ON epi.Accepted_By_Staff_ID = stf.Staff_ID
    LEFT JOIN mrr.CNS_tblCNDocument                             cnDoc
        ON cnDoc.ViewForm LIKE '%episode%' 
        AND epi.Episode_ID = cnDoc.CN_Object_ID
	LEFT JOIN mrr.CNS_tblLocation								loc
		ON epi.Location_ID = loc.Location_ID
	LEFT JOIN mrr.CNS_tblInvalidatedDocuments                   invDoc
        ON invDoc.CN_Doc_ID = cnDoc.CN_Doc_ID
WHERE loc.Location_Name LIKE '%Early%Intervention%Service%'
AND epi.Discharge_Date IS NULL 
AND ISNULL(Discharge_Destination_ID,0)	  <> 69  /*REMOVE "ENTERED IN ERROR"*/
AND ISNULL(Referral_Closure_Reason_ID,0)  <> 11  /*REMOVE "ENTERED IN ERROR"*/
AND ISNULL(Discharge_Method_Episode_ID,0) <> 26  /*REMOVE "ENTERED IN ERROR" */
--eip.[fldCAARMSID] = 0  
--AND eip.Confirm_Date IS NOT NULL;




GO
