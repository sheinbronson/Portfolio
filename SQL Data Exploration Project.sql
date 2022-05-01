SELECT location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
WHERE continent is not NULL


--

--Lookinng at Total Cases VS Total Deaths
--Shows likelihood  of dying if  you contract covid  in our country 
SELECT location, date, total_cases, total_deaths,  (total_deaths*1.0/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location like '%canada%'
and  continent is not NULL
order by 1,2


--Looking at Total Cases VS Population
-- Shows what percentage of population got Covid
SELECT location, date, population, total_cases,   (total_cases*1.0/population)*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE location like '%canada%'
and  continent is not NULL
order by 1,2

--Looking at Countries with Highest Infection Rate compared to Population

SELECT LOCATION, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases*1.0 /population))*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE  continent is not NULL
Group by location, population
order by PercentPopulationInfected desc 

--Showing Countires with Highest Death Count per Population

SELECT  LOCATION, MAX(total_deaths) as TotalDeathsCount
FROM PortfolioProject..CovidDeaths
WHERE  continent is not NULL
GROUP by LOCATION
ORDER by TotalDeathsCount DESC

-- Breaking data down by continents

--Showing continents with the highest death count per population

SELECT continent, MAX(total_deaths) as TotalDeathsCount
FROM PortfolioProject..CovidDeaths
Where continent is not NULL
GROUP by continent
ORDER by TotalDeathsCount DESC

--GLOBAL NUMBERS by Dates

SELECT  date, SUM(new_cases)  as total_cases, SUM(new_deaths) as total_deaths ,(SUM(new_deaths)*1.0/SUM(new_cases))*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
Where  continent is not NULL
Group by date
order by 1,2

--GLOBAL NUMBERS TOTAL

SELECT  SUM(new_cases)  as total_cases, SUM(new_deaths) as total_deaths ,(SUM(new_deaths)*1.0/SUM(new_cases))*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
Where  continent is not NULL
order by 1,2


--Looking at Total Population vs Vaccinations

WITH Pop_vs_Vac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated) AS (

SELECT dea.continent, dea.location, dea.DATE, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations*1.0) OVER (Partition by dea.LOCATION ORDER by dea.location, dea.date)  as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccination vac
ON dea.LOCATION = vac.LOCATION
and dea.DATE = vac.DATE
WHERE dea.continent is not NULL
)
 

--Temp Table

 


--Create View to store data for later visualization

CREATE VIEW PercentPopulationVaccinated as

SELECT dea.continent, dea.location, dea.DATE, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations*1.0) OVER (Partition by dea.LOCATION ORDER by dea.location, dea.date)  as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccination vac
ON dea.LOCATION = vac.LOCATION
and dea.DATE = vac.DATE
WHERE dea.continent is not NULL
