======================= Cacular total de hits =============================
create or replace function homeHits(tm teams, tipoHit text)
returns TABLE  (
  HR bigint
)
as $$
begin
  return query select count(*) as HR
from games, teams, atbats
where atbats.event = tipoHit and atbats.g_id = games.g_id and teams.team_id = tm.team_id and games.home_team = teams.team_id;
end
$$ LANGUAGE plpgsql;

select homeHits(tm, 'Double') from teams tm;

create or replace function awayHits2(tm teams, gm games, tipoHit text)
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

==========================================================================

create or replace function carreras_anotadas_visitante(tm teams)
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

create or replace function carreras_anotadas_away(tm teams)
returns TABLE  (
  anotadas bigint
)
as $$
begin
  return query select sum(games.away_final_score) as anotadas
from games, teams, atbats
where teams.team_id = 'tba' and games.away_team = teams.team_id;
end
$$ LANGUAGE plpgsql;


create or replace function carreras_anotadas_home(tm teams)
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

create or replace function home_lanzamiento_tipico(tm teams)
returns TABLE  (
  lanzamiento bigint
)
as $$
begin
  return query select count(*) as lanzamiento
from games, teams, atbats
where atbats.event = 'Home Run' and atbats.g_id = games.g_id and teams.team_id = tm.team_id and games.home_team = teams.team_id;
end
$$ LANGUAGE plpgsql;

create or replace function bolas_visitante(tm teams)
returns TABLE  (
  bolas bigint
)
as $$
begin
  return query select count(*) as bolas
from games, teams, atbats, Pitches
where atbats.event = 'B' and teams.team_id = tm.team_id and games.away_team = teams.team_id 
end
$$ LANGUAGE plpgsql;

