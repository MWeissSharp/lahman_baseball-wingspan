--qn:3
--Find all players in the database who played at Vanderbilt University. 
--Create a list showing each player’s first and last names as well as the total salary they earned in the major leagues. 
--Sort this list in descending order by the total salary earned. 
--Which Vanderbilt player earned the most money in the majors?

SELECT DISTINCT(p.namefirst), p.namelast,p.playerid,s.schoolname,sl.salary
FROM schools AS s
INNER JOIN collegeplaying AS c ON c.schoolid = s.schoolid
INNER JOIN people AS p ON p.playerid = c.playerid
INNER JOIN salaries AS sl ON sl.playerid = p.playerid
WHERE schoolname = 'Vanderbilt University'
ORDER BY sl.salary DESC;

--

SELECT p.playerid, p.namefirst, p.namelast,s.schoolname,sl.salary
FROM schools AS s
INNER JOIN collegeplaying AS c ON c.schoolid = s.schoolid
INNER JOIN people AS p ON p.playerid = c.playerid
INNER JOIN salaries AS sl ON sl.playerid = p.playerid
WHERE schoolname = 'Vanderbilt University'
ORDER BY sl.salary DESC;