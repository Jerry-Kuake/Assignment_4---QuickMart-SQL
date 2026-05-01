-- ASSIGNMENT 4 - QuickMart Database Analysis

USE QuickMart;

-- JOINS

-- Sale details with product, customer and employee names
SELECT s.sale_id, p.product_name, c.customer_name, e.employee_name, s.quantity, s.sale_date
FROM sales s
JOIN products p ON s.product_id = p.product_id
JOIN customers c ON s.customer_id = c.customer_id
JOIN employees e ON s.employee_id = e.employee_id;

-- Each product with total quantity sold
SELECT p.product_name,
       SUM(s.quantity) AS total_quantity_sold
FROM products p
JOIN sales s ON p.product_id = s.product_id
GROUP BY p.product_name;

-- Each employee with number of sales handled
SELECT e.employee_name,
       COUNT(s.sale_id) AS number_of_sales
FROM employees e
JOIN sales s ON e.employee_id = s.employee_id
GROUP BY e.employee_name;

-- Each customer with total number of transactions
SELECT c.customer_name,
       COUNT(s.sale_id) AS total_transactions
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_name;


-- SUBQUERIES

-- Products with price above the average price
SELECT product_name, price
FROM products
WHERE price > (SELECT AVG(price) FROM products);

-- Employees with salary above the average salary
SELECT employee_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- Product with the highest price
SELECT product_name, price
FROM products
WHERE price = (SELECT MAX(price) FROM products);

-- Customers who made purchases with quantity greater than the average quantity
SELECT DISTINCT c.customer_name, s.quantity
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
WHERE s.quantity > (SELECT AVG(quantity) FROM sales);


-- CTE's

-- CTE for total quantity sold per product, then get products with highest sales volume
WITH product_sales AS (
    SELECT p.product_name,
           SUM(s.quantity) AS total_quantity
    FROM products p
    JOIN sales s ON p.product_id = s.product_id
    GROUP BY p.product_name
)
SELECT product_name, total_quantity
FROM product_sales
WHERE total_quantity = (SELECT MAX(total_quantity) FROM product_sales);

-- CTE for sales handled by each employee, then get the employee with the highest sales
WITH employee_sales AS (
    SELECT e.employee_name,
           COUNT(s.sale_id) AS number_of_sales
    FROM employees e
    JOIN sales s ON e.employee_id = s.employee_id
    GROUP BY e.employee_name
)
SELECT employee_name, number_of_sales
FROM employee_sales
WHERE number_of_sales = (SELECT MAX(number_of_sales) FROM employee_sales);

-- CTE for customers and total transactions, then get customers with more than 3 transactions
WITH customer_transactions AS (
    SELECT c.customer_name,
           COUNT(s.sale_id) AS total_transactions
    FROM customers c
    JOIN sales s ON c.customer_id = s.customer_id
    GROUP BY c.customer_name
)
SELECT customer_name, total_transactions
FROM customer_transactions
WHERE total_transactions > 3;
