create table CAR_RENTAL (CRCode, CRName, Address, City, Country);
create table CAR (NumberPlate, Model, Maker, Category, NumPassengers);
create table CUSTOMER (SSN, Name, Surname, DrivingLicense, CreditCard);
create table RENTAL_RESERVATION (RCode, SSN, ReservationDate, CRCode, StartDate, EndDate, Price, NumberPlate);

-- From here starts the real exercse --

-- query a --
-- Show the name and surname of customers who have never made reservations for two Mercedes cars starting
-- on the same day.


select ct.Name, ct.Surname
from CUSTOMER ct
where ct.SSN not in 
        -- those who have made at least 2 reservations for a mercedes on the same day--
        (select r.SSN
        from RENTAL_RESERVATION r, CAR c
        where c.NumberPlate = r.NumberPlate
        and c.Maker = 'Mercedes'
        group by r.SSn, r.StartDate
        having count(*) >= 2);

-- query b --
-- For car rentals that received at least 30 rental reservation requests during November 2006, show the car
-- rental code and name, and the total number of reservation requests received during the whole year 2006


select rr2.CRCode, cr2.CRName, count(*)
from RENTAL_RESERVATION rr2, CAR_RENTAL cr2
where rr2.CRCode = cr2.Crcode
and rr2.StartDate like '%2006'
and (rr2.Crcode) in 
        -- the car rental code of the car rentals who have received more than 30 requests in november 2006
        (select cr.CRCode
        from CAR_RENTAL cr, RENTAL_RESERVATION rr
        where cr.CRCode = rr.CRCode 
        and rr.StartDate >= '2006-11-01' and rr.StartDate <= '2006-11-31'
        group by cr.CRCode
        having count(*) >= 30)
group by rr2.Crcode, rr2.CRName;