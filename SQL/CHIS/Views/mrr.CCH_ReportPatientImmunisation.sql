SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE VIEW [mrr].[CCH_ReportPatientImmunisation] AS SELECT [Id], [CarenotesPatientId], [ImmPartCode], [PartNumber], [ImmDefCode], [ShortName], [LongName], [Parts], [Priority], [CoreProgramme], [IgnoreTreatmentStatus], [CentreCode], [CentreName], [OutcomeCode], [OutcomeDescription], [DateScheduled], [DateOutcome], [OutcomedByStaffId], [Provisional], [ConsultationId], [SuspensionReasonCode], [SuspensionReasonDescription], [SuspensionType], [SuspensionTypeDesc], [SuspendUntilDate], [Removed], [RequiredNumberOfReminders], [SuspensionResumeReasonCode], [SuspensionResumeReasonDesc] FROM  [Mirror].[mrr_tbl].[CCH_ReportPatientImmunisation];

GO
