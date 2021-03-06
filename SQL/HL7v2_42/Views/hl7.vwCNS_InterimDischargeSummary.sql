SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON



CREATE  VIEW [hl7].[vwCNS_InterimDischargeSummary]
AS 
WITH  Pat_Adrs AS 
( SELECT adrs.Address_ID, Patient_ID , Start_Date, End_Date,
        ROW_NUMBER() OVER ( PARTITION BY Patient_ID ORDER BY Start_Date DESC ) AS RowNum
	FROM mrr.CNS_tblAddress adrs
	WHERE adrs.End_Date IS NULL 
)
SELECT 
--Info for kattering envelop
       CONVERT(VARCHAR(20), dns.Confirm_Date, 103)    AS MsgIssueDate
	 , 'MH'										AS sourceSystem
     , 'CarenotesMH'							AS MsgSender
     , 'Docman'			AS MsgRecipient
     , 'NHS'			AS IdType
     , pat.NHS_Number	AS IdValue
     , 'CU'				AS PersonNameType
     --, Surname
     --, 'Fathi 444' as Forename
     --, CONVERT(VARCHAR(20), Date_Of_Birth, 103)   AS Date_Of_Birth
     , pat.Gender_ID
     , gp.GP_Code AS RecpHcpCode
     , IIF(ISNULL(gp.First_Name, '')='', gp.Last_Name, gp.First_Name + ' ' + gp.Last_Name) AS RecpHcpDescription
     , prac.Practice_Code AS RecpPracticeCode
     , prac.Practice_Name AS RecpPracticeName
	 , st.Consultant_GMC_Code AS SendHCPCode
	 , st.Staff_Name AS SendHCPDesc
     , l.Location_Name AS SendDepartment
	, 'RNU' AS OrgCode
	, 'Oxford Health' AS OrgName
     , dns.OHFTDischargeNotificationSummaryV3_ID AS IntegratedDocumentID
     , 'Discharge Summary' AS ReportType
     ,  CASE WHEN ISDATE(dns.fldDateAdm) = 1 THEN CONVERT(VARCHAR(20),dns.fldDateAdm, 103) END AS EventDate
     , CONVERT(VARCHAR(20), dns.fldDateDis, 103)    AS EventDateEnd
     , CONVERT(VARCHAR(20), dns.Confirm_Date, 103) AS DocCreationDate

	 , 'pdf' AS FileExtension
	 , 'MH Inpatient Interim Discharge Summary' AS Attachment_File_Name
-- Prepare document
    , CompletedByStaffDesc                       = st.Forename + ' ' + st.Surname
	, pat.NHS_Number
	, pat.Forename
	, pat.Surname
	, CAST(CONVERT(VARCHAR(20), LTRIM(RTRIM(pat.Date_of_Birth)), 103) AS DATE) AS Date_of_Birth
	, DATEDIFF(dd,Date_of_Birth, GETDATE())/365 AS Age
	, adrs.Address1
	, adrs.Address2
	, adrs.Address3
	, adrs.Address4
	, adrs.Address5
	,adrs.Post_code
	,gp.First_Name +' ' + gp.Last_Name AS GP_Name
	,prac.Practice_Name
	, prac.Address1 AS Practice_Address1
	, prac.Address2 AS Practice_Address2 
	, prac.Address3 AS Practice_Address3
	, prac.Address4 AS Practice_Address4
	, prac.Address5 AS Practice_Address5
	, prac.Post_code AS Practice_Postcode

     , dns.fldDisLoc
     , dns.fldDisLocTele
     , dns.fldConsult
     , dns.fldCareCoord
     , CASE WHEN ISDATE(dns.fldDateAdm) = 1 THEN dns.fldDateAdm END AS fldDateAdm
     , CONVERT(NVARCHAR(10), dns.fldDateDis, 103) AS fldDateDis
     , dns.fldMHAStat
     , dns.StartDate
     , yn1.Yes_No_Desc                            AS DisIssued
     , yn2.Yes_No_Desc                            AS ohftStaff
     , cnd.CN_Doc_ID
     , st.Staff_Name
     , dns.OHFTDischargeNotificationSummaryV3_ID
     , dns.Confirm_Flag_ID
     , dns.fldDiagnosis
     , dns.fldSecDiagnosis0
     , dns.fldSecDiagnosis1
     , dns.fldSecDiagnosis2
     , dns.fldSecDiagnosis3
     , dns.fldSecDiagnosis4
     , dns.fldBriefSumm
     , dns.fldDisPlan
     , dns.fldDisComments
     , dns.fldDateNotIss
     , st2.Staff_Name                             AS SevenDayStaff
     , dns.fld7DayFollowComm
     , m1.Generic_Name                            AS MedName1
     , m2.Generic_Name                            AS MedName2
     , m3.Generic_Name                            AS MedName3
     , m4.Generic_Name                            AS MedName4
     , m5.Generic_Name                            AS MedName5
     , m6.Generic_Name                            AS MedName6
     , m7.Generic_Name                            AS MedName7
     , m8.Generic_Name                            AS MedName8
     , m9.Generic_Name                            AS MedName9
     , m10.Generic_Name                           AS MedName10
     , m11.Generic_Name                           AS MedName11
     , m12.Generic_Name                           AS MedName12
     , m13.Generic_Name                           AS MedName13
     , m14.Generic_Name                           AS MedName14
     , m15.Generic_Name                           AS MedName15
     , m16.Generic_Name                           AS MedName16
     , m17.Generic_Name                           AS MedName17
     , m18.Generic_Name                           AS MedName18
     , m19.Generic_Name                           AS MedName19
     , m20.Generic_Name                           AS MedName20
     , m21.Generic_Name                           AS MedName21
     , m22.Generic_Name                           AS MedName22
     , m23.Generic_Name                           AS MedName23
     , m24.Generic_Name                           AS MedName24
     , m25.Generic_Name                           AS MedName25
     , dns.flddose1
     , dns.flddose2
     , dns.flddose3
     , dns.flddose4
     , dns.flddose5
     , dns.flddose6
     , dns.flddose7
     , dns.flddose8
     , dns.flddose9
     , dns.flddose10
     , dns.flddose11
     , dns.flddose12
     , dns.flddose13
     , dns.flddose14
     , dns.flddose15
     , dns.flddose16
     , dns.flddose17
     , dns.flddose18
     , dns.flddose19
     , dns.flddose20
     , dns.flddose21
     , dns.flddose22
     , dns.flddose23
     , dns.flddose24
     , dns.flddose25
     , r1.UDP_medroute_Desc                       AS routeDesc1
     , r2.UDP_medroute_Desc                       AS routeDesc2
     , r3.UDP_medroute_Desc                       AS routeDesc3
     , r4.UDP_medroute_Desc                       AS routeDesc4
     , r5.UDP_medroute_Desc                       AS routeDesc5
     , r6.UDP_medroute_Desc                       AS routeDesc6
     , r7.UDP_medroute_Desc                       AS routeDesc7
     , r8.UDP_medroute_Desc                       AS routeDesc8
     , r9.UDP_medroute_Desc                       AS routeDesc9
     , r10.UDP_medroute_Desc                      AS routeDesc10
     , r11.UDP_medroute_Desc                      AS routeDesc11
     , r12.UDP_medroute_Desc                      AS routeDesc12
     , r13.UDP_medroute_Desc                      AS routeDesc13
     , r14.UDP_medroute_Desc                      AS routeDesc14
     , r15.UDP_medroute_Desc                      AS routeDesc15
     , r16.UDP_medroute_Desc                      AS routeDesc16
     , r17.UDP_medroute_Desc                      AS routeDesc17
     , r18.UDP_medroute_Desc                      AS routeDesc18
     , r19.UDP_medroute_Desc                      AS routeDesc19
     , r20.UDP_medroute_Desc                      AS routeDesc20
     , r21.UDP_medroute_Desc                      AS routeDesc21
     , r22.UDP_medroute_Desc                      AS routeDesc22
     , r23.UDP_medroute_Desc                      AS routeDesc23
     , r24.UDP_medroute_Desc                      AS routeDesc24
     , r25.UDP_medroute_Desc                      AS routeDesc25
     , dns.fldcomm1
     , dns.fldcomm2
     , dns.fldcomm3
     , dns.fldcomm4
     , dns.fldcomm5
     , dns.fldcomm6
     , dns.fldcomm7
     , dns.fldcomm8
     , dns.fldcomm9
     , dns.fldcomm10
     , dns.fldcomm11
     , dns.fldcomm12
     , dns.fldcomm13
     , dns.fldcomm14
     , dns.fldcomm15
     , dns.fldcomm16
     , dns.fldcomm17
     , dns.fldcomm18
     , dns.fldcomm19
     , dns.fldcomm20
     , dns.fldcomm21
     , dns.fldcomm22
     , dns.fldcomm23
     , dns.fldcomm24
     , dns.fldcomm25
     , pr1.UDP_ohftprescriber_Desc                AS prescDesc1
     , pr2.UDP_ohftprescriber_Desc                AS prescDesc2
     , pr3.UDP_ohftprescriber_Desc                AS prescDesc3
     , pr4.UDP_ohftprescriber_Desc                AS prescDesc4
     , pr5.UDP_ohftprescriber_Desc                AS prescDesc5
     , pr6.UDP_ohftprescriber_Desc                AS prescDesc6
     , pr7.UDP_ohftprescriber_Desc                AS prescDesc7
     , pr8.UDP_ohftprescriber_Desc                AS prescDesc8
     , pr9.UDP_ohftprescriber_Desc                AS prescDesc9
     , pr10.UDP_ohftprescriber_Desc               AS prescDesc10
     , pr11.UDP_ohftprescriber_Desc               AS prescDesc11
     , pr12.UDP_ohftprescriber_Desc               AS prescDesc12
     , pr13.UDP_ohftprescriber_Desc               AS prescDesc13
     , pr14.UDP_ohftprescriber_Desc               AS prescDesc14
     , pr15.UDP_ohftprescriber_Desc               AS prescDesc15
     , pr16.UDP_ohftprescriber_Desc               AS prescDesc16
     , pr17.UDP_ohftprescriber_Desc               AS prescDesc17
     , pr18.UDP_ohftprescriber_Desc               AS prescDesc18
     , pr19.UDP_ohftprescriber_Desc               AS prescDesc19
     , pr20.UDP_ohftprescriber_Desc               AS prescDesc20
     , pr21.UDP_ohftprescriber_Desc               AS prescDesc21
     , pr22.UDP_ohftprescriber_Desc               AS prescDesc22
     , pr23.UDP_ohftprescriber_Desc               AS prescDesc23
     , pr24.UDP_ohftprescriber_Desc               AS prescDesc24
     , pr25.UDP_ohftprescriber_Desc               AS prescDesc25
	 , dns.Confirm_Staff_Name AS CompletedBy
	 , dns.fld7DayFollowYNID 
	 , dns.fld7DayFollowID
	 , dns.Confirm_Date 
	 , st2.Staff_Name						AS [SevenDayFollowupStaff]
	 , dns.Create_Dttm
FROM mrr.CNS_udfOHFTDischargeNotificationSummaryV3  dns
--INNER JOIN [dbo].[CNS_tblInscope_InterimDischargeSummary] scope
--	ON dns.OHFTDischargeNotificationSummaryV3_ID = scope.OHFTDischargeNotificationSummaryV3_ID
    LEFT JOIN mrr.CNS_tblCNDocument                cnd
        ON dns.OHFTDischargeNotificationSummaryV3_ID = cnd.CN_Object_ID
           AND cnd.Object_Type_ID =
           (
               SELECT Object_Type_ID
               FROM mrr.CNS_tblObjectTypeValues
               WHERE Object_Type_GUID = '888115bc-bbe0-4a77-b59c-b83ebe925569'
           )
    LEFT OUTER JOIN mrr.CNS_tblInvalidatedDocuments id
        ON cnd.CN_Doc_ID = id.CN_Doc_ID
    LEFT JOIN mrr.CNS_tblStaff                      st
        ON st.Staff_ID = dns.OriginalAuthorID
    LEFT JOIN mrr.CNS_tblStaff                      st2
        ON st2.Staff_ID = dns.fld7DayFollowID
    LEFT OUTER JOIN mrr.CNS_tblLocation				l 
		ON st.Staff_Loc_ID = l.Location_ID
	LEFT JOIN mrr.CNS_tblMedicine                   m1
        ON m1.Medicine_ID = dns.flddrug1ID
    LEFT JOIN mrr.CNS_tblMedicine                   m2
        ON m2.Medicine_ID = dns.flddrug2ID
    LEFT JOIN mrr.CNS_tblMedicine                   m3
        ON m3.Medicine_ID = dns.flddrug3ID
    LEFT JOIN mrr.CNS_tblMedicine                   m4
        ON m4.Medicine_ID = dns.flddrug4ID
    LEFT JOIN mrr.CNS_tblMedicine                   m5
        ON m5.Medicine_ID = dns.flddrug5ID
    LEFT JOIN mrr.CNS_tblMedicine                   m6
        ON m6.Medicine_ID = dns.flddrug6ID
    LEFT JOIN mrr.CNS_tblMedicine                   m7
        ON m7.Medicine_ID = dns.flddrug7ID
    LEFT JOIN mrr.CNS_tblMedicine                   m8
        ON m8.Medicine_ID = dns.flddrug8ID
    LEFT JOIN mrr.CNS_tblMedicine m9
        ON m9.Medicine_ID = dns.flddrug9ID
    LEFT JOIN mrr.CNS_tblMedicine                   m10
        ON m10.Medicine_ID = dns.flddrug11ID
    LEFT JOIN mrr.CNS_tblMedicine                   m11
        ON m11.Medicine_ID = dns.flddrug10ID
    LEFT JOIN mrr.CNS_tblMedicine                   m12
        ON m12.Medicine_ID = dns.flddrug12ID
    LEFT JOIN mrr.CNS_tblMedicine                   m13
        ON m13.Medicine_ID = dns.flddrug13ID
    LEFT JOIN mrr.CNS_tblMedicine                   m14
        ON m14.Medicine_ID = dns.flddrug14ID
    LEFT JOIN mrr.CNS_tblMedicine                   m15
        ON m15.Medicine_ID = dns.flddrug15ID
    LEFT JOIN mrr.CNS_tblMedicine                   m16
        ON m16.Medicine_ID = dns.flddrug16ID
    LEFT JOIN mrr.CNS_tblMedicine                   m17
        ON m17.Medicine_ID = dns.flddrug17ID
    LEFT JOIN mrr.CNS_tblMedicine                   m18
        ON m18.Medicine_ID = dns.flddrug18ID
    LEFT JOIN mrr.CNS_tblMedicine                   m19
        ON m19.Medicine_ID = dns.flddrug19ID
    LEFT JOIN mrr.CNS_tblMedicine                   m20
        ON m20.Medicine_ID = dns.flddrug20ID
    LEFT JOIN mrr.CNS_tblMedicine                   m21
        ON m21.Medicine_ID = dns.flddrug21ID
    LEFT JOIN mrr.CNS_tblMedicine                   m22
        ON m22.Medicine_ID = dns.flddrug22ID
    LEFT JOIN mrr.CNS_tblMedicine                   m23
        ON m23.Medicine_ID = dns.flddrug23ID
    LEFT JOIN mrr.CNS_tblMedicine                   m24
        ON m24.Medicine_ID = dns.flddrug24ID
    LEFT JOIN mrr.CNS_tblMedicine                   m25
        ON m25.Medicine_ID = dns.flddrug25ID
    LEFT JOIN mrr.CNS_udpmedrouteValues             r1
        ON r1.UDP_medroute_ID = dns.fldroute1ID
    LEFT JOIN mrr.CNS_udpmedrouteValues             r2
        ON r2.UDP_medroute_ID = dns.fldroute2ID
    LEFT JOIN mrr.CNS_udpmedrouteValues             r3
        ON r3.UDP_medroute_ID = dns.fldroute3ID
    LEFT JOIN mrr.CNS_udpmedrouteValues             r4
        ON r4.UDP_medroute_ID = dns.fldroute4ID
    LEFT JOIN mrr.CNS_udpmedrouteValues             r5
        ON r5.UDP_medroute_ID = dns.fldroute5ID
    LEFT JOIN mrr.CNS_udpmedrouteValues             r6
        ON r6.UDP_medroute_ID = dns.fldroute6ID
    LEFT JOIN mrr.CNS_udpmedrouteValues             r7
        ON r7.UDP_medroute_ID = dns.fldroute7ID
    LEFT JOIN mrr.CNS_udpmedrouteValues             r8
        ON r8.UDP_medroute_ID = dns.fldroute8ID
    LEFT JOIN mrr.CNS_udpmedrouteValues             r9
        ON r9.UDP_medroute_ID = dns.fldroute9ID
    LEFT JOIN mrr.CNS_udpmedrouteValues             r10
        ON r10.UDP_medroute_ID = dns.fldroute10ID
    LEFT JOIN mrr.CNS_udpmedrouteValues             r11
        ON r11.UDP_medroute_ID = dns.fldroute11ID
    LEFT JOIN mrr.CNS_udpmedrouteValues             r12
        ON r12.UDP_medroute_ID = dns.fldroute12ID
    LEFT JOIN mrr.CNS_udpmedrouteValues             r13
        ON r13.UDP_medroute_ID = dns.fldroute13ID
    LEFT JOIN mrr.CNS_udpmedrouteValues             r14
        ON r14.UDP_medroute_ID = dns.fldroute14ID
    LEFT JOIN mrr.CNS_udpmedrouteValues             r15
        ON r15.UDP_medroute_ID = dns.fldroute15ID
    LEFT JOIN mrr.CNS_udpmedrouteValues             r16
        ON r16.UDP_medroute_ID = dns.fldroute16ID
    LEFT JOIN mrr.CNS_udpmedrouteValues             r17
        ON r17.UDP_medroute_ID = dns.fldroute17ID
    LEFT JOIN mrr.CNS_udpmedrouteValues             r18
        ON r18.UDP_medroute_ID = dns.fldroute18ID
    LEFT JOIN mrr.CNS_udpmedrouteValues             r19
        ON r19.UDP_medroute_ID = dns.fldroute19ID
    LEFT JOIN mrr.CNS_udpmedrouteValues             r20
        ON r20.UDP_medroute_ID = dns.fldroute20ID
    LEFT JOIN mrr.CNS_udpmedrouteValues             r21
        ON r21.UDP_medroute_ID = dns.fldroute21ID
    LEFT JOIN mrr.CNS_udpmedrouteValues             r22
        ON r22.UDP_medroute_ID = dns.fldroute22ID
    LEFT JOIN mrr.CNS_udpmedrouteValues             r23
        ON r23.UDP_medroute_ID = dns.fldroute23ID
    LEFT JOIN mrr.CNS_udpmedrouteValues             r24
        ON r24.UDP_medroute_ID = dns.fldroute24ID
    LEFT JOIN mrr.CNS_udpmedrouteValues             r25
        ON r25.UDP_medroute_ID = dns.fldroute25ID
    LEFT JOIN mrr.CNS_udpohftprescriberValues       pr1
        ON pr1.UDP_ohftprescriber_ID = dns.fldprsbr1ID
    LEFT JOIN mrr.CNS_udpohftprescriberValues       pr2
        ON pr2.UDP_ohftprescriber_ID = dns.fldprsbr2ID
    LEFT JOIN mrr.CNS_udpohftprescriberValues       pr3
        ON pr3.UDP_ohftprescriber_ID = dns.fldprsbr3ID
    LEFT JOIN mrr.CNS_udpohftprescriberValues       pr4
        ON pr4.UDP_ohftprescriber_ID = dns.fldprsbr4ID
    LEFT JOIN mrr.CNS_udpohftprescriberValues       pr5
        ON pr5.UDP_ohftprescriber_ID = dns.fldprsbr5ID
    LEFT JOIN mrr.CNS_udpohftprescriberValues       pr6
        ON pr6.UDP_ohftprescriber_ID = dns.fldprsbr6ID
    LEFT JOIN mrr.CNS_udpohftprescriberValues       pr7
        ON pr7.UDP_ohftprescriber_ID = dns.fldprsbr7ID
    LEFT JOIN mrr.CNS_udpohftprescriberValues       pr8
        ON pr8.UDP_ohftprescriber_ID = dns.fldprsbr8ID
    LEFT JOIN mrr.CNS_udpohftprescriberValues       pr9
        ON pr9.UDP_ohftprescriber_ID = dns.fldprsbr9ID
    LEFT JOIN mrr.CNS_udpohftprescriberValues       pr10
        ON pr10.UDP_ohftprescriber_ID = dns.fldprsbr10ID
    LEFT JOIN mrr.CNS_udpohftprescriberValues       pr11
        ON pr11.UDP_ohftprescriber_ID = dns.fldprsbr11ID
    LEFT JOIN mrr.CNS_udpohftprescriberValues       pr12
        ON pr12.UDP_ohftprescriber_ID = dns.fldprsbr12ID
    LEFT JOIN mrr.CNS_udpohftprescriberValues       pr13
        ON pr13.UDP_ohftprescriber_ID = dns.fldprsbr13ID
    LEFT JOIN mrr.CNS_udpohftprescriberValues       pr14
        ON pr14.UDP_ohftprescriber_ID = dns.fldprsbr14ID
    LEFT JOIN mrr.CNS_udpohftprescriberValues       pr15
        ON pr15.UDP_ohftprescriber_ID = dns.fldprsbr15ID
    LEFT JOIN mrr.CNS_udpohftprescriberValues       pr16
        ON pr16.UDP_ohftprescriber_ID = dns.fldprsbr16ID
    LEFT JOIN mrr.CNS_udpohftprescriberValues       pr17
        ON pr17.UDP_ohftprescriber_ID = dns.fldprsbr17ID
    LEFT JOIN mrr.CNS_udpohftprescriberValues       pr18
        ON pr18.UDP_ohftprescriber_ID = dns.fldprsbr18ID
    LEFT JOIN mrr.CNS_udpohftprescriberValues       pr19
        ON pr19.UDP_ohftprescriber_ID = dns.fldprsbr19ID
    LEFT JOIN mrr.CNS_udpohftprescriberValues       pr20
        ON pr20.UDP_ohftprescriber_ID = dns.fldprsbr20ID
    LEFT JOIN mrr.CNS_udpohftprescriberValues       pr21
        ON pr21.UDP_ohftprescriber_ID = dns.fldprsbr21ID
    LEFT JOIN mrr.CNS_udpohftprescriberValues       pr22
        ON pr22.UDP_ohftprescriber_ID = dns.fldprsbr22ID
    LEFT JOIN mrr.CNS_udpohftprescriberValues       pr23
        ON pr23.UDP_ohftprescriber_ID = dns.fldprsbr23ID
    LEFT JOIN mrr.CNS_udpohftprescriberValues       pr24
        ON pr24.UDP_ohftprescriber_ID = dns.fldprsbr24ID
    LEFT JOIN mrr.CNS_udpohftprescriberValues       pr25
        ON pr25.UDP_ohftprescriber_ID = dns.fldprsbr25ID
    LEFT JOIN mrr.CNS_tblYesNoValues                yn1
        ON yn1.Yes_No_ID = dns.fldDisNotIssID
    LEFT JOIN mrr.CNS_tblYesNoValues                yn2
        ON yn2.Yes_No_ID = dns.fld7DayFollowYNID
LEFT JOIN mrr.CNS_tblPatient pat
	ON pat.Patient_ID = dns.Patient_ID
LEFT JOIN Pat_Adrs 
	ON Pat_Adrs.Patient_ID = dns.Patient_ID
	AND Pat_Adrs.RowNum = 1
LEFT JOIN mrr.CNS_tblAddress adrs
	ON adrs.Address_ID = Pat_Adrs.Address_ID
LEFT JOIN  mrr.CNS_tblGPDetail gpd
	ON gpd.Patient_ID = pat.Patient_ID
	AND gpd.End_Date IS NULL
LEFT JOIN mrr.CNS_tblGP gp
	ON gpd.GP_ID = gp.GP_ID
LEFT JOIN mrr.CNS_tblPractice prac
	ON gpd.Practice_ID = prac.Practice_ID
WHERE  id.CN_Doc_ID IS NULL
--AND pat.Patient_Name LIKE '%XX%TEST%'
--AND pat.Patient_Name NOT LIKE '%DO%NOT%USE%'
--AND cnd.CN_Doc_ID != 18502668

GO
