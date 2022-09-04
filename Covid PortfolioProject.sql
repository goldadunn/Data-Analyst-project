Select *
From DataProject..CovidDeaths
where continent is not null
order by 3,4

--Select *
--From DataProject..CovidVaccinations
--order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From DataProject..CovidDeaths
order by 1,2

--Looking at total cases vs total deaths

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From DataProject..CovidDeaths
Where Location like '%states%'
where continent is not null
order by 1,2

--Looking at total cases vs population
--Shows what percentage of population got COVID
Select Location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From DataProject..CovidDeaths
Where Location like '%states%'
where continent is not null
order by 1,2


--Looking at countries with highest infection rates compared to population

Select Location, population, Max(total_cases)as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
From DataProject..CovidDeaths
--Where Location like '%states%'
Group by Location, population
order by PercentpopulationInfected desc

--Showing Countries with highest death rate per population

Select Location, Max(cast(Total_deaths as int)) as TotalDeathCount
From DataProject..CovidDeaths
--Where Location like '%states%'
where continent is not null
Group by Location
order by TotalDeathCount desc


Select Location, Max(cast(Total_deaths as int)) as TotalDeathCount
From DataProject..CovidDeaths
--Where Location like '%states%'
where continent is null
Group by Location
order by TotalDeathCount desc

--Showing continents with the highest death count per population

Select continent, Max(cast(Total_deaths as int)) as TotalDeathCount
From DataProject..CovidDeaths
--Where Location like '%states%'
where continent is not null
Group by continent
order by TotalDeathCount desc


--Global Numbers

Select SUM(new_cases), SUM(Cast(new_deaths as int)), SUM(Cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From DataProject..CovidDeaths
--Where Location like '%states%'
where continent is not null
--Group by date
order by 1,2


--Looking at total population vs vaccination 

with Popvsvac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Convert(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated,
From DataProject..CovidDeaths dea
Join DataProject..CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)

Select* (Rollingpeoplevaccinated/population)*100
From popvsvac

--Temp Table
Drop table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
Rollingpeolevaccinated numeric
)

insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Convert(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
from DataProject..CovidDeaths dea
Join DataProject..CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Create view #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Convert(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
from DataProject..CovidDeaths dea
Join DataProject..CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

