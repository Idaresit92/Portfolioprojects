Select*
From Portfolioproject..CovidDeaths
Where continent is not null
order by 3,4

Select*
From Portfolioproject..CovidVaccinations
order by 3,4

--Select data that we are going to be using
Select Location, date, total_cases, new_cases, total_deaths, population
From Portfolioproject..CovidDeaths
where continent is not null
order by 1,2

--Looking at Total cases vs Total Deaths
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Percentagepopulationinfected
From Portfolioproject..CovidDeaths
where location like 'Nigeria'
order by 1,2

--showing countries Highest Death Count per population
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From Portfolioproject..CovidDeaths
--where location like 'Nigeria'
where continent is not null
Group by Location
order by TotalDeathCount desc

-- Global Number
Select Sum(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 
as DeathPercentage
From Portfolioproject..CovidDeaths
--where location like 'Nigeria'
where continent is not null
--Group by date
order by 1,2

--Total population vs vaccinations
with popvsvac (continent, location, Date, population, new_vaccinations, Rollingpeoplevaccinated) as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM (CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated
From Portfolioproject..CovidDeaths dea
Join Portfolioproject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select*, (RollingPeopleVaccinated/Population)*100
from popvsvac

--Temp Table

Create Table #PercentPopulationVaccinated
(
Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingpeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,Sum(convert(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVacccinated
--, (RollingPeopleVaccinated/population)*100
from portfolioproject..CovidDeaths dea
join portfolioproject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select*, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated

-- Creating view to store data for later visualizations

Create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,Sum(convert(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVacccinated
--, (RollingPeopleVaccinated/population)*100
from portfolioproject..CovidDeaths dea
join portfolioproject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
--order by 2,3