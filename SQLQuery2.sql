***** DATA ANALYSIS OF IPL DATASET 2008 - 2022  *****

***** EXPLORATORY DATA ANALYSIS *****

1*** EVERY SEASON WISE PLAYER OF THE MATCH RANKING ORDER ***

SELECT SEASON,TEAM1,TEAM2,PLAYER_OF_MATCH,
DENSE_RANK() OVER (PARTITION BY SEASON,TEAM1,TEAM2 ORDER BY PLAYER_OF_MATCH) AS RANKZ
FROM
IPL.DBO.match

2*** EVERY TEAM TOTAL RUNS IN EVERY SEASON ***

select season,batting_team,
sum(runs_off_bat + extras) as total_runs
from ipl.dbo.score
group by season,batting_team
order by season asc,total_runs desc


3*** highest runs scorer of each season by which team rank wise ***


WITH added_row_number AS (
 select season,batting_team,striker,run_score,
 ROW_NUMBER() over (partition by season order by run_score desc) as row_number,
max(run_score) over (partition by season) as  highest_scorer,
DENSE_RANK() over (partition by season order by run_score desc) as ranking
from
(select season,batting_team,striker,sum(runs_off_bat) as run_score from ipl.dbo.score
group by season,batting_team,striker)z 
 )
SELECT
  *
FROM added_row_number
WHERE row_number = 1;


4*** highest runs by each team season wise *** 

WITH added_row_number AS (
  SELECT season,batting_team,total_runs,
    ROW_NUMBER() OVER(PARTITION BY season ORDER BY total_runs DESC) AS row_number,
	max(total_runs) over (partition by season) as top_team,
DENSE_RANK() over (partition by season order by total_runs desc) as rankz
from
(select batting_team,season,sum(runs_off_bat + extras) as total_runs from ipl.dbo.score 
group by season,batting_team)z 
 )
SELECT
  *
FROM added_row_number
WHERE row_number = 1;


5**** HIGHEST WICKET TAKER SEASON WISE ****

with added_row_number as (
 select season,bowling_team,bowler,wks,
 ROW_NUMBER() over (partition by season order by wks desc) as row_number,
max(wks) over (partition by season) as  highest_wks
from
(select season,bowling_team,bowler,count(wicket_type) as wks from ipl.dbo.score
group by season,bowler,bowling_team)z)
select 
*
from 
added_row_number 
where row_number =1 

6**** 50+ runs scored by batsman in each season of ipl by their respective team **** 

select season,match_id,batting_team,striker,
sum(runs_off_bat) as batter_score
from 
ipl.dbo.score
group by season,match_id,batting_team,striker
having sum(runs_off_bat) between 50 and 99

7**** 100+ runs scored by batsman in each season of ipl by their respective team ****

select season,match_id,batting_team,striker,
sum(runs_off_bat) as batter_score
from 
ipl.dbo.score
group by season,match_id,batting_team,striker
having sum(runs_off_bat) > 99

8**** batsman got out in the nervous 90 in each ipl season by their respective team ****

select season,match_id,batting_team,striker,
sum(runs_off_bat) as batter_score
from 
ipl.dbo.score
group by season,match_id,batting_team,striker
having sum(runs_off_bat) between 90 and 99

9**** bowlers getting 5 wicket haul in each ipl season by their respective team ****

select season,match_id,bowling_team,bowler,
count(wicket_type) as wicket_taker
from
ipl.dbo.score
group by season,match_id,bowling_team,bowler
having count(wicket_type)>4


10**** bowlers getting (3-4) wicket haul in each ipl season by their respective team ****

select season,match_id,bowling_team,bowler,
count(wicket_type) as wicket_taker
from
ipl.dbo.score
group by season,match_id,bowling_team,bowler
having count(wicket_type) between 3 and 4

11**** batsman getting 40+ scores in ipl seasonwise by respective team ****

select season,match_id,batting_team,striker,
sum(runs_off_bat) as run_score 
from
ipl.dbo.score
group by season,match_id,batting_team,striker
having sum(runs_off_bat) between 40 and 49

12**** bowlers getting 0 wickets in each ipl season by their respective team ****

select season,match_id,bowling_team,bowler,
count(wicket_type) as wicket_taker
from
ipl.dbo.score
group by season,match_id,bowling_team,bowler
having count(wicket_type) = 0

13**** teams having most number of 50+ scores by their batters ****

select season,batting_team,striker,count(striker) as no_of_batsman
from
(select season,match_id,batting_team,striker,
sum(runs_off_bat) as batter_score
from 
ipl.dbo.score
group by season,match_id,batting_team,striker
having sum(runs_off_bat) between 50 and 99)z 
group by season,batting_team,striker

14**** teams having most number of 100+ scores by their batters ****

select season,batting_team,striker,count(striker) as no_of_batsman
from
(select season,match_id,batting_team,striker,
sum(runs_off_bat) as batter_score
from 
ipl.dbo.score
group by season,match_id,batting_team,striker
having sum(runs_off_bat) > 100)z 
group by season,batting_team,striker

15**** teams having most number of 90+ scores by their batters ****

select season,batting_team,striker,count(striker) as no_of_batsman
from
(select season,match_id,batting_team,striker,
sum(runs_off_bat) as batter_score
from 
ipl.dbo.score
group by season,match_id,batting_team,striker
having sum(runs_off_bat) between 90 and 99)z 
group by season,batting_team,striker


16**** highest runs scored by teams in a match by each season ****

with added_row_number as (
 select season,match_id,batting_team,team_runs,
 ROW_NUMBER() over (partition by season order by team_runs desc) as row_number,
max(team_runs) over (partition by season) as  highest_total,
DENSE_RANK() over (partition by season order by team_runs desc) as ranking
from
(select season,match_id,batting_team,sum(runs_off_bat + extras) as team_runs
from ipl.dbo.score
group by season,match_id,batting_team)z)
select 
*
from 
added_row_number 
where row_number =1 

17**** lowest runs scored by teams in a match by each season ****

with added_row_number as (
 select season,match_id,batting_team,team_runs,
 ROW_NUMBER() over (partition by season order by team_runs asc) as row_number,
min(team_runs) over (partition by season) as  lowest_total,
DENSE_RANK() over (partition by season order by team_runs asc) as ranking
from
(select season,match_id,batting_team,sum(runs_off_bat + extras) as team_runs
from ipl.dbo.score
group by season,match_id,batting_team)z)
select 
*
from 
added_row_number 
where row_number =1 

18**** how many matches 1st batting team won seasonwise  **** 

select season,count(*) fisrt_batting_team
from
(select season,toss_winner,toss_decision,winner 
from ipl.dbo.match
where toss_decision = 'bat')z
group by season

19**** how many team 2nd batting won season wise ****

select season,count(*) second_batting_team
from
(select season,toss_winner,toss_decision,winner
from ipl.dbo.match
where toss_decision = 'field')z
group by season

20**** most number of man of the match award ****

select player_of_match, count(player_of_match) no_of_awards
from ipl.dbo.match
group by player_of_match
order by  no_of_awards desc

21**** season wise highest man of the match award ****

with added_row_number as (
 select season,player_of_match,no_of_awards,
 ROW_NUMBER() over (partition by season order by no_of_awards desc) as row_number,
max(no_of_awards) over (partition by season) as  highest_award_per_season,
DENSE_RANK() over (partition by season order by no_of_awards desc) as ranks
from
(select season,player_of_match, count(player_of_match) no_of_awards
from ipl.dbo.match
group by season,player_of_match)z)
select 
*
from 
added_row_number 
where row_number =1 



22**** which team conceded most no of extras ****

select bowling_team,sum(extras) total_extra_runs
from ipl.dbo.score
group by bowling_team
order by total_extra_runs desc

23**** highest won by runs in ipl history ****

select season,
concat(max(team1), ' vs ' , max(team2)) as match_name,
winner,win_by
from
(select season,winner,win_by,winner_type,team1,team2
from ipl.dbo.match 
where winner_type='runs')z
group by season,winner,win_by
order by season asc,win_by desc

24****how many pacers took wk in season wise ****

select season,bowler,count(wicket_type) as wks,bowling_type
from ipl.dbo.score s
inner join ipl.dbo.players p
on s.bowler_id = p.identifier
group by season,bowler,bowling_type
having bowling_type = 'pace'
order by season asc,wks desc

24****how many spinners took wk in season wise ****

select season,bowler,count(wicket_type) as wks,bowling_type
from ipl.dbo.score s
inner join ipl.dbo.players p
on s.bowler_id = p.identifier
group by season,bowler,bowling_type
having bowling_type = 'spin'
order by season asc,wks desc


25****how many right hander batter scored  runs in ipl over the years ****

select season,striker,sum(runs_off_bat)as runs_scored_righty,batting_style
from ipl.dbo.score s
inner join ipl.dbo.players p
on s.striker_id = p.identifier
group by season,striker,batting_style
having batting_style = 'right hand bat'
order by season asc,runs_scored_righty desc

26****how many left hander batter scored  runs in ipl over the years ****

select season,striker,sum(runs_off_bat)as runs_scored_lefty,batting_style
from ipl.dbo.score s
inner join ipl.dbo.players p
on s.striker_id = p.identifier
group by season,striker,batting_style
having batting_style = 'left hand bat'
order by season asc,runs_scored_lefty desc

27**** left hander batter scored  50+ runs in ipl over the years ****

select season,striker,match_id,batting_style,runs_scored_lefty
from
(select season,striker,match_id,sum(runs_off_bat)as runs_scored_lefty,batting_style
from ipl.dbo.score s
inner join ipl.dbo.players p
on s.striker_id = p.identifier
group by season,striker,batting_style,match_id)z
where batting_style = 'left hand bat' and runs_scored_lefty between 50 and 99


28**** right hander batter scored  50+ runs in ipl over the years ****

select season,striker,match_id,batting_style,runs_scored_righty
from
(select season,striker,match_id,sum(runs_off_bat)as runs_scored_righty,batting_style
from ipl.dbo.score s
inner join ipl.dbo.players p
on s.striker_id = p.identifier
group by season,striker,batting_style,match_id)z
where batting_style = 'right hand bat' and runs_scored_righty between 50 and 99


29**** right hander batter scored  100+ runs in ipl over the years ****

select season,striker,match_id,batting_style,runs_scored_righty
from
(select season,striker,match_id,sum(runs_off_bat)as runs_scored_righty,batting_style
from ipl.dbo.score s
inner join ipl.dbo.players p
on s.striker_id = p.identifier
group by season,striker,batting_style,match_id)z
where batting_style = 'right hand bat' and runs_scored_righty > 100


30**** left hander batter scored  50+ runs in ipl over the years ****

select season,striker,match_id,batting_style,runs_scored_lefty
from
(select season,striker,match_id,sum(runs_off_bat)as runs_scored_lefty,batting_style
from ipl.dbo.score s
inner join ipl.dbo.players p
on s.striker_id = p.identifier
group by season,striker,batting_style,match_id)z
where batting_style = 'left hand bat' and runs_scored_lefty > 100

31**** team crossing 200 runs mark over the years in ipl ****

select season,match_id,batting_team,sum(runs_off_bat + extras) as total_runs
from ipl.dbo.score
group by season,match_id,batting_team
having sum(runs_off_bat + extras) > 200
order by season 

32**** openers scored 50+ score in ipl over the years ****

select season,striker,match_id,playing_position,runs_scored
from
(select season,striker,match_id,sum(runs_off_bat)as runs_scored,playing_position
from ipl.dbo.score s
inner join ipl.dbo.players p
on s.striker_id = p.identifier
group by season,striker,playing_position,match_id)z
where playing_position = 'opening batter' and runs_scored between 50 and 99

33**** openers scored 100+ score in ipl over the years ****

select season,striker,match_id,playing_position,runs_scored
from
(select season,striker,match_id,sum(runs_off_bat)as runs_scored,playing_position
from ipl.dbo.score s
inner join ipl.dbo.players p
on s.striker_id = p.identifier
group by season,striker,playing_position,match_id)z
where playing_position = 'opening batter' and runs_scored > 100

34**** wicketkeeper scored 50 to 100  in ipl over the years ****

select season,striker,match_id,playing_position,runs_scored
from
(select season,striker,match_id,sum(runs_off_bat)as runs_scored,playing_position
from ipl.dbo.score s
inner join ipl.dbo.players p
on s.striker_id = p.identifier
group by season,striker,playing_position,match_id)z
where playing_position = 'wicketkeeper batter' and runs_scored between 50 and 100

35**** all-rounders scored 50 to 100 in ipl over the years ****

select season,striker,match_id,playing_position,runs_scored
from
(select season,striker,match_id,sum(runs_off_bat)as runs_scored,playing_position
from ipl.dbo.score s
inner join ipl.dbo.players p
on s.striker_id = p.identifier
group by season,striker,playing_position,match_id)z
where playing_position = 'allrounder' and runs_scored between 50 and 100

36**** right hander pacer took wks over the years ****

select season,bowler,count(wicket_type) as wks,bowling_type,bowling_arm
from ipl.dbo.score s
inner join ipl.dbo.players p
on s.bowler_id = p.identifier
group by season,bowler,bowling_type,bowling_arm
having bowling_type = 'pace' and bowling_arm = 'right'
order by season asc,wks desc

37**** left hander pacer took wks over the years ****

select season,bowler,count(wicket_type) as wks,bowling_type,bowling_arm
from ipl.dbo.score s
inner join ipl.dbo.players p
on s.bowler_id = p.identifier
group by season,bowler,bowling_type,bowling_arm
having bowling_type = 'pace' and bowling_arm = 'left'
order by season asc,wks desc

38**** right hander spinner took wks over the years ****

select season,bowler,count(wicket_type) as wks,bowling_type,bowling_arm
from ipl.dbo.score s
inner join ipl.dbo.players p
on s.bowler_id = p.identifier
group by season,bowler,bowling_type,bowling_arm
having bowling_type = 'spin' and bowling_arm = 'right'
order by season asc,wks desc

39**** right hander spinner took wks over the years ****

select season,bowler,count(wicket_type) as wks,bowling_type,bowling_arm
from ipl.dbo.score s
inner join ipl.dbo.players p
on s.bowler_id = p.identifier
group by season,bowler,bowling_type,bowling_arm
having bowling_type = 'spin' and bowling_arm = 'left'
order by season asc,wks desc

40**** right hander pacer took 5wks over the years ****

select season,s.match_id,bowler,count(wicket_type) as wks,bowling_type,bowling_arm
from ipl.dbo.score s
inner join ipl.dbo.players p
on s.bowler_id = p.identifier
group by season,s.match_id,bowler,bowling_type,bowling_arm
having bowling_type = 'pace' and bowling_arm = 'right' and count(wicket_type) >= 5

41**** left hander pacer took 5wks over the years ****

select season,s.match_id,bowler,count(wicket_type) as wks,bowling_type,bowling_arm
from ipl.dbo.score s
inner join ipl.dbo.players p
on s.bowler_id = p.identifier
group by season,s.match_id,bowler,bowling_type,bowling_arm
having bowling_type = 'pace' and bowling_arm = 'left' and count(wicket_type) >= 5


42**** left hander spinner took 5wks over the years ****

select season,s.match_id,bowler,count(wicket_type) as wks,bowling_type,bowling_arm
from ipl.dbo.score s
inner join ipl.dbo.players p
on s.bowler_id = p.identifier
group by season,s.match_id,bowler,bowling_type,bowling_arm
having bowling_type = 'spin' and bowling_arm = 'left' and count(wicket_type) >= 5

43**** left hander spinner took 5wks over the years ****

select season,s.match_id,bowler,count(wicket_type) as wks,bowling_type,bowling_arm
from ipl.dbo.score s
inner join ipl.dbo.players p
on s.bowler_id = p.identifier
group by season,s.match_id,bowler,bowling_type,bowling_arm
having bowling_type = 'spin' and bowling_arm = 'right' and count(wicket_type) >= 5

44****right arm off break spinner took wks over the years ****

select bowler,count(wicket_type) as wks,bowling_type,bowling_style
from ipl.dbo.score s
inner join ipl.dbo.players p
on s.bowler_id = p.identifier
group by bowler,bowling_type,bowling_style
having bowling_type = 'spin' and bowling_style = 'right arm offbreak' 
order by wks desc

45****left arm off break spinner took wks over the years ****

select bowler,count(wicket_type) as wks,bowling_type,bowling_style
from ipl.dbo.score s
inner join ipl.dbo.players p
on s.bowler_id = p.identifier
group by bowler,bowling_type,bowling_style
having bowling_type = 'spin' and bowling_style = 'slow left arm orthodox' 
order by wks desc

46****leg spinner  took wks over the years ****

select bowler,count(wicket_type) as wks,bowling_type,bowling_style
from ipl.dbo.score s
inner join ipl.dbo.players p
on s.bowler_id = p.identifier
group by bowler,bowling_type,bowling_style
having bowling_type = 'spin' and bowling_style in ('leg break','legbreak googly') 
order by wks desc

47****right arm fast bowler took wks over the years ****

select bowler,count(wicket_type) as wks,bowling_type,bowling_style
from ipl.dbo.score s
inner join ipl.dbo.players p
on s.bowler_id = p.identifier
group by bowler,bowling_type,bowling_style
having bowling_type = 'pace' and bowling_style = 'right arm fast' 
order by wks desc


48****right arm  medium fast bowler took wks over the years ****

select bowler,count(wicket_type) as wks,bowling_type,bowling_style
from ipl.dbo.score s
inner join ipl.dbo.players p
on s.bowler_id = p.identifier
group by bowler,bowling_type,bowling_style
having bowling_type = 'pace' and bowling_style = 'right arm fast medium' 
order by wks desc

49****right arm medium bowler took wks over the years ****

select bowler,count(wicket_type) as wks,bowling_type,bowling_style
from ipl.dbo.score s
inner join ipl.dbo.players p
on s.bowler_id = p.identifier
group by bowler,bowling_type,bowling_style
having bowling_type = 'pace' and bowling_style = 'right arm medium' 
order by wks desc

50****left arm medium fast bowler took wks over the years ****

select bowler,count(wicket_type) as wks,bowling_type,bowling_style
from ipl.dbo.score s
inner join ipl.dbo.players p
on s.bowler_id = p.identifier
group by bowler,bowling_type,bowling_style
having bowling_type = 'pace' and bowling_style = 'left arm fast medium' 
order by wks desc

51****left arm  fast bowler took wks over the years ****

select bowler,count(wicket_type) as wks,bowling_type,bowling_style
from ipl.dbo.score s
inner join ipl.dbo.players p
on s.bowler_id = p.identifier
group by bowler,bowling_type,bowling_style
having bowling_type = 'pace' and bowling_style = 'left arm fast' 
order by wks desc

52**** players out in different manner ****

select wicket_type,striker,count(wicket_type) as occurance
from ipl.dbo.score
group by wicket_type,striker
order by occurance desc

53**** bowler conceded most no of no balls/free hit occurance ****

select bowler,count(noballs) as free_hit_count
from 
ipl.dbo.score
group by bowler
order by free_hit_count desc

54**** bowler conceded most no of wide balls ****

select bowler,count(wides) as wide
from 
ipl.dbo.score
group by bowler
order by wide desc

55****bowlers mostly targeted the stumps got bowled and lbw ****

select bowler,wicket_type,count(wicket_type) as pray
from ipl.dbo.score
group by bowler,wicket_type
having wicket_type in ('bowled','lbw')
order by pray desc

56**** bowlers mostly took wk in first innings ****

select bowler,innings,count(wicket_type) as pray
from ipl.dbo.score
where innings =1
group by bowler,innings
order by pray desc

57**** bowlers mostly took wk in second innings ****

select bowler,innings,count(wicket_type) as pray
from ipl.dbo.score
where innings =2
group by bowler,innings
order by pray desc

58**** matches are goes into eliminator ****

select season,
concat(max(team1), 'vs' ,max(team2)) as match_name,
toss_winner,outcome,eliminator
from 
ipl.dbo.match
group by season,toss_winner,outcome,eliminator
having outcome = 'tie'

59****how many times teams choose bat or field ****

select toss_decision,count(toss_decision) as occurance
from
ipl.dbo.match
group by toss_decision

60****highest margin of runs a team won in ipl ****

select season,win_by,winner,
max(win_by) as highest_margin,
concat(max(team1), 'vs' ,max(team2)) as match_name
from ipl.dbo.match
group by season,win_by,winner
order by highest_margin desc

61****lowest margin of runs a team won in ipl ****

select season,win_by,winner,
min(win_by) as lowest_margin,
concat(max(team1), 'vs' ,max(team2)) as match_name
from ipl.dbo.match
group by season,win_by,winner
having min(win_by) >1
order by lowest_margin 

62****teams won the match by 1 run ****

select season,match_id,
concat(max(team1), 'vs' ,max(team2)) as match_name,
win_by,winner_type,winner
from
ipl.dbo.match
group by season,match_id,win_by,winner_type,winner
having win_by = 1 and winner_type = 'runs'

63****teams won the match by 1 wicket ****

select season,match_id,
concat(max(team1), 'vs' ,max(team2)) as match_name,
win_by,winner_type,winner
from
ipl.dbo.match
group by season,match_id,win_by,winner_type,winner
having win_by = 1 and winner_type = 'wickets'

64**** how many matches result didnt come per season ****

select season,outcome,count(outcome) as happened
from ipl.dbo.match
group by season,outcome
having outcome = 'no result'

65****venue wise highest runs ****

select venue,sum(runs_off_bat + extras) as total_runs,batting_team
from 
ipl.dbo.score s
inner join
ipl.dbo.match m
on s.match_id = m.match_id
inner join 
ipl.dbo.venue v
on m.venueid = v.id
group by venue,batting_team
order by total_runs desc

66**** venue wise highest runs by players ****

select 
venue,striker,sum(runs_off_bat) as total_runs,batting_team
from 
ipl.dbo.score s
inner join
ipl.dbo.match m
on s.match_id = m.match_id
inner join 
ipl.dbo.venue v
on m.venueid = v.id
group by venue,striker,batting_team
order by total_runs desc

67**** venue wise highest wicket taker ****

select venue,bowler,count(wicket_type)as wks,bowling_team
from 
ipl.dbo.score s
inner join
ipl.dbo.match m
on s.match_id = m.match_id
inner join 
ipl.dbo.venue v
on m.venueid = v.id
group by venue,bowler,bowling_team
order by wks desc

68**** 2021 in UAE highest run scorer in ipl ****

select s.season,venue,striker,sum(runs_off_bat) as total_runs,batting_team
from 
ipl.dbo.score s
inner join
ipl.dbo.match m
on s.match_id = m.match_id
inner join 
ipl.dbo.venue v
on m.venueid = v.id
where s.season = '2021'
group by s.season,venue,striker,batting_team
order by total_runs desc

69**** 2021 in UAE highest wk taker in ipl ****

select s.season,venue,bowler,count(wicket_type) as wks,bowling_team
from 
ipl.dbo.score s
inner join
ipl.dbo.match m
on s.match_id = m.match_id
inner join 
ipl.dbo.venue v
on m.venueid = v.id
where s.season = '2021'
group by s.season,venue,bowler,bowling_team
order by wks desc

70**** 2022 recent ipl highest run scorer venue wise****

select s.season,venue,striker,sum(runs_off_bat) as total_runs,batting_team
from 
ipl.dbo.score s
inner join
ipl.dbo.match m
on s.match_id = m.match_id
inner join 
ipl.dbo.venue v
on m.venueid = v.id
where s.season = '2022'
group by s.season,venue,striker,batting_team
order by total_runs desc

71**** 2022 ipl highest wk taker venue wise ****

select s.season,venue,bowler,count(wicket_type) as wks,bowling_team
from 
ipl.dbo.score s
inner join
ipl.dbo.match m
on s.match_id = m.match_id
inner join 
ipl.dbo.venue v
on m.venueid = v.id
where s.season = '2022'
group by s.season,venue,bowler,bowling_team
order by wks desc

72**** 2022 ipl highest wk taker****

select s.season,bowler,count(wicket_type) as wks,bowling_team
from 
ipl.dbo.score s
inner join
ipl.dbo.match m
on s.match_id = m.match_id
where s.season = '2022'
group by s.season,bowler,bowling_team
order by wks desc

73**** 2022 ipl highest run scorer****

select 
s.season,striker,batting_team,sum(runs_off_bat) as total_runs
from
ipl.dbo.score s
inner join 
ipl.dbo.match m 
on s.match_id = m.match_id
where s.season= '2022'
group by s.season,striker,batting_team
order by total_runs desc

74**** percentage of spin dominated over the years in ipl ****

select season,bowling_type,
((select count(wicket_type)
from
ipl.dbo.score s
join
ipl.dbo.players p 
on s.bowler_id = p.identifier
where bowling_type = 'spin')* 100 / (select count(wicket_type)
from
ipl.dbo.score)) as perc_of_spin_dominance
from 
ipl.dbo.score  s
join
ipl.dbo.players p 
on s.bowler_id = p.identifier
where bowling_type = 'spin'
group by season,bowling_type
order by season


75**** percentage of spin dominated over the years in ipl ****

select season,bowling_type,
((select count(wicket_type)
from
ipl.dbo.score s
join
ipl.dbo.players p 
on s.bowler_id = p.identifier
where bowling_type = 'pace')* 100 / (select count(wicket_type)
from
ipl.dbo.score)) as perc_of_spin_dominance
from 
ipl.dbo.score  s
join
ipl.dbo.players p 
on s.bowler_id = p.identifier
where bowling_type = 'pace'
group by season,bowling_type
order by season

76****kkr players runs scored individually ****

select striker,sum(runs_off_bat) as runs
from ipl.dbo.score
where batting_team = 'kolkata knight riders'
group by striker
order by runs desc

77**** hs by batsman in ipl vs opponent team ****


select 
concat(max(batting_team), 'vs' , max(bowling_team)) as match_name,
striker,
sum(runs_off_bat) as total_runs
from ipl.dbo.score
group by striker,match_id
order by total_runs desc

78****strike rate of batsmans****


select 
striker as batsman,
batting_team,
(sum(runs_off_bat)/count(ball))*100 as strike_rate
from 
ipl.dbo.score
group by striker,batting_team
order by strike_rate desc
 


