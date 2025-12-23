/*reset*/
DROP SCHEMA IF EXISTS fitness CASCADE;
CREATE SCHEMA fitness;

/*tables*/
CREATE TABLE fitness.proband (
    proband_id INT PRIMARY KEY,
    bmi NUMERIC,
    gender VARCHAR(20),
    weight NUMERIC,
    age NUMERIC,
    height NUMERIC,
    workout_frequency NUMERIC
);

CREATE TABLE fitness.workout (
    workout_id SERIAL PRIMARY KEY,
    type VARCHAR(20),
    calories_burned NUMERIC,
    duration NUMERIC,
    proband_id INT NOT NULL REFERENCES fitness.proband(proband_id)
);

CREATE TABLE fitness.nutrition (
    nutrition_id SERIAL PRIMARY KEY,
    calories NUMERIC,
    meal_frequency NUMERIC,
    water_intake NUMERIC,
    proband_id INT NOT NULL REFERENCES fitness.proband(proband_id)
);

/*load probands first beacause of reference in other tables*/
COPY fitness.proband(proband_id, age, gender, weight, bmi, height, workout_frequency) 
FROM 'C:\Program Files\PostgreSQL\18\data\fitness_db\proband_probid.CSV'
WITH (FORMAT csv, HEADER, DELIMITER ',');

COPY fitness.workout(proband_id, type, calories_burned, duration)
FROM 'C:\Program Files\PostgreSQL\18\data\fitness_db\workout_probid.CSV'
WITH (FORMAT csv, HEADER, DELIMITER ',');

COPY fitness.nutrition(proband_id, water_intake, meal_frequency, calories)
FROM 'C:\Program Files\PostgreSQL\18\data\fitness_db\nutrition_probid.CSV'
WITH (FORMAT csv, HEADER, DELIMITER ',');

/*Is nutritional intake (calories and water) associated with workout intensity, and does this association differ by gender?*/
/*workout intensity is approximated as calories burned per hour, so calories_burned/duration 
calculate correlation between 
(1) calories intake and calories burned by hour and 
(2) water intake and caloires burned per hour
separately for each gender*/
SELECT
  p.gender,
/*CORR(x, y) returns the Pearson correlation coefficient between x and y.
Remembder: Descriptive only, no prove of causality.
Range: -1 to +1
    +1 = strong positive relationship (higher intake -> higher intensity)
    0 = no linear relationship
    -1 = strong negative relationship (higher intake -> lower intensity)*/
  CORR(n.calories, w.calories_burned / NULLIF(w.duration, 0)) AS corr_intake_vs_burn_per_hour,
  CORR(n.water_intake, w.calories_burned / NULLIF(w.duration, 0)) AS corr_water_vs_burn_per_hour
FROM fitness.proband p
JOIN fitness.workout w
  ON p.proband_id = w.proband_id
JOIN fitness.nutrition n
  ON p.proband_id = n.proband_id
/*group by gender to compute correlations separately for each gender group*/
GROUP BY p.gender
/*sort alphabetically by gender*/
ORDER BY p.gender;

