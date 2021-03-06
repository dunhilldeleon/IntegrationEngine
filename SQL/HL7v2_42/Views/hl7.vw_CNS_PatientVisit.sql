SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON








CREATE VIEW   [hl7].[vw_CNS_PatientVisit]

AS

WITH externalMapping
    AS ( SELECT   ECM.Internal_Data_Key ,
                COALESCE(ECM.External_Code,
                            ECMDS.External_Code_Mapping_Default_Value,
                            ECMV.External_Code_Mapping_Default_Value) AS External_Code ,
                ECMDS.External_Code_Mapping_Data_Source_Key AS DataType
        FROM     mirror.mrr.CNS_tblExternalCodeMappingContextValues ECMV
                LEFT OUTER JOIN mirror.mrr.CNS_tblExternalCodeMappingDataSource ECMDS 
					ON ECMV.External_Code_Mapping_Context_ID = ECMDS.External_Code_Mapping_Context_ID
                LEFT OUTER JOIN mirror.mrr.CNS_tblExternalCodeMapping ECM 
					ON ECMDS.External_Code_Mapping_Data_Source_ID = ECM.External_Code_Mapping_Data_Source_ID
        WHERE    ECMV.External_Code_Mapping_Context_Key = 'MHMDS'
                AND ECMDS.External_Code_Mapping_Data_Source_Key IN ('Discharge_Method_Episode')
        )
, WardStays AS 
(	SELECT W.Patient_ID
		, CND.Episode_ID
		, W.Ward_Stay_ID
		, W.Location_ID
		, W.Actual_Start_Dttm AS Ward_Start_Dttm
		, W.Actual_End_Dttm AS Ward_End_Dttm
		, e.Start_Date AS Episode_Start_Date
		, e.Discharge_Date AS Episode_End_Date
		, ROW_NUMBER() OVER(PARTITION BY  CND.Episode_ID ORDER BY W.Actual_Start_Dttm ASC) AS RN  
		, e.Episode_Type_ID
		, e.Episode_Priority_ID
		, e.GP_ID
		, e.Referral_Source_ID
		, e.Discharge_Method_Episode_ID
		, e.Discharge_Destination_ID
		, e.Updated_Dttm AS EpisodeUpdated_Dttm
		, W.Updated_Dttm AS WardStay_Updated_Dttm
	FROM mrr.CNS_tblWardStay AS W
		INNER JOIN mirror.mrr.CNS_tblCNDocument CND 
			ON W.Ward_Stay_ID = CND.CN_Object_ID
			AND Object_Type_ID = 82
		LEFT JOIN mirror.mrr.CNS_tblEpisode e
			ON cnd.Episode_ID = e.Episode_ID
	WHERE EXISTS (SELECT 1 FROM [dbo].[CNS_tblInscopePatientVisit] scope WHERE scope.Ward_Stay_ID =  W.Ward_Stay_ID)
	AND e.Episode_Type_ID = 3 ---bringing through inpatient episodes only
	AND w.Actual_Start_Date IS NOT NULL 
	AND ISNULL(e.Discharge_Destination_ID,0)	<> 69  /*REMOVE "ENTERED IN ERROR"*/
	AND ISNULL(e.Referral_Closure_Reason_ID,0)  <> 11  /*REMOVE "ENTERED IN ERROR"*/
	AND ISNULL(e.Discharge_Method_Episode_ID,0) <> 26  /*REMOVE "ENTERED IN ERROR" */	
	--AND W.Patient_ID = 264823--181938
)
,  Main AS
( 
		--==================
		--Admissions
		--==================
		SELECT Patient_ID, Episode_ID, Ward_Stay_ID, Location_ID, Ward_Start_Dttm, NULL AS Ward_End_Dttm, 'A01' AS Event_Type, Episode_Type_ID, Episode_Priority_ID, GP_ID, Referral_Source_ID, Discharge_Method_Episode_ID, Discharge_Destination_ID, EpisodeUpdated_Dttm, WardStay_Updated_Dttm
		, Episode_Start_Date, Episode_End_Date
		FROM WardStays
		WHERE RN = 1

		UNION ALL

		--==================
		--Transfers 
		--==================
		SELECT Patient_ID, Episode_ID
		, Ward_Stay_ID
		, Location_ID
		, Ward_Start_Dttm
		, NULL AS Ward_End_Dttm
		, 'A02' AS EventType
		, Episode_Type_ID, Episode_Priority_ID, GP_ID, Referral_Source_ID, Discharge_Method_Episode_ID, Discharge_Destination_ID, EpisodeUpdated_Dttm, WardStay_Updated_Dttm, Episode_Start_Date, Episode_End_Date
		FROM WardStays m1
		WHERE --CAST(ISNULL(Ward_End_Dttm,'1 Jan 1900') AS DATE) != CAST(ISNULL(Episode_End_Date,'1 Jan 1999') AS DATE) 
		RN != 1
		AND Ward_Start_Dttm IS NOT NULL 

		UNION ALL
		--==================
		--Discharges
		--==================
		SELECT Patient_ID, Episode_ID, Ward_Stay_ID, Location_ID, Ward_Start_Dttm, Ward_End_Dttm, 'A03', Episode_Type_ID, Episode_Priority_ID, GP_ID, Referral_Source_ID, Discharge_Method_Episode_ID, Discharge_Destination_ID, EpisodeUpdated_Dttm, WardStay_Updated_Dttm
		, Episode_Start_Date, Episode_End_Date
		FROM WardStays 
		WHERE CAST(Ward_End_Dttm AS DATE) = CAST(Episode_End_Date AS DATE)   
		AND ISNULL(Episode_End_Date, '') <> ''
)

SELECT  DISTINCT 
	     'MH-'+CAST(mn.Ward_Stay_ID AS VARCHAR)+'-'+mn.Event_Type AS PV_ID
		, mpi.MPI_ID
		, mn.Ward_Stay_ID
		, mn.Patient_ID
		, pc.code					AS Patient_Class -- from HL70004 PatientClass
		, mn.Location_ID			AS Ward_LocationID --to link with ascribe codes
		, at.code					AS Admission_Type
		, sc.Consultant_GMC_Code	AS Consulting_GMC_Code  ---or use professional registration entry?? 
		, sc.Surname				AS Consulting_Surname
		, sc.Forename				AS Consulting_Forename
		, adm.code					AS Admit_Source --  referral source
		, 'MH-'+CAST(mn.Episode_ID AS VARCHAR)		AS Episode_ID
		, exmap.External_Code		AS Discharge_Method --national code for discharge method
		, dd.code					AS Discharge_Destination_ID --itk0013 codes
        , CONVERT(VARCHAR(20), mn.[Ward_Start_Dttm], 112) +REPLACE(CONVERT(VARCHAR(20), [Ward_Start_Dttm], 108),':','') AS [PV_Start]
        , CONVERT(VARCHAR(20), mn.[Ward_End_Dttm], 112) +REPLACE(CONVERT(VARCHAR(20), [Ward_End_Dttm], 108),':','')	AS [PV_End]
		, mn.Event_Type
        , mn.[Ward_Start_Dttm]
        , mn.[Ward_End_Dttm]
		, mn.WardStay_Updated_Dttm
FROM Main mn
	INNER JOIN [dbo].[CNS_tblInscopePatientVisit]					inscope
		ON inscope.Episode_ID = mn.Episode_ID
	LEFT JOIN [PersistentDataStore].[dbo].[tblOH_MPI]				mpi
		ON mn.Patient_ID = mpi.MH_Patient_ID
	LEFT JOIN	HL7v2_42_ReferenceData.dbo.tblHL70004PatientClass	pc
		ON pc.PicklistID = mn.Episode_Type_ID
	LEFT JOIN	HL7v2_42_ReferenceData.dbo.tblHL70007AdmissionType	at
		ON at.picklistID = mn.Episode_Priority_ID 
		AND at.sourcesystem = 'CN MH'
    LEFT JOIN mirror.mrr.CNS_tblGPDetail					gpd
        ON gpd.Patient_ID = mn.Patient_ID
		AND gpd.End_Date IS NULL
    LEFT JOIN mirror.mrr.CNS_tblGP							gp
        ON gp.GP_ID = mn.GP_ID
        AND gpd.Start_Date <= mn.Episode_Start_Date
        AND COALESCE(gpd.End_Date, CONVERT(DATE, GETDATE())) <= COALESCE(mn.Episode_End_Date, CONVERT(DATE, GETDATE()))
    LEFT JOIN mirror.mrr.CNS_tblTeamMember					tm
        ON tm.Patient_ID = mn.Patient_ID
           AND tm.Team_Member_Role_ID = 0
		   AND tm.End_Date IS NULL
           --AND tm.Start_Date <= CONVERT(DATE, mn.Episode_Start_Date)
           --AND COALESCE(tm.End_Date, CONVERT(DATE, GETDATE())) <= COALESCE(mn.Episode_End_Date, CONVERT(DATE, GETDATE()))
    LEFT JOIN HL7v2_42_ReferenceData.dbo.tblHL70023AdmitSource		adm
        ON adm.PicklistID = mn.Referral_Source_ID 
		AND adm.sourcesystem = 'CN MH'
    LEFT JOIN mirror.mrr.CNS_tblStaff						sc
        ON sc.Staff_ID = tm.Staff_ID
    LEFT JOIN externalMapping										exmap
        ON exmap.Internal_Data_Key = mn.Discharge_Method_Episode_ID
    LEFT JOIN ReferenceMappingTables.dbo.tblDischargeDestination	dd
        ON dd.PicklistID = mn.Discharge_Destination_ID AND dd.sourcesystem = 'CNS'

WHERE mpi.MPI_ID IS NOT NULL 


GO
