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

select date,sum(new_cases) --(total_deaths/total_cases)*100 as DeathPercentage 
from PortfolioProject..CovidDeaths
--where location like'%state%'
where continent is not null
group by date
order by 1,2

 