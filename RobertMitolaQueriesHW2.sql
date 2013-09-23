{\rtf1\ansi\ansicpg1252\cocoartf1038\cocoasubrtf360
{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
\margl1440\margr1440\vieww9000\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\ql\qnatural\pardirnatural

\f0\fs24 \cf0 ---Robert Mitola\
---Database Management\
---Due 9/23/2013\
---Queries Homework 2\
\
---1\
SELECT city\
FROM Agents\
WHERE aid IN (\
	SELECT aid\
	FROM orders\
	WHERE cid = 'c002'\
	);\
\
---2\
SELECT DISTINCT pid\
FROM orders\
WHERE aid IN (\
	SELECT aid\
	FROM agents\
	WHERE EXISTS(\
		SELECT cid\
		FROM customers\
		WHERE city = 'Kyoto'\
		)\
	);\
\
---3\
SELECT cid, name\
FROM customers\
WHERE cid NOT IN (\
	SELECT cid\
	FROM orders\
	WHERE aid = 'a03'\
	);\
\
---4\
SELECT cid, name\
FROM customers\
WHERE cid IN ((\
	SELECT cid\
	FROM orders\
	WHERE pid = 'p01'\
	) INTERSECT (\
	SELECT cid\
	FROM orders\
	WHERE pid = 'p07'\
	))\
\
---5\
SELECT DISTINCT pid\
FROM orders\
WHERE cid IN (\
	SELECT cid\
	FROM orders\
	WHERE aid = 'a03'\
	);\
\
---6\
SELECT name, discount\
FROM customers\
WHERE cid IN (\
	SELECT cid\
	FROM orders\
	WHERE aid IN (\
		SELECT aid\
		FROM agents\
		WHERE city = 'Dallas'\
		OR city = 'Duluth'\
		)\
	);\
\
---7\
SELECT*\
FROM customers\
WHERE discount IN (\
	SELECT discount\
	FROM customers\
	WHERE city = 'Dallas'\
	OR city = 'Kyoto'\
	);\
}