-- Aperçu de la source TLC, utile pour explorer les données.
SELECT
    tpep_pickup_datetime,
    tpep_dropoff_datetime,
    passenger_count,
    trip_distance,
    total_amount
FROM {{ source('tlc_taxi_trips', 'yellow_tripdata_2024') }}
LIMIT 10
