create table AUTHOR (AuthorCode, Name, Surname, Department, University);
create table ARTICLE (ArticleCode, Title, Topic);
create table AUTHORS_OF_ARTICLE (AuthorCode, AuthorCode);
create table EDITIONS_OF_CONFERENCE (Conference, Edition, EditionName, StartDate, EndDate, Editor);
create table AUTHOR_PRESENTS_ARTICLE (AuthorCode, Date, StartTime, EndTime, Room, ArticleCode, Conference, Edition);

-- From here starts the real exercse --

-- query a --
-- For the authors who have exclusively presented articles with topic ’Data Mining’,
-- show the code of the author, the surname of the author, her/his university, and the
-- total number of articles presented by the author in each edition of every conference.

select a.AuthorCode, a.Surname, a.University, count(*)
from AUTHOR a, AUTHOR_PRESENTS_ARTICLE apa
where a.AuthorCode = apa.AuthorCode and ar.ArticleCode = apa.ArticleCode
-- only take authors who are not among those who have published other but 'Data Mining'
and a.AuthorCode not in (select apa2.AuthorCode
                            from AUTHOR_PRESENTS_ARTICLE apa2, ArticleCode ar2
                            where apa2.ArticleCode = ar2.ArticleCode and ar2.topic <> 'Data Mining')

group by AuthorCode, Surname, a.University, apa.Edition


-- query b --
-- Considering the conferences with at least 10 editions, for each edition of the
-- conference show the name of the edition and the code of the author who presented
-- the highest number of articles in the edition

select eoc.EditionName, apa.AuthorCode
from AUTHOR_PRESENTS_ARTICLE apa, Edition_Of_Conference eoc
where eoc.Edition = apa.Edition and apa.AuthorCode = a.AuthorCode and apa.Conference in (select Conference
                                                                                        from EDITIONS_OF_CONFERENCE
                                                                                        group by Conference
                                                                                        having count(*) >= 10)
group by apa.Edition, apa.AuthorCode
having count(*) = (select max(c)
                  from (select c
                        from (select count(*) as c
                                from AUTHOR_PRESENTS_ARTICLE apa2
                                where apa2.Edition = apa.Edition and apa2.Conference = apa.Conference
                                group by apa2.AuthorCode
                             )
                        ))

