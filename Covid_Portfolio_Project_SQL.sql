--select data that we are going to be using 

select location,date,total_cases,new_cases,total_deaths,population
from covidDeaths


-- looking total cases vs total deaths

select location,date,total_cases,total_deaths,population,cast(total_deaths as decimal)/cast(total_cases as decimal)*100 as deathPer
from covidDeaths
where location='tunisia'

-- looking total cases vs population in your country 

-- create stored procedure
 
create procedure TcasesVsPopulation
@country varchar(50)
as 
select location,date,total_cases,population,cast(total_cases as decimal)/population as PerCasesPerPop
from PortfolioProject.dbo.covidDeaths
where location=@country
 
 -- update the stored procedure 

alter procedure TcasesVsPopulation
@country varchar(50)
as 
select location,date,total_cases,population,cast(total_cases as decimal)/population*100 as PerCasesPerPop
from PortfolioProject.dbo.covidDeaths
where location=@country

-- looking at countries with highest infection rate compared to population

select location,population,max(cast(total_cases as decimal)) as MaxTCases,max(cast(total_cases as decimal)/population)*100 as PerCasesPerPop
from PortfolioProject.dbo.covidDeaths
where continent is not null
group by location,population
order by PerCasesPerPop desc
 
 -- loooking at countries with highest death

select location,population,max(cast(total_deaths as decimal)) as maxDeathsPerCountry
from covidDeaths
where continent is not null
group by location,population
order by maxDeathsPerCountry desc

 -- looking total deaths per day 

select date ,sum(cast(total_deaths as decimal)) TotalDeathPerDay
from covidDeaths
where continent is not null
group by date
order by date

-- looking total population vs vaccinations
--               Use cte

with cte_RollingPeoVacc
as (
select cDeath.location,cDeath.date,cDeath.population, cDeath.total_cases,cDeath.new_cases,cVac.total_vaccinations,
sum(convert(decimal,cVac.total_vaccinations)) over (partition by cDeath.location order by cDeath.location,cDeath.date)
as rollingPeopleVaccinations
from covidDeaths as cDeath
inner join covidVaccination as cVac
on cDeath.date=cVac.date
and cDeath.location=cVac.location
where cDeath.continent is not null
)
select *,rollingPeopleVaccinations/population*100 as 
from cte_RollingPeoVacc


-- temp table


create table #RollingPeopleVaccination (
location varchar(50),
date datetime,
population decimal,
total_cases decimal,
new_cases decimal,
total_vaccinations decimal,
rollingPeopleVaccinations decimal)
 
 insert into #RollingPeopleVaccination
 select cDeath.location,cDeath.date,cDeath.population, cDeath.total_cases,cDeath.new_cases,cVac.total_vaccinations,
sum(convert(decimal,cVac.total_vaccinations)) over (partition by cDeath.location order by cDeath.location,cDeath.date)
as rollingPeopleVaccinations
from covidDeaths as cDeath
inner join covidVaccination as cVac
on cDeath.date=cVac.date
and cDeath.location=cVac.location
where cDeath.continent is not null

select *
from #RollingPeopleVaccination

-- create view

create view RollingPeopleVaccination 
as 
select cDeath.location,cDeath.date,cDeath.population, cDeath.total_cases,cDeath.new_cases,cVac.total_vaccinations,
sum(convert(decimal,cVac.total_vaccinations)) over (partition by cDeath.location order by cDeath.location,cDeath.date)
as rollingPeopleVaccinations
from covidDeaths as cDeath
inner join covidVaccination as cVac
on cDeath.date=cVac.date
and cDeath.location=cVac.location
where cDeath.continent is not null

select *
from RollingPeopleVaccination

  








