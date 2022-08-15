--create a user
create user Loose_Coupling
identified by password111
default tablespace users
temporary tablespace temp
quota 10m on users;

-- DCL
-- Controls access to data
-- consists of two keywords: grant and revoke

-- ability to connect to another user from bookapp
grant connect to Loose_Coupling;
-- ability to create types
grant resource to Loose_Coupling;

-- WE DON'T want the ability to alter and destroy types
-- grant dba to bookapp;

-- ability to create a transaction session
grant create session to Loose_Coupling;

grant create table to Loose_Coupling;
grant create view to Loose_Coupling;

-- Older versions of Oracle SQL we had to grant
-- grant select, insert, update, delete to bookapp;