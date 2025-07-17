---scenario
----you are hired as a junior data analyst for a retail company.
---that sells electronics and accessories.
----your manager wants you to analyze sales and customer data using SQL in SSMS.



create database project
use project;
--------create customers table
create table customers_3(
customerid int primary key,
firstname varchar(50),
lastname varchar(50),
city varchar(50),
joindate date
);


insert into customers_3(customerid,firstname,lastname,city,joindate)
values(1,'john','doe','mumbai','2024-01-05'),
(2,'alice','smith','delhi','2024-02-15'),
(3,'bob','brown','bangalore','2024-03-20'),
(4,'sara','white','mumbai','2024-01-25'),
(5,'mike','black','chennai','2024-02-10');


select * from customers_3;

-- Create Customers table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    City VARCHAR(50),
    JoinDate DATE
);

-- Insert data into Customers
INSERT INTO Customers VALUES
(1, 'John', 'Doe', 'Mumbai', '2024-01-05'),
(2, 'Alice', 'Smith', 'Delhi', '2024-02-15'),
(3, 'Bob', 'Brown', 'Bangalore', '2024-03-20'),
(4, 'Sara', 'White', 'Mumbai', '2024-01-25'),
(5, 'Mike', 'Black', 'Chennai', '2024-02-10');


-- Create Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Customers_3(CustomerID),
    OrderDate DATE,
    Product VARCHAR(50),
    Quantity INT,
    Price INT
);
drop table orders
-- Insert data into Orders
INSERT INTO Orders VALUES
(101, 1, '2024-04-10', 'Laptop', 1, 55000),
(102, 2, '2024-04-12', 'Mouse', 2, 800),
(103, 1, '2024-04-15', 'Keyboard', 1, 1500),
(104, 3, '2024-04-20', 'Laptop', 1, 50000),
(105, 4, '2024-04-22', 'Headphones', 1, 2000),
(106, 2, '2024-04-25', 'Laptop', 1, 52000),
(107, 5, '2024-04-28', 'Mouse', 1, 700),
(108,3,'2024-05-02','keyboard',1,1600);

select * from orders;


---part A: basic Queries
-----1.get the list of all customers from mumbai.
select * from customers_3 where city = 'mumbai';
---Sara and John are from mumbai.


----2. show all orders for laptops.
select * from orders where product = 'laptop';
---Total of 3 laptops are sold 


---3.find the total number of orders placed.
select count(*) as totalorders from orders;
---Total of 8 orders placed.

---customize-find price between 50000 and 80000.
select * from orders where price between 50000 and 80000;
---There are 3 customers who shopped between 50k to 80k.

---customize-find product from orders where price > 10000.
select * from orders where price > 10000;
---There are 3  customers who shopped greater than 10k.


select * from orders
select * from customers_3
----part B.joins
---5.get the full name of customers and their product order

select 
c.firstname+' '+c.lastname as fullname,
o.product
from customers_3 c 
join orders o on c.customerid = o.customerid;


----6.find customers who have not placed any orders.
select c.customerid,o.orderid
from customers_3 c 
join orders o on c.customerid = o.customerid
where o.orderid is null;

---subquery(Optional way)
select * from customers
where customerid not in(select distinct customerid from orders);
---There are not any customers who have not placde nay orders

---part C: aggregation
---6.find the total revenue earned from all orders.
select
sum(price*quantity) as totalrevenue 
from orders;

select sum(price) as totalrevenue from orders;

---7.Find total quantity of mouse sold.
select sum(quantity) as totalquantity from orders where product = 'mouse'


---Part D:group by
---8 show total sales amount per customers.
select 
c.firstname,
sum(o.quantity*o.price) as totalsales
from customers_3 c 
join orders o on c.customerid = o.customerid
group by c.firstname

---9 show numbers of orders placed per city
SELECT 
    c.city,
    COUNT(o.OrderID) AS NumberOfOrders
FROM Customers_3 c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.city;


---part E: subquery and case
---10.find customers who spent more than 50,000 in total.
select * from customers_3 
where customerid in(
select customerid from orders
group by customerid
having SUM(Quantity * Price) > 50000
) 

---11.write a query to display each order with a label:
---'high value' if price > 50000
---'low value' otherwise
select orderid,price,
case
    when price > 50000 then 'High value'
    else 'low value'
end as valuelabel
from orders;


----part F: window functions
---12. find the running total of revenue by order date.
select orderid,orderdate,price,
sum(price) over (order by orderdate) as runningRevenue
from orders;

---13. assign a row_number to each order
--by customerid order by orderDate(oldest first).
select orderid,customerid,orderdate,price,
row_number() over(partition by customerid order by orderdate) as rownum
from orders;


---13 A. assign row_number to each customerid 
---order by price
select orderid,customerid,orderdate,price,
row_number() over(partition by customerid order by price) as rownum
from orders;


--14.use rank to rank order by price(highest to lowest)
select orderid,
customerid,price,
rank() over (order by price desc) as pricerank
from orders;

--14 A. use rank for order to quantity
select orderid,
customerid,quantity,
rank() over (order by quantity desc) as pricerank
from orders;


---15. use dense rank to rank orders by price (highest to lowest)-explain difference with rank.
select orderid,
customerid,price,
dense_rank() over (order by price desc) as pricerank
from orders;

update orders
set price = 55000
where price = 52000;


---16.find customers who have placed more than 1 orders using having
select customerid,count(orderid) as totalorders
from orders 
group by customerid
having count(orderid) > 1;

