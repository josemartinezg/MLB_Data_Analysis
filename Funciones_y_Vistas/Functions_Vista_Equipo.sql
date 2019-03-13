/*======================= Away WINS (working)=============================*/
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
select awayWins(tm) as Victorias_Visitante from teams tm;

/*======================= Home WINS (working)=============================*/
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

select homeWins(tm) as Victorias_Casa from teams tm;


/*======================= Away LOSSES (working)=============================*/
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

select homeLosses(tm) as Perdidos_Casa from teams tm;

/*======================= Home LOSSES (working)=============================*/
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

select awayLosses(tm) as Perdidos_Casa from teams tm;

/*======================= Cacular total de 1B, 2B, 3B y HR EN CASA Y EN LA RUTA =============================*/
create or replace function cantHits(tm teams, tipoHit text)
returns TABLE  (
  HR bigint
)
as $$
begin
  return query select count(*)
from games, teams, atbats
where atbats.event = tipoHit and atbats.g_id = games.g_id and teams.team_id = tm.team_id 
and (games.home_team = teams.team_id or games.away_team = teams.team_id );
end
$$ LANGUAGE plpgsql;

select cantHits(tm, 'Double') from teams tm;

/*create or replace function awayHits(tm teams, gm games, tipoHit text)
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

select awayHits(tm, 'Double') from teams tm, games gm;*/

/*======================= Total Carreras Anotadas  (works) =============================*/

create or replace function runsScored(tms teams)
returns TABLE(
	anotadas bigint
)
as $$
begin

	return query 
	select sum(gm.away_final_score + gm.home_final_score) as All_Scores
	from games gm
	Inner join teams tm on tm.team_id = gm.home_team
	inner join teams tn on tn.team_id = gm.away_team
	where tm.team_id = tms.team_id or tn.team_id = tms.team_id;
end $$
LANGUAGE plpgsql;

select runsScored(tm) as Carreras_Anotadas from teams tm;

create index score_idx on games(away_final_score, home_final_score);
/*======================= Promedio Carreras Anotadas  (works) =============================*/
create or replace function runsScoreAvg(tms teams)
returns TABLE(
	anotadasAVG numeric
)
as $$
begin
	return query 
	select avg(gm.away_final_score + gm.home_final_score) as All_Scores
	from games gm
	Inner join teams tm on tm.team_id = gm.home_team
	inner join teams tn on tn.team_id = gm.away_team
	where tm.team_id = tms.team_id or tn.team_id = tms.team_id;
end $$
LANGUAGE plpgsql;

select runsScoreAvg(tm) as Carreras_Anotadas from teams tm;
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
create or replace function totalRunsScored(tm teams)
returns TABLE  (
  anotadas bigint
)
as $$
begin
  return query select sum(home_final_score) as anotadas
from games, teams, atbats
where teams.team_id = tm.team_id and (games.home_team = tm.team_id /*or games.away_team = teams.team_id*/);
end
$$ LANGUAGE plpgsql;

select totalRunsScored(tm) from teams tm
limit 1;

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
/*======================== FUNCIÓN QUE CONTABILIZA BOLAS Y STRIKES EN LA RUTA Y EN LA CASA ==============================*/
create or replace function quantPitchResults(pitch char)
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
INNER JOIN teams tm on tm.team_id = gm.home_team or tm.team_id = gm.away_team
INNER JOIN player_name pn on pn.player_id = ab.pitcher_id
where p.result_of_pitch = pitch
group by tm.team_name
order by count(p.result_of_pitch) desc;
end
$$ LANGUAGE plpgsql;

select quantPitchResults('S');
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
/*======================== FUNCIÓN QUE PROMEDIA LAS BOLAS Y STRIKES EN LA RUTA Y EN LA CASA ==============================*/
create or replace function avgPitchResult(pitch char)
returns TABLE(
  nombre_equipo text,
  cant  bigint
)
as $$
begin 
return query SELECT  tm.team_name, Avg(p.result_of_pitch)
FROM pitches p
INNER JOIN atbats ab on ab.ab_id = p.ab_id
INNER JOIN games gm on gm.g_id = ab.g_id
INNER JOIN teams tm on tm.team_id = gm.home_team or tm.team_id = gm.away_team
INNER JOIN player_name pn on pn.player_id = ab.pitcher_id
where p.result_of_pitch = pitch
group by tm.team_name
order by count(p.result_of_pitch) desc;
end
$$ LANGUAGE plpgsql;

select avgPitchResult('S');


CREATE VIEW Dim_Equipo as (SELECT team_id as ID,
team_name as Nombre_Equipo,
homeWins(tm) from games tm as Victorias_Home,
venue_name as Nombre_Estadio

from teams tm
inner JOIN
);

/*======================= Bolas y Strikes Lanzados por pitcher (works)=============================*/
create or replace function resultPitch(pl double precision ,resultPitch char)
returns TABLE  (
  result bigint
)
as $$
begin
  return query SELECT count(p.result_of_pitch) as result
FROM pitches p
INNER JOIN atbats ab on ab.ab_id = p.ab_id
INNER JOIN player_name pn on pn.player_id = ab.pitcher_id
where p.result_of_pitch = resultPitch and pl = ab.pitcher_id
group by pn.player_id;
end
$$ LANGUAGE plpgsql;
/*======================= Cantidad de eventos por pitcher (works)=============================*/
create or replace function cantidadEvento(pl double precision ,evento text)
returns TABLE  (
  result bigint
)
as $$
begin
  return query SELECT count(ab.event) as result
FROM pitches p
INNER JOIN atbats ab on ab.ab_id = p.ab_id
INNER JOIN player_name pn on pn.player_id = ab.pitcher_id
where ab.event = evento and pl = ab.pitcher_id
group by pn.player_id;
end
$$ LANGUAGE plpgsql;



