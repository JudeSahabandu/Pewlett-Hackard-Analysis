-- Employee_Database_challenge Queries

SELECT em.emp_no, 
	em.first_name, 
	em.last_name, 
	ti.title, 
	ti.from_date, 
	ti.to_date
INTO retirement_titles
FROM employees AS em
INNER JOIN titles AS ti
ON (em.emp_no = ti.emp_no)
WHERE (em.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no;

-- Use Dictinct with Orderby to remove duplicate rows

SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title
INTO unique_titles
FROM retirement_titles
WHERE (to_date = '9999-01-01')
ORDER BY emp_no, to_date DESC;

-- Obtaining the count of retiring titles

SELECT COUNT(emp_no), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY count DESC;

-- Creating a Mentorship Eligibility Table

SELECT DISTINCT ON (em.emp_no) em.emp_no, 
	em.first_name, 
	em.last_name,
	em.birth_date, 
	de.from_date, 
	de.to_date,
	ti.title
INTO mentorship_eligibilty
FROM employees AS em
INNER JOIN dept_emp AS de
ON (em.emp_no = de.emp_no)
INNER JOIN titles AS ti
ON (em.emp_no = ti.emp_no)
WHERE (de.to_date = '9999-01-01')
AND (em.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY (emp_no);

-- Identifying Count of mentorship program eligible employees by title

SELECT COUNT(emp_no), title
-- INTO retiring_titles
FROM mentorship_eligibilty
GROUP BY title
ORDER BY count DESC;

-- Additional Analysis for Summary/Recommendation
-- Selecting Departmental Mentors for program

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

SELECT * FROM departmental_retirees;

-- Employees to benefit from the mentorship program

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

SELECT COUNT(emp_no), dept_name
INTO departmental_trainees
FROM mentorship_trainees
GROUP BY dept_name
ORDER BY count DESC;

SELECT * FROM mentorship_trainees;



