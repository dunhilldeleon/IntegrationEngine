SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE VIEW [mrr].[PCMSBCKS_PatientDetails] AS SELECT [PatientID], [Title], [FirstName], [MiddleName], [LastName], [DOB], [Nationality], [Gender], [Ethnicity], [Address1], [Address2], [Address3], [TownCity], [County], [PostCode], [TelHome], [TelMobile], [TelWork], [NHSNumber], [FamilyName], [PreviousName], [PreviousAddress1], [PreviousAddress2], [PreviousAddress3], [PreviousTownCity], [PreviousCounty], [PreviousPostCode], [AccomodationType], [SingleOccupancy], [MaritalStatus], [MainLanguage], [Sexuality], [Mobility], [DateOfDeath], [Email], [Alerts], [Disability], [Reminders], [Religion], [DependantChildren], [ChildDetails1], [ChildDetails2], [ChildDetails3], [ChildDetails4], [ChildDetails5], [ChildDetails6], [ChildDetails7], [ChildDetails8], [ChildDetails9], [ChildDetails10], [CarerDetails1], [CarerDetails2], [CarerDetails3], [VoicemailHome], [VoicemailMobile], [VoicemailWork], [NHSNumberVerified], [TelGP], [PriorIllness], [PriorTreatment], [Medicated], [DateOfMedication], [EndOfMedication], [NotifyBySMS], [ArmedForcesCode], [LastNameAlias], [FirstNameAlias], [DisplayName], [Interpreter], [InterpreterLanguage], [PrimaryMUS], [IntIAPTConsent] FROM [Mirror].[mrr_tbl].[PCMSBCKS_PatientDetails];

GO
