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
--Data for teams with WS wins
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
	   t.g AS total_games,
	   t.wswin
FROM hg LEFT JOIN teams AS t ON hg.team = t.teamid AND hg.year = t.yearid
WHERE t.wswin = 'Y'
ORDER BY hg.year;

--Data for teams with Division or Wildcard wins
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
	   t.g AS total_games,
	   t.divwin,
	   t.wcwin,
	   t.wswin
FROM hg LEFT JOIN teams AS t ON hg.team = t.teamid AND hg.year = t.yearid
WHERE t.divwin = 'Y'
OR t.wcwin = 'Y'
ORDER BY hg.year;

--Pulling in following year data for world series winners
WITH wsw AS	(WITH hg AS	(SELECT DISTINCT team,
								 year,
								 SUM(attendance) OVER(PARTITION BY team, year) AS homegame_total_attendance,
								 SUM(games) OVER(PARTITION BY team, year) AS homegames
				 FROM homegames
				 ORDER BY year, team)
			SELECT t.name,
				   hg.year AS wsw_year,
				   hg.homegame_total_attendance AS wswy_hg_attend,
				   hg.homegames AS wswy_hg,
				   ROUND(hg.homegame_total_attendance/hg.homegames, 0) AS wswy_hg_attend_per_game,
				   t.wswin
			FROM hg LEFT JOIN teams AS t ON hg.team = t.teamid AND hg.year = t.yearid
			WHERE t.wswin = 'Y'
			ORDER BY wsw_year),
	ny AS	(WITH hg AS	(SELECT DISTINCT team,
										 year,
										 SUM(attendance) OVER(PARTITION BY team, year) AS homegame_total_attendance,
										 SUM(games) OVER(PARTITION BY team, year) AS homegames
					  	FROM homegames
					 	ORDER BY year, team)
			SELECT t.name,
				   hg.year AS next_year,
				   hg.homegame_total_attendance AS ny_hg_attend,
				   hg.homegames ny_hg,
				   ROUND(hg.homegame_total_attendance/hg.homegames, 0) AS ny_hg_attend_per_game
			FROM hg LEFT JOIN teams AS t ON hg.team = t.teamid AND hg.year = t.yearid
			ORDER BY next_year)
SELECT wsw.name,
	   wsw_year,
	   wsw.wswin,
	   wswy_hg_attend,
	   wswy_hg,
	   wswy_hg_attend_per_game,
	   next_year,
	   ny_hg_attend,
	   ny_hg,
	   ny_hg_attend_per_game
FROM wsw INNER JOIN ny ON wsw.name = ny.name AND (wsw.wsw_year+1) = ny.next_year;

--Pulling in following year data for division and wildcard wins
WITH dwcw AS	(WITH hg AS	(SELECT DISTINCT team,
								 year,
								 SUM(attendance) OVER(PARTITION BY team, year) AS homegame_total_attendance,
								 SUM(games) OVER(PARTITION BY team, year) AS homegames
				 FROM homegames
				 ORDER BY year, team)
			SELECT t.name,
				   hg.year AS dwcw_year,
				   hg.homegame_total_attendance AS dwcwy_hg_attend,
				   hg.homegames AS dwcwy_hg,
				   ROUND(hg.homegame_total_attendance/hg.homegames, 0) AS dwcwy_hg_attend_per_game,
				   t.divwin,
				   t.wcwin,
				   t.wswin
			FROM hg LEFT JOIN teams AS t ON hg.team = t.teamid AND hg.year = t.yearid
			WHERE t.divwin = 'Y'
			OR t.wcwin = 'Y'
			ORDER BY dwcw_year),
	ny AS	(WITH hg AS	(SELECT DISTINCT team,
										 year,
										 SUM(attendance) OVER(PARTITION BY team, year) AS homegame_total_attendance,
										 SUM(games) OVER(PARTITION BY team, year) AS homegames
					  	FROM homegames
					 	ORDER BY year, team)
			SELECT t.name,
				   hg.year AS next_year,
				   hg.homegame_total_attendance AS ny_hg_attend,
				   hg.homegames ny_hg,
				   ROUND(hg.homegame_total_attendance/hg.homegames, 0) AS ny_hg_attend_per_game
			FROM hg LEFT JOIN teams AS t ON hg.team = t.teamid AND hg.year = t.yearid
			ORDER BY next_year)
SELECT dwcw.name,
	   dwcw_year,
	   dwcw.divwin,
	   dwcw.wcwin,
	   dwcw.wswin,
	   dwcwy_hg_attend,
	   dwcwy_hg,
	   dwcwy_hg_attend_per_game,
	   next_year,
	   ny_hg_attend,
	   ny_hg,
	   ny_hg_attend_per_game
FROM dwcw INNER JOIN ny ON dwcw.name = ny.name AND (dwcw.dwcw_year+1) = ny.next_year
ORDER BY dwcw_year;

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