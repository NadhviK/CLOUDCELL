CREATE DATABASE mobile_app;

USE mobile_app;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    phone_number VARCHAR(15) UNIQUE NOT NULL,
    password VARCHAR(50) NOT NULL,
    balance DECIMAL(10,2) DEFAULT 0,
    data_remaining VARCHAR(20) DEFAULT '0MB'
);

INSERT INTO users (phone_number, password, balance, data_remaining)
VALUES ('0771234567', 'mypassword', 500.00, '2GB');
