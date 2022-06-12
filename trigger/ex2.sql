create table COURSE(CourseCode, CourseName, Credits);
create table STUDENT(RegNum, StudentName, YearFirstEnrollment);
create table EXAM_REGISTRATION(CourseCode, RegNum, Date, Score);
create table GRANT_APPLICATION(RegNum, RequestDate);
create table STUDENT_RANKING(RegNum, TotalPoints);
create table GRANT_AVAILABILITY(Grant#, CourseCode, TeachingHours);
create table GRANT_ASSIGNMENT(Grant#, RegNum, TeachingHours);
create table NOTIFICATION(Not#, Grant#, RegNum*, Message);

-- from here starts the exercise --

-- The trigger application deals with the assignment of student grants for supporting teaching activities.
-- Students applying for a student grant are inserted into a ranking (reported in table STUDENT
-- RANKING). When a new grant becomes available, the student recipient of the grant is selected from
-- the ranking. The same student may be the recipient of more than one grant, provided that she/he does
-- not exceed 150 hours of teaching activities. Write the triggers managing the following tasks for the
-- automatic assignment of student grants.


-- a --
-- When a new grant becomes available (insertion into table GRANT_AVAILABILITY), the recipient
-- student is selected from the ranking. The recipient is the student with the highest ranking that
-- satisfies the following requirements: (i) she/he has passed the exam for the course on which the
-- grant is available, and (ii) she/he does not exceed 150 teaching hours overall (including also the
-- new grant). Suppose that at most one student satisfies the above requirements. If the grant is
-- assigned, table GRANT_ASSIGNMENT should be appropriately modified. The result of the
-- assignment process must be notified both in the positive case (the grant is assigned) and in the
-- negative case (no appropriate student is available, in this case the RegNum attribute takes the
-- NULL value). The Not# attribute is a counter, which is incremented for each new notification. 

create or replace trigger OnGrantInsert
after insert on GRANT_AVAILABILITY
declare
    best Number;
    maxtot Number;
    newNot Number;
begin
    select RegNum into best
    from STUDENT_RANKING
    where RegNum in (select RegNum
                    from GRANT_ASSIGNMENT
                    group by RegNum
                    having SUM(TeachingHours) + :NEW.TeachingHours <= 150) -- must have free hours left
    and RegNum in (select RegNum
                    from EXAM_REGISTRATION
                    where :NEW.CourseCode = CourseCode and Score >= 18) -- must have passed the exam
    group by RegNum
    having TotalPoints = (select MAX(TotalPoints)
                         from STUDENT_RANKING
                         where RegNum in (select RegNum
                                            group by RegNum
                                            having SUM(TeachingHours) + :NEW.TeachingHours <= 150)
                                and RegNum in (select RegNum
                                                from EXAM_REGISTRATION
                                                where :NEW.CourseCode = CourseCode and Score >= 18) -- must have passed the exam
                        )           

    select MAX(Not#) into newNot
    from NOTIFICATION;
    
    IF (newNot IS NULL) THEN
        newNot:=0;
    END IF;

    if (best) then
            insert into GRANT_ASSIGNMENT(Grant#, RegNum, TeachingHours)
                    values(:NEW.Grant#, best, :NEW.TeachingHours);
            insert into NOTIFICATION(Not#, Grant#, RegNum*, Message)
                    values(newNot+1, :NEW.Grant#, best, 'Grant assigned');
    else
            insert into NOTIFICATION(Not#, Grant#, RegNum*, Message)
                    values(newNot+1, :NEW.Grant#, NULL, 'Grant NOT assigned');
    end if;

end;

-- b --
-- Grant application. A student applies for the assignment of a student grant (insertion into table
-- GRANT_APPLICATION). The application is accepted if (i) the student has acquired at least 120
-- credits on passed exams (i.e., on exams with score at least 18) and (ii) the student is not yet in the
-- ranking (i.e., in table STUDENT_RANKING). If any of the two requirements is not satisfied, the
-- application is rejected. If the application is accepted, the student is inserted in the ranking. The
-- total points (attribute TotalPoints) of the student are given by the average score computed only on
-- passed exams divided by the years elapsed from the student first enrollment (the current year is
-- given by the variable YEAR(SYSDATE)).

create or replace trigger OnGrantApplication
after insert on GRANT_APPLICATION
when NEW.RegNum not in (select RegNum
                        from RANKING)
declare
    credits Number;
    enrollment Number;
    score Float;
    newNot Number;
begin
    -- finding the credits
    select SUM(c.Credits) into credits
    from COURSE c, EXAM_REGISTRATION er
    where c.CourseCode = er.CourseCode and :NEW.RegNum = er.RegNum and er.score >= 18
    group by er.RegNum;

    select AVG(er.Score) into score
    from EXAM_REGISTRATION er
    where er.score >= 18;

    select YearFirstEnrollment into enrollment
    from STUDENT
    where RegNum = :NEW.RegNum;

    select MAX(Not#) into newNot
    from NOTIFICATION;
    
    IF (newNot IS NULL) THEN
        newNot:=0;
    END IF;


    if(credits < 120) then
        insert into NOTIFICATION(Not#, Grant#, RegNum*, Message)
                values(newNot+1, :NEW.Grant#, :NEW.RegNum, 'Grant application rejected');
    else
        insert into STUDENT_RANKING(RegNum, TotalPoints)
            values(:NEW.RegNum, score/(YEAR(SYSDATE) -  enrollment));
        
        insert into NOTIFICATION(Not#, Grant#, RegNum*, Message)
            values(newNot+1, :NEW.Grant#, :NEW.RegNum, 'Grant application rejected');
    end if;

end;