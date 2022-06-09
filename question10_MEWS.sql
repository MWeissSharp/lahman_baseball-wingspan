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