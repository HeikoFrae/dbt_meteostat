WITH airports_reorder AS (
    SELECT faa
            ,regions
            ,country
    FROM {{ref('staging_airports')}}
)
SELECT * FROM airports_reorder
