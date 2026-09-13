-- Échoue si un trajet contient un nombre de passagers non positif.
SELECT *
FROM {{ ref('transform_data') }}
WHERE passenger_count <= 0
