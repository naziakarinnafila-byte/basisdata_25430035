CREATE DATABASE IF NOT EXISTS kopma_123
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'tamu_123'@'localhost'
IDENTIFIED BY 'password123';

GRANT SELECT ON kopma_123.* TO 'tamu_123'@'localhost';