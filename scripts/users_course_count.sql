select email, count(mc.id) 
from users u join my_courses mc on u.id=mc.user_id 
where mc.status in ('compl') and email not like '%techcorp.com' and email not like '%rocket.co' 
group by email                           
order by 2;