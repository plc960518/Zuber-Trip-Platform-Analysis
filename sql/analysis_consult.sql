-- Taxi trips amount per company between November 15th and 16th, 2017
SELECT 
    cabs.company_name,
    COUNT(trips.trip_id) AS trips_amount
FROM 
    cabs
    FULL JOIN trips ON cabs.cab_id = trips.cab_id
WHERE 
    CAST(trips.start_ts AS date) BETWEEN '2017-11-15' AND '2017-11-16'
GROUP BY 
    company_name
ORDER BY 
    trips_amount DESC;

-- Trips amount per company names that include Yellow or Blue between November 1st and 7th, 2017
SELECT 
    cabs.company_name,
    COUNT(trips.trip_id) AS trips_amount
FROM 
    cabs
    INNER JOIN trips ON cabs.cab_id = trips.cab_id
WHERE 
    CAST(trips.start_ts AS date) BETWEEN '2017-11-01' AND '2017-11-07' AND cabs.company_name LIKE '%Yellow%'
GROUP BY 
    company_name
UNION ALL 
SELECT 
    cabs.company_name,
    COUNT(trips.trip_id) AS trips_amount
FROM 
    cabs
    INNER JOIN trips ON cabs.cab_id = trips.cab_id
WHERE 
    CAST(trips.start_ts AS date) BETWEEN '2017-11-01' AND '2017-11-07' AND cabs.company_name LIKE '%Blue%'
GROUP BY 
    company_name;

-- From the most popular taxi companies from the first outcome 'Flash Cab' and 'Taxi Affiliation Services'
-- divided the total trips amount in 3 groups, the two most popular companies and others for comparation purposes
SELECT DISTINCT
    CASE 
    WHEN cabs.company_name = 'Flash Cab' THEN 'Flash Cab'
    WHEN cabs.company_name = 'Taxi Affiliation Services' THEN 'Taxi Affiliation Services'
    ELSE 'Other' 
    END AS company,
    COUNT(trips.trip_id) AS trips_amount
FROM 
    cabs
    INNER JOIN trips ON cabs.cab_id = trips.cab_id
WHERE 
    CAST(trips.start_ts AS date) BETWEEN '2017-11-01' AND '2017-11-07'
GROUP BY 
    company
ORDER BY 
    trips_amount DESC;

-- Identification for the neiborhood_id trip amount for O'Hare and Loop
SELECT 
    *
FROM 
    neighborhoods
WHERE 
    name LIKE '%Hare' or
    name LIKE 'Loop';

-- Categorizing weather_records in 'Good' weather days and 'Bad' weather days, showing the date and time per day
SELECT DISTINCT 
    ts::timestamp AS time_hour,
    CASE 
    WHEN description LIKE '%rain%'
    THEN 'Bad'
    WHEN description LIKE '%storm%'
    THEN 'Bad'
ELSE 'Good'
END AS weather_conditions
FROM weather_records;

-- Using this categorization grouped the trips from saturdays that started 
-- in Loop and ended in O'Hare to know the weather conditions and trip duration
SELECT 
    trips.start_ts,
    SUBQ.weather_conditions,
    trips.duration_seconds
FROM 
    trips
    INNER JOIN (
    SELECT DISTINCT 
    ts,
    CASE 
    WHEN description LIKE '%rain%' OR description LIKE '%storm%'
    THEN 'Bad'
ELSE 'Good'
END AS weather_conditions
FROM weather_records) AS SUBQ ON trips.start_ts = SUBQ.ts
WHERE 
    pickup_location_id = 50 AND dropoff_location_id = 63
    AND EXTRACT(DOW FROM trips.start_ts) = 6
ORDER BY trips.trip_id;