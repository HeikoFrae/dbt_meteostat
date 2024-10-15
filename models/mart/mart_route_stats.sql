WITH route AS (
    SELECT origin, 
           dest,
           COUNT(flight_number) AS total_flights,
           COUNT(DISTINCT tail_number) AS unique_airplanes,
           COUNT(DISTINCT airline) AS unique_airlines,
           ROUND(AVG(actual_elapsed_time), 2) AS avg_elapsed_time,
           ROUND(AVG(arr_delay), 2) AS avg_arr_delay,
           MAX(arr_delay) AS max_arr_delay,
           MIN(arr_delay) AS min_arr_delay,
           SUM(cancelled) AS cancelled_total,
           SUM(diverted) AS diverted_total
    FROM "hh_analytics_24_2"."s_heikofraembs"."prep_flights" pf
    GROUP BY origin, dest
),
origin_airport AS (
    SELECT faa AS origin_faa,
           country AS origin_country,
           region AS origin_region
    FROM "hh_analytics_24_2"."s_heikofraembs"."prep_airports"
),
dest_airport AS (
    SELECT faa AS dest_faa,
           country AS dest_country,
           region AS dest_region
    FROM "hh_analytics_24_2"."s_heikofraembs"."prep_airports"
)
SELECT 
    route.origin,
    origin_airport.origin_country,
    route.dest,
    dest_airport.dest_country,
    route.total_flights,
    route.unique_airplanes,
    route.unique_airlines,
    route.avg_elapsed_time,
    route.avg_arr_delay,
    route.max_arr_delay,
    route.min_arr_delay,
    route.cancelled_total,
    route.diverted_total
FROM route
JOIN origin_airport
  ON route.origin = origin_airport.origin_faa
JOIN dest_airport
  ON route.dest = dest_airport.dest_faa
ORDER BY route.origin, route.dest
