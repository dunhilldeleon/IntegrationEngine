SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE VIEW [mrr].[ADA_PatientAudit] AS SELECT [PatientAuditRef], [PatientRef], [AddressRef], [Forename], [Surname], [SurnamePrefix], [MaidenPrefix], [Maiden], [Initials], [DOB], [HomePhone], [MobilePhone], [OtherPhone], [Sex], [AgeOnly], [NationalCode], [Obsolete], [LastEditByUserRef], [EditDate], [AuditChange], [EthnicityRef], [HumanLanguageRef], [LocalLanguageSpoken], [NationalityRef], [ChangeReason], [CaseRef], [CaseAuditRef], [NationalCodeSource], [EmailAddress], [OtherPhoneExtn], [ExcludeFromPSQ], [IsTwin], [DemographicsSensitive], [NationalCodeSourceDatabase], [NationalCodeEditDate], [AllergyStatusRef], [ConditionStatusRef], [MedicationStatusRef], [NationalCodeEditByUserRef], [NationalCodeExtraInfo], [HomePhonePrefix], [AllergyStatusCode], [ConditionStatusCode], [MedicationStatusCode], [LatestModificationDate] FROM [Mirror].[mrr_tbl].[ADA_PatientAudit];


GO
