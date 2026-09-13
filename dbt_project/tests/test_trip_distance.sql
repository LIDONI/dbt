-- Échoue si la distance d'un trajet n'est pas strictement positive.
SELECT *
FROM {{ ref('transform_data') }}
WHERE trip_distance <= 0
