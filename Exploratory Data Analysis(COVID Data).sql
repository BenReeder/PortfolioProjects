-- Checking tables and ordering alphabetically by location and then by date

Select *
from [Portfolio Project]..CovidDeaths$
where continent is not null
order by 3,4

Select *
from [Portfolio Project]..CovidVaccinations$
order by 3,4

Select location, date, total_cases, total_deaths, population
From [Portfolio Project]..CovidDeaths$
order by 1,2

-- Looking at Total Cases vs Total Deaths in United States


-- For most of these, can add(Where location like %states%) in order to see results for United States
-- If looing at United States, next line should be (and continent is not null) if following line includes Where clause
-- Shows likelihood of dying if you contact covid in your country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths$
Where location like '%states%'
and continent is not null
order by 1,2

--Looking at Total Cases vs Population 

Select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From [Portfolio Project]..CovidDeaths$
--Where location like '%states'
order by 1,2


-- Looking at countries with highest infection rates compared to population 

Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From [Portfolio Project]..CovidDeaths$
Group by location, population
order by PercentPopulationInfected desc


--Showing Countries with Highest Death Count per Population 

Select location, population, MAX(total_deaths) as HighestDeathCount, MAX((total_deaths/population))*100 as DeathPerPopulation	
From [Portfolio Project]..CovidDeaths$
Group by location, population
order by DeathPerPopulation desc

-- Showing the continents with the highest death count

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths$
--Where location like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc



-- Global Numbers 

-- Death Percentage by Date

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int))as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage 
From [Portfolio Project]..CovidDeaths$
--Where location like '%states%'
Where continent is not null
Group by date
order by 1,2

--Total Death Percentage

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int))as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage 
From [Portfolio Project]..CovidDeaths$
--Where location like '%states%'
Where continent is not null
order by 1,2

-- Looking at Total Population vs Vaccinations for each location

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated

--(RollingPeopleVaccinated/population)*100
From [Portfolio Project]..CovidDeaths$ dea
Join [Portfolio Project]..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

--USE CTE

with PopvsVac (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated

--,(RollingPeopleVaccinated/population)*100
from [Portfolio Project]..CovidDeaths$ dea
Join [Portfolio Project]..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100 as RollingVaccinatedPercentage
from PopvsVac


-- TEMP TABLE

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated

--,(RollingPeopleVaccinated/population)*100
from [Portfolio Project]..CovidDeaths$ dea
Join [Portfolio Project]..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

Select *, (RollingPeopleVaccinated/population)*100 as RollingPeopleVaccinatedPercentage
from #PercentPopulationVaccinated

--Creating View

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated

--,(RollingPeopleVaccinated/population)*100
from [Portfolio Project]..CovidDeaths$ dea
Join [Portfolio Project]..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

--Showing view

select * 
from PercentPopulationVaccinated
