--qn:5:
--Find the average number of strikeouts per game by decade since 1920. 
--Round the numbers you report to 2 decimal places. 
--Do the same for home runs per game?
--Do you see any trends?

SELECT t.yearid, p.yearid, t.so, p.so
FROM teams AS t
INNER JOIN pitching AS p ON p.yearid = t.yearid;
-----------------------
SELECT t.yearid, b.yearid, t.so, b.so
FROM teams AS t
INNER JOIN batting AS b ON b.yearid = t.yearid;
---------------------------------
SELECT DISTINCT(t.yearid), t.so, t.soa, t.g, t.ghome
FROM teams AS t
GROUP BY t.yearid, t.g, t.ghome, t.so, t.soa
HAVING yearid BETWEEN 1920 AND 1930;
---------------------
SELECT t.yearid, AVG(t.so), AVG(t.soa), t.g, t.ghome
FROM teams AS t
GROUP BY t.yearid, t.g, t.ghome
HAVING yearid BETWEEN 1920 AND 1930;

SELECT t.yearid, ROUND(AVG(t.so),2), t.g
FROM teams AS t
GROUP BY t.yearid, t.g
HAVING yearid BETWEEN 1920 AND 1930;


SELECT ROUND(AVG(t.so),2)AS avg_strikeout, ROUND(AVG(t.g),2)AS avg_games
FROM teams AS t
WHERE t.yearid BETWEEN 1920 AND 1930;
---------------------
-----------------------

SELECT DISTINCT(t.yearid), ROUND(AVG(t.so),2), ROUND(AVG(t.soa),2), t.g, t.ghome
FROM teams AS t
GROUP BY t.yearid, t.g, t.ghome
HAVING yearid BETWEEN 1920 AND 1930;


SELECT DISTINCT(t.yearid), ROUND(AVG(t.so),2), ROUND(AVG(t.soa),2), t.g, t.ghome
FROM teams AS t
GROUP BY t.yearid, t.g, t.ghome
HAVING yearid BETWEEN 1931 AND 1940;
--------------------------
SELECT DISTINCT(t.yearid), ROUND(AVG(t.so),2), ROUND(AVG(t.soa),2), t.g, t.ghome
FROM teams AS t
GROUP BY t.yearid, t.g, t.ghome
HAVING yearid BETWEEN 1920 AND 1930;


SELECT t.yearid, ROUND(AVG(t.so),2), ROUND(AVG(t.soa),2), t.g, t.ghome
FROM teams AS t
GROUP BY t.yearid, t.g, t.ghome
HAVING yearid BETWEEN 1931 AND 1940;


SELECT t.yearid, ROUND(AVG(t.so),2), ROUND(AVG(t.soa),2)
FROM teams AS t
GROUP BY t.yearid 
HAVING yearid BETWEEN 1931 AND 1940;


SELECT t.yearid, ROUND(AVG(t.so),2), ROUND(AVG(t.soa),2)
FROM teams AS t
GROUP BY t.yearid 
HAVING yearid BETWEEN 1941 AND 1950;

SELECT t.yearid, ROUND(AVG(t.so),2), ROUND(AVG(t.soa),2)
FROM teams AS t
GROUP BY t.yearid 
HAVING yearid BETWEEN 1951 AND 1960;

SELECT t.yearid, ROUND(AVG(t.so),2), ROUND(AVG(t.soa),2)
FROM teams AS t
GROUP BY t.yearid 
HAVING yearid BETWEEN 1961 AND 1970;


SELECT t.yearid, ROUND(AVG(t.so),2), ROUND(AVG(t.soa),2)
FROM teams AS t
GROUP BY t.yearid 
HAVING yearid BETWEEN 1971 AND 1980;

SELECT t.yearid, ROUND(AVG(t.so),2), ROUND(AVG(t.soa),2)
FROM teams AS t
GROUP BY t.yearid 
HAVING yearid BETWEEN 1981 AND 1990;

SELECT t.yearid, ROUND(AVG(t.so),2), ROUND(AVG(t.soa),2)
FROM teams AS t
GROUP BY t.yearid 
HAVING yearid BETWEEN 1991 AND 2000;

SELECT t.yearid, ROUND(AVG(t.so),2), ROUND(AVG(t.soa),2)
FROM teams AS t
GROUP BY t.yearid 
HAVING yearid BETWEEN 2001 AND 2010;

SELECT t.yearid, ROUND(AVG(t.so),2), ROUND(AVG(t.soa),2)
FROM teams AS t
GROUP BY t.yearid 
HAVING yearid BETWEEN 2011 AND 2020;