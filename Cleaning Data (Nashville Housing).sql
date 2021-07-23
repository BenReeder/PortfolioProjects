--Cleaning Nashville Housing Data

Select * 
From [Portfolio Project].dbo.NashvilleHousing

--Date Formating

Select SaleDateConverted, Convert(Date,SaleDate)
from [Portfolio Project].dbo.NashvilleHousing

ALTER TABLE [Portfolio Project].dbo.NashvilleHousing
Add SaleDateConverted Date;

Update [Portfolio Project].dbo.NashvilleHousing 
Set SaleDateConverted = Convert(Date,SaleDate)

--Working With Property Address Data

Select *
from [Portfolio Project].dbo.NashvilleHousing
order by ParcelID

--Shows and fills in repeated ParcelID's that didn't have both Property Address columns intially filled in

Select a.ParcelID, a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Portfolio Project].dbo.NashvilleHousing a 
join [Portfolio Project].dbo.NashvilleHousing b 
	on a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portfolio Project].dbo.NashvilleHousing a 
join [Portfolio Project].dbo.NashvilleHousing b 
	on a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--Putting Address into Individual Columns

Select PropertyAddress
From [Portfolio Project].dbo.NashvilleHousing

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) Address

From [Portfolio Project].dbo.NashvilleHousing

ALTER TABLE [Portfolio Project].dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(55)

ALTER TABLE [Portfolio Project].dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(55)


Update [Portfolio Project].dbo.NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1)


Update [Portfolio Project].dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))


Select *
From [Portfolio Project].dbo.NashvilleHousing

--Same for Owner Address but using PARSENAME instead

Select 
PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
From [Portfolio Project].dbo.NashvilleHousing


ALTER TABLE [Portfolio Project].dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(55)

ALTER TABLE [Portfolio Project].dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(55)

ALTER TABLE [Portfolio Project].dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(55)


Update [Portfolio Project].dbo.NashvilleHousing
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),3)

Update [Portfolio Project].dbo.NashvilleHousing
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2)

Update [Portfolio Project].dbo.NashvilleHousing
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'),1)

Select * 
From [Portfolio Project].dbo.NashvilleHousing

--In 'Sold As Vacant' change Y and N to Yes and No

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From [Portfolio Project].dbo.NashvilleHousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant 
, Case When SoldAsVacant = 'Y' THEN 'YES'
       When SoldAsVacant = 'N' Then 'NO'
	   Else SoldAsVacant
	   End
from [Portfolio Project].dbo.NashvilleHousing

Update [Portfolio Project].dbo.NashvilleHousing
Set SoldAsVacant = Case When SoldAsVacant = 'Y' THEN 'YES'
       When SoldAsVacant = 'N' Then 'NO'
	   Else SoldAsVacant
	   End


--Remove Duplicates by Creating CTE and Aggregating 


WITH ROWNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID, 
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by 
					UniqueID
					) row_num

From [Portfolio Project].dbo.NashvilleHousing
)
Delete 
from RowNumCTE
Where row_num > 1 

--Delete Columns that are now unused

Select *
From [Portfolio Project].dbo.NashvilleHousing

ALTER TABLE [Portfolio Project].dbo.NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

