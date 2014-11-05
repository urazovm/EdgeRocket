select company_name, email, first_name, last_name --, r.name, a.id
from users u left join accounts a on u.account_id=a.id 
	--join roles r on r.user_id=u.id
order by 1,2;