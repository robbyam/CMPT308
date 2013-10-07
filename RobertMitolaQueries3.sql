--Robert Mitola
--Professor Labouseur
--Database Management
--Queries Homework 3

-----1
SELECT city
FROM agents
WHERE aid IN (
	SELECT aid
	FROM orders
	WHERE cid = 'c002'
	);

-----2
SELECT city
FROM agents
INNER JOIN orders
ON agents.aid = orders.aid
WHERE cid = 'c002';

-----3
SELECT DISTINCT pid
FROM orders
WHERE aid IN (
	SELECT aid
	FROM orders
	WHERE cid IN (
		SELECT cid
		FROM customers
		WHERE city = 'Kyoto'
		)
	);

-----4
DROP VIEW IF EXISTS tempview;
CREATE VIEW tempview AS (
	SELECT o.aid, c.cid
	FROM orders o
	FULL JOIN customers c
	ON c.cid = o.cid
	WHERE c.city = 'Kyoto'
	);
SELECT DISTINCT o.pid
FROM orders o, tempview t
WHERE o.aid = t.aid;

-----5
SELECT name
FROM customers
WHERE cid NOT IN (
	SELECT cid
	FROM orders
	);

-----6
SELECT name
FROM customers
NATURAL FULL OUTER JOIN orders
WHERE ordno IS null;

-----7
SELECT DISTINCT c.name, a.name
FROM customers c, agents a, orders o
WHERE c.cid = o.cid
AND a.aid = o.aid
AND c.city = a.city;

-----8
SELECT DISTINCT c.name, a.name, c.city
FROM customers c, agents a
WHERE c.city = a.city;

-----9
--For this one I wasn't sure if you wanted to have the cities in which
--no products were made to be a part of the problem, so following are both
--possibilities.

--This one is the name of customers and city from the city where the
--least, but existing, number of products are made.

DROP VIEW IF EXISTS productCount;
CREATE VIEW productCount AS (
	SELECT DISTINCT city, sum(quantity)
	FROM products
	GROUP BY city
	);
SELECT DISTINCT c.name, p.city
FROM customers c, products p, productCount pc
WHERE pc.city = p.city
AND c.city = p.city
AND pc.sum IN (
	SELECT MIN(pc.sum)
	FROM productCount pc
	);

--This one is the name of customers and city from the city where the
--least, including zero, products are made.

DROP VIEW IF EXISTS productCount;
CREATE VIEW productCount AS (
	SELECT DISTINCT CONCAT(c.city, p.city) AS city, sum(COALESCE(p.quantity,0))
	FROM products p
	NATURAL FULL OUTER JOIN customers c
	WHERE c.city NOT IN (
		SELECT city
		FROM products
		)
	OR p.city IS NOT NULL
	GROUP BY c.city, p.city
	);
SELECT DISTINCT c.name, c.city
FROM customers c, products p, productCount pc
WHERE pc.city = c.city
AND pc.sum IN (
	SELECT MIN(pc.sum)
	FROM productCount pc
	);

-----10
--For this one I assumed you wanted to find the name and city of customers
--who live in a city where the most number of types of products are made,
--since it is impossible to have Newark as an answer, or have multiple answers
--if measuring the added quantities like in 9.

DROP VIEW IF EXISTS cityOccurences;
CREATE VIEW cityOccurences AS (
	SELECT p.city, count(p.city) AS occurances
	FROM products p
	GROUP BY p.pid
	);
DROP VIEW IF EXISTS cityCount;
CREATE VIEW cityCount AS (
	SELECT city, sum(occurances)
	FROM cityOccurences co
	GROUP BY city
	);
SELECT c.name, c.city
FROM customers c, cityCount cc
WHERE c.city = cc.city
AND cc.sum IN (
	SELECT MAX(cc.sum)
	FROM cityCount cc
	)
LIMIT 1;

-----11

DROP VIEW IF EXISTS cityOccurences;
CREATE VIEW cityOccurences AS (
	SELECT p.city, count(p.city) AS occurances
	FROM products p
	GROUP BY p.pid
	);
DROP VIEW IF EXISTS cityCount;
CREATE VIEW cityCount AS (
	SELECT city, sum(occurances)
	FROM cityOccurences co
	GROUP BY city
	);
SELECT c.name, c.city
FROM customers c, cityCount cc
WHERE c.city = cc.city
AND cc.sum IN (
	SELECT MAX(cc.sum)
	FROM cityCount cc
	);

-----12
SELECT name , priceUSD
FROM products
WHERE priceUSD > (
	select avg(priceUSD) 
	from products
	);

-----13
SELECT c.name, o.pid, o.dollars
FROM orders o
INNER JOIN customers c
ON c.cid = o.cid
ORDER BY o.dollars ASC;

-----14
DROP VIEW IF EXISTS orderTotals;
CREATE VIEW orderTotals AS (
	SELECT c.cid, c.name, sum(COALESCE(o.dollars,0))
	FROM customers c, orders o
	WHERE c.cid = o.cid
	GROUP BY c.cid
	);
SELECT name, sum
FROM orderTotals
ORDER BY name;


-----15
SELECT c.name, p.name, a.name
FROM customers c, products p, agents a, orders o
WHERE c.cid = o.cid
AND a.aid = o.aid
AND p.pid = o.pid
AND a.city = 'New York';

-----16
DROP VIEW IF EXISTS accuracyChecker;
CREATE VIEW accuracyChecker AS (
	SELECT o.ordno, (p.priceUSD * o.qty ) - ((p.priceUSD * o.qty ) * (c.discount / 100)) AS accuracy
	FROM orders o, products p, customers c
	WHERE o.cid = c.cid
	AND o.pid = p.pid
	group by o.ordno, accuracy
	ORDER BY o.ordno ASC
	);
SELECT o.ordno, o.dollars, a.accuracy, ABS(o.dollars - a.accuracy) AS difference
FROM accuracyChecker a, orders o
WHERE o.ordno = a.ordno;

-----17
UPDATE orders
SET dollars = 455.00
WHERE dollars = 450.00;
--Run this and then #16 again to test!
