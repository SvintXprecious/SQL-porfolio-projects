--starting point for our query

SELECT *
FROM [Diabetes project]..diabetes_prediction_dataset


--GLOBAL NUMBERS

--Retrieve the count of total patients

 SELECT COUNT(*) AS total_patients
 FROM [Diabetes project]..diabetes_prediction_dataset

 --Retrieve the number of diabetic patients

  SELECT SUM(diabetes) AS diabetic_patients
 FROM [Diabetes project]..diabetes_prediction_dataset

--Average age of the diabetic patients

SELECT AVG(age) AS average_age_of_patients
FROM [Diabetes project]..diabetes_prediction_dataset
WHERE diabetes = 1


--highest and lowest HbA1c levels recorded

SELECT MAX(HbA1c_level) AS highest_HbA1c
FROM [Diabetes project]..diabetes_prediction_dataset

SELECT MIN(HbA1c_level) AS lowest_HbA1c
FROM [Diabetes project]..diabetes_prediction_dataset






--STATISTICS

--The count of male and female patients and the number of diabetic patients in each group
--done
 SELECT gender, COUNT(*) AS total_patients, SUM(diabetes) AS diabetic_patients
 FROM [Diabetes project]..diabetes_prediction_dataset
 GROUP BY gender

--Average age of patients grouped by gender
SELECT gender,AVG(age) AS average_age_of_patients
FROM [Diabetes project]..diabetes_prediction_dataset
GROUP BY gender
ORDER BY gender


-- Diabetic vs Non-Diabetic
SELECT CASE 
	WHEN diabetes = 0 then 'Non-Diabetic'
	WHEN diabetes = 1 then 'Diabetic'
END AS status,
COUNT(*) AS status_count,
COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS status_percentage
FROM [Diabetes project]..diabetes_prediction_dataset
GROUP BY diabetes
ORDER BY status_count

--stacked bar chart
SELECT gender,
CASE 
	WHEN diabetes = 0 then 'Non-Diabetic'
	WHEN diabetes = 1 then 'Diabetic'
END AS status,
COUNT(*) AS status_count
FROM [Diabetes project]..diabetes_prediction_dataset
GROUP BY gender,diabetes
ORDER BY status_count


--average BMI by gender
--column chart or bar chart
SELECT gender,AVG(bmi) 
FROM [Diabetes project]..diabetes_prediction_dataset
GROUP BY gender
ORDER BY gender

-- Gender vs Hypertension
SELECT gender,
  COUNT(*) AS count_hypertension,
  (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM [Diabetes project]..diabetes_prediction_dataset WHERE hypertension = 1)) AS hypertension_percentage
FROM [Diabetes project]..diabetes_prediction_dataset
WHERE  hypertension = 1
GROUP BY gender;

--Hypertension vs Diabetic count
SELECT
  hypertension,
  COUNT(*) AS patient_count,
  COUNT(CASE WHEN diabetes = 1 THEN 1 END) AS diabetic_count
  --ROUND(COUNT(CASE WHEN diabetes = 1 THEN 1 END) * 100.0 / COUNT(*) , 2) AS diabetic_percentage
FROM
  [Diabetes project]..diabetes_prediction_dataset

GROUP BY
  hypertension;

--distribution of HbA1c levels among diabetic patients
SELECT
  HbA1c_level,
  COUNT(*) AS patient_count
FROM
  [Diabetes project]..diabetes_prediction_dataset
WHERE
  diabetes = 1
GROUP BY
  HbA1c_level
ORDER BY HbA1c_level


--the impact of smoking history on diabetes
SELECT 
	UPPER (smoking_history) AS smoking_history,
	COUNT(*) as diabetic_count,
	COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () as diabetic_count_percentage
FROM [Diabetes project]..diabetes_prediction_dataset
WHERE diabetes=1
GROUP BY smoking_history
ORDER BY smoking_history

--blood glucose levels between diabetic and non-diabetic patients
SELECT 
	CASE WHEN diabetes = 1 then 'Diabetic'
	WHEN diabetes = 0 then 'Non-Diabetic'
	END AS status,
AVG(blood_glucose_level) AS avg_blood_glucose_level

FROM [Diabetes project]..diabetes_prediction_dataset
GROUP BY diabetes
ORDER BY status

--correlation between body mass index and diabetes
--x label(bmi) y label(diabetes)
SELECT bmi,count(*) AS diabetic_count
FROM [Diabetes project]..diabetes_prediction_dataset
WHERE diabetes=1
GROUP BY bmi
ORDER BY bmi

--correlation between age and diabetes
--histogram chart
-- age is x label
SELECT age,count(*) AS diabetic_count
FROM [Diabetes project]..diabetes_prediction_dataset
WHERE diabetes=1
GROUP BY age
ORDER BY age

--the prevalence of smoking history among diabetic and non-diabetic patients:
-- Using a grouped bar chart, you can have two bars for each smoking history category, one representing diabetic patients and the other representing non-diabetic patients. This allows for a clear visual comparison between the two groups.
SELECT
  diabetes,
  smoking_history,
  COUNT(*) AS patient_count,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY diabetes), 2) AS percentage
FROM [Diabetes project]..diabetes_prediction_dataset
GROUP BY diabetes, smoking_history
ORDER BY diabetes,smoking_history

--relationship between hypertension and diabetes
--done
SELECT 
	hypertension,
	COUNT(*) AS patient_count,
	COUNT(CASE WHEN diabetes = 1 THEN 1 END) AS diabetic_count,
	ROUND(COUNT(CASE WHEN diabetes = 1 THEN 1 END) * 100.0 / COUNT(*), 2) AS diabetic_percentage
FROM [Diabetes project]..diabetes_prediction_dataset
GROUP BY hypertension
ORDER BY hypertension