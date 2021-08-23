SELECT PropertyAddress
FROM PortfolioProject..Nashville

--Standardize Date Format 

UPDATE Nashville
SET SaleDate = CONVERT(DATE,SaleDate) 

ALTER TABLE nashville 
ADD SaleDateConverted date;

UPDATE Nashville
SET SaleDateConverted = CONVERT(date,SaleDate)

--Populate Property Address Data

SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress) 
FROM PortfolioProject..Nashville a
JOIN PortfolioProject..Nashville b
   ON a.ParcelID=b.ParcelID
   AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null



UPDATE a
SET PropertyAddress = ISNULL(a.propertyaddress,b.propertyaddress)
FROM PortfolioProject..Nashville a
JOIN PortfolioProject..Nashville b
   ON a.ParcelID=b.ParcelID
   AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null



--Breaking Out Address Into Individual Columns (Address,City,State) 

SELECT PropertyAddress, SUBSTRING(propertyaddress,1,CHARINDEX(',', propertyaddress)-1) as Address,
SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1 , 50) as City,
SUBSTRING
FROM PortfolioProject..Nashville

ALTER TABLE nashville 
ADD PropertySplitAddress nvarchar(255);

UPDATE Nashville
SET PropertySplitAddress = SUBSTRING(propertyaddress,1,CHARINDEX(',', propertyaddress)-1) 


ALTER TABLE nashville 
ADD PropertySplitCity nvarchar(255);

UPDATE Nashville
SET PropertySplitCity = SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1 , 50)

SELECT*
FROM PortfolioProject..Nashville


------------------------------------------

SELECT OwnerAddress
FROM PortfolioProject..Nashville

SELECT owneraddress,
PARSENAME(REPLACE(owneraddress, ',', '.'),3),
PARSENAME(REPLACE(owneraddress, ',', '.'),2),
PARSENAME(REPLACE(owneraddress, ',', '.'),1)

FROM PortfolioProject..Nashville


ALTER TABLE nashville 
ADD OwnerSplitAddress nvarchar(255);

UPDATE Nashville
SET OwnerSplitAddress = PARSENAME(REPLACE(owneraddress, ',', '.'),3)

ALTER TABLE nashville 
ADD OwnerSplitCity nvarchar(255);

UPDATE Nashville
SET OwnerSplitCity = PARSENAME(REPLACE(owneraddress, ',', '.'),2)


ALTER TABLE nashville 
ADD OwnerSplitState nvarchar(255);

UPDATE Nashville
SET OwnerSplitState = PARSENAME(REPLACE(owneraddress, ',', '.'),1)


SELECT *
FROM PortfolioProject..Nashville


------------------------------------------------------

SELECT 
CASE
WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END 
FROM PortfolioProject..Nashville


UPDATE Nashville
SET SoldAsVacant = CASE
WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END 



SELECT  distinct(SoldAsVacant),count(*)
FROM PortfolioProject..Nashville
group by SoldAsVacant


--Remove Duplicates 
WITH duplicates as 
(
SELECT*,
ROW_NUMBER() OVER( 
PARTITION BY n.parcelýd,n.propertyaddress,n.saleprice,n.saledate,n.legalreference order by n.uniqueýd ) row_num
FROM PortfolioProject..Nashville n

)
select*
FROM duplicates
WHERE row_num > 1 


--Unused Columns 

SELECT *
FROM PortfolioProject..Nashville

ALTER TABLE PortfolioProject..Nashville
DROP COLUMN Owneraddress,taxdistrict,propertyaddress


ALTER TABLE PortfolioProject..Nashville
DROP COLUMN Saledate









SELECT uniqueID,parcelýd,landuse,ROW_NUMBER() OVER (PARTITION BY parcelýd,landuse order by uniqueID  ) as ROW_NUMBER
FROM PortfolioProject..Nashville


SELECT *
FROM PortfolioProject..Nashville

ALTER TABLE PortfolioProject..Nashville
ALTER COLUMN parcelýd  PARCELID

EXEC sp_rename 'PortfolioProject.Nashville.ParcelID', 'PARCELID', 'COLUMN';

ALTER TABLE PortfolioProject..Nashville
RENAME COLUMN OldColumnName TO NewColumnName;

exec sp_rename PortfolioProject.dbo.Nashville.ParcelID,PARCELID,Column;




EXEC sp_rename '[PortfolioProject..Nashville.ParcelID]', 'PARCELID','COLUMN';  


EXEC sp_rename 