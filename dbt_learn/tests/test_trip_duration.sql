-- Échoue si la durée d'un trajet n'est pas strictement positive.
SELECT *
FROM {{ ref('transform_data') }}
WHERE trip_duration_minutes <= 0
