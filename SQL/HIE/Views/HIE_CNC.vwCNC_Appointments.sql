SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


CREATE VIEW [HIE_CNC].[vwCNC_Appointments]

AS

WITH  abc AS (SELECT app.Diary_Appointment_ID, stf.Staff_Name
FROM mrr.CNC_tblDiaryAppointment app
INNER JOIN [HIE_CNC].[tblCNC_InscopePatient]			scope 
	ON app.Patient_ID = scope.PatientNo
LEFT JOIN  [mrr].[CNC_tblDiaryAppointmentClinicianAttendee]  atndee
	ON app.Diary_Appointment_ID = atndee.Diary_Appointment_ID
LEFT JOIN mrr.CNC_tblStaff stf 
	ON  atndee.Clinician_Attendee_Staff_ID = stf.Staff_ID
)
, Staff_Name AS 
(
SELECT Diary_Appointment_ID,  Staff_Name = STUFF(
             (SELECT ', ' + Staff_Name 
              FROM abc t1
              WHERE t1.Diary_Appointment_ID = t2.Diary_Appointment_ID
              FOR XML PATH (''))
             , 1, 1, '') 
FROM abc t2
GROUP BY Diary_Appointment_ID
)

SELECT app.Diary_Appointment_ID					AS Appointment_ID
	, app.Patient_ID
	, app.Att_Start_Date + app.Att_Start_Time	AS Appointment_DateTime
	, app.Updated_Dttm							AS [UpdatedDate]
	, 'Diary'									AS [Clinic_Community_Indicator]
	, atv.[Attendance_Type_Desc]				AS [Appointment_Type] 
	, loc.Location_Name							AS [Location]
	, sn.Staff_Name								AS [HCPName]
	, CASE WHEN ct.Event_Type_Of_Contact_Desc = 'Face to Face Communication'
			THEN  'F2F'
			ELSE 'Non F2F'
	   END 										AS [Face_to_Face_Indicator]
	, IIF(InvcnDoc.CN_Doc_ID IS NULL, 0, 1)		AS Deleted
FROM mrr.CNC_tblDiaryAppointment						app
INNER JOIN [HIE_CNC].[tblCNC_InscopePatient]			scope 
	ON app.Patient_ID = scope.PatientNo
LEFT JOIN mrr.CNC_tblLocation							loc
	ON App.Att_Location_ID = loc.Location_ID
LEFT JOIN Staff_Name sn 
	ON app.Diary_Appointment_ID = sn.Diary_Appointment_ID
LEFT JOIN [mrr].[CNC_tblAttendanceTypeValues]			atv
	ON app.Attendance_Type_ID  = atv.[Attendance_Type_ID]
LEFT JOIN mrr.CNC_tblCNDocument							cnDoc
    ON cnDoc.CN_Object_ID = app.Diary_Appointment_ID
        AND cnDoc.Object_Type_ID = 60
LEFT JOIN mrr.CNC_tblInvalidatedDocuments				InvcnDoc
    ON cnDoc.CN_Doc_ID = InvcnDoc.CN_Doc_ID
LEFT JOIN [mrr].[CNC_tblEventTypeOfContactValues] ct
	ON ct.[Event_Type_Of_Contact_ID] = app.Scheduled_Event_Type_Of_Contact_ID
WHERE app.Attendance_Type_ID <> 26 -- Entered in error
AND atv.[Attendance_Type_Desc] NOT LIKE '%To Be Attended%'

UNION 

SELECT app.Appointment_ID
	, app.Patient_ID
	, app.Attended_Date + app.Actual_Start_Time AS Appointment_DateTime
	, app.Updated_Dttm							AS [UpdatedDate]
	, 'Clinic'									AS [Clinic_Community_Indicator]
	, atv.[Attendance_Type_Desc]				AS [Appointment Type] 
	, c.Clinic_Name								AS [Location]
	, stf.Staff_Name							AS [HCPName]
	, 'F2F'										AS [Face to Face Indicator]
	, IIF(InvcnDoc.CN_Doc_ID IS NULL, 0, 1)		AS Deleted
FROM mrr.CNC_tblAppointment								app
INNER JOIN [HIE_CNC].[tblCNC_InscopePatient]			scope 
	ON app.Patient_ID = scope.PatientNo
LEFT JOIN mrr.CNC_tblAppointmentOutcomeValues			aov
	ON app.Appointment_Outcome_ID = aov.Appointment_Outcome_ID
LEFT JOIN mrr.CNC_tblClinic								c
	ON App.Clinic_ID = c.Clinic_ID
LEFT JOIN mrr.CNC_tblStaff								stf
	ON app.Clinic_Date_Attending_Clinician_Staff_ID = stf.Staff_ID
LEFT JOIN [mrr].[CNC_tblAttendanceTypeValues]			atv
	ON app.Attendance_Type_ID  = atv.[Attendance_Type_ID]
LEFT JOIN mrr.CNC_tblCNDocument							cnDoc
    ON cnDoc.CN_Object_ID = app.Appointment_ID
        AND cnDoc.Object_Type_ID = 30
LEFT JOIN mrr.CNC_tblInvalidatedDocuments				InvcnDoc
    ON cnDoc.CN_Doc_ID = InvcnDoc.CN_Doc_ID

WHERE app.Appointment_Outcome_ID <> 21 -- Entered in error
AND atv.[Attendance_Type_Desc] NOT LIKE '%To Be Attended%'

GO
