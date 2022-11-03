
***** IPL 2022 DATA ANALYSIS*****

1****every team pts in ipl 2022 ****

select 
rank() over (order by match_points desc) as ranks,
winner,match_points from
(select winner,(count(winner)*2) as match_points
from
ipl.dbo.match
where season = '2022'
group by winner
)z


2**** team win how many matches with their final pts in ipl 2022 ****

select 
rank() over (order by match_points desc,win desc) as ranks,
winner,match_points,win from
(select winner,(count(winner)*2) as match_points,count(winner) as win
from
ipl.dbo.match
where season = '2022'
group by winner
)z

3****highest runs scorer from gujrat titans ****

select 
striker as batsman,
max(bowling_team) as against,
batting_team as team,
sum(runs_off_bat) as HS
from
ipl.dbo.score
group by striker,batting_team,match_id 
having batting_team ='Gujarat Titans'
order by HS desc

4****  highest bowling figures by bowlers of gujrat titans ****

select
bowler,
bowling_team,
count(wicket_type) as wks
from
ipl.dbo.score
group by bowler,bowling_team,match_id
having bowling_team = 'gujarat titans'
order by wks desc

5**** best bowling fig by the bowlers of gujrat titans against opponents in ipl 2022 ****

select
bowler,
bowling_team,
max(batting_team) as agianst,
concat(count(wicket_type), '-' ,sum(runs_off_bat)) as best 
from
ipl.dbo.score
group by bowler,bowling_team,match_id
having bowling_team = 'gujarat titans'
order by best desc

6**** hs wk taker of gujrat team ****

select
bowler,
count(wicket_type) as wks
from
ipl.dbo.score
where bowling_team = 'gujarat titans'
group by bowler 
order by wks desc

7****hs run conceded by gujrat team in ipl 2022****

select 
batting_team,
max(bowling_team) as VS,
sum(runs_off_bat + extras) as runs,
(case
when sum(runs_off_bat + extras) > 180 then 'awesome'
when sum(runs_off_bat + extras) between 150 and 179 then 'good'
else 'ok'
end) as performance
from
ipl.dbo.score
where batting_team = 'gujarat titans'
group by batting_team,match_id 
order by runs desc

8****strike rate of gujrat batsmans in ipl 2022 ****

select 
striker as batsman,
batting_team,
sum(runs_off_bat)/count(ball)*100 as strike_rate
from 
ipl.dbo.score
where batting_team = 'gujarat titans'
group by striker,batting_team
order by strike_rate desc

9****strike rate of 

select
bowler,
bowling_team,
ceiling(sum(runs_off_bat)/count(ball)) as eco_rate
from
ipl.dbo.score
where bowling_team = 'gujarat titans'
group by bowler,bowling_team
order by eco_rate 









