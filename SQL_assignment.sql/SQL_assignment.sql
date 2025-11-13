-- Clean-up section (Always good practice to start with DROP TABLE statements)
DROP TABLE IF EXISTS Shipments;
DROP TABLE IF EXISTS Inventory;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Suppliers;
DROP TABLE IF EXISTS Warehouses;

-- 1. Warehouses Table
CREATE TABLE Warehouses (
    warehouse_id INTEGER PRIMARY KEY,
    warehouse_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    capacity_sqft INTEGER, -- Capacity in Square Feet
    manager_name VARCHAR(100)
);

-- 2. Suppliers Table
CREATE TABLE Suppliers (
    supplier_id INTEGER PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    contact_person VARCHAR(100),
    registration_city VARCHAR(50)
);

-- 3. Products Table
CREATE TABLE Products (
    product_id INTEGER PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    unit_cost DECIMAL(10, 2) NOT NULL,
    hs_code VARCHAR(20) UNIQUE -- Harmonized System Code
);

-- 4. Inventory Table
CREATE TABLE Inventory (
    inventory_id INTEGER PRIMARY KEY,
    warehouse_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    stock_quantity INTEGER,
    reorder_level INTEGER,
    FOREIGN KEY (warehouse_id) REFERENCES Warehouses(warehouse_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- 5. Shipments Table (Corrected Foreign Key line termination)
CREATE TABLE Shipments (
    shipment_id INTEGER PRIMARY KEY,
    product_id INTEGER NOT NULL,
    supplier_id INTEGER,
    origin_warehouse_id INTEGER NOT NULL,
    destination_city VARCHAR(50) NOT NULL,
    shipment_date DATE NOT NULL,
    expected_delivery_date DATE,
    actual_delivery_date DATE,
    shipping_cost DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20), -- 'In Transit', 'Delivered', 'Delayed'
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id),
    FOREIGN KEY (origin_warehouse_id) REFERENCES Warehouses(warehouse_id)
);

---

## 💾 Corrected Data Insertion (INSERT Statements)


-- Insert data into Warehouses
INSERT INTO Warehouses (warehouse_id, warehouse_name, city, capacity_sqft, manager_name) VALUES
(1, 'Reliance Logistics Hub', 'Mumbai', 50000, 'Vivek Kulkarni'),
(2, 'Gati Cargo Depot', 'Delhi', 75000, 'Sneha Tandon'),
(3, 'TVS Supply Chain Point', 'Chennai', 40000, 'Gopal Iyer'),
(4, 'Amazon Fulfillment Center', 'Bangalore', 100000, 'Prabha Shetty');


-- Insert data into Suppliers
INSERT INTO Suppliers (supplier_id, supplier_name, contact_person, registration_city) VALUES
(10, 'Lakshmi Textiles', 'Ramesh Kumar', 'Coimbatore'),
(20, 'Bharat Pharma Corp', 'Dr. Shanti Rao', 'Hyderabad'),
(30, 'Tata Motors Ancillaries', 'Pankaj Varma', 'Pune'),
(40, 'Amul Dairy Goods', 'Kiran Patel', 'Ahmedabad');


-- Insert data into Products
INSERT INTO Products (product_id, product_name, category, unit_cost, hs_code) VALUES
(100, 'Basmati Rice (50kg)', 'Food Grain', 3500.00, '1006.30'),
(101, 'Auto Gearbox Unit', 'Automotive', 45000.00, '8708.40'),
(102, 'Cotton Fabric Roll', 'Textile', 8500.00, '5209.11'),
(103, 'Tablet Salt (Bulk)', 'Pharma Raw', 15000.00, '2501.00'),
(104, 'E-commerce Box (L)', 'Packaging', 50.00, '4819.10');


-- Insert data into Inventory
INSERT INTO Inventory (inventory_id, warehouse_id, product_id, stock_quantity, reorder_level) VALUES
(1000, 1, 100, 500, 100),
(1001, 1, 104, 15000, 5000),
(1002, 2, 101, 250, 50),
(1003, 3, 102, 300, 75),
(1004, 4, 100, 1000, 200),
(1005, 4, 103, 150, 100);


-- Insert data into Shipments
INSERT INTO Shipments (shipment_id, product_id, supplier_id, origin_warehouse_id, destination_city, shipment_date, expected_delivery_date, actual_delivery_date, shipping_cost, status) VALUES
(5001, 101, 30, 2, 'Chennai', '2024-06-01', '2024-06-07', '2024-06-08', 12500.00, 'Delayed'),
(5002, 104, NULL, 1, 'Pune', '2024-06-05', '2024-06-07', '2024-06-07', 3500.00, 'Delivered'),
(5003, 102, 10, 3, 'Mumbai', '2024-06-10', '2024-06-15', '2024-06-15', 8900.00, 'Delivered'),
(5004, 103, 20, 4, 'Hyderabad', '2024-06-12', '2024-06-14', NULL, 6000.00, 'In Transit'),
(5005, 100, 40, 1, 'Kolkata', '2024-06-15', '2024-06-22', NULL, 15000.00, 'In Transit'),
(5006, 100, 40, 4, 'Delhi', '2024-06-18', '2024-06-20', '2024-06-20', 4200.00, 'Delivered');

-- Q1 Add a new column ’contact_email’ (VARCHAR 100, unique constraint) to the Suppliers table.
ALTER TABLE Suppliers
ADD CONSTRAINT contact_email UNIQUE (Contact_email);

-- Q2 Rename the column ’unit_cost’ in the Products table to ’base_price’.
ALTER TABLE Products 
RENAME COLUMN Unit_cost TO Base_price; 

-- Q3 Create a non-unique index named ’idx_shipment_status’ on the ’status’ column of the Shipments table.
ALTER TABLE Shipments 
ADD INDEX idx_shipment_status(status);

-- Q4 Modify the ’capacity_sqft’ column in the Warehouses table to allow a larger capacity (e.g., BIGINT).
 ALTER TABLE warehouses
 MODIFY COLUMN capacity_sqft BIGINT;  
 
 -- Q5 Insert a new product: ID 105, ’Solar Panel Unit’, category ’Renewable’, cost 25000.00, HS code ’8541.40’.
INSERT INTO PRODUCTS (ID ,Product_name , Category ,Cost , hs_code)
VALUES 
( 105 , 'Solar Panel Unit' , 'Renewable' ,25000.00 , '8541.40' );

-- Q6 Update the stock quantity of ’Basmati Rice (50kg)’ (Product ID 100) in the Mumbai warehouse (ID 1) to 600 units.
UPDATE Inventory
SET stock_quantity = 600
WHERE product_id = 100
  AND Warehouse_id = 1;
  
-- Q7 Update the status of Shipment ID 5004 to ’Delayed’ and set the ’actual_delivery_date’ to ’2024-06-17’.
UPDATE Shipments
SET status = 'Delayed' , actual_delivery_date = ’2024-06-17’
WHERE Shipment_ID = 5004;

-- Q8 Insert a new warehouse: ID 5, ’Adani Logistics Park’, ’Ahmedabad’, 60000 sqft, managed by ’Anil Singh’.
INSERT INTO Warehouses (warehouse_id, warehouse_name, city, capacity_sqft, manager_name)
VALUES 
(5 , 'Adani Logistics Park' , 'Ahmedabad' ,  '60000_sqft',  'Anil Singh')

-- Q9 Delete all inventory records for products belonging to the ’Pharma Raw’ category .
DELETE I
FROM Inventory I
INNER JOIN Products P ON I.product_id = P.product_id
WHERE P.category = 'Pharma Raw';

-- Q10 Delete the supplier named ’Amul Dairy Goods’ (ID 40).
DELETE FROM suppliers
WHERE supplier_name = 'Amul Dairy Goods';

-- Q11 Select the warehouse name, city, and manager name for all warehouses in ’Mumbai’ or ’Bangalore’.
SELECT Warehouse_name , city , manager_name 
FROM warehouses
WHERE city = 'Mumbai' or 'Bangalore'

-- Q12 Select the product name and HS code for all products whose category is NOT ’Food Grain’
SELECT product_name, hs_code
FROM Products
WHERE category != 'Food Grain';

-- Q13 Find all unique registration cities of suppliers.
SELECT DISTINCT registration_cities
FROM Suppliers

-- Q14 List all shipments with a shipping cost between 5000.00 and 10000.00 (inclusive), ordered by cost descending.
SELECT * FROM Shipments
WHERE shipping_cost = 5000.00 AND 10000.00;

-- Q15 Select all products whose product name contains the word ’Unit’ or ’Roll’
SELECT * FROM Products 
WHERE product_name like '%Unit%' or  product_name like '%Roll%'

-- Q16 List the top 2 highest capacity warehouses.
SELECT warehouse_name , capacity_sqft
FROM Warehouses
ORDER BY capacity_sqft DESC 
LIMIT 2;

-- Q17 Select all shipments that do not have an associated supplier (supplier_id is NULL).
SELECT * FROM Suppiers
WHERE supplier_id IS NULL;

-- Q18 Concatenate the product name and category into a single string: ”NAME [CATEGORY]”.
SELECT CONCAT(product_name, ' [', category, ']') AS Product_Detail FROM Products;

-- Q19 Display the supplier name, replacing all occurrences of ’Corp’ with ’Corporation’.
SELECT 
    supplier_id,
    REPLACE (supplier_name, 'Corp', 'Corporation')  FROM Suppliers;
    
-- Q20 Select the shipment date, and the date that is 45 days after the shipment date, labeled ’PaymentDue_Date’.
SELECT 
   shipment_date,
   DATE_ADD(shipment_date , INTERVAL 45 DAY) AS PaymentDue_date
FROM
   Suppliers;
   
-- Q21 Calculate the difference in days between ’expected_delivery_date’ and ’actual_delivery_date’ for all shipments, labeled ’DeliveryDelayInDays’.
SELECT 
     shipment_id,
     expected_delivery_date,
     actual_delivery_date,
     datediff(actual_delivery_date, expected_delivery_date) AS DeliveryDelayInDays
FROM 
   shipments;
   
-- Q22 Display the warehouse name, converting it to all lowercase letters.
SELECT lower(warehouse_name) FROM warehouses;

-- Q23 Calculate the total stock quantity of all products, rounded up to the nearest thousand.
SELECT
    (CEIL(SUM(stock_quantity) / 1000) * 1000) AS Total_stock_quantity
FROM
    Inventory;
    
-- Q24 Extract the year from the ’shipment_date’ for all shipments.
SELECT  year(shipment_date) FROM Shipments

-- Q25 Select the supplier name and the first three characters of their contact person’s name.
SELECT LEFT(contact_person, 3) FROM Suppliers;

-- Q26 List the product name, its current stock quantity, and the warehouse name where it is stored. (3-table INNER JOIN)
SELECT
    P.product_name,
    I.stock_quantity,
    W.warehouse_name
FROM
    Inventory I
JOIN
    Products P ON I.product_id = P.product_id
JOIN
    Warehouses W ON I.warehouse_id = W.warehouse_id
ORDER BY
    W.warehouse_name, P.product_name;
    
-- Q27 List all shipments, showing the Shipment ID, the Supplier Name, and the destination city. (INNER JOIN)
SELECT
    S.Shipment_id,
    SN.Supplier_name,
    S.destination_name
FROM
    Shipment S
JOIN 
    Shipment S ON S.Shipment_id = SU.Supplier_id;
    
-- Q28 List all warehouses and the products they hold in stock (show warehouses even if they hold no stock). (LEFT JOIN)
SELECT
   W.Warehouse_name,
   P.Product_id,
   I.Stock_quantity
FROM 
   Warehouse W
LEFT JOIN 
	Inventory I ON W.warehouse_id = I.warehouse_id
LEFT JOIN 
    Products P ON I.product_id = P.product_id
ORDER BY
    W.warehouse_name , P.product_name;

-- Q29 Find all products that are currently NOT in stock in any warehouse. (LEFT JOIN with WHERE IS NULL)
SELECT 
    P.product_id,
    P.product_name
FROM 
    I.Inventory
LEFT JOIN
    I.Inventory ON I.product_id = P.product_id
WHERE 
     I.product_id IS NULL;
     
-- Q30 List all suppliers and their corresponding shipment IDs (show NULL for suppliers with no shipments). (LEFT JOIN)
SELECT
   S.Shipment_id,
   SN.Supplier_name
FROM
    Suppliers SU
LEFT JOIN
     Shipments S ON SN.Supplier_id = S.Supplier_id
ORDER BY
     SN.Supplier_name , S.Shipment_id; 

-- Q31 List the product name and the name of the supplier who supplied the product for Shipment ID 5001.
SELECT
   P.Product_name , 
   SU.Supplier_name
FROM
    S.Shipment
INNER JOIN 
    S.Shipments ON S.Product_id = P.Product_id
INNER JOIN 
    S.Shipments ON S.Supplier_id = SU.Supplier_id
WHERE
    S.Shipment_id = 5001;
    
-- Q32 List the product name, its category, and the name of the warehouse that stores it, only for products with stock below their reorder level.
SELECT 
    P.Product_name ,
    P.category ,
    W.Warehouse_name,
    I.Stock_quantity,
    I.Reorder_level
From 
    I.Inventory
INNER JOIN 
     P.Products ON I.Product_id = P.Product_id
INNER JOIN 
     W.Warehouse ON I.Warehouse_id = W.Warehouse_id
WHERE 
     I.Stock_quantity < I.Reorder_level;
     
-- Q33 Combine all suppliers and all warehouses, listing every possible supplierwarehouse pair. (CROSS JOIN)
SELECT
   S.Supplier_name , 
   W.Warehouse_name
FROM 
   Suppliers SU
CROSS JOIN
   warehouses W;
   
 -- Q34 Find pairs of warehouses located in the same city, but with different warehouse IDs.
SELECT 
   A.Warehouse_name,
   B.Warehouse_name,
   A.city
FROM
   A.Warehouse
INNER JOIN 
   B.Warehouse ON A.city = B.city
AND  A.Warehouse_id < B.Warehouse_id ;

-- Q35 List all inventory items that have a lower stock quantity than another item stored in the same warehouse.
SELECT DISTINCT
    I1.product_id,
    P1.product_name,
    I1.warehouse_id,
    I1.stock_quantity
FROM
    Inventory I1
INNER JOIN
    Inventory I2 ON I1.warehouse_id = I2.warehouse_id
    AND I1.stock_quantity < I2.stock_quantity
INNER JOIN
    Products P1 ON I1.product_id = P1.product_id
ORDER BY
    I1.warehouse_id, I1.stock_quantity;

-- Q36 Find the names of managers who manage a warehouse in the same city as the ’Reliance Logistics Hub’ (ID 1).
SELECT 
   W.Manager_name
FROM
   W.Warehouse
WHERE 
    W.city = (
	    SELECT City
        FROM Warehouses
        WHERE  Warehouse_name = 'Reliance Logistics Hub'
	);

-- Q37 Calculate the total number of unique products currently in inventory.
SELECT COUNT(DISTINCT product_id ) FROM inventory;

-- Q38 Find the average shipping cost for shipments with a status of ’Delivered’
SELECT AVG cost FROM shipments WHERE status = ’Delivered’

-- Q39 List the total stock quantity for each product category (Category and Total Stock)
SELECT
   P.Category,
   SUM(I.stock_quantity) AS Total_stock
FROM
    I.Inventory
INNER JOIN
    Products P ON I.Product_id = P.Product_id
GROUP BY
	P.Category;

-- Q40 Find the number of shipments originated from each warehouse (Warehouse Name and Shipment Count).
SELECT
    W.warehouse_name,
    COUNT(S.shipment_id) AS Shipment_Count
FROM
    Warehouses W
INNER JOIN
    Shipments S ON W.warehouse_id = S.origin_warehouse_id
GROUP BY
    W.warehouse_name
ORDER BY
    Shipment_Count DESC;
    
-- Q41 Determine the maximum and minimum capacity of the warehouses.
SELECT MAX(Capacity_sqft) AND MIN(Capacity_sqft) FROM Warehouses;

-- Q42 List the total stock value (stock_quantity * unit_cost) for each product name.
SELECT
    P.product_name,
    SUM(I.stock_quantity * P.unit_cost) AS Total_Stock_Value
FROM
    Inventory I
INNER JOIN
    Products P ON I.product_id = P.product_id
GROUP BY
    P.product_name
ORDER BY
    Total_Stock_Value DESC;

-- Q43 Find the cities where the average warehouse capacity is greater than 60000 sqft. (HAVING AVG)
SELECT 
    City,
    AVG(Capacity_sqft) AS Average_Capacity
FROM 
   warehouses
GROUP BY
    City
HAVING 
    AVG(Capacity_sqft) > 60000 
ORDER BY
    Average_Capacity DESC;

-- Q44 Find the supplier (name) that has supplied products for the highest number of distinct shipments.
SELECT
    SU.supplier_name,
    COUNT(DISTINCT S.shipment_id) AS Distinct_Shipment_Count
FROM
    Suppliers SU
INNER JOIN
    Shipments S ON SU.supplier_id = S.supplier_id
GROUP BY
    SU.supplier_name
ORDER BY
    Distinct_Shipment_Count DESC
LIMIT 1;

-- Q45 Find the names of all products that have been part of a shipment. (Subquery with EXISTS)
SELECT
    product_name
FROM
    Products P
WHERE
    EXISTS (
        SELECT 1
        FROM Shipments S
        WHERE S.product_id = P.product_id
    );
    
-- Q46 Find the warehouse names where the stock quantity of any product is below the overall minimum reorder level across all inventory items. (Scalar Subquery)
SELECT DISTINCT
    W.warehouse_name
FROM
    Warehouses W
INNER JOIN
    Inventory I ON W.warehouse_id = I.warehouse_id
WHERE
    I.stock_quantity < (
        -- Scalar Subquery: Finds the single, minimum reorder level across all items
        SELECT
            MIN(reorder_level)
        FROM
            Inventory
    );
    
-- Q47 List the names of suppliers whose registration city is the same as the city of the ’TVS Supply Chain Point’ warehouse. (Scalar Subquery)
SELECT
    supplier_name
FROM
    Suppliers
WHERE
    registration_city = (
        -- Scalar Subquery: Finds the single city value for the target warehouse
        SELECT
            city
        FROM
            Warehouses
        WHERE
            warehouse_name = 'TVS Supply Chain Point'
    );

-- Q48 Find the shipments where the ’shipping_cost’ is higher than the average shipping cost for ALL shipments. (Scalar Subquery)
SELECT
    shipment_id,
    shipping_cost,
    status
FROM
    Shipments
WHERE
    shipping_cost > (
        -- Scalar Subquery: Calculates the single average cost of all shipments
        SELECT
            AVG(shipping_cost)
        FROM
            Shipments
    );

-- Q49 List the product names whose total stock quantity (sum of stock across all warehouses) is greater than 1200. (Subquery in HAVING)
SELECT
    P.product_name,
    SUM(I.stock_quantity) AS Total_Stock
FROM
    Inventory I
INNER JOIN
    Products P ON I.product_id = P.product_id
GROUP BY
    P.product_name
HAVING
    SUM(I.stock_quantity) > 1200
ORDER BY
    Total_Stock DESC;

-- Q50 Find the products (names) that have never been shipped. (Subquery with NOT IN)
SELECT
    product_name
FROM
    Products
WHERE
    product_id NOT IN (
        -- Subquery: Finds the IDs of all products that HAVE been shipped
        SELECT
            product_id
        FROM
            Shipments
    );

   
  



        



    

   




