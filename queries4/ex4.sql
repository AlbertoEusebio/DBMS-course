create table TEACHER(TCode, TName, TSurname, Department, ResearchGroupName, ResearchArea);
create table COURSE(CCode, CName, EnrollingStudent, TCode, Topic);
create table CLASSROOM(RoomID, Floor, VideoKit, Seat);
create table LECTURE(RoomID, Date, StartHour, EndHour, CCode, AttendingStudent, VideoKit=[yes,no]); -- videoKit will be a 0/1 bool

-- From here starts the real exercse --

-- query a --
-- For each teacher who has taught exclusively courses whose topic is databases,
-- select the code of the teacher and, among her courses, the code of the course for
-- which the average number of students attending the course lectures is the highest

select c.TCode, c.CCode
from COURSE c, LECTURE l
where c.CCode = l.CCode and c.TCode not in (select TCode
                                            from Course
                                            where Topic <> 'Databases')
group by c.TCode, c.CCode
having avg(AttendingStudent) = (select MAX(a)
                from (select AVG(l2.AttendingStudent) as a
                        from LECTURE l2, COURSE c2
                        where c.CCode = c2.CCode and c2.CCode = l2.CCode
                        group by c2.CCode, c2.TCode) as TAB
                where TAB.TCode = c.TCode)