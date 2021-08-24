--Showing what percentage of population got Covid

SELECT location,population,MAX(total_cases) AS HighestInfectionCount ,MAX((total_cases / population))*100 as DeathPercentage
FROM covid_deaths
where total_cases is not null
group by location,population 
order by 4 desc

--Looking at countries with Highest Infection Rate compared to population 

SELECT location,population,MAX(total_cases) AS HighestInfectionCount ,MAX((total_cases / population))*100 as PercentPopulationInfected
FROM covid_deaths
where total_cases is not null
group by location,population 
order by 4 desc


--Showing Countries with Highest Death Count per Population 

SELECT location,MAX(cast(total_deaths as int)) as TotalDeathCount  
FROM PortfolioProject..covid_deaths
WHERE continent is not null
GROUP BY location 
ORDER BY TotalDeathCount desc 

select*
from PortfolioProject..covid_deaths
where continent like 'North America'
and location = 'United States'



--BREAK THINGS DOWN BY CONTINENT 

SELECT continent,MAX(cast(total_deaths as int)) as TotalDeathCountByContinent  
FROM PortfolioProject..covid_deaths
WHERE continent is not null
GROUP BY continent 
ORDER BY TotalDeathCountByContinent desc 


--GLOBAL NUMBERS 

SELECT date as Date, SUM(new_cases) as TotalCasesByDay, SUM(CONVERT(int,new_deaths)) as TotalDeathsByDay, (SUM(CONVERT(int,new_deaths)) / SUM( new_cases))*100  as DeathsPercentageByDay
FROM PortfolioProject..covid_deaths
WHERE continent is not null 
GROUP BY date 
ORDER BY 1 desc 

SELECT  SUM(new_cases) as TotalCasesByDay, SUM(CONVERT(int,new_deaths)) as TotalDeathsByDay, (SUM(CONVERT(int,new_deaths)) / SUM( new_cases))*100  as DeathsPercentageByDay
FROM PortfolioProject..covid_deaths
WHERE continent is not null 
ORDER BY 1 desc 


SELECT continent, SUM(new_cases) as cases, SUM(CONVERT(int,new_deaths)) as deaths, (SUM(CONVERT(int,new_deaths)) / SUM( new_cases))*100  as DeathsPercentageByDay
FROM PortfolioProject..covid_deaths
WHERE continent is not null 
GROUP BY continent 
ORDER BY 1 desc 


--Looking at Total Population vs Vaccinations 

SELECT dea.continent, dea.location,dea.date,dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER(PARTITION BY dea.location ORDER BY dea.location , dea.date ) 
FROM PortfolioProject..covid_deaths dea 
JOIN PortfolioProject..covid_vaccinations vac 
	ON dea.location=vac.location 
	AND dea.date= vac.date 
WHERE dea.continent is not null 
ORDER BY 2,3 


--CTE

WITH PopvsVac 
AS (
SELECT dea.continent, dea.location,dea.date,dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER(PARTITION BY dea.location ORDER BY dea.location , dea.date )  as VaccinatedPeople
FROM PortfolioProject..covid_deaths dea 
JOIN PortfolioProject..covid_vaccinations vac 
	ON dea.location=vac.location 
	AND dea.date= vac.date 
WHERE dea.continent is not null 
--ORDER BY 2,3 
) 
SELECT *,( VaccinatedPeople / population )*100   as VaccinatedPercentageByPopulation
FROM PopvsVac


--TEMP TABLE 

CREATE TABLE #PercentPopulationVaccinatedd
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime ,
Population numeric,
New_vaccinations numeric,
VaccinatedPeople numeric
)




Insert into #PercentPopulationVaccinated
SELECT dea.continent, dea.location,dea.date,dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER(PARTITION BY dea.location ORDER BY dea.location , dea.date )  as VaccinatedPeople
FROM PortfolioProject..covid_deaths dea 
JOIN PortfolioProject..covid_vaccinations vac 
	ON dea.location=vac.location 
	AND dea.date= vac.date 
WHERE dea.continent is not null 
--ORDER BY 2,3 


SELECT *,( VaccinatedPeople / population )*100   as VaccinatedPercentageByPopulation
FROM #PercentPopulationVaccinated
