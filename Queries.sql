CREATE TABLE employees(
	emp_no int primary key,
	birth_date date not null,
	first_name varchar(30) not null,
	last_name varchar(30) not null,
	gender varchar(1) not null,
	hire_date date not null);

CREATE TABLE departments (
	dept_no varchar(15) primary key,
	dept_name varchar(30) not null);
	
CREATE TABLE dept_emp (
	emp_no int not null references employees(emp_no),
	dept_no varchar(15) not null references departments(dept_no),
	from_date date not null,
	to_date date not null);

CREATE TABLE dept_manager(
	dept_no varchar (15) not null references departments(dept_no),
	emp_no int not null references employees(emp_no),
	from_date date not null,
	to_date date not null);

CREATE TABLE salaries(
	emp_no int not null references employees(emp_no),
	salary int not null,
	from_date date not null,
	to_date date not null);

CREATE TABLE titles(
	emp_no int not null references employees(emp_no),
	title varchar(30) not null,
	from_date date not null,
	to_date date not null);

SELECT 'postgresql' AS dbms,t.table_catalog,t.table_schema,t.table_name,c.column_name,c.ordinal_position,c.data_type,c.character_maximum_length,n.constraint_type,k2.table_schema,k2.table_name,k2.column_name FROM information_schema.tables t NATURAL LEFT JOIN information_schema.columns c LEFT JOIN(information_schema.key_column_usage k NATURAL JOIN information_schema.table_constraints n NATURAL LEFT JOIN information_schema.referential_constraints r)ON c.table_catalog=k.table_catalog AND c.table_schema=k.table_schema AND c.table_name=k.table_name AND c.column_name=k.column_name LEFT JOIN information_schema.key_column_usage k2 ON k.position_in_unique_constraint=k2.ordinal_position AND r.unique_constraint_catalog=k2.constraint_catalog AND r.unique_constraint_schema=k2.constraint_schema AND r.unique_constraint_name=k2.constraint_name WHERE t.TABLE_TYPE='BASE TABLE' AND t.table_schema NOT IN('information_schema','pg_catalog');

--List the following details of each employee: employee number, last name, first name, gender, and salary.
select employees.emp_no, last_name, first_name, gender, salary from 
	employees inner join salaries
	on employees.emp_no = salaries.emp_no
order by employees.emp_no;

--List employees who were hired in 1986.
select emp_no, last_name, first_name, hire_date from employees
	where hire_date between '1986-1-01' and '1986-12-31';
	
--List the manager of each department with the following information: 
--department number, department name, the manager's employee number, last name, first name, and start and end employment dates.
select departments.dept_no, departments.dept_name, dept_manager.emp_no, last_name, first_name, from_date, to_date from
	dept_manager left join employees
		on dept_manager.emp_no = employees.emp_no
	left join departments
		on dept_manager.dept_no = departments.dept_no;

--List the department of each employee with the following information: employee number, last name, first name, and department name.
select employees.emp_no, last_name, first_name, dept_name from
	employees inner join dept_emp
		on employees.emp_no = dept_emp.emp_no
	inner join departments
		on dept_emp.dept_no = departments.dept_no
order by employees.emp_no;

--List all employees whose first name is "Hercules" and last names begin with "B."
select * from employees
	where first_name = 'Hercules'
	and
	last_name like '%B%';

--List all employees in the Sales department, including their employee number, last name, first name, and department name.
select employees.emp_no, last_name, first_name, dept_name from
	employees inner join dept_emp
		on employees.emp_no = dept_emp.emp_no
	inner join departments
		on dept_emp.dept_no = departments.dept_no
	where dept_name = 'Sales';

--List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
select employees.emp_no, last_name, first_name, dept_name from
	employees inner join dept_emp
		on employees.emp_no = dept_emp.emp_no
	inner join departments
		on dept_emp.dept_no = departments.dept_no
	where dept_name = 'Sales' or dept_name = 'Development';

--In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
select last_name, count(last_name) from employees
group by last_name
order by count(last_name) desc;


