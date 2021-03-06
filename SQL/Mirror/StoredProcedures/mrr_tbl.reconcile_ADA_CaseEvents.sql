SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_ADA_CaseEvents

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_ADA_CaseEvents]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[EventRef], [CaseRef], [EventType], [EntryDate], [StartDate], [FinishDate], [Summary], [Ref], [UserComments], [UserRef], [UserDescription], [SyncRequired], [EventDescription], [MasterEventRef], [CaseStatus], [Obsolete], [ObsoleteByRef], [ObsoleteByDescription], [ObsoleteDate], [ObsoleteMasterEventRef], [CreationDate], [LocationRef], [Editable], [CaseAuditRef], [BeforeCaseAuditRef], [AremoteDeviceRef], [SessionRef]
						 FROM mrr_tbl.ADA_CaseEvents
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[EventRef], [CaseRef], [EventType], [EntryDate], [StartDate], [FinishDate], [Summary], [Ref], [UserComments], [UserRef], [UserDescription], [SyncRequired], [EventDescription], [MasterEventRef], [CaseStatus], [Obsolete], [ObsoleteByRef], [ObsoleteByDescription], [ObsoleteDate], [ObsoleteMasterEventRef], [CreationDate], [LocationRef], [Editable], [CaseAuditRef], [BeforeCaseAuditRef], [AremoteDeviceRef], [SessionRef]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[Adastra3Oxford].[dbo].[CaseEvents])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[EventRef], [CaseRef], [EventType], [EntryDate], [StartDate], [FinishDate], [Summary], [Ref], [UserComments], [UserRef], [UserDescription], [SyncRequired], [EventDescription], [MasterEventRef], [CaseStatus], [Obsolete], [ObsoleteByRef], [ObsoleteByDescription], [ObsoleteDate], [ObsoleteMasterEventRef], [CreationDate], [LocationRef], [Editable], [CaseAuditRef], [BeforeCaseAuditRef], [AremoteDeviceRef], [SessionRef]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[Adastra3Oxford].[dbo].[CaseEvents]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[EventRef], [CaseRef], [EventType], [EntryDate], [StartDate], [FinishDate], [Summary], [Ref], [UserComments], [UserRef], [UserDescription], [SyncRequired], [EventDescription], [MasterEventRef], [CaseStatus], [Obsolete], [ObsoleteByRef], [ObsoleteByDescription], [ObsoleteDate], [ObsoleteMasterEventRef], [CreationDate], [LocationRef], [Editable], [CaseAuditRef], [BeforeCaseAuditRef], [AremoteDeviceRef], [SessionRef]
						 FROM mrr_tbl.ADA_CaseEvents))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.ADA_CaseEvents has discrepancies when compared to its source table.', 1;

				END;
				
GO
