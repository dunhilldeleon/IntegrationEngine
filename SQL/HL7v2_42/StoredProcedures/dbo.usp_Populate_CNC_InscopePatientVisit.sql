SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


CREATE  PROCEDURE [dbo].[usp_Populate_CNC_InscopePatientVisit]
AS

DECLARE @Max_Date DATETIME

SET @Max_Date = (	SELECT MAX([MaxUpdateTime]) 
					FROM [dbo].[tblHL7_TableTracker] 
					WHERE [SourceSystem] = 'CNC'
					AND TABLE_NAME = 'CNC_PatientVisit')

BEGIN TRY

	BEGIN TRANSACTION;

		TRUNCATE TABLE [dbo].[CNC_tblInscopePatientVisit]

		--load new data 
		INSERT INTO  [dbo].[CNC_tblInscopePatientVisit]
		SELECT Patient_ID
			, Episode_ID
			, Ward_Stay_ID
			, WardStay_Updated_Dttm
		FROM [dbo].[vwCNC_InscopePatientVisit] scope
		WHERE scope.WardStay_Updated_Dttm > @Max_Date
		AND (scope.Actual_Start_Dttm > @Max_Date OR scope.Actual_End_Dttm > @Max_Date)

		--Load failed to send data 
		INSERT INTO  [dbo].[CNC_tblInscopePatientVisit]
		SELECT W.Patient_ID
			, CND.Episode_ID
			, W.Ward_Stay_ID
			, W.Updated_Dttm AS WardStay_Updated_Dttm
		FROM mrr.CNC_tblWardStay AS W
		INNER JOIN mirror.mrr.CNC_tblCNDocument CND 
			ON W.Ward_Stay_ID = CND.CN_Object_ID
			AND Object_Type_ID = 82
		LEFT JOIN mirror.mrr.CNC_tblEpisode e
			ON cnd.Episode_ID = e.Episode_ID
		WHERE EXISTS (SELECT 1 FROM [dbo].[tblHL7_SendTracker_PatientVisit] pv WHERE pv.PV_ID LIKE 'CH%' AND W.Ward_Stay_ID = REPLACE(REPLACE(REPLACE(REPLACE(pv.PV_ID,'CH-',''),'-A01',''),'-A02',''),'-A03',''))
		AND NOT EXISTS (SELECT 1 FROM [dbo].[CNC_tblInscopePatientVisit] pv WHERE pv.Ward_Stay_ID = W.Ward_Stay_ID)



		COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH;

GO
