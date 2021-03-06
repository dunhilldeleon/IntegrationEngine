SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON





CREATE VIEW [Graphnet].[vwDemographics]
AS
SELECT [pat].[Patient_ID]                                                  AS [PatientNo]
     , 125                                                                 AS [TenancyID]
     , CONVERT(VARCHAR(23)
             , (
                   SELECT MAX([UpdatedDate])
                   FROM
                   (
                       VALUES
                           ([pat].[Updated_Dttm])
                         , ([addr].[Updated_Dttm])
                         , ([gpd].[Updated_Dttm])
                         , ([gp].[Updated_Dttm])
                         , ([ttl].[Updated_Dttm])
                         , ([eth].[Updated_Dttm])
                         , ([relig].[Updated_Dttm])
                         , ([lang].[Updated_Dttm])
                         , ([mar].[Updated_Dttm])
                         , ([prac].[Updated_Dttm])
                   ) AS [AllDates] ([UpdatedDate])
               )
             , 21
              )                                                            AS [UpdatedDate]
     , REPLACE([NHS_Number], '|', '')                                      AS [NHSNo]
     , REPLACE(LEFT(ISNULL([ttl].[Title_Desc], 'Not Known'), 15), '|', '') AS [Title]
     , REPLACE(LEFT([Surname], 50), '|', 'Not Known')                      AS [Surname]
     , REPLACE(ISNULL(LEFT([Forename], 50), 'Not Known'), '|', '')         AS [Forenames]
     , REPLACE(ISNULL([mar].[External_Code1], 'N'), '|', '')               AS [MaritalStatus]
     , CASE
           WHEN [pat].[Gender_ID] = 2 THEN
               'F'
           WHEN [pat].[Gender_ID] = 3 THEN
               'M'
           ELSE
               'U'
       END                                                                 AS [Sex]
     , CONVERT(VARCHAR(23), [Date_Of_Birth], 21)                           AS [DOB]
     , REPLACE(LEFT([addr].[Address1], 35), '|', '')                       AS [Address1]
     , REPLACE(LEFT([addr].[Address2], 35), '|', '')                       AS [Address2]
     , REPLACE(LEFT([addr].[Address3], 35), '|', '')                       AS [Address3]
     , REPLACE(LEFT([addr].[Address4], 35), '|', '')                       AS [Address4]
     , REPLACE(LEFT([addr].[Address5], 35), '|', '')                       AS [Address5]
     , REPLACE(LEFT([addr].[Post_Code], 35), '|', '')                      AS [PostCode]
     , REPLACE(LEFT([addr].[Tel_Home], 100), '|', '')                      AS [HomeTelephone]
     , REPLACE(LEFT([addr].[Tel_Work], 100), '|', '')                      AS [WorkTelephone]
     , REPLACE(LEFT([addr].[Tel_Mobile], 100), '|', '')                    AS [MobileTelephone]
     --, REPLACE(LEFT([addr].[Email_Address], 100), '|', '')                 AS [Email]
	 , NULL																	AS [Email]
     , CONVERT(VARCHAR(23), [pat].[Date_Of_Death], 21)                     AS [DeathDate]
     , CASE
           WHEN [pat].[Date_Of_Death] IS NOT NULL THEN
               1
           ELSE
               0
       END                                                                 AS [Deceased]
     , REPLACE([gp].[GP_Code], '|', '')                                    AS [GPCode]
     , REPLACE(LEFT([prac].[Practice_Code], 6), '|', '')                   AS [GPPracticeCode]
     --, REPLACE([relig].[External_Code1], '|', '')                          AS [Religion]
	 , NULL																	AS [Religion]
     , REPLACE([eth].[External_Code1], '|', '')                            AS [EthnicOrigin]
     , REPLACE(LEFT([lang].[Language_Desc], 250), '|', '')                 AS [SpokenLanguage]
FROM [Graphnet].[vwInscopePatient]                                [scope]
    INNER JOIN [mrr].[CNS_tblPatient]            [pat]
        ON [pat].[Patient_ID] = [scope].[PatientNo]
    LEFT JOIN [mrr].[CNS_tblAddress]             [addr]
        ON [pat].[Patient_ID] = [addr].[Patient_ID]
           AND [addr].[Usual_Address_Flag_ID] = 1
    LEFT JOIN [mrr].[CNS_tblGPDetail]            [gpd]
        ON [pat].[Patient_ID] = [gpd].[Patient_ID]
           AND [gpd].[End_Date] IS NULL
    LEFT JOIN [mrr].[CNS_tblGP]                  [gp]
        ON [gpd].[GP_ID] = [gp].[GP_ID]
    LEFT JOIN [mrr].[CNS_tblTitleValues]         [ttl]
        ON [ttl].[Title_ID] = [pat].[Title_ID]
    LEFT JOIN [mrr].[CNS_tblEthnicityValues]     [eth]
        ON [pat].[Ethnicity_ID] = [eth].[Ethnicity_ID]
    LEFT JOIN [mrr].[CNS_tblReligionValues]      [relig]
        ON [relig].[Religion_ID] = [pat].[Religion_ID]
    LEFT JOIN [mrr].[CNS_tblLanguageValues]      [lang]
        ON [lang].[Language_ID] = [pat].[First_Language_ID]
    LEFT JOIN [mrr].[CNS_tblMaritalStatusValues] [mar]
        ON [mar].[Marital_Status_ID] = [pat].[Marital_Status_ID]
    LEFT JOIN [mrr].[CNS_tblPractice]            [prac]
        ON [gpd].[Practice_ID] = [prac].[Practice_ID]
WHERE NOT EXISTS -- Ignore invalid documents.
(
    SELECT [CNDoc].[CN_Object_ID]
    FROM [mrr].[CNS_tblCNDocument]                     [CNDoc]
        INNER JOIN [mrr].[CNS_tblInvalidatedDocuments] [InvalidDoc]
            ON [InvalidDoc].[CN_Doc_ID] = [CNDoc].[CN_Doc_ID]
        INNER JOIN [mrr].[CNS_tblObjectTypeValues]     [ObjTyp]
            ON ([ObjTyp].[Object_Type_ID] = [CNDoc].[Object_Type_ID])
    WHERE [pat].[Patient_ID] = [CNDoc].[CN_Object_ID]
          AND [ObjTyp].[Key_Table_Name] = 'tblPatient'
)
AND (
                   SELECT MAX([UpdatedDate])
                   FROM
                   (
                       VALUES
                           ([pat].[Updated_Dttm])
                         , ([addr].[Updated_Dttm])
                         , ([gpd].[Updated_Dttm])
                         , ([gp].[Updated_Dttm])
                         , ([ttl].[Updated_Dttm])
                         , ([eth].[Updated_Dttm])
                         , ([relig].[Updated_Dttm])
                         , ([lang].[Updated_Dttm])
                         , ([mar].[Updated_Dttm])
                         , ([prac].[Updated_Dttm])
                   ) AS [AllDates] ([UpdatedDate])
               ) >= DATEADD(YEAR, -2, GETDATE()) ; -- two years





GO
