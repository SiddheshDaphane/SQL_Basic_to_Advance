-- Create Organizational Data table with the "department_name" column
CREATE TABLE organizational_data (
    employee_id serial PRIMARY KEY,
    manager_id integer,
    employee_name text NOT NULL,
    employee_title text,
    salary numeric(10, 2),
    department_name text -- New column for department names
);

-- Insert sample data into Organizational Data table
INSERT INTO organizational_data (employee_id, manager_id, employee_name, employee_title, salary, department_name) VALUES
    (1, NULL, 'James Smith', 'CEO', 100000.00, 'Executive'),
    (2, 1, 'Jessica Jones', 'VP of Engineering', 85000.00, 'Engineering'),
    (3, 1, 'Michael Johnson', 'VP of Sales', 90000.00, 'Sales'),
    (4, 2, 'Emily Davis', 'Engineering Manager 1', 75000.00, 'Engineering'),
    (5, 2, 'Daniel Wilson', 'Engineering Manager 2', 78000.00, 'Engineering'),
    (6, 3, 'Olivia Martin', 'Sales Manager 1', 72000.00, 'Sales'),
    (7, 3, 'William Brown', 'Sales Manager 2', 73000.00, 'Sales'),
    (8, 4, 'Sophia Lee', 'Software Engineer 1', 65000.00, 'Engineering'),
    (9, 4, 'Liam Johnson', 'Software Engineer 2', 67000.00, 'Engineering'),
    (10, 5, 'Oliver Smith', 'Software Engineer 3', 66000.00, 'Engineering'),
    (11, 5, 'Charlotte Taylor', 'Software Engineer 4', 68000.00, 'Engineering'),
    (12, 6, 'Ethan Anderson', 'Sales Rep 1', 50000.00, 'Sales'),
    (13, 6, 'Ava White', 'Sales Rep 2', 52000.00, 'Sales');
