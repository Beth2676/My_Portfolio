
USE Betiel_G

SELECT* FROM[dbo].[layoffs]

/*DATA CLEANING*/

  /*Created a staging table to minimize impact on source system */
SELECT* 
INTO layoffs_staging
FROM layoffs

SELECT* 
FROM  layoffs_staging

/*REMOVE DUPLICATES*/

WITH DuplicateCTE AS 
(
    SELECT*,
	    ROW_NUMBER() OVER(PARTITION BY company,[location], industry, total_laid_off,percentage_laid_off,[date],stage,country,funds_raised_millions
	ORDER BY company) as row_number
	FROM layoffs_staging
)
DELETE FROM DuplicateCTE
WHERE row_number >1

SELECT*FROM layoffs_staging

/*STANDARDIZING DATA*/

SELECT company,TRIM (company)  
FROM  layoffs_staging

UPDATE layoffs_staging
SET company = TRIM(company)

SELECT DISTINCT industry    
FROM  layoffs_staging
ORDER BY 1


SELECT *
FROM layoffs_staging
WHERE industry like 'crypto%'

UPDATE layoffs_staging
SET INDUSTRY= 'crypto'
WHERE industry LIKE 'crypto%'



SELECT DISTINCT [location]   
FROM layoffs_staging
ORDER BY  1

SELECT * FROM layoffs_staging


SELECT DISTINCT country     
FROM layoffs_staging
ORDER BY  1


SELECT DISTINCT
    country,
    CASE
        WHEN country LIKE '%.'
        THEN LEFT(country, LEN(country) - 1)   
        ELSE country
    END AS cleaned_country
FROM layoffs_staging
ORDER BY 1


UPDATE layoffs_staging
SET country= 'United States'
WHERE country LIKE 'United States.%'


SELECT DISTINCT country 
FROM layoffs_staging


ALTER TABLE layoffs_staging     
ADD date_clean DATEof

UPDATE layoffs_staging
SET date_clean = try_convert(Date,date,101);  

SELECT *
FROM layoffs_staging

/* 4.REMOVE UNNECESSARY COLUMN*/

ALTER TABLE layoffs_staging     
DROP COLUMN date;

SELECT *
FROM layoffs_staging

EXEC sp_rename'layoffs_staging.date_clean', 'date', 'COLUMN'     
SELECT *
FROM layoffs_staging


/*3.NULL VALUES OR BLANCK VALUES*/
SELECT *
FROM layoffs_staging
WHERE total_laid_off IS NULL

/*Since sql treates all the imported csv file as tet data type the above query will give us zero null value.so lets convert the data type first.*/

SELECT *
FROM layoffs_staging
WHERE total_laid_off =' NULL' or total_laid_off=''


UPDATE layoffs_staging
SET total_laid_off = NULL
WHERE total_laid_off ='NULL' or total_laid_off=''


SELECT *
FROM layoffs_staging
WHERE total_laid_off IS NULL

ALTER TABLE layoffs_staging       
ALTER COLUMN total_laid_off INT



SELECT*
FROM layoffs_staging                                     
WHERE percentage_laid_off ='NULL'or percentage_laid_off=''


UPDATE layoffs_staging                   
SET percentage_laid_off  = NULL
WHERE percentage_laid_off  ='NULL' or percentage_laid_off =''

SELECT *
FROM layoffs_staging                  
WHERE percentage_laid_off IS NULL


ALTER TABLE layoffs_staging      
ALTER COLUMN percentage_laid_off DECIMAL(5, 4)  


SELECT *
FROM layoffs_staging
WHERE funds_raised_millions IS NULL



UPDATE layoffs_staging                   
SET funds_raised_millions  = NULL
WHERE funds_raised_millions ='NULL' or funds_raised_millions ='' 


ALTER TABLE layoffs_staging      
ALTER COLUMN funds_raised_millions NUMERIC(10, 2)


SELECt *
FROM layoffs_staging
WHERE industry = 'NULL'OR industry=''


SELECt *
FROM layoffs_staging
WHERE company ='Airbnb'


SELECt*                      
FROM layoffs_staging L1
JOIN layoffs_staging L2
ON L1.company = L2.company
AND L1.[location] = L2.[location]
WHERE L1.industry IS NULL OR L1.industry =''
AND L2.industry IS NOT NULL 


UPDATE  L1
SET L1.industry = L2.industry
FROM layoffs_staging L1
JOIN layoffs_staging L2
ON L1.company =L2.company
AND L1.location =L2.location
WHERE  L1.industry IS NULL OR L1.industry =''
AND L2.industry IS NOT NULL 
AND L2.industry  <> ''

SELECt *
FROM layoffs_staging

SELECt *                            
FROM layoffs_staging
WHERE total_laid_off IS NULL and
percentage_laid_off IS NULL


DELETE 
FROM layoffs_staging
WHERE total_laid_off is NULL and
percentage_laid_off IS NULL


SELECt *
FROM layoffs_staging




