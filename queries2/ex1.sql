create table SPECIALIST_VISIT (VCode, VType);
create table DOCTOR (DCode, DName);
create table PATIENT (SSN, PName, BirthDate);
create table BOOKING (Date, Time, DCode, Room, VCode, SSN);

-- From here starts the real exercse --

-- query a --
-- For patients who have booked at least three specialist visits with the same doctor in 2005, show the SSN,
-- name and total number of bookings in November 2005.


select p.SSN, p.PName, count(*)
from PATIENT p, BOOKING b
where p.SSN = b.SSN 
and b.Date >= '2005-11-01' 
and b.Date <= '2005-11-30' 
and b.SSN in 
 -- patients who booked three specialist visit in 2005 from the same doctor
            (select b2.SSN
            from BOOKING b2, SPECIALIST_VISIT v
            where b2.Vcode = v.Vcode and b2.Date like '%2005' and v.VType = 'specialist'
            group by b2.SSN, b2.DCode
            having count(*) >= 3)
group by P.SSN, P.Name;

-- query b --
-- Show the SSN and name of the patients born after 1960 who have never booked any cardiologist visits
select p.SSN, p.PName
from PATIENT p
where p.BirthDate > '1960-12-31'
and p.SSN not in 
        -- patients who have booked cardiologist visits
        (select b.SSN
        from BOOKING b, SPECIALIST_VISIT v
        where v.Vcode = b.Vcode and v.VType = 'Cardiologist')