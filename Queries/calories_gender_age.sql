-- calories by gender and age group
WITH per_proband AS (
  SELECT
    p.proband_id,
    p.gender,
    p.age,
    AVG(n.calories) AS avg_calories_intake,
    COUNT(*) AS n_nutrition_entries
  FROM fitness.proband p
  JOIN fitness.nutrition n
    ON n.proband_id = p.proband_id
  WHERE n.calories IS NOT NULL
  GROUP BY p.proband_id, p.gender, p.age
),
grouped AS (
  SELECT
    gender,
    CASE
      WHEN age < 20 THEN '<20'
      WHEN age < 30 THEN '20–29'
      WHEN age < 40 THEN '30–39'
      WHEN age < 50 THEN '40–49'
      ELSE '50+'
    END AS age_group,
    avg_calories_intake
  FROM per_proband
)
SELECT
  gender,
  age_group,
  COUNT(*) AS n_probands,
  ROUND(AVG(avg_calories_intake), 2) AS mean_calories,
  ROUND(STDDEV_SAMP(avg_calories_intake), 2) AS sd_calories
FROM grouped
GROUP BY gender, age_group
ORDER BY age_group, gender;



