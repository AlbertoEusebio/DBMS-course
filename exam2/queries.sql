create table TOURIST(TouristID, Name, BirthDate, CreditCard, Nation);
create table RESORT(ResortCode, CompanyName, Name, City, #Stars);
create table AVAILABLE_SERVICES(ResortCode, CompanyName, ServiceName);
create table RESERVATION_STAY(TouristID, StayStartDate, ResortCode, CompanyName, StayEndDate, Amount, #Adults, #Children, DownPayment);


-- from here starts the real exercise --

-- query a --
-- For each tourist born after 1980 who has made at least 3 reservations for the same resort,
-- find the tourist name and country, the total number of reservations made by the tourist,
-- the total number of adults for which reservations have been made and the corresponding
-- total amount

SELECT t.Name, t.Nation, COUNT(*), SUM(rs.#Adults), SUM(Amount)
FROM TOURIST t, RESERVATION_STAY rs
WHERE t.TouristID = rs.TouristID and t.BirthDate >= '1980-01-01' 
and t.TouristID in (SELECT rs2.TouristID
                    FROM RESERVATION_STAY rs2
                    GROUP BY rs2.TouristID, rs2.ResortCode
                    HAVING count(*) >= 3)
GROUP BY t.TouristID, t.Name, t.Nation



-- query b --
-- Find the resort code and company name of the 4-star resorts which 
-- (i) have never received a reservation whose down payment is equal to the amount
-- (ii) have received more reservations from Italian tourists than from German ones

SELECT ResortCode, CompanyName
FROM RESORT
WHERE #Stars = 4 and ResortCode not in (SELECT ResortCode
                                        FROM RESERVATION_STAY
                                        WHERE DownPayment = Amount)
    and ResortCode in (SELECT rs.ResortCode
                       FROM RESERVATION_STAY rs, TOURIST t
                       WHERE t.TouristID = rs.TouristID and t.Nation = 'Italy'
                       GROUP BY rs.ResortCode
                       HAVING COUNT(*) > (SELECT COUNT(*)
                                          FROM RESERVATION_STAY rs2, TOURIST t2
                                          WHERE rs2.TouristID = t.TouristID and t.Nation = 'Germany' and rs2.ResortCode = rs.ResortCode
                                          GROUP BY rs2.ResortCode))