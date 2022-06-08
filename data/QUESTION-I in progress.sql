
--QN:1
--What range of years for baseball games played does the provided database cover?
SELECT c.yearid,af.yearid, awm.yearid, aw.yearid
FROM collegeplaying AS c
INNER JOIN allstarfull AS af ON af.yearid = c.yearid
INNER JOIN awardssharemanagers AS awm ON awm.yearid = c.yearid
INNER JOIN awardsmanagers AS aw ON aw.yearid = c.yearid;

SELECT c.yearid, awp.yearid, awps.yearid, hf.yearid
FROM collegeplaying AS c
INNER JOIN awardsplayers AS awp ON awp.yearid = c.yearid
INNER JOIN awardsshareplayers AS awps ON awps.yearid = c.yearid
INNER JOIN halloffame AS hf ON hf.yearid = c.yearid
