MERGE INTO "DATALAB_DW_PRD"."DWH"."DIM_ADDRESS" AS "target" USING (SELECT 
  * 
FROM (SELECT 
  "ADDRESS_COMPANY_ID", 
  "STATE", 
  "POSTAL_CODE", 
  "STREET_ADDRESS", 
  "STREET_ADDRESS_2", 
  "CITY", 
  "COUNTRY", 
  "T0_AUDIT_KEY", 
  "T1_AUDIT_KEY" 
FROM (SELECT DISTINCT
COALESCE(COMPANY_ID,-1)                                               AS ADDRESS_COMPANY_ID
--,CONCAT(COMPANY_ID, '-', CITY) AS ADDRESS_ID
,COALESCE(STATE,'Missing')                                            AS STATE
,COALESCE(POSTAL_CODE,'Missing')                                      AS POSTAL_CODE
,COALESCE(STREET_ADDRESS,'Missing')                                   AS STREET_ADDRESS
,COALESCE(STREET_ADDRESS_2,'Missing')                                 AS STREET_ADDRESS_2
,COALESCE(CITY,'Missing')                                             AS CITY
,COALESCE(COUNTRY,'Missing')                                          AS COUNTRY
,0                                                                    AS T0_AUDIT_KEY
,0                                                                    AS T1_AUDIT_KEY
FROM DATALAB_DW_PRD.STAGE.STG_HUBSPOT_COMPANIES))) AS "input" ON "input"."ADDRESS_COMPANY_ID"="target"."ADDRESS_COMPANY_ID" WHEN MATCHED AND "input"."STATE"!="target"."ADDRESS_REGION" OR
"input"."POSTAL_CODE"!="target"."ADDRESS_POSTAL_CODE" OR
"input"."STREET_ADDRESS"!="target"."ADDRESS_LINE_01" OR
"input"."STREET_ADDRESS_2"!="target"."ADDRESS_LINE_02" OR
"input"."CITY"!="target"."ADDRESS_CITY" OR
"input"."COUNTRY"!="target"."ADDRESS_COUNTRY"
 THEN UPDATE SET "ADDRESS_COMPANY_ID" = "input"."ADDRESS_COMPANY_ID","ADDRESS_LINE_01" = "input"."STREET_ADDRESS","ADDRESS_LINE_02" = "input"."STREET_ADDRESS_2","ADDRESS_REGION" = "input"."STATE","ADDRESS_POSTAL_CODE" = "input"."POSTAL_CODE","ADDRESS_COUNTRY" = "input"."COUNTRY","ADDRESS_CITY" = "input"."CITY","T0_AUDIT_KEY" = "input"."T0_AUDIT_KEY","T1_AUDIT_KEY" = "input"."T1_AUDIT_KEY" WHEN NOT MATCHED THEN INSERT ("ADDRESS_COMPANY_ID","ADDRESS_LINE_01","ADDRESS_LINE_02","ADDRESS_REGION","ADDRESS_POSTAL_CODE","ADDRESS_COUNTRY","ADDRESS_CITY","T0_AUDIT_KEY","T1_AUDIT_KEY") VALUES ("input"."ADDRESS_COMPANY_ID","input"."STREET_ADDRESS","input"."STREET_ADDRESS_2","input"."STATE","input"."POSTAL_CODE","input"."COUNTRY","input"."CITY","input"."T0_AUDIT_KEY","input"."T1_AUDIT_KEY");
