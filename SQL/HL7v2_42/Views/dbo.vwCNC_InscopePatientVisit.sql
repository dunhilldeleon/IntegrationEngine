SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE VIEW [dbo].[vwCNC_InscopePatientVisit]

AS 
		SELECT W.Patient_ID
				, CND.Episode_ID
				, W.Ward_Stay_ID
				, W.Updated_Dttm AS WardStay_Updated_Dttm
				, W.Actual_Start_Dttm
				, W.Actual_End_Dttm
		FROM mrr.CNC_tblWardStay AS W
			INNER JOIN mirror.mrr.CNC_tblCNDocument CND 
				ON W.Ward_Stay_ID = CND.CN_Object_ID
				AND Object_Type_ID = 82
			LEFT JOIN mirror.mrr.CNC_tblEpisode e
				ON cnd.Episode_ID = e.Episode_ID
		WHERE e.Episode_Type_ID = 3 ---bringing through inpatient episodes only
		AND (e.Discharge_Date IS NULL OR e.Discharge_Date >= '1 Jan 2019')
		AND w.Actual_Start_Date IS NOT NULL 
		AND ISNULL(e.Discharge_Destination_ID,0)	<> 69  /*REMOVE "ENTERED IN ERROR"*/
		AND ISNULL(e.Referral_Closure_Reason_ID,0)  <> 11  /*REMOVE "ENTERED IN ERROR"*/
		AND ISNULL(e.Discharge_Method_Episode_ID,0) <> 26  /*REMOVE "ENTERED IN ERROR" */	

GO
