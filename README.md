# Pewlett-Hackard-Analysis
---
## Analysis of employee databases for Pewlett-Hackard

### Overview of the Analysis

Pewlett-Hackard(PH) is a stable organization with 1000's of employees. the Human Resources department of PH has multiple spreadsheet files which they use to track and store different information about the organization talent pool.

With the emergence of more efficient technologies, PH has decided to migrate thier systems from a excel file driven spreadsheet network to a database management system like Postgres.

With the new utilization of the database management system, PH has decided to review trends regarding employee groups who are nearing retirement age. The purpose of identifying and analyzing these groups are as follows;

1. Determine employees who are nearing retirement
2. Enable succession planning for retiring employees
3. Develop a mentorship program comprosing of eligible retirees

The following report highlights the outcomes of the organixations employee analysis

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

The above query depicts the column outputs we require from 3 different tables under the select statement (employees, dept_emp, titles). Once we input the required columns, we use 2 `INNER JOIN` queries to connect the 3 tables by thier primary keys.

The output gives us the mentorship_eligibilty.csv file which indicates that 1,549 employees are eligible for the mentorship program.

### Recommendations
