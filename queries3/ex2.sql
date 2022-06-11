create table FLAT (FCode, Address, City, Surface);
create table LEASING_CONTRACT (LCCode, StartDate, EndDate, PersonName, MonthlyPrice, FCode);

-- From here starts the real exercse --

-- query a --
-- For the cities in which at least 100 contracts have been signed, find the city, the maximum monthly price,
-- the average monthly price, the maximum duration of the leasing contracts, the average duration of the
-- leasing contracts and the total number of signed contracts.

select f.City, MAX(l.MonthlyPrice), AVG(l.MonthlyPrice), MAX(l.EndDate - l.StartDate), AVG(l.EndDate - l.StartDate), COUNT(*)
from FLAT f, LEASING_CONTRACT l
where f.FCode = l.FCode
group by f.City
having count(*) >= 100;

-- query b --
-- Find the names of the people who have never rented any flat with a surface greater than 80 square meters
select PersonName
from LEASING_CONTRACT
where PersonName not in (select l.PersonName
                        from LEASING_CONTRACT l, FLAT f
                        where f.FCode = l.FCode and f.surface > 80);

-- query c --
-- Find the names of the peo whople have signed more than two leasing contracts for the same flat (in different
-- periods).

select DISTINCT PersonName
from LEASING_CONTRACT
group by PersonName, FCode
having count(*) > 2;

-- query d --
-- Find the codes and the addresses of flats in Turin whose monthly leasing price has
-- always been greater than 500 Euro and for which more than 5 contracts have been
-- signed.

select f.FCode, f.Address
from FLAT f, LEASING_CONTRACT ls
where f.FCode = ls.FCode and f.City = 'Turin' and f.FCode not in (select FCode
                                                                  from LEASING_CONTRACT
                                                                  where MonthlyPrice <= 500)
group by f.FCode, f.Address
having count(*) > 5;