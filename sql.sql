CREATE DATABASE IF NOT EXISTS cloudcell_db;
USE cloudcell_db;
-- 1. Customers Table
CREATE TABLE IF NOT EXISTS Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    address VARCHAR(255),
    password VARCHAR(256) NOT NULL DEFAULT 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855', -- SHA256 of empty string (users will update this on signup)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- 2. Packages Table
CREATE TABLE IF NOT EXISTS Packages (
    package_id INT AUTO_INCREMENT PRIMARY KEY,
    package_name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    validity_period VARCHAR(50) NOT NULL
);
-- 3. Reloads Table
CREATE TABLE IF NOT EXISTS Reloads (
    reload_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    package_id INT,
    amount DECIMAL(10, 2) NOT NULL,
    reload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    otp_code VARCHAR(10),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (package_id) REFERENCES Packages(package_id) ON DELETE SET NULL
);
-- 4. Billing Table
CREATE TABLE IF NOT EXISTS Billing (
    bill_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    bill_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'Unpaid', -- 'Paid' or 'Unpaid'
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE
);
-- 5. BankDetails Table
CREATE TABLE IF NOT EXISTS BankDetails (
    bank_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    bank_name VARCHAR(100) NOT NULL,
    account_number VARCHAR(50) NOT NULL,
    ifsc_code VARCHAR(20) NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE
);
-- 6. Admin Table
CREATE TABLE IF NOT EXISTS Admin (
    admin_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(256) NOT NULL, -- Hashed password
    role VARCHAR(50) NOT NULL DEFAULT 'Admin', -- 'SuperAdmin', 'Admin'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- Sample Data Inserts
-- Customers (Default Password for testing: 'password123' -> SHA256: 'ef92b778bafe445587f57f074b6ecb2c3858f4d404c5e8654b171effe994080a')
INSERT INTO Customers (name, email, phone, address, password, created_at)
VALUES
('John Silva', 'john.silva@example.com', '0771234567', 'Colombo, Sri Lanka', 'ef92b778bafe445587f57f074b6ecb2c3858f4d404c5e8654b171effe994080a', NOW()),
('Amaya Perera', 'amaya.perera@example.com', '0719876543', 'Kandy, Sri Lanka', 'ef92b778bafe445587f57f074b6ecb2c3858f4d404c5e8654b171effe994080a', NOW());
-- Packages
INSERT INTO Packages (package_name, description, price, validity_period)
VALUES
('Data Pack 5GB', '5GB mobile data valid for 30 days', 500.00, '30 days'),
('Unlimited Calls', 'Unlimited local calls valid for 7 days', 300.00, '7 days'),
('Super Triple Combo', '10GB data, 1000 mins voice, 1000 SMS valid for 30 days', 999.00, '30 days'),
('Social Pack', 'Unlimited YouTube, WhatsApp, and Facebook valid for 30 days', 350.00, '30 days');
-- Reloads
INSERT INTO Reloads (customer_id, package_id, amount, reload_date, otp_code)
VALUES
(1, 1, 500.00, NOW(), 'OTP123'),
(2, 2, 300.00, NOW(), 'OTP456');
-- Billing
INSERT INTO Billing (customer_id, total_amount, bill_date, status)
VALUES
(1, 500.00, NOW(), 'Paid'),
(2, 300.00, NOW(), 'Unpaid'),
(1, 1250.00, DATE_SUB(NOW(), INTERVAL 1 MONTH), 'Paid'),
(1, 600.00, DATE_SUB(NOW(), INTERVAL 2 MONTH), 'Paid'),
(2, 450.00, DATE_SUB(NOW(), INTERVAL 1 MONTH), 'Unpaid');
-- BankDetails
INSERT INTO BankDetails (customer_id, bank_name, account_number, ifsc_code, updated_at)
VALUES
(1, 'Bank of Ceylon', '1234567890', 'BOC001', NOW()),
(2, 'Commercial Bank', '9876543210', 'COM002', NOW());
-- Admin (Default Password: 'admin123' -> SHA256: '2407891877f859a48b112fe944552fe47790b8f4ed792bfde8f7eec03d274786')
INSERT INTO Admin (username, password, role, created_at)
VALUES
('admin', '2407891877f859a48b112fe944552fe47790b8f4ed792bfde8f7eec03d274786', 'SuperAdmin', NOW());

SELECT * FROM cloudcell_db.Reloads ORDER BY reload_date DESC;
SELECT * FROM cloudcell_db.Billing ORDER BY bill_date DESC;
SELECT * FROM cloudcell_db.Customers ORDER BY created_at DESC;
SELECT reload_id, customer_id, amount, reload_date, otp_code 
FROM cloudcell_db.Reloads;
