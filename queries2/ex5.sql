create table ATHLETE (ACode, AName, ASurname, TeamName, Country);
create table ATTENDANCE (CCode, ACode, Position);
create table COMPETITION (CCode, CName, CType, Category);

-- From here starts the real exercse --

-- query a--
-- Show the code and the name of the athletes who never attended any Super G competitions (CType = ’SuperG’)

select AName
from ATHLETE
where ACode not in 
    -- the code of who attended a SuperG
    (select att.ACode
    from ATTENDANCE att, COMPETITION c
    where att.CCode = c.CCode
    and c.CType = 'SuperG')

-- query b--
-- For each Italian or Spanish athlete who attended at least 10 Super G competitions, show the code of the
-- athlete, the name, the total number of attended competitions, and the best ranking position achieved by
-- the athlete.

select a.ACode, a.AName, count(*), min(att.Position)
from ATHLETE a, ATTENDANCE att2
where a.ACode = att2.ACode and (a.Country = 'Italy' or a.Country='Spain')
and a.ACode in  -- the code of who attended 10+ SuperG
                (select att.ACode
                from ATTENDANCE att, COMPETITION c
                where att.CCode = c.CCode
                and c.CType = 'SuperG'
                group by att.ACode
                having count(*) >= 10)
group by a.ACode, a.AName;