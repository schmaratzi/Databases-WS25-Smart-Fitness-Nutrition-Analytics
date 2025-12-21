-- Extrema Intake (Top 10%) --> ein wenig mehr Frauen als Männer 
-- sind in den top 10% der calorie-Intakes 

WITH per_proband AS (
  SELECT
    p.proband_id,
    p.gender,
    AVG(n.calories) AS avg_calories_intake
  FROM fitness.proband p
  JOIN fitness.nutrition n ON n.proband_id = p.proband_id
  WHERE n.calories IS NOT NULL
  GROUP BY p.proband_id, p.gender
),
ranked AS (
  SELECT
    *,
    NTILE(10) OVER (ORDER BY avg_calories_intake DESC) AS decile
  FROM per_proband
)
SELECT
  gender,
  COUNT(*) AS n_in_top10pct
FROM ranked
WHERE decile = 1
GROUP BY gender;
