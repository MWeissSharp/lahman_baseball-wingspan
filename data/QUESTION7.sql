--
--QN;7
--From 1970 – 2016, what is the largest number of wins for a team that did not win the world series? 
--What is the smallest number of wins for a team that did win the world series? 
--Doing this will probably result in an unusually small number of wins for a world series champion – determine why this is the case. 
--Then redo your query, excluding the problem year. 
--How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? 
--What percentage of the time?
SELECT *
FROM teams;
----------------
SELECT teamid,yearid,w, wswin
FROM teams
WHERE yearid BETWEEN  1970 AND 2016
AND wswin = 'N'
ORDER BY w DESC;
----------------------
SELECT teamid,yearid,w, wswin
FROM teams
WHERE yearid BETWEEN  1970 AND 2016
AND wswin = 'Y'
ORDER BY w ASC;
----------------
SELECT teamid,yearid,w, wswin
FROM teams
WHERE yearid BETWEEN  1970 AND 2016
AND yearid <> '1981'
AND wswin = 'Y'
ORDER BY w ASC;
-------------------------
SELECT teamid,yearid,w, wswin
FROM teams
WHERE yearid BETWEEN  1970 AND 2016
AND wswin = 'Y'
ORDER BY w DESC;
----------------

-------------------
-------------------
SELECT yearid,MAX(w) AS most_w, wswin
FROM teams
WHERE yearid BETWEEN  1970 AND 2016
AND wswin = 'Y'
ORDER BY w DESC;

SELECT MAX(w)
FROM teams
WHERE yearid = '1977'

WITH wsmostw AS 
(SELECT yearid,MAX(w) AS most_w 
FROM teams
WHERE yearid BETWEEN  1970 AND 2016
 GROUP BY yearid)
 SELECT ROUND((count(DISTINCT(teams.yearid))::decimal)/47,2)
 FROM wsmostw
 INNER JOIN teams USING (yearid)
 WHERE w = most_w AND wswin = 'Y';
 
 ------------------------
--How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? 
--What percentage of the time?
--Need to get- often, yearid, w, wswin

SELECT t.teamid, t.yearid, MAX(w)AS max_w
FROM teams AS t
WHERE yearid BETWEEN  1970 AND 2016
GROUP BY t.teamid, t.yearid
ORDER BY MAX(w) DESC







