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
  
  /*IQR calculations Calories burned*/
  /*25 and 75 percentile of calories burned*/
  /*IQR measures the spread of the middle 50% of workouts, used instead of standard deviation because
    it is less affected by outliers*/
  PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY w.calories_burned) AS calories_q1,
  PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY w.calories_burned) AS calories_q3,
  PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY w.calories_burned)
  	- PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY w.calories_burned) AS calories_iqr,

  /*IQR calculations Session duration*/
  /*25 and 75 percentile of workout duration*/
  PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY w.duration) AS duration_q1,
  PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY w.duration) AS duration_q3,
  PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY w.duration)
    - PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY w.duration) AS duration_iqr,
  /*number of workout sessions for this gender*/
  COUNT(*) AS n_probands,
  /*Average clories burned per workout session for this gender and standard deviation of calories burned*/
  AVG(w.calories_burned) AS avg_calories_burned,
  STDDEV_SAMP(w.calories_burned) AS sd_calories_burned,
  /*Average workout duration for this gender and standard deviation of workout duration*/
  AVG(w.duration) AS avg_duration_hours,
  STDDEV_SAMP(w.duration) AS sd_duration_hours
/*link each workout to the gender of the person who performed it*/
FROM fitness.proband p
JOIN fitness.workout w
  ON p.proband_id = w.proband_id
/*aggregate all workout sessions by gender*/
GROUP BY p.gender
/*sorts results alphabetically by gender*/
ORDER BY p.gender;

