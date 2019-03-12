CREATE PROCEDURE equipo_ganador (int, int)
LANGUAGE plpgsql
AS $$
begin
  IF 
end;
#city_name city.name%TYPE := 'San Francisco';
#new_name ALIAS FOR old_name; 

create or replace function totalVictorias()
returns integer as $total$
declare
total integer;
begin
select (away_team > 
inner join games on team_
)
return total;
end;
$total$ language plpgsql;

create function test1(tmnm text) returns text as $$
declare
    tm_name text;
  found_team teams%rowtype;
begin 
  select * into found_team from teams where tm_name = team_name;
if not found then
  raise exception 'Los % no fueron encontrados', tm_name;
end if;
end;
$$ language plpgsql;

create procedure test4(text)
language plpgsql
as $$
begin
  select * into found_team from teams 
end;


CREATE OR REPLACE PROCEDURE prueba1(team_id)
language plpgsql
as $$
$$;

CREATE FUNCTION attendanceAdjustment(att bigint) RETURNS bigint AS $$
BEGIN
    RETURN att * 0.06;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION getWinsTest(tm text) returns text AS $$
begin
  return tm.team_name;
end;
$$ LANGUAGE plpgsql;
select getWinsTest(teams_id) from teams;

CREATE FUNCTION attendanceAdjustment(att bigint) RETURNS bigint AS $$
BEGIN
    RETURN att * 0.06;
END;
$$ LANGUAGE plpgsql;

select attendanceAdjustment(attendance) from games;

CREATE OR REPLACE FUNCTION getWinsTest3(str text, tm teams) returns text AS $$
begin
  return tm.team_name;
end;
$$ LANGUAGE plpgsql;
select getWinsTest3(td) from teams td;


CREATE FUNCTION getWinsTest5(tm teams) returns text AS $$
begin

end;
$$ LANGUAGE plpgsql;
select getWinsTest5(td) from teams td;


CREATE FUNCTION getWinsTest4(tm teams, tm1 games, tm2 games) returns text AS $$
begin
  return gd1.away_final_score;
end;
$$ LANGUAGE plpgsql;
select getWinsTest4(td, gm1, gm2) from teams td, games gm1, games gm2;


select team_name, away_final_score, home_final_score
from games, teams
where away_team = team_id and away_final_score > home_final_score;

declare 
counter integer;



CREATE FUNCTION score(tm team) RETURNS bigint AS $$
declare 
counter integer;
BEGIN
    select team_name, away_final_score, home_final_score
    from games, teams

    if away_final_score > home_final_score then
      if away_team = tm.team_id;
      then counter:= counter + 1

    if away_final_score < home_final_score then
      if away_team = tm.team_id;
      then counter:= counter:= counter + 1
    end if;
END;
$$ LANGUAGE plpgsql;


create function tumma2(tm games) RETURNS bigint as $$
declare
  counter integer;
begin
  if tm.away_final_score > tm.home_final_score then
    counter := counter + 1;
  end if;
  return counter;
end;
$$ LANGUAGE plpgsql;

create or replace function test()
returns TABLE  (
  team_name text,
  away_team_score int,
  home_team_score int
)
as $$
begin
  return query select teams.team_name, games.away_final_score, games.home_final_score
from games, teams
where games.away_team = teams.team_id and games.away_final_score > games.home_final_score;
end
$$ LANGUAGE plpgsql;

select test ();

create or replace function test()
returns TABLE  (
  quant bigint
)
as $$
begin
  return query select count(*)
from games, teams
where games.away_team = teams.team_id and games.away_final_score > games.home_final_score;
end
$$ LANGUAGE plpgsql;

PRUEBA COM TEAM DE PARAMETRO

 create or replace function awayWins(tm teams)
returns TABLE  (
  away_wins bigint
)
as $$
begin
  return query select count(*) as away_wins
from games, teams
where games.away_team = teams.team_id and teams.team_id = tm.team_id and games.away_final_score > games.home_final_score;
end
$$ LANGUAGE plpgsql;

create or replace function homeWins(tm teams)
returns TABLE  (
  home_wins bigint
)
as $$
begin
  return query select count(*) as home_wins
from games, teams
where games.home_team = teams.team_id and teams.team_id = tm.team_id and games.away_final_score < games.home_final_score;
end
$$ LANGUAGE plpgsql;


 create or replace function awayLosses(tm teams)
returns TABLE  (
  away_losses bigint
)
as $$
begin
  return query select count(*) as away_losses
from games, teams
where games.away_team = teams.team_id and teams.team_id = tm.team_id and games.away_final_score < games.home_final_score;
end
$$ LANGUAGE plpgsql;

create or replace function homeLosses(tm teams)
returns TABLE  (
  home_losses bigint
)
as $$
begin
  return query select count(*) as home_losses
from games, teams
where games.home_team = teams.team_id and teams.team_id = tm.team_id and games.away_final_score > games.home_final_score;
end
$$ LANGUAGE plpgsql;

create or replace function homeSingles(tm teams)
returns TABLE  (
  Hits bigint
)
as $$
begin
  return query select count(*) as hits
from games, teams, atbats
where atbats.event = 'Single' and atbats.g_id = games.g_id and teams.team_id = tm.team_id and games.home_team = teams.team_id;
end
$$ LANGUAGE plpgsql;

create or replace function awaySingles(tm teams)
returns TABLE  (
  Hits bigint
)
as $$
begin
  return query select count(*) as hits
from games, teams, atbats
where atbats.event = 'Single' and atbats.g_id = games.g_id and teams.team_id = tm.team_id and games.away_team = teams.team_id;
end
$$ LANGUAGE plpgsql;

select awaySingles(tm)from teams tm;


create or replace function homeDoubles(tm teams)
returns TABLE  (
  Double bigint
)
as $$
begin
  return query select count(*) as Double
from games, teams, atbats
where atbats.event = 'Double' and atbats.g_id = games.g_id and teams.team_id = tm.team_id and games.home_team = teams.team_id;
end
$$ LANGUAGE plpgsql;

create or replace function awayDoubles(tm teams)
returns TABLE  (
  Double bigint
)
as $$
begin
  return query select count(*) as Double
from games, teams, atbats
where atbats.event = 'Double' and atbats.g_id = games.g_id and teams.team_id = tm.team_id and games.away_team = teams.team_id;
end
$$ LANGUAGE plpgsql;

create or replace function homeTriples(tm teams)
returns TABLE  (
  Triple bigint
)
as $$
begin
  return query select count(*) as Triple
from games, teams, atbats
where atbats.event = 'Triple' and atbats.g_id = games.g_id and teams.team_id = tm.team_id and games.home_team = teams.team_id;
end
$$ LANGUAGE plpgsql;

create or replace function awayTriples(tm teams)
returns TABLE  (
  Triple bigint
)
as $$
begin
  return query select count(*) as Triple
from games, teams, atbats
where atbats.event = 'Triple' and atbats.g_id = games.g_id and teams.team_id = tm.team_id and games.away_team = teams.team_id;
end
$$ LANGUAGE plpgsql;

create or replace function homeHR(tm teams)
returns TABLE  (
  HR bigint
)
as $$
begin
  return query select count(*) as HR
from games, teams, atbats
where atbats.event = 'Home Run' and atbats.g_id = games.g_id and teams.team_id = tm.team_id and games.home_team = teams.team_id;
end
$$ LANGUAGE plpgsql;

create or replace function awayHR(tm teams)
returns TABLE  (
  HR bigint
)
as $$
begin
  return query select count(*) as HR
from games, teams, atbats
where atbats.event = 'Home Run' and atbats.g_id = games.g_id and teams.team_id = tm.team_id and games.away_team = teams.team_id;
end
$$ LANGUAGE plpgsql;