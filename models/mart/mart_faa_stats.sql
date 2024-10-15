create table "hh_analytics_24_2"."s_heikofraembs"."mart_faa_stats__dbt_tmp"
as
(
    -- unique number of departures connections
    WITH departures AS (
        SELECT origin AS faa
            ,COUNT(origin) AS nunique_from 
            ,COUNT(sched_dep_time) AS dep_planned
            ,SUM(cancelled) AS dep_cancelled
            ,SUM(diverted) AS dep_diverted
            ,COUNT(arr_time) AS dep_n_flights
            ,COUNT(DISTINCT tail_number) AS dep_nunique_tails
            ,COUNT(DISTINCT airline) AS dep_nunique_airlines
        FROM "hh_analytics_24_2"."s_heikofraembs"."prep_flights"
        GROUP BY origin
    ),
    -- unique number of arrival connections
    arrivals AS (
        SELECT dest AS faa
            ,COUNT(dest) AS nunique_to
            ,COUNT(sched_dep_time) AS arr_planned
            ,SUM(cancelled) AS arr_cancelled
            ,SUM(diverted) AS arr_diverted
            ,COUNT(arr_time) AS arr_n_flights
            ,COUNT(DISTINCT tail_number) AS arr_nunique_tails
            ,COUNT(DISTINCT airline) AS arr_nunique_airlines
        FROM "hh_analytics_24_2"."s_heikofraembs"."prep_flights"
        GROUP BY dest
    ),
    -- total statistics combining arrivals and departures
    total_stats AS (
        SELECT faa
            ,nunique_to
            ,nunique_from
            ,dep_planned + arr_planned AS total_planed
            ,dep_cancelled + arr_cancelled AS total_canceled
            ,dep_diverted + arr_diverted AS total_diverted
            ,dep_n_flights + arr_n_flights AS total_flights
        FROM departures
        JOIN arrivals
        USING (faa)
    )
    -- final select to create the table
    SELECT country
        -- No need to explicitly select faa here, it's already included in total_stats
        ,total_stats.*
    FROM "hh_analytics_24_2"."s_heikofraembs"."prep_airports"
    RIGHT JOIN total_stats
    USING (faa)
    ORDER BY country
)
