--qn:6
-- Find the player who had the most success stealing bases in 2016, where __success__ is measured as the percentage of stolen base attempts which are successful. 
--(A stolen base attempt results either in a stolen base or being caught stealing.) 
--Consider only players who attempted _at least_ 20 stolen bases.

SELECT p.playerid,f.playerid, p.namefirst, p.namelast,f.sb,f.cs,f.yearid
FROM people AS p
INNER JOIN fielding AS f ON f.playerid = p.playerid
WHERE f.sb IS NOT NULL
AND f.cs IS NOT NULL
AND yearid = '2016'
AND f.sb > 20


SELECT p.playerid,f.playerid, p.namefirst, p.namelast,f.sb,f.cs,f.yearid, ROUND((f.sb::decimal/(f.sb::decimal+f.cs::decimal)*100),2)AS percentsuccess
FROM people AS p
INNER JOIN fielding AS f ON f.playerid = p.playerid
WHERE f.sb IS NOT NULL
AND f.cs IS NOT NULL
AND yearid = '2016'
AND f.sb+f.cs >= 20
ORDER BY percentsuccess DESC;