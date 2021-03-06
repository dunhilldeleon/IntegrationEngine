SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON





CREATE VIEW [src].[vwCNS_NextOfKin]

AS

    SELECT c.Patient_ID
         , c.Contact_ID
         , c.Forename
         , c.Surname
         , t.Title_Desc AS Title
         , c.Gender_ID
         , c.First_Language_ID
		 , c.Relationship
         , CASE
               WHEN rel.Code IS NULL THEN
                   'UNK'
               ELSE
                   rel.Code
           END          AS Relationship_HL7
         , c.Address1
         , c.Address2
         , c.Address3
         , CASE
               WHEN c.Address4 IS NULL
                    AND c.Address5 IS NULL THEN
                   NULL
               WHEN c.Address4 IS NULL
                    AND c.Address5 IS NOT NULL THEN
                   c.Address5
               WHEN c.Address4 IS NOT NULL
                    AND c.Address5 IS NULL THEN
                   c.Address4
               ELSE
                   c.Address4 + ', ' + c.Address5
           END          AS Address4
         , c.Post_Code
         , c.Start_Date
         , c.End_Date
         , (
			   SELECT MAX(Updated_Dttm)
			   FROM
			   (
				   VALUES
					   (c.Updated_Dttm)
					 , (r.Updated_Dttm)
			   ) AS alldates (Updated_Dttm)
            )										 AS UpdatedDate
    FROM mrr.CNS_tblContact				c
    INNER JOIN mrr.CNS_tblContactRole			r
        ON c.Contact_ID = r.Contact_ID
            AND r.Contact_Role_ID IN ( 25, 26 ) -- next of kin only
    LEFT JOIN mrr.CNS_tblTitleValues			t
        ON c.Title_ID = t.Title_ID
    LEFT JOIN HL7v2_42_ReferenceData.dbo.tblHL70063Relationship rel
        ON LTRIM(RTRIM(rel.PicklistID)) = LTRIM(RTRIM(c.Relationship))
    WHERE c.Contact_Type_ID = 2 -- contacttype = 'contact' rather than client or GP
        AND c.Permission_To_Contact_ID IN ( 2, 0 );

GO
