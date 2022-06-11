create table COURSE (CourseCode, CourseName, Year, Semester);
create table COURSE_SCHEDULE (CourseCode, DayOfWeek, StartTime, EndTime, Room);

-- From here starts the real exercse --

-- query a --
-- Find the rooms in which none of the first-year courses has ever been given.

select distinct Room
from COURSE_SCHEDULE
where Room not in (-- rooms who have hosted courses of first year
                   select cs.Room
                   from COURSE_SCHEDULE cs, COURSE c
                   where c.CourseCode = cs.CourseCode and c.Year = 1);

-- query b --
-- Find the codes, the names and the total number of weekly hours of the third-year courses whose total
-- number of weekly hours is greater than 10 and whose schedule spans three different days of the week

select c.CourseCode, c.CourseName, SUM(cs.EndTime - cs.StartTime)
from COURSE_SCHEDULE cs, COURSE c
where c.CourseCode = cs.CourseCode and c.Year = 3
group by c.CourseCode, c.CourseName
having SUM(cs.EndTime - cs.StartTime) > 10 and count(distinct c.DayOfWeek) =  3;