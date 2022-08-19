-- 7. Write a query to display carton id, (len*width*height) as carton_vol and identify the optimum carton (carton with the least volume whose volume is greater than the total volume of all items (len * width * height * product_quantity)) for a given order whose order id is 10006, Assume all items of an order are packed into one single carton (box). (1 ROW) [NOTE: CARTON TABLE]

SELECT C.CARTON_ID AS Carton_ID,(C.LEN*C.WIDTH*C.HEIGHT) as Carton_Volume
FROM ORDERS.CARTON C
WHERE (C.LEN*C.WIDTH*C.HEIGHT) >= (SELECT SUM(P.LEN*P.WIDTH*P.HEIGHT*OI.PRODUCT_QUANTITY) AS PART_VOLUME  # Calculating Product volume and comparing with Carton volume
FROM ORDERS.ORDER_ITEMS OI
INNER JOIN ORDERS.PRODUCT P ON OI.PRODUCT_ID = P.PRODUCT_ID
WHERE OI.ORDER_ID =10006)  # Selecting Order ID 10006
ORDER BY Carton_Volume ASC
LIMIT 1;

-- 8. Write a query to display details (customer id,customer fullname,order id,product quantity) of customers who bought more than ten (i.e. total order qty) products per shipped order. (11 ROWS) [NOTE: TABLES TO BE USED - online_customer, order_header, order_items,]

SELECT OC.CUSTOMER_ID AS Customer_ID,CONCAT(OC.CUSTOMER_FNAME,' ',OC.CUSTOMER_LNAME) AS Customer_FullName,
OH.ORDER_ID AS Order_ID,OI.PRODUCT_QUANTITY,SUM(OI.PRODUCT_QUANTITY) AS Total_Product_order_Quantity
FROM ORDERS.ONLINE_CUSTOMER OC
INNER JOIN ORDERS.ORDER_HEADER OH ON OH.CUSTOMER_ID = OC.CUSTOMER_ID
INNER JOIN ORDERS.ORDER_ITEMS OI ON OI.ORDER_ID = OH.ORDER_ID
WHERE OH.ORDER_STATUS = 'Shipped' # Selecting Shipped orders
GROUP BY OH.ORDER_ID
HAVING Total_Product_order_Quantity > 10 # Selecting only data where Total product order quantity is more than 10 ORDER BY Total_Product_order_Quantity;

-- 9.	Write a query to display the order_id, customer id and cutomer full name of customers along with (product_quantity) as total quantity of products shipped for order ids > 10060. (6 ROWS) [NOTE: TABLES TO BE USED - online_customer, order_header, order_items]

SELECT OH.ORDER_ID,OC.CUSTOMER_ID,CONCAT(CUSTOMER_FNAME,' ',CUSTOMER_LNAME) AS Customer_FullName,
SUM(OI.PRODUCT_QUANTITY) AS Total_Product_Quantity
FROM ORDERS.ONLINE_CUSTOMER OC
INNER JOIN ORDERS.ORDER_HEADER OH ON OH.CUSTOMER_ID = OC.CUSTOMER_ID
INNER JOIN ORDERS.ORDER_ITEMS OI ON OI.ORDER_ID = OH.ORDER_ID
WHERE OH.ORDER_STATUS = 'Shipped' AND OH.ORDER_ID > 10060 # Selecting Shipped orders with order ID more than 10060
GROUP BY OH.ORDER_ID
ORDER BY ORDER_ID;


-- 10.	Write a query to display product class description ,total quantity (sum(product_quantity),Total value (product_quantity * product price) and show which class of products have been shipped highest(Quantity) to countries outside India other than USA? Also show the total value of those items. (1 ROWS)[NOTE:PRODUCT TABLE,ADDRESS TABLE,ONLINE_CUSTOMER TABLE,ORDER_HEADER TABLE,ORDER_ITEMS TABLE,PRODUCT_CLASS TABLE]

SELECT PC.PRODUCT_CLASS_CODE,PC.PRODUCT_CLASS_DESC,
SUM(OI.PRODUCT_QUANTITY) AS Total_Quantity,SUM(OI.PRODUCT_QUANTITY*P.PRODUCT_PRICE) AS Total_Value FROM ORDERS.ORDER_ITEMS OI
INNER JOIN ORDERS.ORDER_HEADER OH ON OH.ORDER_ID = OI.ORDER_ID
INNER JOIN ORDERS.ONLINE_CUSTOMER OC ON OC.CUSTOMER_ID = OH.CUSTOMER_ID
INNER JOIN ORDERS.PRODUCT P ON P.PRODUCT_ID = OI.PRODUCT_ID
INNER JOIN ORDERS.PRODUCT_CLASS PC ON PC.PRODUCT_CLASS_CODE = P.PRODUCT_CLASS_CODE
INNER JOIN ORDERS.ADDRESS A ON A.ADDRESS_ID = OC.ADDRESS_ID
WHERE OH.ORDER_STATUS ='Shipped' AND A.COUNTRY NOT IN('India','USA') # Selecting Shipped orders from contries other than India & USA
GROUP BY PC.PRODUCT_CLASS_CODE,PC.PRODUCT_CLASS_DESC
ORDER BY Total_Quantity DESC # Order to get highest Quantity
LIMIT 1;
