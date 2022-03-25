-- find the names of the magazines who have at least once published about motorcycles


select distinct Mname
from Magazine
where Mid in (select Mid
		  from Articles
		  where Topic = "motorcycles")
-- or
select distinct Mname
from Magazines as mag, Articles as art
where mag.Mid = art.Mid and art.Topic="motorcycles"

-- or
select distinct Mname
from Magazines as mag
where EXISTS (select *
		  from Articles as art
		  where Topic="motorcycles" and mag.Mid = art.Mid)


-- find the names of the magazines who have never published about motorcycles

select distinct Mname
from Magazine
where Mid NOT in (select Mid
		  from Articles
		  where Topic = "motorcycles")

-- or

select Mname
from Magazine as mag
where NOT EXISTS	(select *
						from Articles as art
						where Topic="magazines" and mag.Mid = art.Mid) 