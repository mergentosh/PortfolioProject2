SELECT location,date,total_cases, new_cases,total_deaths,population 
FROM PortfolioProject..covid_deaths 
ORDER BY 1,2


--Looking at Total Cases vs Total Deaths in 'TURKEY'

SELECT location,date,total_cases,total_deaths ,ROUND( CAST(total_deaths AS int) / total_cases *100,2 ) AS DeathPercentage
FROM PortfolioProject..[covid_deaths ]
WHERE location like '%key'
ORDER BY 1,2 
--------------------------------------------------------
SELECT a.location,MAX(a.deathpercentage)  AS MaxDeathPercentage
FROM (SELECT location,population,total_cases,total_deaths, 
	ROUND(( CAST(total_deaths as int) / total_cases )*100,2) as DeathPercentage 
	FROM PortfolioProject..covid_deaths ) a
WHERE location like '%key'
GROUP BY a.location 
ORDER BY MaxDeathPercentage DESC

--Looking at Total Cases vs Population of 'TURKEY'

SELECT location,date,total_cases,population , ROUND(( total_cases / population )*100,2) as TotalCasesPercentageByPopulation
FROM PortfolioProject..[covid_deaths ]
WHERE location like '%key'
ORDER BY 1,2 

----------------------------------------------------------
SELECT location as Location ,population as Population , MAX(total_cases) HighestInfectionCount,round(( max(total_cases) / population )*100,2) as InfectionRateByPopulation
FROM PortfolioProject..covid_deaths
WHERE continent is not null
AND location in 
	( SELECT location 
	FROM PortfolioProject..covid_deaths 
	WHERE location = 'Turkey'  ) 
GROUP BY location,population 
ORDER BY HighestInfectionCount desc

--Countries with Highest Infection Rate compared to Population 

SELECT location , MAX(total_cases) as HighestInfectionCount , MAX((total_cases/ population)*100) as InfectionRate
FROM PortfolioProject..[covid_deaths ]
--WHERE location like '%key'
WHERE continent is not null 
GROUP BY location 
ORDER BY 3 desc 

--Showing Countries with Highest Death Count per Population (TURKEY)

SELECT location , MAX(CONVERT(int,total_deaths)) as TotalDeathCount , MAX((CAST(total_deaths as int )/ total_cases)*100) as DeathRate
FROM PortfolioProject..[covid_deaths ]
WHERE continent is not null 
AND location like '%key'
GROUP BY location 




SELECT location AS Location , MAX(CONVERT(int,total_deaths)) as TotalDeathCount , MAX((CAST(total_deaths as int )/ total_cases)*100) as DeathRate
FROM PortfolioProject..[covid_deaths ]
WHERE continent is null 
GROUP BY location 
ORDER BY 2 DESC 


--Showing Continents with the Highest Death Count per Population 


SELECT location AS Location , MAX((CAST(total_deaths as int )/ population)*100) as HighestDeathCountPerPopulation
FROM PortfolioProject..[covid_deaths ]
WHERE continent is null 
GROUP BY location 
ORDER BY 2 DESC 



SELECT date as Date , SUM(new_cases) as NewCases , SUM(CONVERT(int,new_deaths )) as NewDeaths , ROUND(SUM(CONVERT(int,new_deaths ))  / SUM( new_cases ),2)  as DeathsPercentageByDay
FROM PortfolioProject..[covid_deaths ]
WHERE continent is not null
GROUP BY date
ORDER BY 1


--


SELECT SUM(new_cases) as TotalCases , SUM(CONVERT(int,new_deaths )) as TotalDeaths , ROUND(SUM(CONVERT(int,new_deaths ))  / SUM( new_cases ),2)  as TotalDeathPercentage
FROM PortfolioProject..[covid_deaths ]
WHERE continent is not null
ORDER BY 1


--Covid Vaccinations 

SELECT*
FROM PortfolioProject..[covid_deaths ] dea
JOIN PortfolioProject..[covid_vaccinations ] vac
		ON dea.location =vac.location 
		AND dea.date=vac.date 

--Looking at Total Population vs Vaccinations 

SELECT dea.continent, dea.location ,dea.date,dea.population,vac.new_vaccinations ,
SUM(CONVERT(int,vac.new_vaccinations) ) OVER( PARTITION BY dea.location ORDER BY dea.date) as RollingPeopleVaccinated 
FROM PortfolioProject..[covid_deaths ] dea
JOIN PortfolioProject..[covid_vaccinations ] vac
		ON dea.location =vac.location 
		AND dea.date=vac.date 
WHERE dea.continent is not null
ORDER BY 2,3 

--CTE 

WITH VaccinatedPopulation AS
(
SELECT dea.continent, dea.location ,dea.date,dea.population,vac.new_vaccinations ,
SUM(CONVERT(int,vac.new_vaccinations) ) OVER( PARTITION BY dea.location ORDER BY dea.date) as RollingPeopleVaccinated 
FROM PortfolioProject..[covid_deaths ] dea
JOIN PortfolioProject..[covid_vaccinations ] vac
		ON dea.location =vac.location 
		AND dea.date=vac.date 
WHERE dea.continent is not null
--ORDER BY 2,3 
)
SELECT * 
FROM VaccinatedPopulation ; 


--Usage with Subqueries 

SELECT a.*, ROUND((a.RollingPeopleVaccinated / a.population )*100,2) as VaccinatedPercentage
FROM (   SELECT dea.continent, dea.location ,dea.date,dea.population,vac.new_vaccinations ,
SUM(CONVERT(int,vac.new_vaccinations) ) OVER( PARTITION BY dea.location ORDER BY dea.date) as RollingPeopleVaccinated 
FROM PortfolioProject..[covid_deaths ] dea
JOIN PortfolioProject..[covid_vaccinations ] vac
		ON dea.location =vac.location 
		AND dea.date=vac.date 
WHERE dea.continent is not null   ) a 

--TEMP Table 

DROP TABLE IF EXISTS #PercentPopVaccinated
CREATE TABLE #PercentPopVaccinateddd
( Continent nvarchar(255),
  Location nvarchar(255),
  Date datetime , 
  Population numeric,
  RollingPeopleVaccinated numeric,
  VaccinatedPercentage numeric ) 

INSERT INTO #PercentPopvaccinateddd
SELECT dea.continent, dea.location ,dea.date,dea.population,vac.new_vaccinations ,
SUM(CONVERT(int,vac.new_vaccinations) ) OVER( PARTITION BY dea.location ORDER BY dea.date) as RollingPeopleVaccinated 
FROM PortfolioProject..[covid_deaths ] dea
JOIN PortfolioProject..[covid_vaccinations ] vac
		ON dea.location =vac.location 
		AND dea.date=vac.date 
WHERE dea.continent is not null
--ORDER BY 2,3 



SELECT*
FROM #PercentPopvaccinateddd


--VIEWS

CREATE VIEW PercentPopulationVaccinated as 
SELECT dea.continent, dea.location ,dea.date,dea.population,vac.new_vaccinations ,
SUM(CONVERT(int,vac.new_vaccinations) ) OVER( PARTITION BY dea.location ORDER BY dea.date) as RollingPeopleVaccinated 
FROM PortfolioProject..[covid_deaths ] dea
JOIN PortfolioProject..[covid_vaccinations ] vac
		ON dea.location =vac.location 
		AND dea.date=vac.date 
WHERE dea.continent is not null
--ORDER BY 2,3 

SELECT*
FROM PercentPopulationVaccinated



