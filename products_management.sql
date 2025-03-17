CREATE DATABASE products_management
USE products_management
CREATE TABLE brands (
    `brand_id` BIGINT PRIMARY KEY,
    `brand_name` VARCHAR(255) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE products
CREATE TABLE products (
    `product_id` BIGINT PRIMARY KEY,
    `brand_id` BIGINT NOT NULL,
    `attribute_id` BIGINT NOT NULL,
    `category_id` BIGINT NOT NULL,
    `variation_id` BIGINT NOT NULL,
    `product_name` VARCHAR(255) NOT NULL,
    `description` TEXT,
    `price` DECIMAL(10,2) NOT NULL,
    `discount_price` DECIMAL(10,2) DEFAULT NULL,
    `stock` ENUM('In Stock', 'Out of Stock') NOT NULL DEFAULT 'In Stock',
    `status` ENUM('Active', 'Inactive') NOT NULL DEFAULT 'Active',
    `thumbnail` VARCHAR(255),
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`brand_id`) REFERENCES brands(`brand_id`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`attribute_id`) REFERENCES attributes(`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`category_id`) REFERENCES categories(`category_id`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`variation_id`) REFERENCES variations(`variation_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE attribute_sets (
    `attribute_set_id` BIGINT PRIMARY KEY,
    `attribute_set_name` VARCHAR(255) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE attributes (
    `attribute_id` BIGINT PRIMARY KEY,
    `attribute_set_id` BIGINT NOT NULL,
    `attribute_name` VARCHAR(255) NOT NULL,
    `url` VARCHAR(255) NOT NULL,
    `filterable` BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (`attribute_set_id`) REFERENCES attribute_sets(`attribute_set_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE attribute_values (
	`attribute_value_id`  BIGINT PRIMARY KEY,
	`attribute_id` BIGINT NOT NULL,
	`value` TEXT NOT NULL, 
	FOREIGN KEY (`attribute_id`) REFERENCES attributes(`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE categories (
    `category_id` BIGINT PRIMARY KEY,
    `parent_id` BIGINT DEFAULT NULL,
    `category_name` VARCHAR(255) NOT NULL,
    FOREIGN KEY (`parent_id`) REFERENCES categories(`category_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE attribute_categories (
    `attribute_id` BIGINT NOT NULL,
    `category_id` BIGINT NOT NULL,
    PRIMARY KEY (`attribute_id`, `category_id`),
    FOREIGN KEY (`attribute_id`) REFERENCES attributes(`attribute_id`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`category_id`) REFERENCES categories(`category_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE variations (
    `variation_id` BIGINT PRIMARY KEY,
    `variation_name` VARCHAR(255) NOT NULL,
    `type` ENUM('Text', 'Color', 'Image') NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE variation_values (
    `variation_value_id` BIGINT PRIMARY KEY,
    `variation_id` BIGINT NOT NULL,
    `label` VARCHAR(255) NOT NULL,
    `color` VARCHAR(7) DEFAULT NULL,  -- Mã màu HEX 
    `image` VARCHAR(255), -- link ảnh
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (variation_id) REFERENCES variations(variation_id) ON DELETE CASCADE
);


-- Bảng brands
INSERT INTO brands (brand_id, brand_name) VALUES
(1, 'Apple'),
(2, 'Samsung'),
(3, 'Sony'),
(4, 'LG'),
(5, 'Xiaomi');

-- Bảng attribute_sets
INSERT INTO attribute_sets (attribute_set_id, attribute_set_name) VALUES
(1, 'General Attributes'),
(2, 'Phone Features'),
(3, 'Laptop Features'),
(4, 'TV Features'),
(5, 'Tablet Features');

-- Bảng attributes
INSERT INTO attributes (attribute_id, attribute_set_id, attribute_name, url, filterable) VALUES
(1, 1, 'Color', 'color', TRUE),
(2, 1, 'Size', 'size', TRUE),
(3, 2, 'Battery Life', 'battery-life', FALSE),
(4, 3, 'Processor', 'processor', FALSE),
(5, 4, 'Screen Type', 'screen-type', TRUE);

-- Bảng attribute_values
INSERT INTO attribute_values (attribute_value_id, attribute_id, value) VALUES
(1, 1, 'Red'),
(2, 1, 'Blue'),
(3, 2, 'Large'),
(4, 2, 'Medium'),
(5, 3, '4000mAh');

-- Bảng categories
INSERT INTO categories (category_id, parent_id, category_name) VALUES
(1, NULL, 'Electronics'),
(2, 1, 'Smartphones'),
(3, 1, 'Laptops'),
(4, 1, 'Televisions'),
(5, 2, 'Android Phones');

-- Bảng attribute_categories
INSERT INTO attribute_categories (attribute_id, category_id) VALUES
(1, 2),
(2, 2),
(3, 3),
(4, 3),
(5, 4);

-- Bảng variations
INSERT INTO variations (variation_id, variation_name, type) VALUES
(1, 'Color', 'Color'),
(2, 'Size', 'Text'),
(3, 'Storage', 'Text'),
(4, 'RAM', 'Text'),
(5, 'Material', 'Text');

-- Bảng variation_values
INSERT INTO variation_values (variation_value_id, variation_id, label, color, image) VALUES
(1, 1, 'Black', '#000000', NULL),
(2, 1, 'White', '#FFFFFF', NULL),
(3, 2, 'Small', NULL, NULL),
(4, 2, 'Medium', NULL, NULL),
(5, 3, '128GB', NULL, NULL);

-- Bảng products
INSERT INTO products (product_id, brand_id, attribute_id, category_id, variation_id, product_name, description, price, discount_price, stock, status, thumbnail) VALUES
(1, 1, 1, 2, 1, 'iPhone 14', 'Latest Apple iPhone', 999.99, 899.99, 'In Stock', 'Active', 'iphone14.jpg'),
(2, 2, 2, 5, 2, 'Samsung Galaxy S23', 'Latest Samsung flagship', 799.99, 699.99, 'In Stock', 'Active', 's23.jpg'),
(3, 3, 3, 3, 3, 'Sony Vaio Laptop', 'High-end laptop', 1200.00, 1100.00, 'In Stock', 'Active', 'vaio.jpg'),
(4, 4, 4, 4, 4, 'LG OLED TV', '4K Smart TV', 1500.00, NULL, 'In Stock', 'Active', 'lg_oled.jpg'),
(5, 5, 5, 2, 5, 'Xiaomi Mi 11', 'Affordable flagship', 599.99, 499.99, 'In Stock', 'Active', 'mi11.jpg');
