-- 1. List the following details of each employee: employee number, last name, first name, gender, and salary.

CREATE OR REPLACE VIEW public.employee_dept_list
 AS
 SELECT e.emp_no,
    e.last_name,
    e.first_name,
    d.dept_name
   FROM employees e,
    departments d,
    deptemployee de
  WHERE e.emp_no = de.emp_no AND de.dept_no::text = d.dept_no::text
  ORDER BY e.emp_no;


-- 2. List employees who were hired in 1986.
CREATE OR REPLACE VIEW public.employee_details
 AS
 SELECT e.emp_no,
    e.last_name,
    e.first_name,
    e.gender,
    s.salary
   FROM employees e,
    salaries s
  WHERE e.emp_no = s.emp_no;


-- 3. List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name, and start and end employment dates.
CREATE OR REPLACE VIEW public.employees_hire_year
 AS
 SELECT e.emp_no,
    e.last_name,
    e.first_name,
    t.emp_title,
    t.from_date
   FROM employees e,
    titles t
  WHERE t.from_date >= '1986-01-01'::date AND t.from_date <= '1986-12-31'::date AND e.emp_no = t.emp_no;


-- 4. List the department of each employee with the following information: employee number, last name, first name, and department name.
CREATE OR REPLACE VIEW public.hercules_list
 AS
 SELECT employees.emp_no,
    employees.birth_date,
    employees.first_name,
    employees.last_name,
    employees.gender,
    employees.hire_date
   FROM employees
  WHERE employees.first_name::text = 'Hercules'::text AND employees.last_name::text ~~ 'B%'::text;



-- 5. List all employees whose first name is "Hercules" and last names begin with "B."
CREATE OR REPLACE VIEW public.managers_list
 AS
 SELECT m.dept_no,
    d.dept_name,
    m.emp_no,
    e.last_name,
    e.first_name,
    m.from_date,
    m.to_date
   FROM deptmanager m,
    employees e,
    departments d
  WHERE e.emp_no = m.emp_no AND m.dept_no::text = d.dept_no::text;


-- 6. List all employees in the Sales department, including their employee number, last name, first name, and department name.
CREATE OR REPLACE VIEW public.name_frequency
 AS
 SELECT employees.last_name,
    count(*) AS count
   FROM employees
  GROUP BY employees.last_name;


-- 7. List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
CREATE OR REPLACE VIEW public.sales_development_employees
 AS
 SELECT e.emp_no,
    e.last_name,
    e.first_name,
    d.dept_name
   FROM employees e,
    departments d,
    deptemployee de
  WHERE d.dept_no::text = de.dept_no::text AND de.emp_no = e.emp_no AND (d.dept_name::text = ANY (ARRAY['Sales'::character varying, 'Development'::character varying]::text[]));


-- 8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
CREATE OR REPLACE VIEW public.sales_employees
 AS
 SELECT e.emp_no,
    e.last_name,
    e.first_name,
    d.dept_name
   FROM employees e,
    departments d,
    deptemployee de
  WHERE d.dept_no::text = de.dept_no::text AND de.emp_no = e.emp_no AND d.dept_name::text = 'Sales'::text;
