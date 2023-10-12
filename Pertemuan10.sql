CREATE PROCEDURE Sales.GetTopCustomers 
AS
SELECT TOP(10) c.custid, c.contactname,
SUM(o.val) AS salesvalue 
FROM Sales.OrderValues AS o 
INNER JOIN Sales.Customers AS c 
ON c.custid = o.custid 
GROUP BY c.custid, c.contactname 
ORDER BY salesvalue DESC;

/*NOMOR 1*/
EXEC Sales.GetTopCustomers;

ALTER PROCEDURE Sales.GetTopCustomers 
AS
SELECT c.custid, c.contactname,
SUM(o.val) AS salesvalue 
FROM Sales.OrderValues AS o 
INNER JOIN Sales.Customers AS c 
ON c.custid = o.custid 
GROUP BY c.custid, c.contactname 
ORDER BY salesvalue DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

EXEC Sales.GetTopCustomers;


ALTER PROCEDURE Sales.GetTopCustomers 
@orderyear int
AS
SELECT c.custid, c.contactname, 
SUM(o.val) AS salesvalue 
FROM Sales.OrderValues AS o 
INNER JOIN Sales.Customers AS c 
ON c.custid = o.custid 
WHERE YEAR(o.orderdate) = @orderyear 
GROUP BY c.custid, c.contactname 
ORDER BY salesvalue DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

EXEC Sales.GetTopCustomers @orderyear = '2007';

EXEC Sales.GetTopCustomers @orderyear = '2008';

EXEC Sales.GetTopCustomers;


ALTER PROCEDURE Sales.GetTopCustomers 
@orderyear int = NULL
AS
SELECT c.custid, c.contactname, 
SUM(o.val) AS salesvalue 
FROM Sales.OrderValues AS o 
INNER JOIN Sales.Customers AS c 
ON c.custid = o.custid 
WHERE YEAR(o.orderdate) = @orderyear 
OR @orderyear IS NULL
GROUP BY c.custid, c.contactname 
ORDER BY salesvalue DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

EXEC Sales.GetTopCustomers;

ALTER PROCEDURE Sales.GetTopCustomers 
@orderyear int = NULL, 
@n int = 10 
AS
SELECT c.custid, c.contactname, 
SUM(o.val) AS salesvalue 
FROM Sales.OrderValues AS o 
INNER JOIN Sales.Customers AS c 
ON c.custid = o.custid 
WHERE YEAR(o.orderdate) = @orderyear 
OR
@orderyear IS NULL
GROUP BY c.custid, c.contactname 
ORDER BY salesvalue DESC
OFFSET 0 ROWS FETCH NEXT @n ROWS ONLY;

EXEC Sales.GetTopCustomers;

EXEC Sales.GetTopCustomers 
@orderyear = '2008',
@n = '5';

EXEC Sales.GetTopCustomers @orderyear = '2007';

EXEC Sales.GetTopCustomers @n = '20';

ALTER PROCEDURE Sales.GetTopCustomers 
@customerpos int = 1, 
@customername nvarchar(30) OUTPUT
AS
SET @customername = ( 
SELECT c.contactname 
FROM Sales.OrderValues AS o 
INNER JOIN Sales.Customers AS c 
ON c.custid = o.custid 
GROUP BY c.custid, c.contactname 
ORDER BY SUM(o.val) DESC 
OFFSET @customerpos - 1 ROWS FETCH NEXT 1 ROW ONLY 
);

DECLARE @outcustomername nvarchar(30);

EXEC Sales.GetTopCustomers @customerpos = '1', 
@customername = @outcustomername OUTPUT;

SELECT @outcustomername AS customername;

EXEC sys.sp_help;

EXEC sys.sp_help  N'Sales.Customers';

EXEC sys.sp_helptext N'Sales.GetTopCustomers';

EXEC sys.sp_columns
@table_name ='Customers',
@table_owner = 'Sales';
