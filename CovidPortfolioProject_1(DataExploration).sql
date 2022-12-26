select * 
from PortfolioProject..CovidDeaths
order by 3,4


--select * 
--from PortfolioProject..CovidVaccinations
--order by 3,4


--selecting the data we are going to be using
select location ,date,total_cases ,new_cases,total_deaths,population
from PortfolioProject..CovidDeaths
order by 1,2



--Looking at Total cases vs Total Death
-- shows the likelihood of dying if you contract covid in your country
select location ,date,total_cases ,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage 
from PortfolioProject..CovidDeaths
where location like'%state%'
order by 1,2 



--Looking at the total cases vs population 
--shows what percentage of the population got affected


select location ,date,Population,total_cases ,(total_deaths/total_cases)*100 as DeathPercentage 
from PortfolioProject..CovidDeaths
where location like'%state%'
order by 1,2


--Looking at country has the highest infection rate compared to population


select location ,Population,MAX(total_cases) as highestInfectioCount ,MAX((total_deaths/total_cases)*100) as PercentPopulationInfected  
from PortfolioProject..CovidDeaths
--where location like'%state%'
group by population ,Location 
order by PercentPopulationInfected  desc


--showing countries with highest death count per population

select location,MAX(cast(total_deaths as int )) as TotalDeathCount  
from PortfolioProject..CovidDeaths
--where location like'%state%'
where continent is not null
group by location  
order by TotalDeathCount   desc




--lets break things down by continent 

-- shwoing the continent with the highest death count per population

select continent ,MAX(cast(total_deaths as int )) as TotalDeathCount  
from PortfolioProject..CovidDeaths
--where location like'%state%'
where continent is not null
group by continent   
order by TotalDeathCount   desc


-- Global numbers 

select sum(cast(new_deaths as int)) as total_death ,sum(cast(new_deaths as int))/sum(new_cases) *100 as deathPercentaGE,sum(new_cases) AS total_case --(total_deaths/total_cases)*100 as DeathPercentage 
from PortfolioProject..CovidDeaths
--where location like'%state%'
where continent is not null
--group by date
order by 1,2

 
 -- Looking at Total Populatio vs Vaccination 

 select dea.continent,dea.location,dea.population,dea.date,vac.new_vaccinations,
 sum(cast(vac.new_vaccinations as int )) over (partition by dea.location order by dea.location,dea.date ) as RollingpeopleVaccinnated
 from PortfolioProject..CovidDeaths dea
 join  PortfolioProject..CovidVaccinations vac
    on  dea.location=vac.location 
	and dea.date=vac.date
	where dea.continent is not null
  order by 2,3 


  --USE CTE 

  with  PopvsVac(continent,location,date,population,new_vaccination ,RollingpeopleVaccinnated)
  as
  (
   select dea.continent,dea.location,dea.population,dea.date,vac.new_vaccinations,
 sum(cast(vac.new_vaccinations as int )) over (partition by dea.location order by dea.location,dea.date )
 --RollingpeopleVaccinated
 from PortfolioProject..CovidDeaths dea
 join  PortfolioProject..CovidVaccinations vac
    on  dea.location=vac.location 
	and dea.date=vac.date
	where dea.continent is not null
  --order by 2,3 
  )
  select * from PopvsVac


  --TEMP TABLE


create table #Percentpopulationvaccinated 
(
continent nvarchar(250),
location nvarchar(260),
date datetime, 
Population numeric ,
new_vaccinations numeric  ,
RollingpeopleVaccinated numeric  
)


  insert into #Percentpopulationvaccinated
   select dea.continent,dea.location,dea.population,dea.date,vac.new_vaccinations,
 sum(cast(vac.new_vaccinations as int )) over (partition by dea.location order by dea.location,dea.date )
 --RollingpeopleVaccinated
 from PortfolioProject..CovidDeaths dea
 join  PortfolioProject..CovidVaccinations vac
    on  dea.location=vac.location 
	and dea.date=vac.date
	where dea.continent is not null
  --order by 2,3

  select *,(RollingpeopleVaccinated/population)*100
  from #Percentpopulationvaccinated


