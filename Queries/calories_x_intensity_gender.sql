-- calorie & water intake x workout intensity nach 
-- gender gruppiert

WITH nutrition_per_proband AS (
  SELECT
    p.proband_id,
    p.gender,
    AVG(n.calories) AS avg_calories,
    AVG(n.water_intake) AS avg_water,
    AVG(n.meal_frequency) AS avg_meals
  FROM fitness.proband p
  JOIN fitness.nutrition n
    ON n.proband_id = p.proband_id
  GROUP BY p.proband_id, p.gender
),
intensity_per_proband AS (
  SELECT
    w.proband_id,
    AVG(w.calories_burned / NULLIF(w.duration, 0)) AS avg_intensity
  FROM fitness.workout w
  GROUP BY w.proband_id
)
SELECT
  n.gender,
  CORR(n.avg_calories, i.avg_intensity) AS corr_calories_intensity,
  CORR(n.avg_water, i.avg_intensity)    AS corr_water_intensity,
  CORR(n.avg_meals, i.avg_intensity)     AS corr_meals_intensity
FROM nutrition_per_proband n
JOIN intensity_per_proband i
  ON n.proband_id = i.proband_id
GROUP BY n.gender
ORDER BY n.gender;


