SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE VIEW vw_Objects_ModificationDates
AS

SELECT 'CHIS' [Database], [name], [object_id], [type_desc], create_date, modify_date FROM CHIS.sys.objects WHERE type_desc  IN ('SQL_SCALAR_FUNCTION','SQL_STORED_PROCEDURE','USER_TABLE','VIEW')
UNION 
SELECT 'FHIRv3',[name], [object_id], [type_desc], create_date, modify_date FROM FHIRv3.sys.objects WHERE type_desc  IN ('SQL_SCALAR_FUNCTION','SQL_STORED_PROCEDURE','USER_TABLE','VIEW')
UNION 
SELECT 'Graphnet',[name], [object_id], [type_desc], create_date, modify_date FROM Graphnet.sys.objects WHERE type_desc  IN ('SQL_SCALAR_FUNCTION','SQL_STORED_PROCEDURE','USER_TABLE','VIEW')
UNION 
SELECT 'HIE',[name], [object_id], [type_desc], create_date, modify_date FROM HIE.sys.objects WHERE type_desc  IN ('SQL_SCALAR_FUNCTION','SQL_STORED_PROCEDURE','USER_TABLE','VIEW')
UNION 
SELECT 'HL7v2_42',[name], [object_id], [type_desc], create_date, modify_date FROM HL7v2_42.sys.objects WHERE type_desc  IN ('SQL_SCALAR_FUNCTION','SQL_STORED_PROCEDURE','USER_TABLE','VIEW')
UNION 
SELECT 'HL7v2_42_ReferenceData',[name], [object_id], [type_desc], create_date, modify_date FROM HL7v2_42_ReferenceData.sys.objects WHERE type_desc  IN ('SQL_SCALAR_FUNCTION','SQL_STORED_PROCEDURE','USER_TABLE','VIEW')
UNION 
SELECT 'Mirror',[name], [object_id], [type_desc], create_date, modify_date FROM Mirror.sys.objects WHERE type_desc  IN ('SQL_SCALAR_FUNCTION','SQL_STORED_PROCEDURE','USER_TABLE','VIEW')
UNION 
SELECT 'PersistentDataStore',[name], [object_id], [type_desc], create_date, modify_date FROM PersistentDataStore.sys.objects WHERE type_desc  IN ('SQL_SCALAR_FUNCTION','SQL_STORED_PROCEDURE','USER_TABLE','VIEW')
UNION 
SELECT 'ReferenceMappingTables',[name], [object_id], [type_desc], create_date, modify_date FROM ReferenceMappingTables.sys.objects WHERE type_desc  IN ('SQL_SCALAR_FUNCTION','SQL_STORED_PROCEDURE','USER_TABLE','VIEW')


GO
