SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE VIEW [mrr].[ADA_consultationTemplateAnswer] AS SELECT [ConsultationTemplateAnswerRef], [Ref], [CaseRef], [PatientRef], [QuestionRef], [Code], [EntryDate], [AnswerText], [AnswerValue], [AnswerDate], [ServiceRef], [TemplateRef], [Obsolete], [EventRef], [SecondaryCode] FROM [Mirror].[mrr_tbl].[ADA_consultationTemplateAnswer];

GO
