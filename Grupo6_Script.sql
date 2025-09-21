-- ¿Cuántos registros existen en la tabla de clientes? --

SELECT 
    COUNT(*) AS total_clientes
FROM
    customers;
    
    -- 2 # ¿Cuántas facturas hay registradas en total?--
    
SELECT 
    COUNT(*) AS total_facturas
FROM
    invoices;
    
    -- #3 ¿Cuántos productos diferentes están disponibles? -- 
SELECT 
    COUNT(*) AS total_productos
FROM
    products;
    
    -- #4 Muestra la estructura de la tabla de detalles de facura (campos y tipos de datos).--
    
 DESCRIBE invoice_items;
 
 -- 5 
 SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS nombre_cliente,
    SUM(ii.amount) AS monto_total
FROM customers c
INNER JOIN invoices i ON c.customer_id = i.customer_id
INNER JOIN invoice_items ii ON i.invoice_id = ii.invoice_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY monto_total DESC
LIMIT 1;
 
 -- 6 -- 
 
 SELECT 
    c.city,
    COUNT(i.invoice_id) AS num_facturas
FROM customers c
INNER JOIN invoices i ON c.customer_id = i.customer_id
GROUP BY c.city
ORDER BY num_facturas DESC
LIMIT 5;


-- 7 --

SELECT 
    cat.category_name,
    SUM(ii.amount) AS monto_total
FROM categories cat
INNER JOIN products p ON cat.category_id = p.category_id
INNER JOIN invoice_items ii ON p.product_id = ii.product_id
INNER JOIN invoices i ON ii.invoice_id = i.invoice_id
GROUP BY cat.category_id, cat.category_name
ORDER BY monto_total DESC
LIMIT 1;
 
 -- 8 --
 
SELECT 
    pro.product_id,
    pro.product_name,
    SUM(ini.qty) AS total_unidades
FROM
    invoice_items ini
        JOIN
    products pro ON ini.product_id = pro.product_id
GROUP BY pro.product_id , pro.product_name
ORDER BY total_unidades DESC
LIMIT 1;

-- 9 --

SELECT YEAR(invoice_date) AS año, MONTH(invoice_date) AS mes, COUNT(*) AS total_facturas
FROM invoices
GROUP BY año, mes
ORDER BY año, mes;

-- 10 --

SELECT COUNT(*) as  clientes_multicat
FROM (
      SELECT i.customer_id,COUNT(DISTINCT p.category_id) AS num_categorias
      FROM invoices i
      JOIN invoice_items ic ON ic.invoice_id = i.invoice_id
      JOIN products p ON p.product_id = ic.product_id
      GROUP BY i.customer_id 
      HAVING  COUNT(DISTINCT p.category_id) > 1
      ) t;
      
      -- preguntas propias -- 
      
-- ¿Cuál es el cliente que ha comprado más productos diferentes?
-- 1
SELECT c.customer_id, c.first_name, c.last_name, COUNT(DISTINCT ii.product_id) AS productos_distintos
FROM customers c
JOIN invoices i ON c.customer_id = i.customer_id
JOIN invoice_items ii ON i.invoice_id = ii.invoice_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY productos_distintos DESC
LIMIT 1;

-- ¿Cuál es el promedio de ventas por factura en cada ciudad y qué ciudades concentran los valores más altos?
-- 2
SELECT c.city,
       ROUND(AVG(ii.amount), 2) AS Promedio_Ventas_USD
FROM customers c
JOIN invoices i ON c.customer_id = i.customer_id
JOIN invoice_items ii ON i.invoice_id = ii.invoice_id
GROUP BY c.city
ORDER BY Promedio_Ventas_USD DESC
LIMIT 5;

-- ¿Cuales son las ciudades que generan más ingresos con mas de 2 clientes?
-- 3
SELECT 
    c.city,
    COUNT(DISTINCT c.customer_id) AS total_clientes,
    COUNT(DISTINCT i.invoice_id) AS total_facturas,
    SUM(ini.amount) AS gasto_total_cliente
FROM customers c
JOIN invoices i ON c.customer_id = i.customer_id
JOIN invoice_items ini ON i.invoice_id = ini.invoice_id
GROUP BY c.city
HAVING total_clientes > 2
ORDER BY gasto_total_cliente DESC;

-- ¿Cuál es el día de la semana con mayor volumen de ventas y existe diferencia significativa entre fines de semana y días laborables?
-- 4
SELECT 
    DAYNAME(i.invoice_date) AS dia_semana,
    COUNT(i.invoice_id) AS num_facturas,
    SUM(ic.qty * ic.amount) AS ventas_totales
FROM invoices i
JOIN invoice_items ic ON ic.invoice_id = i.invoice_id
GROUP BY dia_semana
ORDER BY ventas_totales DESC;

-- ¿Qué productos generan la mayor rentabilidad total y cómo se compara su volumen de ventas con su margen de ganancia?
-- 5
SELECT p.product_id,
       p.product_name,
       SUM(ii.qty) AS unidades_vendidas,
       SUM(ii.amount) AS ventas_totales
FROM invoice_items ii
JOIN products p ON p.product_id = ii.product_id
GROUP BY p.product_id, p.product_name
ORDER BY SUM(ii.qty) DESC
LIMIT 10;



