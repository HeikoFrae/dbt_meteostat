WITH hourly_data AS (
    SELECT * 
    FROM {{ref('staging_flights_one_month')}}
),
add_features AS (
    SELECT *
        , timestamp::DATE AS date -- only date (year-month-day)
        , timestamp::TIME AS time -- only time (hours:minutes:seconds)
        , TO_CHAR(timestamp,'HH24:MI') AS hour -- time (hours:minutes) as TEXT data type
        , TO_CHAR(timestamp, 'FMMonth') AS month_name -- month name as a text
        , TO_CHAR(timestamp, 'Day') AS weekday -- weekday name as text
        , DATE_PART('day', timestamp) AS date_day -- extract day of the month
        , DATE_PART('month', timestamp) AS date_month -- extract month of the year
        , DATE_PART('year', timestamp) AS date_year -- extract year
        , DATE_PART('week', timestamp) AS cw -- calendar week of the year
    FROM hourly_data
),
add_more_features AS (
    SELECT *
        ,(CASE 
            WHEN time BETWEEN TIME '00:00:00' AND TIME '06:00:00' THEN 'night'
            WHEN time BETWEEN TIME '06:00:01' AND TIME '12:00:00' THEN 'morning'
            WHEN time BETWEEN TIME '12:00:01' AND TIME '18:00:00' THEN 'afternoon'
            ELSE 'evening'
        END) AS day_part
        FROM add_features)
SELECT *
FROM add_more_features;
