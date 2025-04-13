-- https://www.kaggle.com/datasets/serpilturanyksel/adult-income/code
-- "Adult Income Dataset", which is based on the 1994 U.S. Census data (Current Population Survey - CPS)

/*
1. renaming columns
2. remove duplicates (if any)
3.standardize data and fix errors
4. identify if null values are to remain null, or deleted
5. rows to remove 
*/


select *
from adult11
;

-- First I will create a staging table. 
-- This is the one I will use to clean the data.

create table adultincome.adult11_staging
like adultincome.adult11;

insert into adult11_staging
select * from adult11;

select * from adult11_staging;

-- 1. renaming columns
-- I will proceed by changing the names of some of the columns
-- This is for simplicity when writing queries.

alter table adult11_staging
rename column `education-num` to education_num;

alter table adult11_staging
rename column `marital-status` to maritalstatus;

alter table adult11_staging
rename column `capital-gain` to capgain;

alter table adult11_staging
rename column `capital-loss` to caploss;

alter table adult11_staging
rename column `hours-per-week` to hpw;

alter table adult11_staging
rename column `native-country` to natcountry;

select *
from adult11_staging;

-- 2. removing duplicates

SELECT *,
		ROW_NUMBER() OVER (
			PARTITION BY age, 
            workclass, 
            fnlwgt, 
            education, 
            education_num, 
            maritalstatus, 
            occupation, 
            relationship, 
            race, 
            capgain, 
            caploss, 
            hpw, 
            natcountry, 
            salary) AS row_num
	FROM 
		adult11_staging;
        
with duplicate_cte as 
(
	SELECT 
    age, 
            workclass, 
            fnlwgt, 
            education, 
            education_num, 
            maritalstatus, 
            occupation, 
            relationship, 
            race, 
            capgain, 
            caploss, 
            hpw, 
            natcountry, 
            salary,
		ROW_NUMBER() OVER (
			PARTITION BY age, 
            workclass, 
            fnlwgt, 
            education, 
            education_num, 
            maritalstatus, 
            occupation, 
            relationship, 
            race, 
            capgain, 
            caploss, 
            hpw, 
            natcountry, 
            salary) AS row_num
	FROM 
		adult11_staging)
 
 select count(*)
 from duplicate_cte
        where row_num > 1
        order by row_num desc;
        
-- this code tells me the amount of time rows are duplicated
-- preferrably we would like a 1 everywhere to keep unique data
-- i have decided to partition over the rows above because if they are all identical, there is a problem
-- although the chances of people to have the exact same entries for every fireld is possible, it is highly unlikely

select *
from adult11_staging
where fnlwgt= 243368;
-- i have decided to look at this specific example to see how the data can be identical


drop table if exists `adult11_staging2`;
CREATE TABLE `adult11_staging2` (
  `age` int DEFAULT NULL,
  `workclass` text,
  `fnlwgt` int DEFAULT NULL,
  `education` text,
  `education_num` int DEFAULT NULL,
  `maritalstatus` text,
  `occupation` text,
  `relationship` text,
  `race` text,
  `gender` text,
  `capgain` int DEFAULT NULL,
  `caploss` int DEFAULT NULL,
  `hpw` int DEFAULT NULL,
  `natcountry` text,
  `salary` text,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select *
from adult11_staging2;

insert into adult11_staging2
SELECT *,
		ROW_NUMBER() OVER (
			PARTITION BY age, 
            workclass, 
            fnlwgt, 
            education, 
            education_num, 
            maritalstatus, 
            occupation, 
            relationship, 
            race, 
            capgain, 
            caploss, 
            hpw, 
            natcountry, 
            salary) AS row_num
	FROM 
		adult11_staging;
        
select *
        from adult11_staging2
        where row_num>1;
        
delete from adult11_staging2
where row_num>1;


select *
from adult11_staging2;


-- 3. Standardizing Data

select count(*)
from adult11_staging2
where workclass = '?';

select count(*)
from adult11_staging2
where occupation = '?' or workclass = '?';

-- I will set the '?' to NULL since it is easier to work with

update adult11_staging2
set workclass = NULL 
where occupation = '?' or workclass = '?';

update adult11_staging2
set occupation = NULL 
where occupation = '?' or workclass = '?';

select distinct natcountry
from adult11_staging2
order by natcountry
;

update adult11_staging2
set natcountry = NULL 
where natcountry= '?';

select salary, count(salary), count(*)*100/(select count(*) from adult11_staging2) as percentage
from adult11_staging2
group by salary
;




-- 4. Null values will remain as they could be important for EDA
/* 5. rows to remove 
i will remove the row_num column as they are all 1 as there are no duplicates
*/

select *
from adult11_staging2;

alter table adult11_staging2
drop row_num;

-- the data is now clean and ready for analysis