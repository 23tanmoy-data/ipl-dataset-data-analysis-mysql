select * from ipl.dbo.venue

select * from ipl.dbo.match

select * from ipl.dbo.players

select * from ipl.dbo.playing_11

select * from ipl.dbo.score


with added_row_number as (
 select season,bowling_team,bowler,wks,
 ROW_NUMBER() over (partition by season order by wks desc) as row_number,
max(wks) over (partition by season) as  highest_wks,
DENSE_RANK() over (partition by season order by wks desc) as ranking
from
(select season,bowling_team,bowler,count(wicket_type) as wks from ipl.dbo.score
group by season,bowler,bowling_team)z)
select 
*
from 
added_row_number 
where row_number =1 





