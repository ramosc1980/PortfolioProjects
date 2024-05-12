SELECT *
FROM coviddeaths
ORDER BY 3, 4;

SELECT * 
FROM covidvaccinations
ORDER BY 3, 4;


SELECT 
FROM 
ORDER BY;

SELECT location, date, total_cases, new_cases, total_cases, population
FROM CovidDeaths
where date > '2020-02-23'
ORDER BY 1, 2;


-- Looking a Total cases vs Total Deaths
-- Shows likelyhood of dying if you contract covid in your country

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Death_percentage
FROM CovidDeaths
where date > '2020-02-23'
ORDER BY 1, 2;

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Death_percentage
FROM CovidDeaths
where date > '2020-01-21' AND location like '%states%'
ORDER BY 1, 2;

-- Looking at total cases vs population
-- Shows percentage of population got covid
SELECT location, date, population, total_cases, (total_cases/population)*100 AS Death_percentage
FROM CovidDeaths
WHERE date > '2020-01-21' AND location like '%states%'
ORDER BY 1, 2;

-- Looking at countries with highest infection rate copared to population
SELECT location, population, MAX(total_cases) AS HighestInfectionCount,  MAX(total_cases/population)*100 AS persentofpopulationinfected
FROM CovidDeaths   
GROUP BY location, population
-- Where location like '%states%'
ORDER BY persentofpopulationinfected DESC;

-- Show countries with highest death count per population
SELECT location, MAX(Total_deaths) as Total_Death_Count
FRom CovidDeaths
Where continent is not null
GROUP BY location
ORDER BY Total_Death_Count desc

-- Let's break this down by continent
SELECT location, MAX(Total_deaths) as Total_Death_Count
FROM CovidDeaths
WHERE continent IS NULL 
GROUP BY location 
ORDER BY Total_Death_Count DESC 
;


-- Showing continents with the highest death count per population
SELECT continent, MAX(Total_deaths) as Total_Death_Count
FRom CovidDeaths
Where continent is not null
GROUP BY continent
ORDER BY Total_Death_Count desc
;
-- Global Numbers

SELECT SUM(new_cases) as TotalCases, SUM(new_deaths) as TotalDeaths, SUM(new_deaths)/SUM(new_cases)*100 AS Death_Percentage  
FROM CovidDeaths	
WHERE continent is not NULL 
-- GROUP BY date 
ORDER BY 1, 2
;

-- Looking at total population vs total vaccinations

-- USE CTE
WITH PopvsVac (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated) as 
(

SELECT D.continent , D.location, D.`date`,D.population , V.new_vaccinations, SUM(V.new_vaccinations) OVER (PARTITION by D.location 		ORDER BY D.location, D.date) AS RollingPeopleVaccinated -- , (RollingPeopleVaccinated/pop
FROM CovidDeaths D
JOIN CovidVaccinations V 
	ON D.location = V.location 
	AND D.date = V.date
WHERE D.continent is not null
)

SELECT *, (RollingPeopleVaccinated/ population)*100
FROM PopvsVac
;

-- Use Temp Table
DROP TABLE IF EXISTS PercentPopulationVaccinated
;
Create Table PercentPopulationVaccinated (
	Continent nvarchar(255),
	Location nvarchar(255),
	Date datetime,
	Population numeric,
	new_vaccinations numeric,
	RollingPeopleVaccinated numeric
	)
;
insert INTO PercentPopulationVaccinated 

SELECT D.continent , D.location, D.`date`,D.population , V.new_vaccinations, SUM(V.new_vaccinations) OVER (PARTITION by D.location ORDER BY D.location, D.date) AS RollingPeopleVaccinated -- , (RollingPeopleVaccinated/pop
FROM CovidDeaths D
JOIN CovidVaccinations V 
	ON D.location = V.location 
	AND D.date = V.date
WHERE D.continent is not null
;

SELECT *, (RollingPeopleVaccinated/population)*100
FROM PercentPopulationVaccinated
;
	
-- Creating view to store data for later visualizations
Create View PercentPopulationVaccinatedView as 
SELECT D.continent , D.location, D.`date`,D.population , V.new_vaccinations, SUM(V.new_vaccinations) OVER (PARTITION by D.location ORDER BY D.location, D.date) AS RollingPeopleVaccinated 
-- , (RollingPeopleVaccinated/poppulation)*100
FROM CovidDeaths D
JOIN CovidVaccinations V 
	ON D.location = V.location 
	AND D.date = V.date
WHERE D.continent is not null
-- ORDER BY 2, 3

SELECT * FROM PercentPopulationVaccinatedView




