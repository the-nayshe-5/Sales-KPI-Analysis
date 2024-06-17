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

SELECT * FROM product_sales_1;

-- Details with cumulative values for each Product Type
INSERT INTO product_sales_combined
SELECT DISTINCT(`Product Type`), SUM(`Net Quantity`),
SUM(`Gross Sales`), SUM(`Discounts`), SUM(`Returns`),
SUM(`Total Net Sales`) 
FROM product_sales_1
GROUP BY `Product Type`;

SELECT * FROM product_sales_combined;


-- Average Values for each Product Type
CREATE TABLE `product_sales_c2` (
  `Product_Type` text,
  `Net_Quantity` int DEFAULT NULL,
  `Avg_Gross_Sales_PP` double DEFAULT NULL,
  `Avg_Discounts_PP` double DEFAULT NULL,
  `Avg_Returns_PP` int DEFAULT NULL,
  `Avg_Net_Sales_PP` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO product_sales_c2
SELECT p1.Product_Type, p1.Net_Quantity,
(p1.Gross_Sales/p1.Net_Quantity), (p1.Discounts/p1.Net_Quantity),
(p1.Avg_Returns_PP/p1.Net_Quantity), (p1.Total_Net_Sales/p1.Net_Quantity)
FROM product_sales_combined p1 JOIN product_sales_combined p2
ON p1.Product_Type = p2.Product_Type
WHERE p1.Product_Type = p2.Product_Type;

SELECT * FROM product_sales_c2;
SELECT * FROM product_sales_1;
SELECT * FROM product_sales_combined;

-- Calculating price of each Product Type
SELECT * FROM product_sales_1
WHERE `Returns` = 0 AND `Discounts` = 0;

SELECT *, (`Gross Sales`/`Net Quantity`) AS Price FROM product_sales_1
ORDER BY 1;

SELECT *, 
(`Gross Sales`/`Net Quantity`) AS Price,
ROW_NUMBER() OVER(PARTITION BY `Product type`, (`Gross Sales`/`Net Quantity`)) AS Type_No 
FROM product_sales_1
ORDER BY 1;

-- No. of returns for each product
SELECT *, (`Gross Sales`/`Net Quantity`) AS Price, 
(`Returns`/(`Gross Sales`/`Net Quantity`)) AS No_of_Returns
FROM product_sales_1
WHERE `Returns` != 0
ORDER BY 1;

-- Return Rates of Products
SELECT Product_Type, ROUND((`Returns`/Total_Net_Sales)*100,2) AS Avg_Return_Rate 
FROM product_sales_combined;

SELECT * FROM product_sales_c2;
SELECT * FROM product_sales_1;
SELECT * FROM product_sales_combined;

-- Max and Min Total Net Sales for each Product Type
SELECT DISTINCT(`Product Type`), MAX(`Total Net Sales`), MIN(`Total Net Sales`)
FROM product_sales_1
GROUP BY `Product Type`;

-- Max and Min Total Net Sales Overall
SELECT MAX(`Total Net Sales`), MIN(`Total Net Sales`)
FROM product_sales_1;


