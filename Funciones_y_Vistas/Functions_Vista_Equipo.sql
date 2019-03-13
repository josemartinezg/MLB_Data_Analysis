/*======================= Cacular total de 1B, 2B, 3B y HR =============================*/
create or replace function homeHits(tm teams, tipoHit text)
returns TABLE  (
  HR bigint
)
as $$
begin
  return query select count(*)
from games, teams, atbats
where atbats.event = tipoHit and atbats.g_id = games.g_id and teams.team_id = tm.team_id and games.home_team = teams.team_id;
end
$$ LANGUAGE plpgsql;

select homeHits(tm, 'Double') from teams tm;

create or replace function awayHits(tm teams, gm games, tipoHit text)
returns TABLE  (
  HR bigint
)
as $$
begin
  return query select count(*) as HR
from games, teams, atbats
where atbats.event = tipoHit and atbats.g_id = games.g_id and teams.team_id = tm.team_id and games.away_team = teams.team_id;
end
$$ LANGUAGE plpgsql;

select awayHits(tm, gm, 'Single') from teams tm, games gm;

/*======================= Carreras Anotadas visitante (works) =============================*/

create or replace function awayRunScored(tm teams)
returns TABLE  (
  anotadas bigint
)
as $$
begin
  return query select sum(away_final_score) as anotadas
from games, teams, atbats
where teams.team_id = tm.team_id and games.away_team = teams.team_id;
end
$$ LANGUAGE plpgsql;

select awayRunScored(tm) from teams tm;

create index score_idx on games(away_final_score, home_final_score);

/*create or replace function carreras_anotadas_away(tm teams)
returns TABLE  (
  anotadas bigint
)
as $$
  begin
  return query select sum(games.away_final_score) as anotadas
from games, teams, atbats
where teams.team_id = 'tba' and games.away_team = teams.team_id;
end
$$ LANGUAGE plpgsql;*/
/*======================= Carreras Anotadas Home (works)=============================*/
create or replace function homeRunScored(tm teams, tipoPitch text)
returns TABLE  (
  anotadas bigint
)
as $$
begin
  return query select sum(home_final_score) as anotadas
from games, teams, atbats
where teams.team_id = tm.team_id and games.home_team = teams.team_id;
end
$$ LANGUAGE plpgsql;

select awayRunScored(tm) from teams tm;

/*create or replace function commonPitch(tm teams)
returns TABLE  (
  lanzamiento bigint,
  amount bigint
)
as $$
begin
  return query 
  select pitch_type, count(pitch_type) as amount
  from pitches, teams, games
where teams.team_id = tm.team_id  and games.away_team = teams.team_id;
group by pitch_type
order by amount
desc
limit 1;
end
$$ LANGUAGE plpgsql;

select commonPitch(tm) from teams tm;/*/

create or replace function awayBalls(tm teams)
returns TABLE  (
  bolas bigint
)
as $$
begin
  return query select count(*) as bolas
from games, teams, atbats, Pitches
where pitches.result_of_pitch = 'B' and teams.team_id = tm.team_id and games.away_team = teams.team_id;
end
$$ LANGUAGE plpgsql;

select awayBalls(tm) from teams tm LIMIT 2;

select pitch_type, count(pitch_type) as amount
from pitches, teams
where teams.team_id = tm.team_id
group by pitch_type
order by amount
desc 
limit 1

select to_char(avg(p.break_angle),'9999.99') as 'Avg. Break Angle'
where teams.team_id = 'tba'
from pitches p, teams;


create or replace function awayStrikes()
returns TABLE(
  nombre_equipo text,
  cant  biging
)
as $$
begin 
return query SELECT  tm.team_name, count(p.result_of_pitch)
FROM pitches p
INNER JOIN atbats ab on ab.ab_id = p.ab_id
INNER JOIN games gm on gm.g_id = ab.g_id
INNER JOIN teams tm on tm.team_id = gm.away_team
INNER JOIN player_name pn on pn.player_id = ab.pitcher_id
where p.result_of_pitch = 'B'
group by tm.team_name
order by count(p.result_of_pitch) desc;
end
$$ LANGUAGE plpgsql;


create or replace function awayPitches(ch char)
returns TABLE(
  nombre_equipo text,
  cant  bigint
)
as $$
begin 
return query SELECT  tm.team_name, count(p.result_of_pitch)
FROM pitches p
INNER JOIN atbats ab on ab.ab_id = p.ab_id
INNER JOIN games gm on gm.g_id = ab.g_id
INNER JOIN teams tm on tm.team_id = gm.away_team
INNER JOIN player_name pn on pn.player_id = ab.pitcher_id
where p.result_of_pitch = ch
group by tm.team_name
order by count(p.result_of_pitch) desc;
end
$$ LANGUAGE plpgsql;

select awayStrikes();

create or replace function homePitches(ch char)
returns TABLE(
  nombre_equipo text,
  cant  bigint
)
as $$
begin 
return query SELECT  tm.team_name, count(p.result_of_pitch)
FROM pitches p
INNER JOIN atbats ab on ab.ab_id = p.ab_id
INNER JOIN games gm on gm.g_id = ab.g_id
INNER JOIN teams tm on tm.team_id = gm.home_team
INNER JOIN player_name pn on pn.player_id = ab.pitcher_id
where p.result_of_pitch = ch
group by tm.team_name
order by count(p.result_of_pitch) desc;
end
$$ LANGUAGE plpgsql;

select homePitches('S');
/*LA FUNCION SIGUIENTE FUNCIONA Y TIENE UN PROMEDIO GENERAL, NO SOLO DE RUTA O CASA. */

create or replace function breakAngleAvg()
returns TABLE(
	BrkAnglAvg text
)
as $$
begin 
return query SELECT  to_char(avg(p.break_angle), '9999.99') as "Break Angle Avg."
FROM pitches p
INNER JOIN atbats ab on ab.ab_id = p.ab_id
INNER JOIN games gm on gm.g_id = ab.g_id
INNER JOIN teams tm on tm.team_id = gm.home_team or tm.team_id = gm.away_team
INNER JOIN player_name pn on pn.player_id = ab.pitcher_id
group by tm.team_name;
end
$$ LANGUAGE plpgsql;

  select breakAngleAvg();
  /*PENDIENTE A REVISAR ESTA FUNCION DE ABAJO.*/
create or replace function breakLenAvg()
returns TABLE(
	BrkLngthlAvg text
)
as $$
begin 
return query SELECT  to_char(avg(p.break_lengTH), '9999.99') as "Break Lenght Avg"
FROM pitches p
INNER JOIN atbats ab on ab.ab_id = p.ab_id
INNER JOIN games gm on gm.g_id = ab.g_id
INNER JOIN teams tm on tm.team_id = gm.home_team or tm.team_id = gm.away_team
INNER JOIN player_name pn on pn.player_id = ab.pitcher_id
group by tm.team_name;
end
$$ LANGUAGE plpgsql;

select breakLenAvg();

/*SPIN RATE PROMEDIO*/
create or replace function spnLenAvg()
returns TABLE(
	BrkLngthlAvg text
)
as $$
begin 
return query SELECT  to_char(avg(p.spin_rate), '9999.99') as "Spin Rate Avg"
FROM pitches p
INNER JOIN atbats ab on ab.ab_id = p.ab_id
INNER JOIN games gm on gm.g_id = ab.g_id
INNER JOIN teams tm on tm.team_id = gm.home_team or tm.team_id = gm.away_team
INNER JOIN player_name pn on pn.player_id = ab.pitcher_id
group by tm.team_name;
end
$$ LANGUAGE plpgsql;

select spnLenAvg();
/*VELOCIDAD PROMEDIO DEL LANZADOR*/
create or replace function avgSpeed()
returns TABLE(
	BrkLngthlAvg text
)
as $$
begin 
return query SELECT  to_char(avg(p.start_Speed), '9999.99') as "Speed Average"
FROM pitches p
INNER JOIN atbats ab on ab.ab_id = p.ab_id
INNER JOIN games gm on gm.g_id = ab.g_id
INNER JOIN teams tm on tm.team_id = gm.home_team or tm.team_id = gm.away_team
INNER JOIN player_name pn on pn.player_id = ab.pitcher_id
group by tm.team_name
;end
$$ LANGUAGE plpgsql;

select avgSpeed();
/**/


CREATE VIEW Dim_Equipo as (SELECT team_id as ID,
team_name as Nombre_Equipo,
homeWins(tm) from games tm as Victorias_Home,
venue_name as Nombre_Estadio

from teams tm
inner JOIN
);

