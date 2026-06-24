

USE Betiel_G

/*EXPLORATORY DATA ANALYSIS*/

SELECT* FROM layoffs_staging


SELECT MAX(total_laid_off) AS Max_laidoff,MAX(percentage_laid_off)AS Max_percentage_laidoff
FROM   layoffs_staging

SELECT* 
FROM layoffs_staging
WHERE percentage_laid_off=1
ORDER BY funds_raised_millions DESC


SELECT company,SUM(total_laid_off)AS um_of_TotalLaidOff
FROM layoffs_staging
GROUP BY company 
ORDER BY 2 DESC


SELECT MIN([date])AS Min_date,
MAX([date]) AS Main_date
FROM layoffs_staging


SELECT company,YEAR([date])AS [Year],SUM(total_laid_off)AS sum_of_TotalLaidOff
FROM layoffs_staging
GROUP BY company,YEAR([date])
ORDER BY company ASC


SELECT industry, SUM(total_laid_off)AS sum_of_total_laid_off
FROM layoffs_staging
GROUP BY industry


SELECT country, sum(total_laid_off)AS Sum_of_laid_Off
FROM layoffs_staging
GROUP BY country 
ORDER BY 2 DESC

SELECT YEAR([date])AS [Year],SUM(total_laid_off)AS sum_of_TotalLaidOff
FROM layoffs_staging
GROUP BY YEAR([date])
ORDER BY 1 DESC

SELECT *
FROM layoffs_staging


SELECT month([date])As [month],sum(total_laid_off)AS sum_of_TotalLaidOff
FROM layoffs_staging
GROUP BY month([date])
ORDER BY 1 ASC


SELECT company,year([date])as [year],sum(total_laid_off)AS Sum_of_TotalLaidOff
FROM layoffs_staging
GROUP BY company,year([date]) 
ORDER BY 2 ASC


SELECT company,year([date])AS [year],SUM(total_laid_off)AS sum_of_TotalLaidOff  
FROM layoffs_staging
group by company,year([date]) 
ORDER BY 3 DESC


WITH company_year (company,[year],total_laid_off)AS     
(
SELECT company,year([date])as [year],SUM(total_laid_off)as sum_of_TotalLaidOff
FROM layoffs_staging
GROUP BY company,year([date]) 
),company_year_Rank AS
(SELECT*,DENSE_RANK() OVER(PARTITION BY year ORDER BY total_laid_off DESC)AS Ranking
FROM company_year 
WHERE year is not Null)
SELECT* 
FROM company_year_Rank
WHERE  Ranking <=5

