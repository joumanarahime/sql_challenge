
CREATE TABLE departments
(
    dept_no character varying(64),
    dept_name character varying(64),
    CONSTRAINT departments_pkey PRIMARY KEY (dept_no, dept_name)
);

CREATE TABLE deptemployee
(
    emp_no integer NOT NULL,
    dept_no character varying(64),
    from_date date,
    to_date date,
    CONSTRAINT deptemployee_pkey PRIMARY KEY (emp_no, dept_no, from_date)
);

CREATE TABLE deptmanager
(
    dept_no character varying(64),
    emp_no integer NOT NULL,
    from_date date NOT NULL,
    to_date date,
    CONSTRAINT deptmanager_pkey PRIMARY KEY (dept_no, emp_no, from_date)
);

CREATE TABLE employees
(
    emp_no integer NOT NULL,
    birth_date date,
    first_name character varying(64),
    last_name character varying(64),
    gender character(1),
    hire_date date,
    CONSTRAINT employees_pkey PRIMARY KEY (emp_no)
);

CREATE TABLE salaries
(
    emp_no integer NOT NULL,
    salary money,
    from_date date,
    to_date date,
    CONSTRAINT salaries_pkey PRIMARY KEY (emp_no),
    CONSTRAINT salaries_emp_no_fkey FOREIGN KEY (emp_no)
        REFERENCES public.employees (emp_no) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

CREATE TABLE titles
(
    emp_no integer NOT NULL,
    emp_title character varying(64),
    from_date date NOT NULL,
    to_date date,
    CONSTRAINT titles_pkey PRIMARY KEY (emp_no, from_date),
    CONSTRAINT titles_emp_no_fkey FOREIGN KEY (emp_no)
        REFERENCES public.employees (emp_no) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);




\copy departments(dept_no, dept_name) from 'data/departments.csv' csv delimiter ',' header;
\copy employees(emp_no, birth_date, first_name, last_name, gender, hire_date) from 'data/employees.csv' csv delimiter ',' header;
\copy salaries(emp_no, salary, from_date, to_date) from 'data/salaries.csv' csv delimiter ',' header;
\copy titles(emp_no, title, from_date, to_date) from 'data/titles.csv' csv delimiter ',' header;
\copy dept_emp(emp_no, dept_no, from_date, to_date) from 'data/dept_emp.csv' csv delimiter ',' header;
\copy dept_manager(dept_no, emp_no, from_date, to_date) from 'data/dept_manager.csv' csv delimiter ',' header;


-- 1. List the following details of each employee: employee number, last name, first name, gender, and salary.


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
 SELECT e.emp_no,
    e.last_name,
    e.first_name,
    e.gender,
    s.salary
   FROM employees e,
    salaries s
  WHERE e.emp_no = s.emp_no;


-- 3. List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name, and start and end employment dates.
 SELECT e.emp_no,
    e.last_name,
    e.first_name,
    t.emp_title,
    t.from_date
   FROM employees e,
    titles t
  WHERE t.from_date >= '1986-01-01'::date AND t.from_date <= '1986-12-31'::date AND e.emp_no = t.emp_no;


-- 4. List the department of each employee with the following information: employee number, last name, first name, and department name.
 SELECT employees.emp_no,
    employees.birth_date,
    employees.first_name,
    employees.last_name,
    employees.gender,
    employees.hire_date
   FROM employees
  WHERE employees.first_name::text = 'Hercules'::text AND employees.last_name::text ~~ 'B%'::text;



-- 5. List all employees whose first name is "Hercules" and last names begin with "B."
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
 SELECT employees.last_name,
    count(*) AS count
   FROM employees
  GROUP BY employees.last_name;


-- 7. List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
 SELECT e.emp_no,
    e.last_name,
    e.first_name,
    d.dept_name
   FROM employees e,
    departments d,
    deptemployee de
  WHERE d.dept_no::text = de.dept_no::text AND de.emp_no = e.emp_no AND (d.dept_name::text = ANY (ARRAY['Sales'::character varying, 'Development'::character varying]::text[]));


-- 8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
 SELECT e.emp_no,
    e.last_name,
    e.first_name,
    d.dept_name
   FROM employees e,
    departments d,
    deptemployee de
  WHERE d.dept_no::text = de.dept_no::text AND de.emp_no = e.emp_no AND d.dept_name::text = 'Sales'::text;
