create table dbo.NFLplaybyplay2022
(GameID smallint,
Gamedate DATE,
Quarter tinyint,
Minute tinyint,
Second tinyint,
OffenseTeam varchar(50),
DefenseTeam varchar(50),
Down tinyint,
ToGo tinyint,
YardLine tinyint,
SeriesFirstDown bit,
NextScore tinyint,
Description varchar(350),
TeamWin tinyint,
SeasonYear smallint,
Yards smallint,
Formation varchar(50),
PlayType varchar(50),
IsRush bit,
IsPass bit,
IsIncomplete bit,
IsTouchdown bit,
PassType varchar(50),
IsSack bit,
IsChallenge tinyint,
IsChallengeReversed tinyint,
Challenger varchar(50),
IsMeasurement tinyint,
IsInterception bit,
IsFumble bit,
IsPenalty bit,
IsTwoPointConversion bit,
IsTwoPointConversionSuccessful  bit,
RushDirection varchar(50),
YardlineFixed tinyint,
YardLineDirection varchar(50),
IsPenaltyAccepted bit,
PenaltyTeam varchar(50),
IsNoPlay bit,
PenaltyType varchar(50),
PenaltyYards tinyint,
);


1. Number of Field goals per quarter

SELECT 
  offenseteam,
  COUNT(CASE WHEN quarter = 1 THEN 1 END) AS Q1,
  COUNT(CASE WHEN quarter = 2 THEN 1 END) AS Q2,
  COUNT(CASE WHEN quarter = 3 THEN 1 END) AS Q3,
  COUNT(CASE WHEN quarter = 4 THEN 1 END) AS Q4,
  COUNT(CASE WHEN quarter = 5 THEN 1 END) AS OT
FROM nflplaybyplay2022
WHERE playtype = 'FIELD GOAL'
GROUP BY offenseteam
order by offenseteam asc

--The query selects the offensive team and uses conditional statements to count the number of field goals for each of the five quarters. 
	--The result is grouped by offensive team and returned in a table where the quarter numbers are displayed as separate columns. 
		--The query filters the data to only include plays of type "FIELD GOAL".

-- This query is easy to change so that you can view other playtypes as well. 
	--Just change the 'FIELD GOAL' in the where clause on line 56 to any playtype you'd like to see, for instance, "RUSH."
		--The new output would be a count of each teams total rushes per quarter.
			-- And if you added "count(playtype) as totalrushes after line 54, the query would create a new column that adds up all the Rush attempts.


2. Plays over 20 yds, 50 yds per team

select offenseteam, 
		count(case when yards > 20 then 1  END) as Over20ydPlays,
		count(case when yards > 50 then 1 END) as Over50ydPlays		
from nflplaybyplay2022
		group by offenseteam
			order by over50ydplays desc

3. Plays over 20 yards, 50 yards  given up defensively


select defenseteam, 
		count(case when yards > 20 then 1  END) as Over20ydPlays,
		count(case when yards > 50 then 1 END) as Over50ydPlays		
from nflplaybyplay2022
		group by defenseteam
			order by Over20ydplays desc
				
				
3. total passing plays, total running plays, total scrambles, total fg attempts, total punts

select offenseteam,
	count(case when playtype = 'RUSH' then 1 END) as TotalRushes,
	count(case when playtype = 'SCRAMBLE' then 1 END) as TotalScrambles,
	count(case when playtype = 'PASS' then 1 END) as TotalPasses,
	count(case when playtype = 'FIELD GOAL' then 1 END) as FGAttempts,
	count(case when playtype = 'PUNT' then 1 END) as TotalPunts
from nflplaybyplay2022
		group by offenseteam

5. Total Defensive pass interference penalty yards allowed

select penaltyteam, sum(penaltyyards) as  totalyds
from nflplaybyplay2022
where penaltytype = 'DEFENSIVE PASS INTERFERENCE' and
ispenaltyaccepted = '1' and
defenseteam = penaltyteam
group by penaltyteam
order by totalyds desc
	
6. Total Penalties against each quarter
select penaltyteam,
	COUNT(CASE WHEN quarter = 1 THEN 1 END) AS Q1,
  	COUNT(CASE WHEN quarter = 2 THEN 1 END) AS Q2,
  	COUNT(CASE WHEN quarter = 3 THEN 1 END) AS Q3,
  	COUNT(CASE WHEN quarter = 4 THEN 1 END) AS Q4,
  	COUNT(CASE WHEN quarter = 5 THEN 1 END) AS OT,
	count(*) as TotalPenalties
from nflplaybyplay2022
where ispenaltyaccepted = '1'
group by penaltyteam
order by totalpenalties desc
	
7. Rushing  averages based on direction for Detroit Lions

select offenseteam,
	CASE WHEN rushdirection = 'CENTER' THEN avg(yards) END AS Center,
	CASE WHEN rushdirection = 'LEFT END' THEN avg(yards) END AS LeftEnd,
	CASE WHEN rushdirection = 'LEFT GUARD' THEN avg(yards) END AS LeftGuard,
	CASE WHEN rushdirection = 'LEFT TACKLE' THEN avg(yards) END AS LeftTackle,
	CASE WHEN rushdirection = 'RIGHT END' THEN avg(yards) END AS RightEnd,
	CASE WHEN rushdirection = 'RIGHT GUARD' THEN avg(yards) END AS RightGuard,
	CASE WHEN rushdirection = 'RIGHT TACKLE' THEN avg(yards) END AS RightTackle
from nflplaybyplay2022
where offenseteam = 'DET'
group by offenseteam, rushdirection

