create table PERSON (Name, Sex, Age);
create table PARENT(ParentName, ChildName);

-- From here starts the real exercse --

-- query a --
-- Find the name of each person younger than 10 years old who is an only child

select p.Name
from PERSON p, PARENT pa
where p.Age < 10 and p.Name = pa.Name and pa.ParentName in (select ParentName
                                                            from PARENT
                                                            group by ParentName
                                                            having count(*) = 1);