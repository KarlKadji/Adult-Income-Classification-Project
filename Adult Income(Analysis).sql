-- https://www.kaggle.com/datasets/serpilturanyksel/adult-income/code
-- "Adult Income Dataset", which is based on the 1994 U.S. Census data (Current Population Survey - CPS)

-- In this file I will be doing some data analysis to answer some questions acout the 1994 US Census


-- 1. What is the average age for each highest education level?

select *
from adult11_staging2;

select education_num, education, avg(age) 
from adult11_staging2
group by education_num, education
order by education_num;

/* the highest average age belongs to those who achieved the highest education level of 7th-8th grade
The lowest average age belongs to those who achieved the highest education level of 11th grade
The societal minimum standard of  HS grad has an average age of 39 years old
similarly bachelors have an average age of 39 years old (rounded up)
*/

-- 2. How many people have each level of education?

select  education, count(*), count(*)*100/(select count(*) from adult11_staging2) as percentage
from adult11_staging2
group by education_num, education
order by education_num;


/* According to the results, the most amount of people are high shcool graduates, sitting at 32% of survey entries
meanwhile, 0.16%, the lowest, have the highest education level of what is considered preschool in america
The majority of people have at least graduated high school
surprisingly, a higher percentage of people have finished 11th grade (3.7139) compared to 12th grade (1.3425)
12th grade has the lowest percentage out of all high school years
Overall we can deduce that most participants have post-secondary education
*/

-- 3. What is the most common education level among people earning >50K?

select education, count(*), count(*)*100/(select count(*) from adult11_staging2) as percentage
from adult11_staging2
where salary = '>50K'
group by education_num, education
order by education_num;

/* The highest percentage of people earning more than 50K have a bachelors degree (6.79%), 
followed by a high school degree (5.12%), and followed by some college degree (4.22%)
Keeping in mind that we do not have the exact salary of each participant thus making this greater than 50K a wide range
It is a salary that can be obtained with entry-level jobs
*/

-- 4. What is the average hours-per-week worked by each workclass?

select workclass, avg(hpw)
from adult11_staging2
group by workclass;

/* The highest average of hours per week is done by the self employed incorporated 
meanwhile the participants without pay on average work the lowest amount of hours non-including the null workclass
*/

-- 5. Which workclass has the highest percentage of people earning >50K?

select workclass, count(*), count(*)*100/(select count(*) from adult11_staging2) as percentage
from adult11_staging2
where salary = '>50K'
group by workclass;

/* The highest percentage of people earning over 50k work in the private industry at 15%. 
This is by far the highest as the second highest are self-employed not incorporated at 2.2%
*/

-- 6. Do men or women work more hours per week on average?

select gender, avg(hpw), count(*)
from adult11_staging2
group by gender;

/* On average, men work more hours per week, however, it is important to note that there are about twice as many male participants
in the census.
*/

-- 7. What is the average income for each race?

select race, 
count(*), 
COUNT(CASE WHEN salary = '>50K' THEN 1 END) * 100.0 / COUNT(*) AS percent_high_income, 
COUNT(CASE WHEN salary = '<=50K' THEN 1 END) * 100.0 / COUNT(*) AS percent_low_income
from adult11_staging2
group by race;

/* Based off the data given, I cannot calculate the average income for each race, however, I can calculate the percentage of peopl
who are over and under 50k. The results show that 75% of white people are under 50K, 87% of black people are under 50k.
The asian-pacific islanders are the top earning race with about 27% of them above 50K.*/

-- 8. What percentage of men vs. women earn >50K?
select gender, count(*), COUNT(CASE WHEN salary = '>50K' THEN 1 END) * 100.0 / COUNT(*) AS percent_high_income, 
COUNT(CASE WHEN salary = '<=50K' THEN 1 END) * 100.0 / COUNT(*) AS percent_low_income
from adult11_staging2
group by gender
; 

/* The results show that 30% of men earn over 50K, meanwhile about 11% of women earn over 50K
*/

-- 9. What is the average capital gain and loss for people earning >50K vs. <=50K?

select salary,avg(capgain), avg(caploss)
from adult11_staging2
group by salary;

/* The people earning less than 50K had an average capital gain of $147 USD and a capital loss of $54.
The people earning more than 50K had an average capital gain of $4044 USD and a capital loss of about $194 USD*/

-- 10. What is the highest capital gain recorded in the dataset, and who earned it?

select count(*)
from adult11_staging2
where capgain = 99999 and salary = '>50K'
order by capgain desc
;

/* The highest capital gain recorded is $99,999 USD, however, 244 people are recorded to have earned so in that year. 
One thing to note is that they are all earning over 50K.
I am not confident that this information is accurate, I believe some of them have earned more but the maximum number
was 99,999.*/

-- 11. Which native-country has the highest percentage of people earning >50K?

select natcountry, COUNT(CASE WHEN salary = '>50K' THEN 1 END) * 100.0 / COUNT(*) AS percent_high_income
from adult11_staging2
group by natcountry
order by percent_high_income desc;

/* The results indicate that the people whose native country is France have the highest percentage of people earning over 50K.
Next to them is India, followed by Taiwan and Iran. Canada is ranked 9th.*/

-- 12. What is the distribution of people from different countries in the dataset?

SELECT natcountry, COUNT(*) AS count
FROM adult11_staging2
GROUP BY natcountry
ORDER BY count DESC;

/* The majority of people have the United states as their Native Country, followed by Mexico*/

