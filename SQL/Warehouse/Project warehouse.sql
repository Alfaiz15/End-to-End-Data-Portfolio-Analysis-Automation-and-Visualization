-- Database & Struktur Utama
-- 1. Buat database baru
DROP DATABASE IF EXISTS warehouse_db;
CREATE DATABASE warehouse_db;
USE warehouse_db;

-- 2. Tabel utama
CREATE TABLE warehouses (
  warehouse_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  city VARCHAR(100),
  capacity_kg INT
);

CREATE TABLE suppliers (
  supplier_id INT AUTO_INCREMENT PRIMARY KEY,
  supplier_name VARCHAR(150),
  city VARCHAR(100),
  contact VARCHAR(50)
);

CREATE TABLE customers (
  customer_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_name VARCHAR(150),
  city VARCHAR(100),
  phone VARCHAR(20)
);

CREATE TABLE products (
  product_id INT AUTO_INCREMENT PRIMARY KEY,
  sku VARCHAR(50),
  product_name VARCHAR(150),
  category VARCHAR(100),
  weight_kg DECIMAL(6,2)
);

CREATE TABLE inventory (
  inventory_id INT AUTO_INCREMENT PRIMARY KEY,
  warehouse_id INT,
  product_id INT,
  quantity INT,
  last_update DATETIME,
  FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);


-- Data Dummy (Simulasi Real)
-- Warehouse
INSERT INTO warehouses (name, city, capacity_kg) VALUES
('WH Jakarta', 'Jakarta', 100000),
('WH Bandung', 'Bandung', 80000),
('WH Surabaya', 'Surabaya', 120000);

-- Suppliers
INSERT INTO suppliers (supplier_name, city, contact) VALUES
('PT Sumber Makmur', 'Jakarta', '021-123456'),
('CV Global Steel', 'Surabaya', '031-789101');

-- Customers
INSERT INTO customers (customer_name, city, phone) VALUES
('PT Cahaya Abadi', 'Bekasi', '081234567890'),
('UD Sinar Jaya', 'Bandung', '082233445566');

-- Products
INSERT INTO products (sku, product_name, category, weight_kg) VALUES
('SKU-001', 'Battery 12V', 'Electronics', 1.5),
('SKU-002', 'Steel Rod 2m', 'Hardware', 10.0),
('SKU-003', 'Cardboard Box', 'Packaging', 0.5);

-- Inventory
INSERT INTO inventory (warehouse_id, product_id, quantity, last_update) VALUES
(1,1,500,'2025-01-10 10:00:00'),
(1,2,300,'2025-01-10 10:00:00'),
(2,3,1000,'2025-01-11 11:30:00'),
(3,1,200,'2025-01-12 09:00:00');

-- Shipments (barang masuk & keluar)
-- Header shipment
CREATE TABLE shipments (
  shipment_id INT AUTO_INCREMENT PRIMARY KEY,
  shipment_type ENUM('IN','OUT'),
  warehouse_id INT,
  partner_id INT,
  partner_type ENUM('SUPPLIER','CUSTOMER'),
  ship_date DATE,
  delivery_date DATE,
  cost DECIMAL(12,2),
  status ENUM('Pending','Delivered','Cancelled'),
  FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id)
);

-- Detail barang dalam shipment
CREATE TABLE shipment_lines (
  line_id INT AUTO_INCREMENT PRIMARY KEY,
  shipment_id INT,
  product_id INT,
  quantity INT,
  unit_price DECIMAL(10,2),
  FOREIGN KEY (shipment_id) REFERENCES shipments(shipment_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Contoh data shipment
INSERT INTO shipments (shipment_type, warehouse_id, partner_id, partner_type, ship_date, delivery_date, cost, status)
VALUES
('IN', 1, 1, 'SUPPLIER', '2025-01-05', '2025-01-06', 1500000, 'Delivered'),
('OUT', 1, 1, 'CUSTOMER', '2025-01-10', '2025-01-11', 250000, 'Delivered'),
('OUT', 2, 2, 'CUSTOMER', '2025-01-15', '2025-01-16', 400000, 'Delivered');

INSERT INTO shipment_lines (shipment_id, product_id, quantity, unit_price) VALUES
(1, 1, 100, 10000),   -- IN: restock Battery
(2, 1, 10, 15000),    -- OUT: 10 battery ke customer
(3, 3, 50, 5000);     -- OUT: 50 box ke customer

-- Shipment IN = barang masuk dari supplier
-- Shipment OUT = barang keluar ke customer

-- Query Analisis (All Levels)
-- Semua produk & stok di setiap warehouse
SELECT w.name AS warehouse, p.product_name, i.quantity
FROM inventory i
JOIN warehouses w ON i.warehouse_id = w.warehouse_id
JOIN products p ON i.product_id = p.product_id
ORDER BY w.name;

-- Total pengiriman keluar per gudang
SELECT w.name AS warehouse, COUNT(s.shipment_id) AS total_out
FROM shipments s
JOIN warehouses w ON s.warehouse_id = w.warehouse_id
WHERE s.shipment_type = 'OUT'
GROUP BY w.warehouse_id;

-- Total pendapatan per produk
SELECT p.product_name, SUM(sl.quantity * sl.unit_price) AS total_value
FROM shipment_lines sl
JOIN shipments s ON sl.shipment_id = s.shipment_id
JOIN products p ON sl.product_id = p.product_id
WHERE s.shipment_type = 'OUT'
GROUP BY p.product_name
ORDER BY total_value DESC;

-- Performa gudang (revenue - cost)
WITH revenue AS (
  SELECT warehouse_id, SUM(cost) AS total_revenue
  FROM shipments WHERE shipment_type = 'OUT'
  GROUP BY warehouse_id
),
expense AS (
  SELECT warehouse_id, SUM(cost) AS total_expense
  FROM shipments WHERE shipment_type = 'IN'
  GROUP BY warehouse_id
)
SELECT w.name,
       COALESCE(r.total_revenue,0) - COALESCE(e.total_expense,0) AS net_profit
FROM warehouses w
LEFT JOIN revenue r ON w.warehouse_id = r.warehouse_id
LEFT JOIN expense e ON w.warehouse_id = e.warehouse_id;


-- Advanced (Automation & View)
-- Buat View stok rendah ! 
CREATE OR REPLACE VIEW vw_low_stock AS
SELECT w.name AS warehouse, p.product_name, i.quantity
FROM inventory i
JOIN products p ON i.product_id = p.product_id
JOIN warehouses w ON i.warehouse_id = w.warehouse_id
WHERE i.quantity < 100;

-- Stored Procedure update stok otomatis
DELIMITER //
CREATE PROCEDURE sp_update_stock(
  IN p_warehouse INT,
  IN p_product INT,
  IN p_qty INT
)
BEGIN
  IF EXISTS (SELECT 1 FROM inventory WHERE warehouse_id = p_warehouse AND product_id = p_product) THEN
    UPDATE inventory
    SET quantity = quantity + p_qty, last_update = NOW()
    WHERE warehouse_id = p_warehouse AND product_id = p_product;
  ELSE
    INSERT INTO inventory (warehouse_id, product_id, quantity, last_update)
    VALUES (p_warehouse, p_product, p_qty, NOW());
  END IF;
END //
DELIMITER ;

-- 🚀 HASIL AKHIR
-- Database warehouse_db
-- 8 tabel fungsional
-- Data simulasi realistis
-- Query dari dasar → mahir
-- View untuk monitoring stok rendah

-- Procedure untuk automation update stok

