create table Magazines(Mid int, Mname varchar(255), publisher varchar(255));
create table Articles(Aid int , Title varchar(255), Topic varchar(255), Mid int);


-- find the names of the magazines who have at least once published about motorcycles

select distinct Mname
from Magazine
where Mid in (select Mid
		  from Articles
		  where Topic = "motorcycles");
-- or
select distinct Mname
from Magazines as mag, Articles as art
where mag.Mid = art.Mid and art.Topic="motorcycles";
-- or
select distinct Mname
from Magazines as mag
where EXISTS (select *
		  from Articles as art
		  where Topic="motorcycles" and mag.Mid = art.Mid);



-- find the names of the magazines who have never published about motorcycles
select distinct Mname
from Magazine
where Mid NOT in (select Mid
		  from Articles
		  where Topic = "motorcycles");
-- or
select Mname
from Magazine as mag
where NOT EXISTS (select *
				from Articles as art
				where Topic="magazines" and mag.Mid = art.Mid);



-- find the names of the magazines that have only ever published about motorcycles
select Mname
from Magazine as mag, Articles as art
where mag.Mid = art.Mid and Mid not in (select Mid
				 						from Articles as art1
										where art1.Topic <> "motorcycles");
-- or
select Mname
from Magazine as mag, Articles as art
where mag.Mid = art.Mid and not EXISTS (select *
										from Articlesas art1
										where art1.Topic <> "motorcycles" and art.Aid = art1.Aid);



-- select name of the magaziens who have published about motorcycles or cars
select Mname
from Magazines as mag, Articles as art
where mag.Mid = art.Mid and (art.Topic="magazines" or art.Topic="cars");


-- find the nameso of the magazines who have published about motorcycles and cars
select Mname
from Magazines as mag
where mag.Mid in	(select Mid
					from Articles
					where Topic="motorcycles")
	and mag.Mid in	(select Mid
					from Articles
					where Topic="cars");
-- or
select Mname
from Magazine as mag
where mag.Mid in (select Mid
				  from Articles as a1, Articles as a2
				  where a1.Mid=a2.Mid and a2.Aid <> a1.Aid and a1.Topic="motorcycle" and a2.Topoic="cars")



-- find the names that have published at least 2 articles about motorcycles
select Mname
from Magazine
where Mid in (
		--> the number of articles that each magazine has published
		select COUNT(*) as num, Mid
		from Articles
		where Topic="motorcycles"
		GROUP BY Mid
		having num >= 2);
-- or
select Mname, Mid
from Magazine as mag, Articles as art
where art.Mid = mag.Mid and art.Topic="motorcycles"
GROUP BY art.Mid, Mname --> we also have to group by Mname in order to show it
having COUNT(*)>=2



-- find the names of the magazines who have published only one article about motorcycles 
select Mname, Mid
from Magazine as mag, Articles as art
where art.Mid = mag.Mid and art.Topic="motorcycles"
GROUP BY art.Mid, Mname --> we also have to group by Mname in order to show it
having COUNT(*)=1