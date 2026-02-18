use crowdfunding_data;
# 1Q Total Number of Projects Based on Outcome
Select State as Outcome,count(*) as `Total Projects`
from projects
where state in("Failed","Successful","Live","Purged","Suspended","Canceled")
Group by State
Order by `Total Projects` Desc;
# 2 Question Total Number of Projects Location
select locations.Country,count(projects.projectID) as `Total projects`
from locations  left join projects 
on locations.id=projects.location_id
group by locations.country
order by `Total Projects` desc;
# 3 Question Total Number of Projects Based on Category
select categories.id as `Category ID`,categories.name as `Category Name`,
count(projects.projectID) AS `Total Projects`
from categories 
left join projects 
on categories.id=projects.category_id
group by categories.id,categories.name
order by `Total Projects` desc;
# 4th Fourth Question Total Number of Projects Based on Year,Quarter,Month
SELECT
    YEAR(calendar.date) AS Year,

    COUNT(projects.projectID) AS `Total Projects in Year`,

    /* Quarters */
    SUM(CASE WHEN QUARTER(calendar.date) = 1 THEN 1 ELSE 0 END) AS Q1,
    SUM(CASE WHEN QUARTER(calendar.date) = 2 THEN 1 ELSE 0 END) AS Q2,
    SUM(CASE WHEN QUARTER(calendar.date) = 3 THEN 1 ELSE 0 END) AS Q3,
    SUM(CASE WHEN QUARTER(calendar.date) = 4 THEN 1 ELSE 0 END) AS Q4,

    /* Months */
    SUM(CASE WHEN MONTH(calendar.date) = 1  THEN 1 ELSE 0 END) AS Jan,
    SUM(CASE WHEN MONTH(calendar.date) = 2  THEN 1 ELSE 0 END) AS Feb,
    SUM(CASE WHEN MONTH(calendar.date) = 3  THEN 1 ELSE 0 END) AS Mar,
    SUM(CASE WHEN MONTH(calendar.date) = 4  THEN 1 ELSE 0 END) AS Apr,
    SUM(CASE WHEN MONTH(calendar.date) = 5  THEN 1 ELSE 0 END) AS May,
    SUM(CASE WHEN MONTH(calendar.date) = 6  THEN 1 ELSE 0 END) AS Jun,
    SUM(CASE WHEN MONTH(calendar.date) = 7  THEN 1 ELSE 0 END) AS Jul,
    SUM(CASE WHEN MONTH(calendar.date) = 8  THEN 1 ELSE 0 END) AS Aug,
    SUM(CASE WHEN MONTH(calendar.date) = 9  THEN 1 ELSE 0 END) AS Sep,
    SUM(CASE WHEN MONTH(calendar.date) = 10 THEN 1 ELSE 0 END) AS Oct,
    SUM(CASE WHEN MONTH(calendar.date) = 11 THEN 1 ELSE 0 END) AS Nov,
    SUM(CASE WHEN MONTH(calendar.date) = 12 THEN 1 ELSE 0 END) AS `Dec`

FROM calendar
JOIN projects
    ON DATE(projects.created_date) = calendar.date
GROUP BY YEAR(calendar.date)
ORDER BY Year;
# 5th Question Successful Projects Amount Raised
select sum(projects.usd_pledged) as `Successful Projects Total Amount Raised in US Dollars`
from projects 
where projects.state="successful";
# 6th Question Sucessful Projects Number of Backers
select sum(projects.backers_count) as `Total Successful Backers`
from projects
where projects.state="Successful";
# 7th Question Avg Number of Days for Successful Projects
select Round(avg(projects.duration_days)) as `Avg Days for Successful Projects`
from projects
where projects.state="successful";
# 8th Question Top Sucsessful Projects Based on Highest Backers count
select ProjectID,state,name,country,backers_count,created_date,deadline_date from Projects
where projects.state="successful" and projects.backers_count is not null
order by projects.backers_count desc
limit 10;
# 9th Question Top Successful Projects Having Highest Amount Raised in US Dollars
select ProjectID,state,name,country,usd_pledged,created_date,deadline_date from projects 
where projects.state="successful" and projects.usd_pledged is not null 
order by projects.usd_pledged desc
limit 10;
# 10 th Question Percentage of Successful Projects
select Round((count(case when projects.state="successful" then 1 end)*100.0
/count(projects.projectID)),2)as `Success Percentage`
from projects;
# 11th Question percentage of Successful projects by Category
SELECT
    categories.id AS `Category ID`,
    categories.name AS `Category Name`,
    COUNT(projects.projectID) AS `Total Projects`,
    COUNT(CASE WHEN projects.state = 'successful' THEN 1 END) AS `Successful Projects`,
    ROUND(
        COUNT(CASE WHEN projects.state = 'successful' THEN 1 END) * 100.0
        / NULLIF(COUNT(projects.projectID), 0),
        2
    ) AS `Success Percentage`
FROM categories
LEFT JOIN projects
    ON categories.id = projects.category_id
GROUP BY categories.id, categories.name
ORDER BY `Success Percentage` DESC;
# 12th Projects Percentage of Successful Projects by Year,Quarter,Month
SELECT
    YEAR(calendar.date) AS Year,

    /* Year-wise success percentage */
    ROUND(
        100 * SUM(projects.state = 'successful') / COUNT(projects.projectID),
        2
    ) AS `Year Succes Percentage `,

    /* Quarter-wise success percentage */
    ROUND(
        100 * SUM(CASE WHEN QUARTER(calendar.date) = 1 AND projects.state = 'successful' THEN 1 ELSE 0 END)
        / NULLIF(SUM(CASE WHEN QUARTER(calendar.date) = 1 THEN 1 ELSE 0 END), 0),
        2
    ) AS Q1,

    ROUND(
        100 * SUM(CASE WHEN QUARTER(calendar.date) = 2 AND projects.state = 'successful' THEN 1 ELSE 0 END)
        / NULLIF(SUM(CASE WHEN QUARTER(calendar.date) = 2 THEN 1 ELSE 0 END), 0),
        2
    ) AS Q2,

    ROUND(
        100 * SUM(CASE WHEN QUARTER(calendar.date) = 3 AND projects.state = 'successful' THEN 1 ELSE 0 END)
        / NULLIF(SUM(CASE WHEN QUARTER(calendar.date) = 3 THEN 1 ELSE 0 END), 0),
        2
    ) AS Q3,

    ROUND(
        100 * SUM(CASE WHEN QUARTER(calendar.date) = 4 AND projects.state = 'successful' THEN 1 ELSE 0 END)
        / NULLIF(SUM(CASE WHEN QUARTER(calendar.date) = 4 THEN 1 ELSE 0 END), 0),
        2
    ) AS Q4,

    /* Month-wise success percentage */
    ROUND(100 * SUM(CASE WHEN MONTH(calendar.date)=1  AND projects.state='successful' THEN 1 ELSE 0 END)
          / NULLIF(SUM(MONTH(calendar.date)=1),0), 2) AS Jan,

    ROUND(100 * SUM(CASE WHEN MONTH(calendar.date)=2  AND projects.state='successful' THEN 1 ELSE 0 END)
          / NULLIF(SUM(MONTH(calendar.date)=2),0), 2) AS Feb,

    ROUND(100 * SUM(CASE WHEN MONTH(calendar.date)=3  AND projects.state='successful' THEN 1 ELSE 0 END)
          / NULLIF(SUM(MONTH(calendar.date)=3),0), 2) AS Mar,

    ROUND(100 * SUM(CASE WHEN MONTH(calendar.date)=4  AND projects.state='successful' THEN 1 ELSE 0 END)
          / NULLIF(SUM(MONTH(calendar.date)=4),0), 2) AS Apr,

    ROUND(100 * SUM(CASE WHEN MONTH(calendar.date)=5  AND projects.state='successful' THEN 1 ELSE 0 END)
          / NULLIF(SUM(MONTH(calendar.date)=5),0), 2) AS May,

    ROUND(100 * SUM(CASE WHEN MONTH(calendar.date)=6  AND projects.state='successful' THEN 1 ELSE 0 END)
          / NULLIF(SUM(MONTH(calendar.date)=6),0), 2) AS Jun,

    ROUND(100 * SUM(CASE WHEN MONTH(calendar.date)=7  AND projects.state='successful' THEN 1 ELSE 0 END)
          / NULLIF(SUM(MONTH(calendar.date)=7),0), 2) AS Jul,

    ROUND(100 * SUM(CASE WHEN MONTH(calendar.date)=8  AND projects.state='successful' THEN 1 ELSE 0 END)
          / NULLIF(SUM(MONTH(calendar.date)=8),0), 2) AS Aug,

    ROUND(100 * SUM(CASE WHEN MONTH(calendar.date)=9  AND projects.state='successful' THEN 1 ELSE 0 END)
          / NULLIF(SUM(MONTH(calendar.date)=9),0), 2) AS Sep,

    ROUND(100 * SUM(CASE WHEN MONTH(calendar.date)=10 AND projects.state='successful' THEN 1 ELSE 0 END)
          / NULLIF(SUM(MONTH(calendar.date)=10),0), 2) AS Oct,

    ROUND(100 * SUM(CASE WHEN MONTH(calendar.date)=11 AND projects.state='successful' THEN 1 ELSE 0 END)
          / NULLIF(SUM(MONTH(calendar.date)=11),0), 2) AS Nov,

    ROUND(100 * SUM(CASE WHEN MONTH(calendar.date)=12 AND projects.state='successful' THEN 1 ELSE 0 END)
          / NULLIF(SUM(MONTH(calendar.date)=12),0), 2) AS `Dec`

FROM calendar
JOIN projects
    ON DATE(projects.created_date) = calendar.date
GROUP BY YEAR(calendar.date)
ORDER BY Year;
# 13th question Percenatage of Successful Projects By Goal Range
select projects.goal_range as `Goal Range`,
count(projects.projectID) AS `Total Projects`,
count(case when projects.state="successful" then 1 end) as `Successful Projects`,
Round(case 
when count(projects.projectID)=0 THEN 0
ELSE (COUNT(CASE WHEN projects.state="successful" then 1 end)*100.0
/count(projects.projectID))
END,2) AS `Success Percentage`
from projects
group by Projects.goal_range
order by `Success Percentage` desc;
# END
