-- Vérifie que les données couvrent les 12 mois de l'année 2024.
WITH months AS (
    SELECT DISTINCT EXTRACT(MONTH FROM tpep_pickup_datetime) AS month
    FROM {{ ref('transform_data') }}
)

-- Un résultat signifie que la couverture n'est pas complète.
SELECT COUNT(*) AS number_of_months
FROM months
HAVING COUNT(*) <> 12
