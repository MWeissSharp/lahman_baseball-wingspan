SELECT *
FROM people;
-- Qn:1 What range of years for baseball games played does the provided database cover? 
--pull years
SELECT MIN(year)
FROM homegames;
SELECT MAX(year)
FROM homegames;
--1871 TO 2016
SELECT MIN(yearid)
FROM collegeplaying;
SELECT MAX(yearid)
FROM collegeplaying;
--1864 to 2014
SELECT MAX(yearid)
FROM salaries;
SELECT MIN(yearid)
FROM salaries;
--1985 to 2016
SELECT MIN(yearid)
FROM allstarfull;
SELECT MAX(yearid)
FROM allstarfull;
--1933 TO 2016
SELECT MIN(yearid)
FROM managershalf;
SELECT MAX(yearid)
FROM managershalf;
--1892 to 1981
SELECT MIN(yearid)
FROM awardssharemanagers;
SELECT MAX(yearid)
FROM awardssharemanagers;
--1983 TO 2016
SELECT MIN(yearid)
FROM awardsmanagers;
SELECT MAX(yearid)
FROM awardsmanagers;
--1936 TO 2016
SELECT MIN(yearid)
FROM awardsplayers;
SELECT MAX(yearid)
FROM awardsplayers;
--1877 TO 2016
SELECT MIN(yearid)
FROM awardsshareplayers;
SELECT MAX(yearid)
FROM awardsshareplayers;
--1911-TO 2016
SELECT MIN(yearid)
FROM halloffame;
SELECT MAX(yearid)
FROM halloffame;
--1936 TO 2017
