

-- The Top 3 products with the highest total sales (item_nbr 45, 9 and 5).
SELECT item_nbr, sum(units) AS total_units_sold
FROM train
GROUP BY item_nbr
ORDER BY total_units_sold DESC
LIMIT 3;

-- Joining sales data with the correct weather station.
SELECT t.date, t.store_nbr, t.item_nbr, t.units, k.station_nbr
FROM train AS t 
JOIN key AS k
ON t.store_nbr = k.store_nbr;

-- The daily sales and average temperature of each day for the most sold unit (item_nbr 45).
SELECT t.date, SUM(t.units) AS daily_units_sold, AVG(CAST(w.tavg AS FLOAT)) AS avg_temp
FROM train AS t
JOIN key AS k
ON k.store_nbr = t.store_nbr
LEFT JOIN weather AS w
ON w.station_nbr = k.station_nbr
AND w.date = t.date
WHERE t.item_nbr = 45
GROUP BY t.date
ORDER BY t.date;

-- Designing a table to be loaded into R
-- This query will return every sale row for the items 45, 9 and 5,
-- with the weather for each sale date. 
-- Used left join so that no sales rows are missing if weather is missing. 
WITH sales AS (
SELECT date, store_nbr, item_nbr, SUM(units) AS units
FROM train
WHERE item_nbr IN (45, 9, 5)
GROUP BY date, store_nbr, item_nbr
),
store_station AS (
SELECT store_nbr, station_nbr
FROM key
GROUP BY store_nbr, station_nbr
)
SELECT s.date, s.store_nbr, ss.station_nbr, s.item_nbr, s.units, 
w.tmax, w.tmin, w.tavg, w.depart, w.dewpoint, w.wetbulb, w.heat, 
w.cool, w.sunrise, w.sunset, w.codesum, w.snowfall, w.preciptotal,
w.stnpressure, w.sealevel, w.resultspeed, w.resultdir, w.avgspeed
FROM sales as s
JOIN store_station as ss
ON ss.store_nbr = s.store_nbr
LEFT JOIN weather w
ON w.station_nbr = ss.station_nbr
AND w.date = s.date;


