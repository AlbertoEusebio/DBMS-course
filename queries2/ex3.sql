create table DRUG (DCode, Name, ActivePrinciple, Category, Maker);
create table PHARMACY (PCode, OwnerName, Address, City);
create table SALE (PCode, DCode, Date, Quantity);

-- From here starts the real exercse --


-- queary a --
-- Show the name of the owner, address, and city of pharmacies that have never sold paracetamol drugs
-- (ActivePinciple = ’Paracetamol’)

select OwnerName, Address, City
from PHARMACY
wher Pcode not in 
        -- pharmacies who have sold paracetamol
        (select s.Pcode
        from SALE s, DRUG d
        where s.Dcode = d.Dcode and d.ActivePinciple = 'Paracetamol');


-- query b --
--  For pharmacies that have sold a total quantity of drugs greater than the average quantity of drugs sold by
--  all pharmacies, show the pharmacy code, the name of the owner, and the total quantity of Bayer drugs
--  (Maker = ’Bayer’) sold during the whole year 2007

-- pharmacies code, ownername, number of bayer drugs sold
select p2.PCode, p2.OwnerName, sum(s3.Quantity)
from SALE s3, PHARMACY p2, DRUG d
where s3.PCode = p2.PCode and s3.DCode = d.DCode
and s3.Date like '%2007' and d.Maker = 'Bayer'
and p2.Pcode in -- pharmacies who have sold more than the average number of drugs
                (select p.Pcode
                from SALE s2
                group by p.Pcode
                having sum(s2.Quantity) > -- average number of drugs sold
                                (select avg(tot)
                                from (
                                        select sum(Quantity) as tot
                                        from SALE s
                                        group by s.PCode
                                )))
group by p2.PCode, p2.OwnerName;

