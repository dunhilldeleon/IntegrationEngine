SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
 
/*==========================================================================================================================================
Populate the materialized list of patients that are in scope for Graphnet. This should be executed at the start
of SSIS package.

Test:

EXECUTE [HIE_CNS].[uspCNS_PopulateInscopePatient]

History:
 

==========================================================================================================================================*/
CREATE PROCEDURE [HIE_CNS].[zzzuspCNS_PopulateInscopePatient]
AS
TRUNCATE TABLE [HIE_CNS].[CNS_InscopePatient];

INSERT INTO [HIE_CNS].[CNS_InscopePatient]
(
    [PatientNo]
)
SELECT [PatientNo]
FROM [HIE_CNS].[vwCNS_InscopePatient];

GO
