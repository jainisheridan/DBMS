CREATE DATABASE midtermpractical_jaini;
USE midtermpractical_jaini;

CREATE TABLE countries (
    countryName VARCHAR(255) NOT NULL,
    population INT CHECK (population > 0),
    capital VARCHAR(255)
);

INSERT INTO countries (name, population, capital)
VALUES
('China', 1382, 'Beijing'),
('India', 1326, 'Delhi'),
('United States', 324, 'Washington D.C.'),
('Indonesia', 260, 'Jakarta'),
('Brazil', 209, 'Brasilia'),
('Pakistan', 193, 'Islamabad'),
('Nigeria', 187, 'Abuja'),
('Bangladesh', 163, 'Dhaka'),
('Russia', 143, 'Moscow'),
('Mexico', 128, 'Mexico City'),
('Japan', 126, 'Tokyo'),
('Philippines', 102, 'Manila'),
('Ethiopia', 101, 'Addis Ababa'),
('Vietnam', 94, 'Hanoi'),
('Egypt', 0, 'Cairo'),
('Germany', 81, 'Berlin'),
('Iran', 80, 'Tehran'),
('Turkey', 79, 'Ankara'),
('Congo', 79, 'Kinshasa'),
('France', 64, 'Paris'),
('United Kingdom', 65, 'London'),
('Italy', 60, 'Rome'),
('South Africa', 55, 'Pretoria'),
('Myanmar', 54, 'Naypyidaw');

ALTER TABLE countries CHANGE name countryName VARCHAR(255);

RENAME TABLE countries TO bigCountries;

CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    supplier_id INT,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);

CREATE TABLE Suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(255) NOT NULL UNIQUE,
    location VARCHAR(255)
);

CREATE TABLE Stock (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    balance_stock INT,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

ALTER TABLE Suppliers
MODIFY COLUMN supplier_name VARCHAR(255) NOT NULL UNIQUE;

ALTER TABLE Products
ADD COLUMN prod_rating DECIMAL(3, 1) DEFAULT 5.0;







