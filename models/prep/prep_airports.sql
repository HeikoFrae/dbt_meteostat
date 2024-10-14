WITH airports_reorder AS (
    SELECT faa
            ,regions,
            countries
    FROM {{ref('staging_airports')}}
)
SELECT * FROM airports_reorder
