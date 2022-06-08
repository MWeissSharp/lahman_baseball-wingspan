--Question #7
/*From 1970 – 2016, what is the largest number of wins for a team that did not win the world series? 
What is the smallest number of wins for a team that did win the world series? Doing this will probably 
result in an unusually small number of wins for a world series champion – determine why this is the case. 
Then redo your query, excluding the problem year. How often from 1970 – 2016 was it the case that a team 
with the most wins also won the world series? What percentage of the time?*/
--Below gives a list of teams that didn't win the world series in the given year, ordered by number of wins(descending)
SELECT name,
	   teamid,
	   yearid,
	   g,
	   w,
	   l,
	   wswin
FROM teams
WHERE yearid BETWEEN 1970 AND 2016
AND wswin IN(NULL, 'N')
ORDER BY w DESC;
--Seattle Mariners had 116 wins in 2001 bud did not win the world series
--Below gives the table of world series winners ordered by wins(ascending)
SELECT name,
	   teamid,
	   yearid,
	   g,
	   w,
	   l,
	   wswin
FROM teams
WHERE yearid BETWEEN 1970 AND 2016
AND wswin = 'Y'
ORDER BY w;
/*Los Angeles Dodgers in 1981 had only 63 wins, but there were only 110 games that season b/c there was a strike that
resulted in the cancellation of regular season games. This was the first strike that had such a result.*/
--Below table is the same as above but filtering out 1981
SELECT name,
	   teamid,
	   yearid,
	   g,
	   w,
	   l,
	   wswin
FROM teams
WHERE yearid BETWEEN 1970 AND 2016
AND yearid <> 1981
AND WSWIN = 'Y'
ORDER BY w;
--In 2006 the St. Louis Cardinals won the world series with only 83 wins overall
--Table below lists all instances when the team with the most wins also won the world series 1970-2016
SELECT yearid,
	   teamid,
	   name,
	   win_rank_by_year,
	   wswin
FROM (SELECT *,
	 		 RANK() OVER(PARTITION BY yearid ORDER BY w DESC) AS win_rank_by_year
	   FROM teams
	   WHERE yearid BETWEEN 1970 AND 2016) AS ranks
WHERE win_rank_by_year = 1
AND wswin = 'Y';
--Below provides the number of times from 1970-2016 that the team with the most wins won the world series
SELECT COUNT(*) AS count_max_wins_ws_winner
FROM (SELECT *,
	 		 RANK() OVER(PARTITION BY yearid ORDER BY w DESC) AS win_rank_by_year
	   FROM teams
	   WHERE yearid BETWEEN 1970 AND 2016) AS ranks
WHERE win_rank_by_year = 1
AND wswin = 'Y';
--12 times between 1970 and 2016 the team with most wins also won the world series
--Below provides the % of the time that the team with the most wins also won the world series
SELECT CONCAT(ROUND(COUNT(*)::decimal/(2016-1970+1)*100, 2), '%') AS percent_max_wins_ws_winner
FROM (SELECT *,
	 		 RANK() OVER(PARTITION BY yearid ORDER BY w DESC) AS win_rank_by_year
	   FROM teams
	   WHERE yearid BETWEEN 1970 AND 2016) AS ranks
WHERE win_rank_by_year = 1
AND wswin = 'Y';
--25.53% of the time, the team with the most wins also won the world series between 1970 and 2016