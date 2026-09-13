--SELECT * FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-06.parquet' LIMIT 10;

--SELECT COUNT(*)FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-06.parquet' LIMIT 10;

--SELECT vendorID, COUNT(*) AS trips_count 
--FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
--GROUP BY vendorID;

--SELECT RatecodeID, COUNT(*) AS trips_count 
--FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
--GROUP BY RatecodeID;

--SELECT StoreAndFwdFlag, COUNT(*) AS trips_count 
--FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
--GROUP BY StoreAndFwdFlag;

--SELECT payment_type, COUNT(*) AS trips_count 
--FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
--GROUP BY payment_type;

--SELECT PULocationID, COUNT(*) AS trips_count 
--FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
--GROUP BY PULocationID;

--SELECT DOLocationID, COUNT(*) AS trips_count 
--FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
--GROUP BY DOLocationID;


-- SELECT COUNT(*) AS trips_count 
-- FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
-- WHERE tpep_pickup_datetime > tpep_dropoff_datetime;

-- SELECT *
-- FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
-- WHERE tpep_pickup_datetime > tpep_dropoff_datetime LIMIT 10;

-- .read 'analyses/analyse_exploratoire.sql':pour exécuter les requetes dans le fichier analyse_exploratoire.sql

-- SELECT COUNT(*) AS trips_count 
-- FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
-- WHERE trip_distance <= 0;

-- SELECT *
-- FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
-- WHERE trip_distance = 0;

-- SELECT *
-- FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
-- WHERE trip_distance < 0;

-- SELECT COUNT(*) AS trips_count
-- FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
-- WHERE total_amount <= 0;

-- SELECT tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count, trip_distance, total_amount
-- FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
-- WHERE total_amount < 0
-- LIMIT 10;

--SELECT *, EXCLUDE(VendorID, RatecodeID) FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
--WHERE total_amount < 0; 

--Couclusion :  
-- on aura à supprimer les lignes ou tpep_pickup_datetime > tpep_dropoff_datetime, trip_distance <= 0 et total_amount <= 0 


