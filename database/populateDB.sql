
SET storage_engine=InnoDB;
SET FOREIGN_KEY_CHECKS=1;
use GYM;


insert into TRAINER(SSN, NameTrainer, Surname, DateOfBirth, Email, PhoneNo)
        values ('SMTPLA80N31B791Z', 
                'Paul', 
                'Smith',
                STR_TO_DATE('31/12/1980', '%d/%m/%Y'), 
                'p.smith@gym.it',
                null
                );
insert into TRAINER(SSN, NameTrainer, Surname, DateOfBirth, Email, PhoneNo)
        values ('KHNJHN81E30C455Y', 
                'John', 
                'Johnson',
                STR_TO_DATE('30/05/1981', '%d/%m/%Y'), 
                'j.johnson@gym.it',
                '+2300110303444'
                );
insert into TRAINER(SSN, NameTrainer, Surname, DateOfBirth, Email, PhoneNo)
        values ('AAAGGG83E30C445A', 
                'Peter', 
                'Johnson',
                STR_TO_DATE('30/05/1980', '%d/%m/%Y'), 
                'p.johnson@gym.it',
                '+2300110303444'
                );


insert into COURSE(Cid, NameCourse, typeCourse, levelCourse)
        values(
                'CT100',
                'Spinning for beginners',
                'Spinning',
                1
        );
insert into COURSE(Cid, NameCourse, typeCourse, levelCourse)
        values(
                'CT101',
                'Fitdancing',
                'Music activity',
                2
        );
insert into COURSE(Cid, NameCourse, typeCourse, levelCourse)
        values(
                'CT104',
                'Advanced spinning',
                'Spinning',
                4
        );



insert into SCHEDULE(SSN, DayWeek, StartTime, Duration, Cid, GymRoom)
        values(
            'SMTPLA80N31B791Z',
            'Monday',
            '10:00',
            45,
            'CT100',
            'R1'
        );
insert into SCHEDULE(SSN, DayWeek, StartTime, Duration, Cid, GymRoom)
        values(
            'SMTPLA80N31B791Z',
            'Tuesday',
            '11:00',
            45,
            'CT100',
            'R1'
        );
insert into SCHEDULE(SSN, DayWeek, StartTime, Duration, Cid, GymRoom)
        values(
            'SMTPLA80N31B791Z',
            'Tuesday',
            '15:00',
            45,
            'CT100',
            'R2'
        );
insert into SCHEDULE(SSN, DayWeek, StartTime, Duration, Cid, GymRoom)
        values(
            'KHNJHN81E30C455Y',
            'Monday',
            '10:00',
            30,
            'CT101',
            'R2'
        );
insert into SCHEDULE(SSN, DayWeek, StartTime, Duration, Cid, GymRoom)
        values(
            'KHNJHN81E30C455Y',
            'Monday',
            '11:30',
            30,
            'CT104',
            'R2'
        );
insert into SCHEDULE(SSN, DayWeek, StartTime, Duration, Cid, GymRoom)
        values(
            'KHNJHN81E30C455Y',
            'Wednesday',
            '9:00',
            60,
            'CT104',
            'R1'
        );
