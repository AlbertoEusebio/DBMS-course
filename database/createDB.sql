SET storage_engine=InnoDB;
SET FOREIGN_KEY_CHECKS=1;
CREATE DATABASE IF NOT EXISTS GYM;
USE GYM;

SET autocommit=0;

drop table if EXISTS SCHEDULE;
drop table if EXISTS COURSE;
drop table if EXISTS TRAINER;


create table TRAINER(
            SSN char(20),
            NameTrainer char(50)    not NULL,
            Surname char(50)        not NULL,
            DateOfBirth date        not NULL,
            Email char(50)          not NULL UNIQUE,
            PhoneNo char(20)        NULL,
            
            primary key(SSN),
            CONSTRAINT email_constr check(Email like "%@%") 
);

create table COURSE(
        Cid char(20),
        NameCourse char(50) not NULL,
        typeCourse char(50) not NULL,
        levelCourse smallint
            check(levelCourse is not NULL and levelCourse > 0 and levelCourse <= 4),

        primary key(Cid)
);


create table SCHEDULE(
        SSN char(20)      not Null,
        DayWeek char(10)  not Null,
        StartTime time    not Null,
        Duration int      not Null,
        Cid char(20)      not Null,
        GymRoom char(10)  not Null,

        primary key(SSN, DayWeek, StartTime),

        foreign key (Cid)
            references COURSE(Cid)
        on delete cascade
        on update cascade,
        
        foreign key (SSN)
            references TRAINER(SSN)
        on delete cascade
        on update cascade,

        constraint day_constr check (DayWeek in ('Monday', 'Tuesday', 'Wednesday','Thursday', 'Friday', 'Saturday', 'Sunday'))
);