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

/*Gender differences in workout performance?*/
SELECT
  p.gender,
  COUNT(*) AS n_probands,
  AVG(w.calories_burned) AS avg_calories_burned,
  STDDEV_SAMP(w.calories_burned) AS sd_calories_burned,
  AVG(w.duration) AS avg_duration_hours,
  STDDEV_SAMP(w.duration) AS sd_duration_hours
FROM fitness.proband p
JOIN fitness.workout w
  ON p.proband_id = w.proband_id
GROUP BY p.gender
ORDER BY p.gender;

