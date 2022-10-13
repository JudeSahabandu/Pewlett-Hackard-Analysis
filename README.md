# Pewlett-Hackard-Analysis
---
## Analysis of employee databases for Pewlett-Hackard

### Overview of the Analysis

Pewlett-Hackard(PH) is a stable organization with 1000's of employees. the Human Resources department of PH has multiple spreadsheet files which they use to track and store different information about the organization talent pool.

With the emergence of more efficient technologies, PH has decided to migrate their systems from a excel file driven spreadsheet network to a database management system like Postgres.

With the new utilization of the database management system, PH has decided to review trends regarding employee groups who are nearing retirement age. The purpose of identifying and analyzing these groups are as follows;

1. Determine employees who are nearing retirement
2. Enable succession planning for retiring employees
3. Develop a mentorship program compromising of eligible retirees

The following report highlights the outcomes of the organizations employee analysis

### Results

A key element of the analysis is to determine a unique list of employees who meet the retirement criteria and filter them by their most recent title. Furthermore, the analysis requires that we depict the total count of retirees by their title as well.

* Identifying list of retiring employees based on the title

To identify the list of retirement eligible employees by title, we first look at the employees and titles tables for data we need to extract through a join statement.

We use an inner join to obtain an output of common columns of both tables we are joining, and specify employees based on birth_date in the years of 1952, 1953, 1954 and 1955.

We use the following query to extract all rows of data, but they are not unique items;

```
SELECT em.emp_no, em.first_name, em.last_name, ti.title, ti.from_date, ti.to_date
INTO retirement_titles
FROM employees AS em
INNER JOIN titles AS ti
ON (em.emp_no = ti.emp_no)
WHERE (em.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no;
```

* Using `DISTINCT ON` query for unique list of retiring employees based on the title

In order to obtain unique values of employees based on the most recent title, we need to use the `DISTINCT ON` function which is unique to Postgres. The function will filter and return the most recent value for our retiring employee list. 

```
SELECT DISTINCT ON (emp_no) emp_no, first_name, last_name, title
INTO unique_titles
FROM retirement_titles
WHERE (to_date = '9999-01-01')
ORDER BY emp_no, to_date DESC;
```

Prior to identifying unique employees based on most recent title using the `DISTINCT ON` query we obtained 133,776 rows of information as can be seen in retirement_titles.csv file.

With the utilization of the `DISTINCT ON` we can see that the number of rows are 72,458. The unique list of identified retiring employees can be found in the unique_titles.csv file.

* Identifying sum of retiring employees by title - using count()

Once we have obtained a list of unique employees based on most recent titles, we use the `COUNT` query to obtain a summary list of employees based on title within the retiring parameters. The query used to obtain the following is;

```
SELECT COUNT(emp_no), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY count DESC;
```

The summary list of identified retiring employees can be found in the retiring_titles.csv file.

* Identifying eligible employees for the mentorship program

Further in our study of the employee database of Pewlett-Hackard, we have a requirement to identify employees eligible for participation in the mentorship program.

In order to obtain the list of eligible employees for the mentorship program we build a query based on some key parameters;

1. The employee should be currently employed
2. The employee birth date should be in 1965

The complete query is as follows;

```
SELECT DISTINCT ON (em.emp_no) em.emp_no, em.first_name, em.last_name, em.birth_date, de.from_date, de.to_date, ti.title
INTO mentorship_eligibilty
FROM employees AS em
INNER JOIN dept_emp AS de
ON (em.emp_no = de.emp_no)
INNER JOIN titles AS ti
ON (em.emp_no = ti.emp_no)
WHERE (de.to_date = '9999-01-01')
AND (em.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY (emp_no);
```

The above query depicts the column outputs we require from 3 different tables under the select statement (employees, dept_emp, titles). Once we input the required columns, we use 2 `INNER JOIN` queries to connect the 3 tables by their primary keys.

The output gives us the mentorship_eligibilty.csv file which indicates that 1,549 employees are eligible for the mentorship program.

### Recommendations

* How many roles will need to be filled as the "silver tsunami" begins to make an impact?

In analyzing the employee data of Pewlett-Hackard we have identified certain parameters that employees need to meet in order to be considered as a role that will require filling in time to come. These parameters are as follows;

1. The employee should be currently employed
2. The employee birth date should be between 1952 and 1955

We have joined our employees table with the titles table to identify a summary of employees based on titles who fulfil the above 2 criteria. The output table can be seen in the retiring_titles.csv file. The data output indicates that there are 72,458 employees who are likely to retire across all departments.

We can further see that most of the employees eligible for retirement are senior engineers and staff which is more than 2/3rds of the total employees eligible for retirement;

1. 25,916 Senior Engineers
2. 24,926 Senior Staff

* Are there enough qualified, retirement-ready employees in the departments to mentor the next generation of Pewlett Hackard employees?

In our previous analysis, we looked at a group of employees eligible to be a mentor based on the following criteria;

1. The employee should be currently employed
2. The employee birth date should be in 1965

Although, the purpose of analysis was to determine employees based on their titles so we did a JOIN query between employees, dept_emp and titles tables. Based on the approach we were able to obtain a summary table of total eligible employees by title.

To obtain eligible employees for the mentorship program based on departments, we need to refactor the code to create a join between employees, dept_emp and departments tables. The query output is as follows;

```
SELECT DISTINCT ON (em.emp_no) em.emp_no, 
	em.first_name, 
	em.last_name,
	em.birth_date, 
	de.from_date, 
	de.to_date,
	d.dept_name
INTO departmental_mentorship
FROM employees AS em
INNER JOIN dept_emp AS de
ON (em.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no)
WHERE (de.to_date = '9999-01-01')
AND (em.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY (emp_no);

SELECT COUNT(emp_no), dept_name
INTO departmental_retirees
FROM departmental_mentorship
GROUP BY dept_name
ORDER BY count DESC;
```

Based on the above analysis output we can come to the following conclusion;

All departments have more than 50 employees eligible for the mentorship program. On the higher end, the Development and Production departments have 396 and 322 eligible mentors and on the lower end the Human Resources, Quality Management and Finance departments have 97, 86 and 64 eligible mentors respectively.

The above output can be seen in the departmental_mentorship.csv and departmental_retirees.csv file within the Additional Data folder.

It can be concluded that each department has a sizeable pool of talented individuals to choose from in order to drive the mentorship program to develop upcoming talent within the organization.

* Additional queries to present insight towards retirement preparation (silver-tsunami)

1. Identifying list of potential trainees for the mentorship program

Given our identification of suitable mentors through the analysis above, we can also attempt to determine key talent that needs to be trained under our mentorship program. As an example, we can look at hires within the last 3 years (1998-2000) to determine a pool of employees who can most benefit from the training.

In order to determine a list of employees based on their hire date, we can use the following query;

```
SELECT DISTINCT ON (em.emp_no) em.emp_no, 
	em.first_name, 
	em.last_name,
	em.birth_date, 
	de.from_date, 
	de.to_date,
	d.dept_name
INTO mentorship_trainees
FROM employees AS em
INNER JOIN dept_emp AS de
ON (em.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no)
WHERE (de.to_date = '9999-01-01')
AND (em.hire_date BETWEEN '1998-01-01' AND '2000-12-31')
ORDER BY (emp_no);
```

The above query will give us a list of 4,535 potential candidates who can be trained under the proposed program. The list is based on most recent hires (those who have been hired to the organization in the past 3 years and are currently employed)

The data from above query can be seen in mentorship_trainees.csv file within the Additional Data folder.

2. Identifying potential trainees by department for the mentorship program

If we are to further filter our trainee output by department, we can utilize the following code to convert the list of employees into a counted list filtered through departments.

```
SELECT COUNT(emp_no), dept_name
INTO departmental_trainees
FROM mentorship_trainees
GROUP BY dept_name
ORDER BY count DESC;
```
The data from above query can be seen in departmental_trainees.csv file within the Additional Data folder.



