create table ATHLETE(AthleteCode, TeamName);
create table ATHLETE_ARRIVAL(AthleteCode, Time);
create table TEAM_ARRIVAL(TeamName, NumberArrivedAthletes);
create table RANKING(AthleteCode, Position, Time);

-- from here starts the exercise --

-- trigger a --
-- Write triggers to update TEAM_ARRIVAL and RANKING tables when a new
-- row is inserted in ATHLETE_ARRIVAL table. For the update of the
-- TEAM_ARRIVAL table, consider also the case of a team not yet inserted in
-- the table. For the update of RANKING table, consider that the Time field
-- can assume the same value for two different athletes.

create OR REPLACE trigger NewAthleteTamArrival
after insert on ATHLETE_ARRIVAL
declare
team char(50);
N Number;
begin
    select a.TeamName into team
    from ATHLETE a
    where :NEW.AthleteCode = a.AthleteCode;

    select count(*) into N
    from TEAM_ARRIVAL
    where TeamName = team;

    if (N = 0) then
        -- the team is not yet in the table
        insert into TEAM_ARRIVAL(TeamName, NumberArrivedAthletes)
                values(team, 1);
    else
        update TEAM_ARRIVAL
        set NumberArrivedAthletes = NumberArrivedAthletes + 1;
    end if;
end;


create OR REPLACE trigger NewAthleteRankArrival
after insert on ATHLETE_ARRIVAL
FOR EACH ROW
declare
    POS Number;
    Tmp Number;
begin
    select MAX(Time), MAX(Position)+1 into Tmp, POS
    from RANKING
    where :NEW.Time <= Time;

    if (:NEW.Time = Tmp) then
        POS = POS - 1;
    else
        -- if the two athletes do not have the same position then update all other ranks
        update RANKING
        set Position = Position + 1
        where Position > POS;
    end if;

    insert into RANKING(AthleteCode, Position, Time)
            values(:NEW.AthleteCode, POS, :NEW.Time);

end;