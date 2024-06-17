-- PRODUCT SALES

SELECT * FROM product_sales;

CREATE TABLE `product_sales_1` (
  `Product Type` text,
  `Net Quantity` int DEFAULT NULL,
  `Gross Sales` double DEFAULT NULL,
  `Discounts` double DEFAULT NULL,
  `Returns` int DEFAULT NULL,
  `Total Net Sales` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO product_sales_1
SELECT * FROM product_sales;

-- 1. Remove duplicates

SELECT *, ROW_NUMBER() OVER(PARTITION BY `Product Type`, `Net Quantity`, `Gross Sales`, `Discounts`, `Returns`, `Total Net Sales`)
AS row_num
FROM product_sales_1
WHERE row_num > 1;