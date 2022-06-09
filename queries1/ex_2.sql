create table SAILOR(SId int, SName varchar(255), Expertise varchar(255), DateOfBirth varchar(255));
create table BOOKING (SId, BId varchar(255), Date varchar(255));
create table BOAT (BId int, BName varchar(255), Color varchar(255));


-- find the names of the sailors who have booked a red boat or a green boat.

select SName
from SAILOR
where Sid in 
            (select distinct SId
            from BOOKING
            where BId in 
                        (select BId
                        from BOAT
                        where Color="red" or Color="green")
            );
-- or
select distinct SName
from SAILOR, BOAT, BOOKING
where SAILOR.SId = BOOKING.Sid and BOAT.BId = BOOKING.BId and Color="red" or Color="green";


-- find the codes and the names of the sailors who have booked a red boat and a green boat.
select distinct SName, SId
from SAILOR as s
where Sid in (
            select Sid
            from BOOKING
            where BId in (select BId
                        from BOAT
                        where Color="red")
) and
Sid in (
        select Sid
        from BOOKING
        where BId in (select BId
                    from BOAT
                    where Color="red")
);


-- Find the codes of the sailors who have never booked a red boat.
select Sid
from SAILOR
where Sid not in (select Sid
                from BOOKING, BOAT
                where BOOKING.BId = BOAT.BId and BOAT.Color='red');
-- or
select Sid
from SAILOR
where Sid NOT EXISTS (select *
                    from BOOKING, BOAT
                    where BOOKING.BId = BOAT.BId and BOAT.Color='red', SAILOR.Sid = BOOKING.Sid);



--  Find the codes and the names of the sailors who have booked at least two boats.

select Sname, Sid
from SAILOR
where Sid in (
            select COUNT(distinct BId), Sid
            from BOOKING
            GROUPBY SId
            having COUNT(distinct Bid)>=2
)