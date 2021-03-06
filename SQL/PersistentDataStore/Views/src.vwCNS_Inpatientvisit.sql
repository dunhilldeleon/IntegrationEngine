SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


CREATE view [src].[vwCNS_Inpatientvisit]
as
--not finished, still need to bring in ascribe wards and check whether using ConsultantGMCCode or professional registration entry

with latestwardstay as
( select * from(
select   Ward_Stay_ID ,
         CND.Episode_ID ,
                    W.Patient_ID ,
                    W.Location_ID ,
                    L.Location_Name as WardName ,
                    Actual_Start_Dttm as Ward_Adm_Dttm ,
                    Actual_End_Dttm as Ward_Dis_Dttm ,
                    W.Updated_Dttm as Wardstay_Updated_Dttm,
					row_number() over ( partition by CND.Episode_ID,w.Patient_ID order by w.Updated_Dttm desc ) as RN
          from      OHMirror.mirror.mrr.CNS_tblWardStay as W
                    inner join OHMirror.mirror.mrr.CNS_tblCNDocument CND on W.Ward_Stay_ID = CND.CN_Object_ID
                                                            and CND.ViewForm = 'Ward Stay'
                    inner join OHMirror.mirror.mrr.CNS_tblLocation as L on W.Location_ID = L.Location_ID
          where     Actual_Start_Dttm is not null
                    and coalesce(Actual_End_Dttm, getdate()) > Actual_Start_Dttm
                    and cast(Actual_Start_Dttm as date) <> cast(coalesce(W.Actual_End_Date,
                                                              getdate()) as date)
                    and L.Location_Name not like '%Test%') wardstay


where wardstay.RN =1),

externalMapping
    AS ( SELECT   ECM.Internal_Data_Key ,
                COALESCE(ECM.External_Code,
                            ECMDS.External_Code_Mapping_Default_Value,
                            ECMV.External_Code_Mapping_Default_Value) AS External_Code ,
                ECMDS.External_Code_Mapping_Data_Source_Key AS DataType
        FROM     OHMirror.mirror.mrr.CNS_tblExternalCodeMappingContextValues ECMV
                LEFT OUTER JOIN OHMirror.mirror.mrr.CNS_tblExternalCodeMappingDataSource ECMDS 
					ON ECMV.External_Code_Mapping_Context_ID = ECMDS.External_Code_Mapping_Context_ID
                LEFT OUTER JOIN OHMirror.mirror.mrr.CNS_tblExternalCodeMapping ECM 
					ON ECMDS.External_Code_Mapping_Data_Source_ID = ECM.External_Code_Mapping_Data_Source_ID
        WHERE    ECMV.External_Code_Mapping_Context_Key = 'MHMDS'
                AND ECMDS.External_Code_Mapping_Data_Source_Key IN ('Discharge_Method_Episode')
        )


select * from
( select e.Patient_ID
     , pc.code     AS Episode_Type -- from HL70004 PatientClass
     , ws.Location_ID AS Ward_LocationID --to link with ascribe codes
     , at.code as Admission_Type
     , sc.Consultant_GMC_Code AS Consulting_GMC_Code  ---or use professional registration entry?? 
     , sc.Surname AS Consulting_Surname
     , sc.Forename AS Consulting_Forename
     , adm.code as Admit_Source --  referral source
     , e.Episode_ID
     , exmap.External_Code as Discharge_Method --national code for discharge method
     , dd.code as Discharge_Destination_ID --itk0013 codes
     , replace(convert(varchar(8),ws.Ward_Adm_Dttm, 112)+convert(varchar(8),ws.Ward_Adm_Dttm, 114), ':','')       as PV_Start
     , replace(convert(varchar(8),ws.Ward_Dis_Dttm, 112)+convert(varchar(8),ws.Ward_Dis_Dttm, 114), ':','')   as PV_End
	 ,ws.Wardstay_Updated_Dttm
	 ,e.Updated_Dttm as Episode_Updated_Dttm
	, ROW_NUMBER() OVER(PARTITION by e.patient_ID ORDER BY e.Updated_Dttm deSC) as RN 
	

FROM OHMirror.mirror.mrr.CNS_tblEpisode e
   
	left Join	HL7v2_42_ReferenceData.dbo.tblHL70004PatientClass					pc
		on pc.PicklistID = e.Episode_Type_ID
	left join	HL7v2_42_ReferenceData.dbo.tblHL70007AdmissionType						at
	on at.picklistID = e.Episode_Priority_ID and at.sourcesystem = 'CN MH'
    LEFT JOIN OHMirror.mirror.mrr.CNS_tblGPDetail											gpd
        ON gpd.Patient_ID = e.Patient_ID
    LEFT JOIN OHMirror.mirror.mrr.CNS_tblGP												 gp
        ON gp.GP_ID = e.GP_ID
           AND gpd.Start_Date <= e.Start_Date
           AND COALESCE(gpd.End_Date, CONVERT(DATE, GETDATE())) <= COALESCE(e.Discharge_Date, CONVERT(DATE, GETDATE()))
    LEFT JOIN OHMirror.mirror.mrr.CNS_tblTeamMember										tm
        ON tm.Patient_ID = e.Patient_ID
           AND tm.Team_Member_Role_ID = 0
           AND tm.Start_Date <= CONVERT(DATE, e.Start_Date)
           AND COALESCE(tm.End_Date, CONVERT(DATE, GETDATE())) <= COALESCE(e.Discharge_Date, CONVERT(DATE, GETDATE()))
    LEFT JOIN HL7v2_42_ReferenceData.dbo.tblHL70023AdmitSource												adm
        ON adm.PicklistID = e.Referral_Source_ID and adm.sourcesystem = 'CN MH'
    LEFT JOIN OHMirror.mirror.mrr.CNS_tblStaff											sc
        ON sc.Staff_ID = tm.Staff_ID
    left join externalMapping																exmap
        ON exmap.Internal_Data_Key = e.Discharge_Method_Episode_ID
    left join ReferenceMappingTables.dbo.tblDischargeDestination							dd
        ON dd.PicklistID = e.Discharge_Destination_ID and dd.sourcesystem = 'CNS'
    left join LatestWardStay																 ws
        ON ws.Patient_ID = e.Patient_ID
           and ws.Episode_ID = e.Episode_ID
	where   e.Episode_Type_ID = 3 ---bringing through inpatient episodes only
	AND ISNULL(e.Discharge_Destination_ID,0)	  <> 69  /*REMOVE "ENTERED IN ERROR"*/
	and ISNULL(e.Referral_Closure_Reason_ID,0)  <> 11  /*REMOVE "ENTERED IN ERROR"*/
	and ISNULL(e.Discharge_Method_Episode_ID,0) <> 26  /*REMOVE "ENTERED IN ERROR" */	
		) episode
			
		where episode.RN = 1
		






GO
