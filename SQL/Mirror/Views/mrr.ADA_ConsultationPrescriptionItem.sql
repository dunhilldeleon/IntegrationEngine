SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE VIEW [mrr].[ADA_ConsultationPrescriptionItem] AS SELECT [PrescriptionItemRef], [ConsultationRef], [ProdID], [FormID], [DrugName], [Preparation], [Dosage], [Qty], [Sort], [ItemType], [ClinicalCode], [Strength], [ScriptIssueType], [StockItemRef], [CodedDirections], [PrescriptionNumber], [NationalCode], [FromFormulary], [OverrideDosage], [CourseDurationWarning], [Comments], [UnitOfMeasureCode], [SLSEndorsement], [ACBSEndorsement], [CDEndorsement], [ContraceptiveEndorsement], [WordsAndFiguresRequired], [ControlStatus], [ControlledScheduleNumber] FROM [Mirror].[mrr_tbl].[ADA_ConsultationPrescriptionItem];
GO
