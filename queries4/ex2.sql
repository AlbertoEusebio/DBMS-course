create table STUDENT (StudentID, Name, Surname, DegreeProgramme);
create table ASSIGNMENT_TO_BE_DELIVERED (ACode, Title, Topic, ScheduledExpirationDate);
create table TEACHER (TeacherID, Name, Surname, Department);
create table EVALUATION_OF_DELIVERED_ASSIGNMENT (StudentID, ACode, TeacherID, DeliveryDate, EvaluationDate, Score);

-- From here starts the real exercse --

-- query a --
-- For each student who has delivered at least 3 assignments with score greater than
-- 4, show the surname of the student, the total number of assignments delivered
-- by the student, the average score of all delivered assignments, and the number of
-- different teachers who evaluated their delivered assignments.

select s.Surname, count(*), AVG(ea.Score), count(distinct TeacherID)
from EVALUATION_OF_DELIVERED_ASSIGNMENT ea, STUDENT s
where s.StudentID = ea.StudentID
group by s.Surname
having count(*) >= 3 and MIN(ea.score) = 4;

-- query b --
-- Show the identifier, surname and degree programme of the students who have
-- never delivered an assignment after the scheduled expiration date, and who have
-- delivered all the assignments due always getting the highest score.

select StudentID, Surname, DegreeProgramme
from STUDENT
where StudentID not in (
                        select StudentID
                        from EVALUATION_OF_DELIVERED_ASSIGNMENT ea, ASSIGNMENT_TO_BE_DELIVERED ad
                        where ea.ACode = ad.ACode and ea.DeliveryDate > ad.ScheduledExpirationDate)
and StudentID not in (select StudentID
                      from EVALUATION_OF_DELIVERED_ASSIGNMENT
                      where score <= (select MAX(Score)
                                      from EVALUATION_OF_DELIVERED_ASSIGNMENT))
group by StudentID, Surname, DegreeProgramme
-- ALL the assignments must be delivered
having count(*) = (select count(*)
                    from ASSIGNMENT_TO_BE_DELIVERED)
