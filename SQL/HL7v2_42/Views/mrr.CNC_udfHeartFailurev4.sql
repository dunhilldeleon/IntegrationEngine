SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
 

CREATE VIEW  [mrr].[CNC_udfHeartFailurev4] AS SELECT [HeartFailurev4_ID], [Patient_ID], [Confirm_Flag_ID], [Confirm_Date], [Confirm_Time], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [OriginalAuthorID], [fldEnteredDate], [fldEnteredTime], [StartDate], [StartTime], [ReplanRequested], [DocumentGroupIdentifier], [PreviousCNObjectID], [fldService], [fldServEmail], [fldServTele], [fldSessionTypeID], [fldPatInfo], [fldDNACPRID], [fldResearchDiscussedID], [fldProjDiscussedID], [fldResProjDetails], [fldLVSDID], [fldEjectFrac], [fldEchoOutcomesID], [fldchkIschaemicID], [fldchkDCMID], [fldchkCardiomyopathyID], [fldchknonLVSDID], [fldchkValvularID], [fldchkAlchCardiomyopID], [fldchkCongHeartID], [fldchkUnknownID], [fldchkHypertenseID], [fldchkRestCardiomyopID], [fldchkInhHeartID], [fldchkOtherID], [fldAeitologyOther], [fldIschHeartID], [fldIschHeartDetails], [fldValveDiseaseID], [fldValveDiseaseDetails], [fldHypertensionID], [fldHypertensionDetails], [fldArrhythmiaID], [fldArrhythmiaDetails], [fldDiabetesID], [fldDiabetesDetails], [fldChronKidDiseaseID], [fldChronKidDiseaseDetails], [fldAsthmaID], [fldAsthmaDetails], [fldCOPDID], [fldCOPDDetails], [fldCerebroAccID], [fldCerebroAccDetails], [fldPeriVascDiseaseID], [fldPeriVascDiseaseDetails], [fldAnaemiaID], [fldAnaemiaDetails], [fldOthrMedHist], [fldDeviceID], [fldDeviceDate], [fldDeviceDetails], [fldCoroAngioID], [fldCoroAngioDetails], [fldPCIID], [fldPCIDetails], [fldCABGID], [fldCABGDetails], [flddrug1ID], [flddose1], [fldfreq1], [fldroute1ID], [fldprsbr1ID], [fldcomm1], [flddrug2ID], [flddose2], [fldfreq2], [fldroute2ID], [fldprsbr2ID], [fldcomm2], [flddrug3ID], [flddose3], [fldfreq3], [fldroute3ID], [fldprsbr3ID], [fldcomm3], [flddrug4ID], [flddose4], [fldfreq4], [fldroute4ID], [fldprsbr4ID], [fldcomm4], [flddrug5ID], [flddose5], [fldfreq5], [fldroute5ID], [fldprsbr5ID], [fldcomm5], [flddrug6ID], [flddose6], [fldfreq6], [fldroute6ID], [fldprsbr6ID], [fldcomm6], [flddrug7ID], [flddose7], [fldfreq7], [fldroute7ID], [fldprsbr7ID], [fldcomm7], [flddrug8ID], [flddose8], [fldfreq8], [fldroute8ID], [fldprsbr8ID], [fldcomm8], [flddrug9ID], [flddose9], [fldfreq9], [fldroute9ID], [fldprsbr9ID], [fldcomm9], [flddrug10ID], [flddose10], [fldfreq10], [fldroute10ID], [fldprsbr10ID], [fldcomm10], [flddrug11ID], [flddose11], [fldfreq11], [fldroute11ID], [fldprsbr11ID], [fldcomm11], [flddrug12ID], [flddose12], [fldfreq12], [fldroute12ID], [fldprsbr12ID], [fldcomm12], [flddrug13ID], [flddose13], [fldfreq13], [fldroute13ID], [fldprsbr13ID], [fldcomm13], [flddrug14ID], [flddose14], [fldfreq14], [fldroute14ID], [fldprsbr14ID], [fldcomm14], [flddrug15ID], [flddose15], [fldfreq15], [fldroute15ID], [fldprsbr15ID], [fldcomm15], [flddrug16ID], [flddose16], [fldfreq16], [fldroute16ID], [fldprsbr16ID], [fldcomm16], [flddrug17ID], [flddose17], [fldfreq17], [fldroute17ID], [fldprsbr17ID], [fldcomm17], [flddrug18ID], [flddose18], [fldfreq18], [fldroute18ID], [fldprsbr18ID], [fldcomm18], [flddrug19ID], [flddose19], [fldfreq19], [fldroute19ID], [fldprsbr19ID], [fldcomm19], [flddrug20ID], [flddose20], [fldfreq20], [fldroute20ID], [fldprsbr20ID], [fldcomm20], [flddrug21ID], [flddose21], [fldfreq21], [fldroute21ID], [fldprsbr21ID], [fldcomm21], [flddrug22ID], [flddose22], [fldfreq22], [fldroute22ID], [fldprsbr22ID], [fldcomm22], [flddrug23ID], [flddose23], [fldfreq23], [fldroute23ID], [fldprsbr23ID], [fldcomm23], [flddrug24ID], [flddose24], [fldfreq24], [fldroute24ID], [fldprsbr24ID], [fldcomm24], [flddrug25ID], [flddose25], [fldfreq25], [fldroute25ID], [fldprsbr25ID], [fldcomm25], [fldFutureMeds], [fldHeartFailMed], [fldOthrRelMed], [fldBreathlessness], [fldMobLimit], [fldOrthopnoea], [fldPND], [fldOedema], [fldAscites], [fldChest], [fldCough], [fldFldIntake], [fldAngina], [fldPalpitations], [fldDizziness], [fldFatigue], [fldECGFind], [fldCardiacRehabID], [fldCBTRevID], [fldWeight], [fldSittingBP], [fldStandingBP], [fldHeartRythID], [fldPulse], [fldResp], [fldSpO2], [fldTemp], [fldNYHAID], [fldMUST], [fldBraden], [fldDetsPlanAction], [flgchknewform], [flgchkDNACPR], [flgchkAetiologyOther], [flgchkIschHeart], [flgchkValveDisease], [flgchkHypertension], [flgchkArrhythmia], [flgchkDiabetes], [flgchkChronKidDisease], [flgchkAsthma], [flgchkCOPD], [flgchkCerebroAcc], [flgchkPeriVascDisease], [flgchkAnaemia], [flgchkCoroAngio], [flgchkPCI], [flgchkCABG], [flgchkResearch], [flgchkDevice], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm] FROM [Mirror].[mrr_tbl].[CNC_udfHeartFailurev4];

GO
