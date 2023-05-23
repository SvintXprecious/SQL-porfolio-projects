/*

Queries used for Tableau Project
Link to Tableau project visualisation https://public.tableau.com/app/profile/precious.tsetekani/viz/Covid19Dashboard_16848371984790/Dashboard1
*/


--1
--Total New Cases vs Total New Deaths


SELECT SUM(new_cases) AS total_cases,SUM(CAST(new_deaths AS INT)) AS total_deaths,(SUM(CAST(new_deaths AS INT))/SUM(new_cases)) * 100 AS DeathPercentage 
FROM CovidProject..CovidDeaths
WHERE  continent IS NOT NULL

--2
-- Showing contintents with the highest death count per population

SELECT continent,MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM CovidProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

--3
-- Total Cases vs Population
-- Countries with Highest Infection Rate compared to Population by date

SELECT location,date,population,MAX(total_cases) AS HighestInfectionCount,MAX((total_cases/population)) * 100 AS PercentPopulationInfected
FROM CovidProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location,population,date
ORDER by PercentPopulationInfected desc

--4
-- Countries with Highest Infection Rate compared to Population

SELECT location,MAX(total_cases) AS HighestInfectionCount,population,MAX((total_cases/population)) * 100 AS PercentPopulationInfected
FROM CovidProject..CovidDeaths
GROUP BY location,population
ORDER BY PercentPopulationInfected DESC