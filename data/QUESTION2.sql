--QN2
--Find the name and height of the shortest player in the database. 
--How many games did he play in? 
--What is the name of the team for which he played?

SELECT DISTINCT(playerid), namefirst, namelast
FROM people;

SELECT DISTINCT(p.playerid), a.playerid, namefirst, namelast, height, g_all,t.name
FROM people AS p
INNER JOIN appearances AS a ON a.playerid = p.playerid
INNER JOIN teams AS t ON t.yearid = a.yearid
GROUP BY p.playerid,a.playerid,g_all,t.name
ORDER BY height ASC;

--QN TO ASK TEAMMATES- t.name gives a whole bunch of list because of the weird inner join. How to fix it!!?
SELECT DISTINCT(p.playerid), a.playerid, t.teamid, a.teamid, namefirst, namelast, height, g_all,t.name
FROM people AS p
INNER JOIN appearances AS a ON a.playerid = p.playerid
INNER JOIN teams AS t ON t.teamid = a.teamid
GROUP BY p.playerid,a.playerid,t.teamid,a.teamid, g_all,t.name
ORDER BY height ASC;
