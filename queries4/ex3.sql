create table SEMINAR(SCode, STitle, Topic, Duration);
create table SPEAKER(SSSN, SName, BirthDate);
create table SEMINAR_CALENDAR(SCode, Date, StartTime, SSSN, Room);
create table EXPERTISE(SSSN, Topic);

-- From here starts the real exercse --

-- query a --
-- Show the code of the seminars for which at least one scheduled presentation was
-- held by the speaker with the highest number of topics of expertise

select s.Scode
from SEMINAR s, SEMINAR_CALENDAR sc
where s.SCode = sc.SCode and sc.SSSN = (select SSSN
                                        from expertise
                                        group by SSSN
                                        having count(*) = (select MAX(c)
                                                            from (select SSSN, count(*) as c
                                                                 from EXPERTISE
                                                                 group by SSSN)
                                                          ))

