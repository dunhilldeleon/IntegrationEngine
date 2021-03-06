SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
/*==========================================================================================================================================
Populate the materialized list of patients that are in scope for Graphnet. This should be executed at the start
of SSIS package.

Test:

EXECUTE [Graphnet].[uspPopulateInscopePatient]

History:
22/06/2018 OBMH\Steve.Nicoll  Initial version.

==========================================================================================================================================*/
CREATE PROCEDURE [Graphnet].[uspPopulateInscopePatient]
AS
TRUNCATE TABLE [Graphnet_Config].[InscopePatient];

INSERT INTO [Graphnet_Config].[InscopePatient]
(
    [PatientNo]
)
SELECT [PatientNo]
FROM [Graphnet].[vwInscopePatient];
GO
