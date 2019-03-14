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
FROM atbats ab
INNER JOIN player_name pn on pn.player_id = ab.pitcher_id
where ab.event = evento and pl = ab.pitcher_id
group by pn.player_id;
end
$$ LANGUAGE plpgsql;


