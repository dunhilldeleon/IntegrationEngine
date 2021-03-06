SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON





CREATE VIEW [dbo].[vwADA_DBSExtract] 

AS

--WITH Adrs1 AS
--		(
--		SELECT p.PatientRef, a.PostCode--,ROW_NUMBER() OVER(PARTITION BY p.PatientRef ORDER BY Start_Date desc) rn
--		 FROM Mirror.mrr.ADA_Patient p
--		 LEFT JOIN mrr.ADA_Address a ON p.AddressRef = a.AddressRef
--		 WHERE a.AddressType LIKE 'PATIENT'
--		)
		SELECT 10 AS RecordType
			, p.LocalID
			, ISNULL(CONVERT(VARCHAR,p.DOB,112),'') AS DOB
			, '' AS DOD
			, '' AS OldNHSNumber
			, ISNULL(NationalCode,'') AS NHS_Number
			, TRIM(REPLACE(CASE WHEN p.Surname LIKE '%,%' THEN SUBSTRING(p.Surname,0,CHARINDEX(',',p.Surname)) 
						   WHEN p.Surname LIKE '%(%' THEN SUBSTRING(p.Surname,0,CHARINDEX('(',p.Surname)) 
							ELSE p.Surname 
					  END,'"','')) AS Surname
			, ISNULL(TRIM(REPLACE(CASE WHEN p.Surname LIKE '%,%' THEN SUBSTRING(p.Surname,CHARINDEX(',',p.Surname)+1,50) END,'"','')),'') AS AltSurname
			, TRIM(REPLACE(CASE WHEN p.Forename LIKE '%,%' THEN SUBSTRING(p.Forename,0,CHARINDEX(',',p.Forename)) 
						   WHEN p.Forename LIKE '%(%' THEN SUBSTRING(p.Forename,0,CHARINDEX('(',p.Forename)) 
							ELSE p.Forename 
					  END,'"',''))  AS Forename
			, '' AS AltForename
			, CASE WHEN p.Sex LIKE 'F' THEN '2'
					WHEN p.Sex LIKE 'M' THEN '1'
					WHEN p.Sex LIKE 'N' THEN '9'
					ELSE '0'
			  END AS Gender
			, ''  AS Address1
			, ''  AS Address2
			, ''  AS Address3
			, ''  AS Address4
			, ''  AS Address5
			, TRIM(REPLACE(COALESCE(adrs1.Postcode,''),'  ',' ')) AS Postcode

		FROM Mirror.mrr.ADA_Patient p
		LEFT JOIN mrr.ADA_Address adrs1
			ON p.AddressRef = adrs1.AddressRef
		--WHERE p.Obsolete = 0
			--AND adrs1.rn = 1
--		LEFT JOIN adrs2
--			ON pat.Patient_ID = adrs2.Patient_ID
--			AND adrs2.rn = 1



GO
