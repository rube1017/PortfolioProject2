/*
Select *
From PortfolioProject.dbo.NashvilleHousing

*/

-- Standardize Date Format


select [SaleDate]
from[dbo].[nashvillehousing]

ALTER TABLE [nashvillehousing]
ADD Saledateconverted Date

Update [nashvillehousing]
set Saledateconverted = CONVERT(Date,[SaleDate])

ALTER TABLE [nashvillehousing]
drop column [SaleDate]

select Saledateconverted
from[dbo].[nashvillehousing]


-- Using Self Join to Populate Null Values in Address(same [ParcelID] have same [PropertyAddress] )


select PropertyAddress
from[dbo].[nashvillehousing]

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress
from[dbo].[nashvillehousing] a
join [dbo].[nashvillehousing] b
on a.ParcelID=b.ParcelID 
and a.[UniqueID ]!=b.[UniqueID ]
where a.PropertyAddress is null

--The above query rechecks if all values corresponding to the null value is present

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
from[dbo].[nashvillehousing] a
join [dbo].[nashvillehousing] b
on a.ParcelID=b.ParcelID 
and a.[UniqueID ]!=b.[UniqueID ]
where a.PropertyAddress is null


update a
set a.PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from[dbo].[nashvillehousing] a
join [dbo].[nashvillehousing] b
on a.ParcelID=b.ParcelID 
and a.[UniqueID ]!=b.[UniqueID ]
where a.PropertyAddress is null


-- Dividing the [PropertyAddress] into 2 columns using ',' as the delimiter


select PropertyAddress
from[dbo].[nashvillehousing]


select SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)) as Addresss,
       SUBSTRING (PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress)) as Addresss
	   
from[dbo].[nashvillehousing]

ALTER TABLE [nashvillehousing]
ADD PropertysplitAddress nvarchar(255)


ALTER TABLE [nashvillehousing]
ADD PropertysplitCity nvarchar(255)


Update [nashvillehousing]
set PropertysplitAddress =SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress))


Update [nashvillehousing]
set PropertysplitCity =SUBSTRING (PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))

select * from [nashvillehousing]


ALTER TABLE [nashvillehousing]
drop column PropertyAddress


-- Updating the [OwnerAddress] using Parsename 


select PARSENAME(REPLACE([OwnerAddress],',','.'),3),
	   PARSENAME(REPLACE([OwnerAddress],',','.'),2),
	   PARSENAME(REPLACE([OwnerAddress],',','.'),1)
from [nashvillehousing]


ALTER TABLE [nashvillehousing]
ADD OwnersplitAddress nvarchar(255)


ALTER TABLE [nashvillehousing]
ADD OwnersplitCity nvarchar(255)


ALTER TABLE [nashvillehousing]
ADD OwnersplitState nvarchar(255)


Update [nashvillehousing]
set OwnersplitAddress =PARSENAME(REPLACE([OwnerAddress],',','.'),3)


Update [nashvillehousing]
set OwnersplitCity =PARSENAME(REPLACE([OwnerAddress],',','.'),2)

Update [nashvillehousing]
set OwnersplitState =PARSENAME(REPLACE([OwnerAddress],',','.'),1)

select * from [nashvillehousing]


ALTER TABLE [nashvillehousing]
drop column [OwnerAddress]


-- Using Case Statement to covert data in column ([SoldAsVacant] into 'yes' or 'no')

select distinct(SoldAsVacant),COUNT(SoldAsVacant)
from [nashvillehousing]
group by SoldAsVacant
order by 2

-- Above Query is to check how many distinct data is present and check their count

select SoldAsVacant,
case when SoldAsVacant = 'y' then 'Yes'
     when SoldAsVacant = 'n' then 'No'
	 else SoldAsVacant
	 end
from [nashvillehousing]

update [nashvillehousing]
set SoldAsVacant = case when SoldAsVacant = 'y' then 'Yes'
     when SoldAsVacant = 'n' then 'No'
	 else SoldAsVacant
	 end