/*

Cleaning Data in SQL Queries

*/


Select *
From NashvilleHousing
--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format
select SaleDate,CONVERT(date,SaleDate)
from PortfolioProject.dbo.NashVilleHousing

update NashVilleHousing
set SaleDate=CONVERT(date,SaleDate)

select SaleDate
from NashVilleHousing

alter table NashVilleHousing
add SaleDate2 date

update NashVilleHousing
set SaleDate2=CONVERT(date,SaleDate)

select SaleDate,SaleDate2
from NashVilleHousing

 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

select a.[UniqueID ],a.PropertyAddress ,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashVilleHousing a
join NashVilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]!= b.[UniqueID ]
where a.PropertyAddress is null
order by [UniqueID ]

update a
set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashVilleHousing a
join NashVilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]!= b.[UniqueID ]
where a.PropertyAddress is null

select * 
from NashVilleHousing
order by ParcelID



--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


select PropertyAddress,SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as PropertySplitAddress,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as PropertySplitCity
from NashVilleHousing

alter table NashVilleHousing
add PropertySplitAddress varchar(250),PropertySplitCity varchar(250)

update NashVilleHousing
set PropertySplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1),
PropertySplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))



select PropertyAddress,PropertySplitAddress,PropertySplitCity
from NashVilleHousing









--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


update NashVilleHousing
set SoldAsVacant=
case 
when  SoldAsVacant='y' then 'yes'
when SoldAsVacant='n' then 'no'
else SoldAsVacant
end

select *
from NashVilleHousing
where SoldAsVacant='y' or SoldAsVacant='n'









-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

with cteRowNumb as (
select a.[UniqueID ] as au,a.PropertyAddress as apa 
,a.SalePrice as asp ,a.SaleDate as asd ,a.LegalReference as alr,
ROW_NUMBER() over (partition by a.PropertyAddress order by a.[UniqueID ])as rownumb
from NashVilleHousing a
join NashVilleHousing b
on a.ParcelID=b.ParcelID
and a.PropertyAddress=b.PropertyAddress
and a.SalePrice=b.SalePrice
and a.SaleDate=b.SaleDate
and a.LegalReference=b.LegalReference
and a.[UniqueID ]!= b.[UniqueID ]
--order by [UniqueID ]
)

select * 
from cteRowNumb
Order by apa
--*****************

--**************
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
Select count(*)
From RowNumCTE
Where row_num > 1
Order by PropertyAddress
---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


select * from 
NashVilleHousing

alter table NashVilleHousing
drop column PropertyAddress,SaleDate
















-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------




