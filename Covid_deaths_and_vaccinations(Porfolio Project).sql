Select *
FROM PortfolioProject..CovidDeaths
Order BY 3



--Selecting the Data that we are going to use

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Order by 1,2


--Looking at Total Registered Cases vs Total Deaths

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
Order by 1,2

--Looking at Total cases vs Population 
--Shows what percentage of population got Covid 


Select location, date, population, total_cases, (total_cases/population)*100 as Infection_Rate
From PortfolioProject..CovidDeaths
Order by 1,2

--Looking at Countries with Highest Infection rate compared to Population
Select location, population, MAX(total_cases) as Highest_Infection_Count, MAX((total_cases/population))*100 as Infection_Rate
From PortfolioProject..CovidDeaths
group by location, population
order by 4


-- Showing Countries with Highest Death Count per population.
-- Data Type of Total_deaths is varchar instead of int data type due to
-- which it is unable to arrange the data properly in descending order. Hence casted as int variable.
 
 --Also, in the table, there are 2 location columns (Continent and location).
 --The 'Location' column contains both the country names and continent names.
 --Hence to only get the country location, we filter out the continents.

Select location, Max(cast(Total_deaths as int)) as Total_Death_count
From PortfolioProject..CovidDeaths
WHERE continent is not null
group by location
order by 2 desc

-- Now lets look at the count for each Continent

Select continent, Max(cast(Total_deaths as int)) as Total_Death_count
From PortfolioProject..CovidDeaths
WHERE continent is not null
group by continent
order by 2 desc

Select location, Max(cast(Total_deaths as int)) as Total_Death_count
From PortfolioProject..CovidDeaths
WHERE continent is null
group by location
order by 2 desc


-- Random Data Test 
Select location, Max(cast(Total_deaths as int)) as Total_Death_count
From PortfolioProject..CovidDeaths
WHERE continent = 'North America'
group by location
order by 2 desc

Select continent, SUM(cast(Total_deaths as int)) as Total_death
FROM PortfolioProject..CovidDeaths
WHERE continent= 'North America'
group by continent


Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast
(new_deaths as int))/SUM(new_cases)*100 as Death_Percentage
From PortfolioProject..CovidDeaths
where continent is not null
--group by date
order by 1,2 



-- Now looking at another Table 'Covid Vaccinations'


Select *
from PortfolioProject..CovidVaccinations





Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER(Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated 
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
Where dea.continent is not null
Order by 2,3


-- USE CTE 

WITH PopvsVac(Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) OVER(Partition by dea.location order by dea.date) as RollingPeopleVaccinated 
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
Where dea.location like '%nistan%'
--Order by 2,3
)


Select *
From PopvsVac
Where New_vaccinations is not null
Order by RollingPeopleVaccinated



--- Create TEmp Table and testing it

Create Table #PercentPopulationVaccinated
(
Continent varchar(255),
location varchar(255),
date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) OVER(Partition by dea.location order by dea.date) as RollingPeopleVaccinated 
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
--Where dea.location like '%nistan%'
--Order by 2,3

Select *
From #PercentPopulationVaccinated


--Creating view and testing


DROP VIEW if exists TempView

CREATE VIEW TotalVaccinations as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) OVER(Partition by dea.location order by dea.date) as RollingPeopleVaccinated 
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
Where dea.continent is not null
)