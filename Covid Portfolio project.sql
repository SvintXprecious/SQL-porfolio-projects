-- Select Data that we are going to be starting with
-- Retrieves location, date, total cases, new cases, total deaths, and population from the CovidDeaths table
-- Filters the results to include only records where the continent is not null
-- Sorts the data in ascending order by location and date

SELECT location,date,total_cases,new_cases,total_deaths,population
FROM CovidProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY location,date


-- Total Cases vs Total Deaths
-- Shows the likelihood of dying if you contract COVID-19 in your Malawi

SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases) * 100 AS DeathPercentage 
FROM CovidProject..CovidDeaths
WHERE location LIKE '%Malawi%'
ORDER BY location,date

-- Total Cases vs Population
-- Countries with Highest Infection Rate compared to Population by date

SELECT location,date,population,MAX(total_cases) AS HighestInfectionCount,MAX((total_cases/population)) * 100 AS PercentPopulationInfected
FROM CovidProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location,population,date
ORDER by PercentPopulationInfected desc

-- Countries with Highest Infection Rate compared to Population

SELECT location,MAX(total_cases) AS HighestInfectionCount,population,MAX((total_cases/population)) * 100 AS PercentPopulationInfected
FROM CovidProject..CovidDeaths
GROUP BY location,population
ORDER BY PercentPopulationInfected DESC

-- Countries with Highest Death Count per Population

SELECT location,MAX(CAST(total_deaths as int)) AS TotalDeathCount
FROM CovidProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

-- BREAKING THINGS DOWN BY CONTINENT


-- Showing contintents with the highest death count per population

SELECT continent,MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM CovidProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC


-- GLOBAL NUMBERS



--Total New Cases vs Total New Deaths

SELECT SUM(new_cases) AS total_cases,SUM(CAST(new_deaths AS INT)) AS total_deaths,(SUM(CAST(new_deaths AS INT))/SUM(new_cases)) * 100 AS DeathPercentage 
FROM CovidProject..CovidDeaths
WHERE  continent IS NOT NULL

--Total Cases vs Total Deaths

SELECT SUM(total_cases) AS total_cases,SUM(CAST(total_deaths AS INT)) AS total_deaths,(SUM(CAST(total_deaths AS INT))/SUM(total_cases)) * 100 AS DeathPercentage 
FROM CovidProject..CovidDeaths
WHERE continent IS NOT NULL

--Total New Cases vs Total New Deaths by Date

SELECT date,SUM(new_cases) AS total_cases,SUM(CAST(new_deaths AS INT)) AS total_deaths,(SUM(CAST(new_deaths AS INT))/SUM(new_cases)) * 100 AS DeathPercentage 
FROM CovidProject..CovidDeaths
WHERE  continent IS NOT NULL
GROUP BY date
ORDER BY date

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

SELECT death.continent, death.location, death.date, death.population, vac.new_vaccinations
,SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY death.Location ORDER BY death.location, death.Date) AS RollingPeopleVaccinated
FROM CovidProject..CovidDeaths death
JOIN CovidProject..CovidVaccinations vac
	ON death.location = vac.location
	and death.date = vac.date
WHERE death.continent IS NOT NULL
ORDER BY location,date 

-- Using CTE to perform Calculation on Partition By in previous query

WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.Location Order by dea.location, dea.Date) AS RollingPeopleVaccinated
FROM CovidProject..CovidDeaths dea
JOIN CovidProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
)
SELECT *, (RollingPeopleVaccinated/Population)*100 AS RollingPeopleVaccinatedPercentage
FROM PopvsVac

