-- Nettoie et transforme les données de la source yellow_tripdata_2024.
WITH source_data AS (
    SELECT * EXCLUDE (VendorID, RatecodeID)
    FROM {{ source('tlc_taxi_trips', 'yellow_tripdata_2024') }}
),

-- Élimine les enregistrements incomplets ou incohérents.
filtered_data AS (
    SELECT *
    FROM source_data
    WHERE passenger_count > 0
      AND trip_distance > 0
      AND total_amount > 0
      AND tpep_pickup_datetime < tpep_dropoff_datetime
      AND store_and_fwd_flag = 'N'
      AND tip_amount >= 0
      AND payment_type IN (1, 2)
),

-- Crée les colonnes métier dérivées.
transformed_data AS (
    SELECT
        CAST(passenger_count AS BIGINT) AS passenger_count,
        CASE
            WHEN payment_type = 1 THEN 'Credit card'
            WHEN payment_type = 2 THEN 'Cash'
        END AS payment_method,
        DATE_DIFF(
            'minute', tpep_pickup_datetime, tpep_dropoff_datetime
        ) AS trip_duration_minutes,
        * EXCLUDE (passenger_count, payment_type)
    FROM filtered_data
),

-- Conserve uniquement les trajets dont le départ et l'arrivée sont en 2024.
final_data AS (
    SELECT
        *,
        CAST(tpep_pickup_datetime AS DATE) AS pickup_date,
        CAST(tpep_dropoff_datetime AS DATE) AS dropoff_date
    FROM transformed_data
    WHERE CAST(tpep_pickup_datetime AS DATE) >= '2024-01-01'
      AND CAST(tpep_pickup_datetime AS DATE) < '2025-01-01'
      AND CAST(tpep_dropoff_datetime AS DATE) >= '2024-01-01'
      AND CAST(tpep_dropoff_datetime AS DATE) < '2025-01-01'
)

SELECT * EXCLUDE (pickup_date, dropoff_date)
FROM final_data
WHERE trip_duration_minutes > 0
