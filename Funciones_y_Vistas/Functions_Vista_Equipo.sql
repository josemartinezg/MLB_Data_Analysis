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
  hit bigint
)
as $$
begin
  return query 
  select count(*)
  from games, teams, atbats
  where atbats.event = tipoHit and atbats.g_id = games.g_id and teams.team_id = tm.team_id 
  and (games.home_team = teams.team_id or games.away_team = teams.team_id );
end
$$ LANGUAGE plpgsql;

select cantHits(tm, 'Double') from teams tm;

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
/*======================== FUNCIÓN QUE CONTABILIZA BOLAS Y STRIKES EN LA RUTA Y EN LA CASA ==============================*/
create or replace function quantPitchResults(tms teams, pitch char)
returns TABLE(
  cant  bigint
)
as $$
begin 
  return query 
  SELECT count(p.result_of_pitch)
  FROM pitches p
  INNER JOIN atbats ab on ab.ab_id = p.ab_id
  INNER JOIN games gm on gm.g_id = ab.g_id
  INNER JOIN teams tm on tm.team_id = gm.home_team or tm.team_id = gm.away_team
  INNER JOIN player_name pn on pn.player_id = ab.pitcher_id
  where p.result_of_pitch = pitch and tm.team_id = tms.team_id
  group by tm.team_name
  order by count(p.result_of_pitch) desc;
end
$$ LANGUAGE plpgsql;

select quantPitchResults(tms, 'S') from teams tms;

/*======================================VELOCIDAD PROMEDIO DE CADA EQUIPO======================================*/
create or replace function avgSpeedTeams(tms teams)
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
  where tm.team_id = tms.team_id
  group by tm.team_name
;end
$$ LANGUAGE plpgsql;

select avgSpeedTeams(tm) from teams tm;
/*======================================SPIN RATE PROMEDIO POR EQUIPO======================================*/
create or replace function spnRateAvgTeam(teams tms)
returns TABLE(
	BrkLngthlAvg text
)
as $$
begin 
return query 
  SELECT  to_char(avg(p.spin_rate), '9999.99') as "Spin Rate Avg. ("
  FROM pitches p
  INNER JOIN atbats ab on ab.ab_id = p.ab_id
  INNER JOIN games gm on gm.g_id = ab.g_id
  INNER JOIN teams tm on tm.team_id = gm.home_team or tm.team_id = gm.away_team
  INNER JOIN player_name pn on pn.player_id = ab.pitcher_id
  where tm.team_id = tms.team_id
  group by tm.team_name;
end
$$ LANGUAGE plpgsql;

select spnRateAvgTeam(teams tms);
/*Cálculo de break angle promedio*/
create or replace function breakAngleAvgTeam(tms teams)
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
  where tm.team_id = tms.team_id
  group by tm.team_name;
end
$$ LANGUAGE plpgsql;

select breakAngleAvgTeam(tm) from teams tm;
/*Cálculo de break length promedio*/
create or replace function breakLenAvgTeam(tms teams)
returns TABLE(
	BrkLngthlAvg text
)
as $$
begin 
return query 
  SELECT  to_char(avg(p.break_lengTH), '9999.99') as "Break Lenght Avg"
  FROM pitches p
  INNER JOIN atbats ab on ab.ab_id = p.ab_id
  INNER JOIN games gm on gm.g_id = ab.g_id
  INNER JOIN teams tm on tm.team_id = gm.home_team or tm.team_id = gm.away_team
  INNER JOIN player_name pn on pn.player_id = ab.pitcher_id
  where tm.team_id = tms.team_id
  group by tm.team_name;
end
$$ LANGUAGE plpgsql;

select breakLenAvgTeam(tm) from teams tm;

/*======================= Cacular total de 1B, 2B, 3B y HR EN LA RUTA =============================*/
create or replace function awayHits(tm teams, tipoHit text)
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

select awayHits(tm, 'Double') from teams tm;
/*======================= Cacular total de 1B, 2B, 3B y HR EN CASA  =============================*/
create or replace function homeHits(tm teams, tipoHit text)
returns TABLE  (
  HR bigint
)
as $$
begin
  return query 
  select count(*) as HR
  from games, teams, atbats
  where atbats.event = tipoHit and atbats.g_id = games.g_id and teams.team_id = tm.team_id and games.home_team = teams.team_id;
end
$$ LANGUAGE plpgsql;

select homeHits(tm, 'Double') from teams tm;

