--Question #1
/*What range of years for baseball games played does the provided database cover?*/
SELECT MIN(yearid) AS first_year_of_data,
	   MAX(yearid) AS last_year_of_data
FROM teams;
--1871 to 2016
--from Anjana, checking college table starts at 1864 goes to 2014
SELECT MIN(yearid), MAX(yearid)
FROM collegeplaying;

--Question #2
/*Find the name and height of the shortest player in the database. How many games 
did he play in? What is the name of the team for which he played?*/
WITH player_appearances AS (SELECT CONCAT(namefirst, ' ', namelast) AS name,
							height,
							g_all,
							teamid
							FROM people INNER JOIN appearances USING(playerid)
							ORDER BY height, name)
SELECT player_appearances.name, height, g_all, teams.name
FROM player_appearances INNER JOIN teams USING(teamid)
GROUP BY player_appearances.name, height, g_all, teams.name
ORDER BY height, player_appearances.name
LIMIT 1;

--Reworking Kelly's code, works but it's messy b/ lots of duplicate rows
SELECT namefirst, namelast, height, name, g_all
FROM people
     INNER JOIN appearances USING(playerid)
	 INNER JOIN teams USING(teamid)
WHERE name IN (SELECT DISTINCT name
               FROM teams
               WHERE teamid='SLA')
AND g_all IN (SELECT g_all
        	FROM appearances
        	WHERE playerid='gaedeed01')
ORDER BY height
LIMIT 1;
--Eddie Gedel at 43 inches, he played in 1 game for the St. Louis Browns

--Question #3
/*Find all players in the database who played at Vanderbilt University. Create a list showing each player’s 
first and last names as well as the total salary they earned in the major leagues. Sort this list in descending 
order by the total salary earned. Which Vanderbilt player earned the most money in the majors?*/
SELECT namefirst,
	   namelast,
	   total_salary::numeric::money
FROM	(SELECT people.playerid,
			   namefirst,
			   namelast,
			   SUM(salary) AS total_salary
		FROM people INNER JOIN collegeplaying USING(playerid)
					INNER JOIN schools USING(schoolid)
					INNER JOIN salaries USING(playerid)
		WHERE schoolname ILIKE '%vand%'
		GROUP BY people.playerid, namefirst, namelast) as inside
ORDER BY total_salary DESC;

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
	  		WHEN pos IN('P', 'C') THEN 'Battery' END AS pos_group
FROM fielding AS f LEFT JOIN people AS p USING(playerid);
--Below provides a table with the number of putouts by each position group in 2016
WITH grouping AS (SELECT playerid,
					   yearid,
					   po,
					   CASE WHEN pos = 'OF' THEN 'Outfield'
					   		WHEN pos IN('SS', '1B', '2B', '3B') THEN 'Infield'
					   		WHEN pos IN('P', 'C') THEN 'Battery' END AS pos_group
				  FROM fielding)
SELECT pos_group,
	   SUM(po) AS total_putouts
FROM grouping
WHERE yearid = 2016
GROUP BY pos_group;

--Martin's simpler version
Select sum(po),
		Case when pos = 'OF' then 'Outfield'
			 When pos in('SS', '1B', '2B', '3B') then 'Infield'
			 When pos in('P', 'C') then 'Battery'
			 End as new_pos
from fielding
Where yearid = '2016'
Group by new_pos;

--Question #5
/*Find the average number of strikeouts per game by decade since 1920. Round the numbers you report to 
2 decimal places. Do the same for home runs per game. Do you see any trends?*/
SELECT 
	   CASE WHEN yearid BETWEEN 1920 AND 1929 THEN '1920s'
			WHEN yearid BETWEEN 1930 AND 1939 THEN '1930s'
			WHEN yearid BETWEEN 1940 AND 1949 THEN '1940s'
			WHEN yearid BETWEEN 1950 AND 1959 THEN '1950s'
			WHEN yearid BETWEEN 1960 AND 1969 THEN '1960s'
			WHEN yearid BETWEEN 1970 AND 1979 THEN '1970s'
			WHEN yearid BETWEEN 1980 AND 1989 THEN '1980s'
			WHEN yearid BETWEEN 1990 AND 1999 THEN '1990s'
			WHEN yearid BETWEEN 2000 AND 2009 THEN '2000s'
			WHEN yearid BETWEEN 2010 AND 2020 THEN '2010s' END AS decade,
			ROUND(SUM(so::decimal) / (SUM(g::decimal) / 2), 2) AS strikeouts_per_game
FROM teams
WHERE yearid >= 1920
GROUP BY decade;

SELECT 
	   CASE WHEN yearid BETWEEN 1920 AND 1929 THEN '1920s'
			WHEN yearid BETWEEN 1930 AND 1939 THEN '1930s'
			WHEN yearid BETWEEN 1940 AND 1949 THEN '1940s'
			WHEN yearid BETWEEN 1950 AND 1959 THEN '1950s'
			WHEN yearid BETWEEN 1960 AND 1969 THEN '1960s'
			WHEN yearid BETWEEN 1970 AND 1979 THEN '1970s'
			WHEN yearid BETWEEN 1980 AND 1989 THEN '1980s'
			WHEN yearid BETWEEN 1990 AND 1999 THEN '1990s'
			WHEN yearid BETWEEN 2000 AND 2009 THEN '2000s'
			WHEN yearid BETWEEN 2010 AND 2020 THEN '2010s' END AS decade,
			ROUND(SUM(hr::decimal) / (SUM(g::decimal) / 2), 2) AS hr_per_game
FROM teams
WHERE yearid >= 1920
GROUP BY decade;

SELECT 
	   CASE WHEN yearid BETWEEN 1920 AND 1929 THEN '1920s'
			WHEN yearid BETWEEN 1930 AND 1939 THEN '1930s'
			WHEN yearid BETWEEN 1940 AND 1949 THEN '1940s'
			WHEN yearid BETWEEN 1950 AND 1959 THEN '1950s'
			WHEN yearid BETWEEN 1960 AND 1969 THEN '1960s'
			WHEN yearid BETWEEN 1970 AND 1979 THEN '1970s'
			WHEN yearid BETWEEN 1980 AND 1989 THEN '1980s'
			WHEN yearid BETWEEN 1990 AND 1999 THEN '1990s'
			WHEN yearid BETWEEN 2000 AND 2009 THEN '2000s'
			WHEN yearid BETWEEN 2010 AND 2020 THEN '2010s' END AS decade,
			ROUND(SUM(hr::decimal) / (SUM(g::decimal) / 2), 2) AS hr_per_game,
			ROUND(SUM(so::decimal) / (SUM(g::decimal) / 2), 2) AS strikeouts_per_game
FROM teams
WHERE yearid >= 1920
GROUP BY decade;

--Question #6
/* Find the player who had the most success stealing bases in 2016, where __success__ is measured as the percentage of 
stolen base attempts which are successful. (A stolen base attempt results either in a stolen base or being caught stealing.) 
Consider only players who attempted _at least_ 20 stolen bases*/
SELECT namefirst,
	   namelast,
	   CONCAT(ROUND(sb::decimal / (sb::decimal + cs::decimal) * 100, 2), '%') AS sb_success
FROM batting INNER JOIN people USING(playerid)
WHERE yearid = 2016 
AND (sb + cs) >= 20
ORDER BY sb_success DESC
LIMIT 1;

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
AND wswin = 'Y'
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
--Trying to answer the last part without a window function
WITH topwswinners AS ((SELECT yearid,
							 MAX(w) AS w
						FROM teams
						WHERE yearid BETWEEN 1970 AND 2016
						GROUP BY yearid
						ORDER BY yearid)
						INTERSECT
						(SELECT yearid,
							    w
						FROM teams
						WHERE wswin = 'Y'
						AND yearid BETWEEN 1970 AND 2016
						ORDER BY yearid))
SELECT teams.name, teams.yearid, teams.w, teams.wswin
FROM teams INNER JOIN topwswinners ON teams.yearid = topwswinners.yearid AND teams.w = topwswinners.w
WHERE teams.wswin = 'Y';

--Question #8
/*Using the attendance figures from the homegames table, find the teams and parks which had the top 5 average attendance 
per game in 2016 (where average attendance is defined as total attendance divided by number of games). Only consider parks 
where there were at least 10 games played. Report the park name, team name, and average attendance. Repeat for the lowest 
5 average attendance.*/
--Top 5
WITH hg AS (SELECT *,
				  ROUND(attendance::decimal / games::decimal, 0) AS hg_attendance_per_game,
				  RANK() OVER(PARTITION BY year ORDER BY (attendance::decimal / games::decimal) DESC) AS rank
		   FROM homegames
		   WHERE year = 2016
		   ORDER BY park)
SELECT DISTINCT name, park_name, hg_attendance_per_game
FROM hg INNER JOIN parks USING(park)
		INNER JOIN teams ON hg.team = teams.teamid
WHERE teams.yearid = 2016
AND hg.rank BETWEEN 1 AND 5
ORDER BY hg_attendance_per_game DESC;
--Bottom 5
WITH hg AS (SELECT *,
				  ROUND(attendance::decimal / games::decimal, 0) AS hg_attendance_per_game,
				  RANK() OVER(PARTITION BY year ORDER BY (attendance::decimal / games::decimal)) AS rank
		   FROM homegames
		   WHERE year = 2016)
SELECT DISTINCT name, park_name, hg_attendance_per_game
FROM hg INNER JOIN parks USING(park)
		INNER JOIN teams ON hg.team = teams.teamid
WHERE teams.yearid = 2016
AND hg.rank BETWEEN 1 AND 5
ORDER BY hg_attendance_per_game;
--You could union the two together to show them all in one table

--Question #9
/*Which managers have won the TSN Manager of the Year award in both the National League (NL) and the American League (AL)? 
Give their full name and the teams that they were managing when they won the award.*/
WITH manageraward AS (SELECT *
				      FROM awardsmanagers
				      WHERE playerid IN
								(SELECT playerid
								FROM awardsmanagers
								WHERE awardid = 'TSN Manager of the Year'
								AND lgid = 'NL'
								INTERSECT
								SELECT playerid
								FROM awardsmanagers
								WHERE awardid = 'TSN Manager of the Year'
								AND lgid = 'AL')
				  	  AND awardid = 'TSN Manager of the Year')
SELECT manageraward.playerid,
	   namefirst,
	   namelast,
	   manageraward.yearid,
	   teams.name
FROM manageraward INNER JOIN people USING(playerid)
				  INNER JOIN managers ON manageraward.playerid = managers.playerid AND manageraward.yearid = managers.yearid
				  INNER JOIN teams ON managers.teamid = teams.teamid AND manageraward.yearid = teams.yearid;
--to avoid duplicate rows, have to make sure to match all years back to the manageraward table

--Question #10
/*Find all players who hit their career highest number of home runs in 2016. Consider only players 
who have played in the league for at least 10 years, and who hit at least one home run in 2016. 
Report the players' first and last names and the number of home runs they hit in 2016.*/
SELECT namefirst,
	   namelast,
	   hr AS hr_in2016,
	   career_seasons
FROM	(SELECT namefirst,
			    namelast, 
			    hr,
			    yearid,
			    EXTRACT(year FROM finalgame::date) - EXTRACT(year FROM debut::date) + 1 AS career_seasons, --this will allow filtering based on carrer length
			    RANK() OVER(PARTITION BY playerid ORDER BY hr DESC) AS player_hr_by_year_rank --this allows filtering for players' best hr year
		FROM people AS p INNER JOIN batting AS b USING(playerid) 
		WHERE HR > 0) AS ranks --going ahead and filtering out rows where the player didn't have any home runs
WHERE player_hr_by_year_rank = 1
AND yearid = 2016
AND career_seasons >= 10;
/* Players who had their top hitting year in 2016: Robinson Cano-39, Bartolo Colon-1, Rajal Davis-12, Edwin Encarnacion-42
(also got 42 hr in 2012, Alcides Escobar-7, Francisco Liriano-1 (also got 1 hr in 2015), Evan Longoria-36, Daniel Murphy-25, 
Mike Napoli-34, Angel Pagan-12, Denard Span-11, Justin Upton-31 (also got 31 hr in 2011), Adam Wainwright-2 
also got 2 hr in 2009))*/

--Question #11
/*Is there any correlation between number of wins and team salary? Use data from 2000 and later to answer this question. 
As you do this analysis, keep in mind that salaries across the whole league tend to increase together, so you may want 
to look on a year-by-year basis.*/
WITH t_salaries AS	(SELECT teamid,
					 		yearid,
					 		SUM(salary)::numeric::money AS team_total_salary
					 FROM salaries
					 WHERE yearid >= 2000
					 GROUP BY teamid, yearid
					 ORDER BY teamid, yearid)
SELECT ts.teamid,
	   ts.yearid,
	   ts.team_total_salary,
	   RANK() OVER(PARTITION BY ts.yearid ORDER BY ts.team_total_salary DESC) AS salary_rank,
	   t.w AS wins,
	   RANK() OVER(PARTITION BY ts.yearid ORDER BY t.w DESC) AS win_count_rank,
	   t.g AS total_games,
	   ROUND(t.w::decimal / t.g::decimal * 100, 2) AS percent_wins,
	   RANK() OVER(PARTITION BY ts.yearid ORDER BY ROUND(t.w::decimal / t.g::decimal * 100, 2) DESC) AS win_percent_rank
FROM t_salaries AS ts INNER JOIN teams AS t ON ts.teamid = t.teamid AND ts.yearid = t.yearid

--Question #12
/* In this question, you will explore the connection between number of wins and attendance.
    a) Does there appear to be any correlation between attendance at home games and number of wins?
    b) Do teams that win the world series see a boost in attendance the following year? 
	   What about teams that made the playoffs? Making the playoffs means either being a division winner 
	   or a wild card winner.*/
--Part A
--Table below gives attendance and homegames for each team each year
SELECT DISTINCT team,
	   		 	year,
			    SUM(attendance) OVER(PARTITION BY team, year) AS homegame_total_attendance,
	  			SUM(games) OVER(PARTITION BY team, year) AS homegames
FROM homegames
ORDER BY year, team;
--Pulling in team name and wins
WITH hg AS	(SELECT DISTINCT team,
	   		 				 year,
			 				 SUM(attendance) OVER(PARTITION BY team, year) AS homegame_total_attendance,
	   		 				 SUM(games) OVER(PARTITION BY team, year) AS homegames
			 FROM homegames
			 ORDER BY year, team)
SELECT t.name,
	   hg.year,
	   hg.homegame_total_attendance,
	   hg.homegames,
	   ROUND(hg.homegame_total_attendance/hg.homegames, 0) AS homegame_attendance_per_game,
	   t.w AS wins,
	   t.g AS total_games
FROM hg LEFT JOIN teams AS t ON hg.team = t.teamid AND hg.year = t.yearid
ORDER BY hg.year, t.name;

--Part B
--I'm only including my final solution here, the script for just question 12 has more of my work
--Using LEAD function for world series winners
SELECT *
FROM 	(WITH hg AS	(SELECT DISTINCT team,
									 year,
									 SUM(attendance) OVER(PARTITION BY team, year) AS homegame_total_attendance,
									 SUM(games) OVER(PARTITION BY team, year) AS homegames
					 FROM homegames)
		SELECT t.name,
			   hg.year AS wswin_year,
			   hg.homegame_total_attendance,
			   hg.homegames,
		 	   t.wswin,
			   ROUND(hg.homegame_total_attendance/hg.homegames, 0) AS homegame_attendance_per_game,
			   LEAD(hg.homegame_total_attendance, 1) OVER(PARTITION BY t.name ORDER BY t.yearid) AS ny_hg_total_attendance,
			   LEAD(hg.homegames, 1) OVER(PARTITION BY t.name ORDER BY t.yearid) AS ny_homegames,
			   LEAD(ROUND(hg.homegame_total_attendance/hg.homegames, 0), 1) OVER(PARTITION BY t.name ORDER BY t.yearid) AS ny_hg_attendance_per_game
		FROM hg INNER JOIN teams AS t ON hg.team = t.teamid AND hg.year = t.yearid) AS year_comparisons
WHERE wswin = 'Y'
ORDER BY wswin_year;
--Doing calculations on the attendance change
SELECT name,
	   year AS wswin_year,
	   (ny_hg_total_attendance - homegame_total_attendance) AS total_attendance_change,
	   ny_hg_attendance_per_game - homegame_attendance_per_game AS per_game_attendance_change,
	   ny_homegames - homegames AS hg_count_change
FROM 	(WITH hg AS	(SELECT DISTINCT team,
									 year,
									 SUM(attendance) OVER(PARTITION BY team, year) AS homegame_total_attendance,
									 SUM(games) OVER(PARTITION BY team, year) AS homegames
					 FROM homegames)
		SELECT t.name,
			   hg.year,
			   hg.homegame_total_attendance,
			   hg.homegames,
			   ROUND(hg.homegame_total_attendance/hg.homegames, 0) AS homegame_attendance_per_game,
			   t.wswin,
			   LEAD(hg.year, 1) OVER(PARTITION BY t.name ORDER BY t.yearid) AS next_year,
			   LEAD(hg.homegame_total_attendance, 1) OVER(PARTITION BY t.name ORDER BY t.yearid) AS ny_hg_total_attendance,
			   LEAD(hg.homegames, 1) OVER(PARTITION BY t.name ORDER BY t.yearid) AS ny_homegames,
			   LEAD(ROUND(hg.homegame_total_attendance/hg.homegames, 0), 1) OVER(PARTITION BY t.name ORDER BY t.yearid) AS ny_hg_attendance_per_game
		FROM hg INNER JOIN teams AS t ON hg.team = t.teamid AND hg.year = t.yearid) AS year_comparisons
WHERE wswin = 'Y'
ORDER BY wswin_year;
--AVG changes
SELECT ROUND(AVG(ny_hg_total_attendance - homegame_total_attendance), 0) AS avg_total_attendance_change,
	   ROUND(AVG(ny_hg_attendance_per_game - homegame_attendance_per_game), 0) AS avg_per_game_attendance_change
FROM 	(WITH hg AS	(SELECT DISTINCT team,
									 year,
									 SUM(attendance) OVER(PARTITION BY team, year) AS homegame_total_attendance,
									 SUM(games) OVER(PARTITION BY team, year) AS homegames
					 FROM homegames)
		SELECT t.name,
			   hg.year,
			   hg.homegame_total_attendance,
			   hg.homegames,
			   ROUND(hg.homegame_total_attendance/hg.homegames, 0) AS homegame_attendance_per_game,
			   t.wswin,
			   LEAD(hg.year, 1) OVER(PARTITION BY t.name ORDER BY t.yearid) AS next_year,
			   LEAD(hg.homegame_total_attendance, 1) OVER(PARTITION BY t.name ORDER BY t.yearid) AS ny_hg_total_attendance,
			   LEAD(hg.homegames, 1) OVER(PARTITION BY t.name ORDER BY t.yearid) AS ny_homegames,
			   LEAD(ROUND(hg.homegame_total_attendance/hg.homegames, 0), 1) OVER(PARTITION BY t.name ORDER BY t.yearid) AS ny_hg_attendance_per_game
		FROM hg INNER JOIN teams AS t ON hg.team = t.teamid AND hg.year = t.yearid) AS year_comparisons
WHERE wswin = 'Y';
--I'm not reproducing for the division/wild card winners here, but you would do the same thing, just adjust your WHERE statement accordingly

--Question #13
/*It is thought that since left-handed pitchers are more rare, causing batters to face them less often, that they are more effective. 
Investigate this claim and present evidence to either support or dispute this claim. First, determine just how rare left-handed 
pitchers are compared with right-handed pitchers. Are left-handed pitchers more likely to win the Cy Young Award? 
Are they more likely to make it into the hall of fame?*/
--Getting a list of all pitchers from the people table
SELECT playerid, namefirst, namelast, throws
FROM people
WHERE playerid IN
				(SELECT playerid
				 FROM pitching);

SELECT COUNT(DISTINCT playerid)
FROM people
WHERE playerid IN
				(SELECT playerid
				 FROM pitching);
--9302 pitchers
--Getting all entry options for the throws column
SELECT DISTINCT throws
FROM people
WHERE playerid IN
				(SELECT playerid
				 FROM pitching);
--R, L, null, and S are the options
--Getting counts for each option
SELECT 
	COUNT(CASE WHEN throws = 'R' THEN playerid END) AS r_handed_pitchers,
	COUNT(CASE WHEN throws = 'L' THEN playerid END) AS l_handed_pitchers,
	COUNT(CASE WHEN throws IS NULL THEN playerid END) AS unknown,
	COUNT(CASE WHEN throws = 'S' THEN playerid END) AS s_pitchers
FROM people
WHERE playerid IN
				(SELECT playerid
				 FROM pitching);
-- R=6605, L=2477, NULL=219, S=1
--Cy Young Award winners
SELECT playerid, namefirst, namelast, throws
FROM people
WHERE playerid IN
				(SELECT DISTINCT playerid
				FROM awardsplayers
				WHERE awardid = 'Cy Young Award');
--Counts for handedness for Cy Young Award winners (there are no null or S pitchers in this group)
SELECT 
	COUNT(CASE WHEN throws = 'R' THEN playerid END) AS r_handed_pitchers,
	COUNT(CASE WHEN throws = 'L' THEN playerid END) AS l_handed_pitchers
FROM people
WHERE playerid IN
				(SELECT playerid
				FROM awardsplayers
				WHERE awardid = 'Cy Young Award');
--53 right handed, 24 left handed
--Combining all pitcher info w/ Cy Young award info, award was first given in 1956, so limiting to those years
WITH all_pitchers AS (SELECT playerid,
					  namefirst,
					  namelast,
					  throws
					  FROM people
					  WHERE playerid IN
									(SELECT playerid
									 FROM pitching
									 WHERE yearid >=1956)),
	 cy_winners AS	(SELECT playerid, awardid
					 FROM awardsplayers
					 WHERE awardid = 'Cy Young Award')
SELECT namefirst, namelast, throws, awardid
FROM all_pitchers FULL JOIN cy_winners USING(playerid);
--Getting percentages
SELECT ROUND(r_handed_winners::decimal / r_handed_pitchers::decimal * 100, 2) AS percent_of_r_handed,
	   ROUND(l_handed_winners::decimal / l_handed_pitchers::decimal * 100, 2) AS percent_of_l_handed
FROM(WITH all_pitchers AS (SELECT playerid,
							  namefirst,
							  namelast,
							  throws
							  FROM people
							  WHERE playerid IN
											(SELECT playerid
											 FROM pitching
											 WHERE yearid >=1956)),
			 cy_winners AS	(SELECT DISTINCT(playerid), awardid
							 FROM awardsplayers
							 WHERE awardid = 'Cy Young Award')
		SELECT
			COUNT(CASE WHEN throws = 'R' THEN playerid END) AS r_handed_pitchers,
			COUNT(CASE WHEN throws = 'L' THEN playerid END) AS l_handed_pitchers,
			COUNT(CASE WHEN throws IS NULL THEN playerid END) AS unknown,
			COUNT(CASE WHEN throws = 'S' THEN playerid END) AS s_pitchers,
			COUNT(CASE WHEN throws = 'R' AND awardid = 'Cy Young Award' THEN playerid END) AS r_handed_winners,
			COUNT(CASE WHEN throws = 'L' AND awardid = 'Cy Young Award' THEN playerid END) AS l_handed_winners
		FROM all_pitchers LEFT JOIN cy_winners USING(playerid)) AS counts;
--1.32% of right handed pitchers since 1956 became Cy Young Award winners, 1.51% of left handed pitchers
--Hall of fame calculations
SELECT ROUND(r_handed_winners::decimal / r_handed_pitchers::decimal * 100, 2) AS percent_of_r_handed,
	   ROUND(l_handed_winners::decimal / l_handed_pitchers::decimal * 100, 2) AS percent_of_l_handed
FROM(WITH all_pitchers AS (SELECT playerid,
							  namefirst,
							  namelast,
							  throws
							  FROM people
							  WHERE playerid IN
											(SELECT playerid
											 FROM pitching)),
			 hof_winners AS	(SELECT playerid, yearid,
							 inducted AS hof_inductee
							 FROM halloffame
							 WHERE inducted = 'Y'
							 AND category = 'Player')
		SELECT
			COUNT(CASE WHEN throws = 'R' THEN playerid END) AS r_handed_pitchers,
			COUNT(CASE WHEN throws = 'L' THEN playerid END) AS l_handed_pitchers,
			COUNT(CASE WHEN throws IS NULL THEN playerid END) AS unknown,
			COUNT(CASE WHEN throws = 'S' THEN playerid END) AS s_pitchers,
			COUNT(CASE WHEN throws = 'R' AND hof_inductee = 'Y' THEN playerid END) AS r_handed_winners,
			COUNT(CASE WHEN throws = 'L' AND hof_inductee = 'Y' THEN playerid END) AS l_handed_winners
		FROM all_pitchers LEFT JOIN hof_winners USING(playerid)) AS counts;
--1.09% of right handed pitchers have gone on to be inducted into the hall of fame, 0.89% of left handed pitchers 


