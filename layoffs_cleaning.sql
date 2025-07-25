-- REMOVE DUPICATE
-- USING THIS WE ARE GOING TO ASSIGN A UNIQUE row_id TO EVERY ROW 
/*SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions ) AS row_id
FROM layoff_staging;
*/
-- WITHclause or we can say CTE is like a temporary table in
-- which we store result of the query return inside () and then we perform operations on this query

WITH duplicate_cte AS (
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions ) AS row_id
FROM layoff_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_id > 1;


-- now we can't remove from the with cluse because it is not updatable to best way 
-- is that we can create  a another tabole lets say layoff_staging2 and in which  we store day
--  along with the  row_id column nd we can prform delte operation fromn there

-- first step
-- right click on the layoff_staging a
-- then copy to clipboard then create statement
-- then paste you can see it just below
-- create table layoff_staging2
CREATE TABLE `layoff_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_id` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- insert data in table layoff_staging2 using table layoff_staging

INSERT INTO layoff_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,
percentage_laid_off,'date',stage,country,funds_raised_millions ) AS row_id
FROM layoff_staging;

-- highlight that row which have roe_id greater than 1 means they are repeated i.e. duplicate



-- delete duplicate  from the layoff_staging2 table



-- ERROR because wee are using safe update mode and trying to update a table so for treating 
-- this we first have to diable safe update mode we can  disable it using
SET SQL_SAFE_UPDATES = 0;

-- now try again to delete
DELETE 
FROM layoff_staging2
WHERE row_id>1;
-- deleted successfully

SELECT * 
FROM layoff_staging2;
-- now we have our unique data in layoff_staging2 table
-- now we dont't need row_id anymore so we can remove it
ALTER TABLE layoff_staging2
DROP COLUMN row_id;
-- this will remove column row_id


-- Standardizing data

-- this will remove all the whit space fro both the ends in the column company
UPDATE layoff_staging2
SET company=TRIM(company);

-- BY USING DISTINCT KEYWORD WE CAN SEE UNIQUE COMPANIES 
SELECT DISTINCT company
FROM layoff_staging2;

-- UPDATE will remove all the whit space fro both the ends in the industry company

SELECT DISTINCT industry
FROM layoff_staging2;


UPDATE layoff_staging2
SET industry=TRIM(industry);



-- this will update all industry which is statred from crypto to crypto

UPDATE layoff_staging2
SET industry ='Crypto'
WHERE industry LIKE 'Crypto%';


SELECT DISTINCT location
FROM layoff_staging2
ORDER BY 1; -- 1 IS FOR ASC ORDER
-- EVERYTHING IS ALL RIGHT IN THE LOCATION COLUMN SO NO NEED TO DO ANYTHING

SELECT DISTINCT country
FROM layoff_staging2
ORDER BY 1;

UPDATE layoff_staging2
SET country ='United States'
WHERE country LIKE 'United States%';
-- country column is now correctd.

-- update date from string to date type we can use str_to_date ('coulmn_name','%m/%d/%Y)

UPDATE layoff_staging2
SET `date`=STR_TO_DATE(`date`,'%m/%d/%Y');

SELECT `date`
FROM layoff_staging2;

-- change date datatype from text to date type
ALTER TABLE layoff_staging2
MODIFY COLUMN `date` date;

-- treat NULL and BLANK values
SELECT * 
FROM layoff_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL; 

-- select that rows in which we have value of 
-- industry column as null or blank so that we can review them
SELECT *
FROM layoff_staging2
WHERE industry IS NULL
OR industry ='';


SELECT * 
FROM layoff_staging2
WHERE company= 'Airbnb';

-- we are going to use self join  to populate them 
SELECT t1.industry,t2.industry
FROM layoff_staging2 t1
JOIN layoff_staging2 t2
ON t1.company=t2.company
AND t1.location =t2.location
AND t1.country= t2.country
WHERE t1.industry IS NULL or t1.industry=''
AND t2.industry IS NOT NULL;

-- first update all blank values of industry to null only then we can join them or 
-- populate them populate means if two companies 
-- have same name and same location but industry is null or 
-- blank in one of them then we can assign the value of the one's industry to another one
UPDATE layoff_staging2
SET industry = NULL
WHERE industry= '';  -- by using this we can update all blank values to null now we can populate it

-- to update the value of industry

UPDATE layoff_staging2 t1
JOIN layoff_staging2 t2
ON t1.company=t2.company
SET t1.industry=t2.industry  -- now by using this we successfully populated the value of the industry column
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

SELECT * 
FROM layoff_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL; 
-- if you accidently close your workbench so we have to again disable safe updates using
SET SQL_SAFE_UPDATES = 0; -- now we can delete data

-- this will deleteall therows where total_laid_off and percentage_laid_off both have null values
DELETE 
FROM layoff_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL; 



-- we do not populate total_laid_off and percentage_laid_off 
-- because we don'rt have any perimeter on the basis we are going to populate them
-- so here is our final cleaned data which we have in our layoff_staging2 table
-- thank you for the project.

SELECT * 
FROM layoff_staging2;


