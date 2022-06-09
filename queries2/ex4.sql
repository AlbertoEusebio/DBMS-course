create table BEACH (BeachAddress, BeachCity, Capacity, LifeguardInCharge);
create table LIFEGUARD (LID, FirstName, LastName, HomeCity, PhoneNumber);
create table RESCUE (RID, Lifeguard, BeachAddress, BeachCity, BatherSSN, Date, Reason);
create table BATHER (SSN, FirstName, LastName, DateOfBirth, HomeCity);

-- From here starts the real exercse --

--query a --
-- Show the identification code, the first name and the last name of lifeguards living in Ostuni who are not in
-- charge of any beach and have accomplished at least two rescues on the same beach on the same day

select LID, FirstName, LastName
from LIFEGUARD
where LID not in -- lifeguards who are in charge of a beach
                (select distinct LifeguardInCharge
                from BEACH)
and LID in 
        -- guards who have rescued at least 2 people on the same beach on the same day 
        (select LID
        from RESCUE
        group by Lifeguard, BeachAddress, BeachCity, Date
        having count(*) >= 2)
and HomeCity = 'Ostuni';

-- query b --
-- Taking into account only the beaches located in cities that have at least 10 beaches whose capacity is greater
-- than the average capacity of all beaches, show for each of such beaches the address, the city, and the number
-- of distinct lifeguards who have performed rescues on that beach.

select b.BeachAddress, b.BeachCity, count(distinct r.Lifeguard)
from BEACH b, RESCUE r
where b.BeachAddress = r.BeachAddress and b.BeachCity = r.BeachCity
and b.BeachCity in 
                -- cities whith at least 10 beaches whose capacity is greater
                -- than the average capacity of all beaches
                (select b1.BeachCity
                from BEACH b1
                where b1.capacity > (select avg(b2.capacity)
                                    from BEACH b2)
                group by b1.BeachCity
                having count(b1.BeachAddress) >= 10)
group by b.BeachAddress, b.BeachCity;