
-- MODE:int PWM_COND:int PWM_FAN:int HALL1:int HALL2:int LED:int PUMP:int

alter table LJC0A
add column MODE Smallint Null;
alter table LJC0A
add column COND Smallint Null;
alter table LJC0A
add column FAN Smallint Null;
alter table LJC0A
add column HALL1 Smallint Null;
alter table LJC0A
add column HALL2 Smallint Null;
alter table LJC0A
add column LED Smallint Null;
alter table LJC0A
add column PUMP Smallint Null;

alter table LJC0B
add column MODE Smallint Null;
alter table LJC0B
add column COND Smallint Null;
alter table LJC0B
add column FAN Smallint Null;
alter table LJC0B
add column HALL1 Smallint Null;
alter table LJC0B
add column HALL2 Smallint Null;
alter table LJC0B
add column LED Smallint Null;
alter table LJC0B
add column PUMP Smallint Null;

alter table LJC0C
add column MODE Smallint Null;
alter table LJC0C
add column COND Smallint Null;
alter table LJC0C
add column FAN Smallint Null;
alter table LJC0C
add column HALL1 Smallint Null;
alter table LJC0C
add column HALL2 Smallint Null;
alter table LJC0C
add column LED Smallint Null;
alter table LJC0C
add column PUMP Smallint Null;

alter table LJC0D
add column MODE Smallint Null;
alter table LJC0D
add column COND Smallint Null;
alter table LJC0D
add column FAN Smallint Null;
alter table LJC0D
add column HALL1 Smallint Null;
alter table LJC0D
add column HALL2 Smallint Null;
alter table LJC0D
add column LED Smallint Null;
alter table LJC0D
add column PUMP Smallint Null;