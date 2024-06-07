WITH CTE_DATESTABLE AS (
    SELECT
        IFNULL(MAX(EXCHANGE_RATE_DATE), TO_DATE('2024-05-01') ) AS DATE FROM DATALAB_DW_PRD.DWH.FCT_EXCHANGE_RATE
    UNION ALL
    SELECT
        DATEADD('day', 1, DATE)
    FROM
        CTE_DATESTABLE
    WHERE
        DATEADD('day', 1, DATE) < CURRENT_DATE()
)

select * from CTE_DATESTABLE

---Query Results to grid Component