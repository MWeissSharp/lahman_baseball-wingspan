--Question #4 
/*Using the fielding table, group players into three groups based on their position: 
label players with position OF as "Outfield", those with position "SS", "1B", "2B", and "3B" as "Infield", 
and those with position "P" or "C" as "Battery". Determine the number of putouts made by each of these 
three groups in 2016.*/
--Below provides a table with the player's name, putouts, year, and position group
SELECT playerid,
	   CONCAT(p.namefirst, ' ', p.namelast) AS name,
	   yearid,
	   po,
	   CASE WHEN pos = 'OF' THEN 'Outfield'
	   WHEN pos IN('SS', '1B', '2B', '3B') THEN 'Infield'
	   WHEN pos IN('P', 'C') THEN 'Battery' END as pos_group
FROM fielding AS f LEFT JOIN people AS p USING(playerid);
--Below provides a table with the number of putouts by each position group in 2016
WITH grouping AS (SELECT playerid,
					   yearid,
					   po,
					   CASE WHEN pos = 'OF' THEN 'Outfield'
					   WHEN pos IN('SS', '1B', '2B', '3B') THEN 'Infield'
					   WHEN pos IN('P', 'C') THEN 'Battery' END as pos_group
				  FROM fielding)
SELECT pos_group, SUM(po) AS total_putouts
FROM grouping
WHERE yearid = 2016
GROUP BY pos_group;