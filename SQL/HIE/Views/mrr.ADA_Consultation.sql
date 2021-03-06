SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE VIEW [mrr].[ADA_Consultation] AS SELECT [ConsultationRef], [CaseRef], [History], [Examination], [Diagnosis], [Treatment], [StartDate], [EndDate], [ProviderRef], [CaseTypeRef], [PriorityRef], [Outcome], [BeforeCaseTypeRef], [AfterStatus], [BeforeStatus], [LocationRef], [Obsolete], [InitialAssessment], [ButtonScreen], [ConfigurationSet], [LanguageScreen] FROM [Mirror].[mrr_tbl].[ADA_Consultation];

GO
