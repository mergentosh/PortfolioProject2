SELECT*
FROM PortfolioProject..nashville

SELECT saledate ,CONVERT(date,saledate) as SalssseDate
FROM PortfolioProject.DBO.nashville

UPDATE PortfolioProject.DBO.nashville      --It doesn't work right now 
SET SaleDate = CONVERT(date,saledate) 

--Trying something new 

ALTER TABLE PortfolioProject.DBO.nashville 
ADD SaleDateConverted date ; 

UPDATE PortfolioProject.DBO.nashville     
SET SaleDateConverted = CONVERT(date,saledate) 

--Filling null values and populating

SELECT n.parcelID,n.propertyaddress,nnull.ParcelID,nnull.propertyaddress,ISNULL(nnull.propertyaddress,n.propertyaddress)
FROM PortfolioProject.dbo.nashville n, (SELECT *
FROM PortfolioProject.DBO.nashville
WHERE PropertyAddress is null 
 ) nnull
WHERE n.parcelID = nnull.ParcelID 
AND n.[UniqueID ] != nnull.[UniqueID ]
ORDER BY n.parcelID 

UPDATE nnull
SET propertyaddress = ISNULL(nnull.propertyaddress,n.propertyaddress)
FROM PortfolioProject.dbo.nashville n, (SELECT *
FROM PortfolioProject.DBO.nashville
WHERE PropertyAddress is null 
 ) nnull
WHERE n.parcelID = nnull.ParcelID 
AND n.[UniqueID ] != nnull.[UniqueID ]

-----------------------------------------------------------------------------

--Breaking out Address into Individual Columns (Address,City,State) 


SELECT PropertyAddress, SUBSTRING(PROPERTYADDRESS,1,CHARINDEX(',',PROPERTYADDRESS  ) -1 ) AS Address,
 SUBSTRING(PROPERTYADDRESS,CHARINDEX(',',PROPERTYADDRESS  ) +1,50 ) AS City 
FROM PortfolioProject..nashville



SELECT owneraddress,
PARSENAME(REPLACE(owneraddress, ',' , '.' ),3) as Address,
PARSENAME(REPLACE(owneraddress, ',' , '.' ),2) as City,
PARSENAME(REPLACE(owneraddress, ',' , '.' ),1) as State
FROM PortfolioProject.dbo.nashville

ALTER TABLE PortfolioProject.dbo.nashville
ADD OwnerSplitAddress nvarchar(255) ; 

UPDATE PortfolioProject.dbo.nashville
SET OwnerSplitAddress = PARSENAME(REPLACE(owneraddress, ',' , '.' ),3)


ALTER TABLE PortfolioProject.dbo.nashville
ADD OwnerSplitCity nvarchar(255) ; 

UPDATE PortfolioProject.dbo.nashville
SET OwnerSplitCity = PARSENAME(REPLACE(owneraddress, ',' , '.' ),2)


ALTER TABLE PortfolioProject.dbo.nashville
ADD OwnerSplitState nvarchar(255) ; 

UPDATE PortfolioProject.dbo.nashville
SET OwnerSplitState = PARSENAME(REPLACE(owneraddress, ',' , '.' ),1)


--Change 'Y' with 'Yes' and 'N' with 'No' in SoldAsVacant

SELECT distinct(soldasvacant) ,count(*)
FROM PortfolioProject.dbo.nashville
GROUP BY SoldAsVacant
ORDER BY COUNT(*)  


SELECT 
CASE 
WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END 
FROM PortfolioProject.dbo.nashville

UPDATE PortfolioProject.dbo.nashville
SET SoldAsVacant = CASE 
WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END 

---------------------------------------------------------------------------------------------------

--REMOVE DUPLICATES 

DELETE FROM b
FROM (SELECT a.row_num
FROM ( SELECT *,ROW_NUMBER() OVER(PARTITION BY PARCELID,LANDUSE,PROPERTYADDRESS,SALEDATE,SalePrice,LEGALREFERENCE,OWNERADDRESS
ORDER BY PARCELID,LANDUSE,PROPERTYADDRESS,SALEDATE,SALEPRÝCE,LEGALREFERENCE,OWNERADDRESS) row_num
FROM PortfolioProject.dbo.nashville ) a
WHERE a.row_num > 1 ) b

-- Validating Results 

SELECT a.row_num
FROM ( SELECT *,ROW_NUMBER() OVER(PARTITION BY PARCELID,LANDUSE,PROPERTYADDRESS,SALEDATE,SalePrice,LEGALREFERENCE,OWNERADDRESS
ORDER BY PARCELID,LANDUSE,PROPERTYADDRESS,SALEDATE,SALEPRÝCE,LEGALREFERENCE,OWNERADDRESS) row_num
FROM PortfolioProject.dbo.nashville ) a
WHERE a.row_num > 1 

--Dropping Unused Columns 

ALTER TABLE PortfolioProject.dbo.nashville
DROP COLUMN owneraddress,taxdistrict 
