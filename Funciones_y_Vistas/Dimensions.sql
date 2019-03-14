CREATE OR REPLACE VIEW Dim_Equipo1 as (SELECT team_id as ID,
team_name as Nombre_Equipo,
venue_name as Nombre_Estadio,
homeWins(tm) as Victorias_Casa,
awayWins(tm) as Victorias_Ruta,
homeLosses(tm) as Perdidos_Casa,
awayLosses(tm) as Perdidos_Ruta,
cantHits(tm, 'Single') as Total_1B,
cantHits(tm, 'Double') as Total_2B,
cantHits(tm, 'Triple') as Total_3B,
cantHits(tm, 'Home Run') as Total_HR,
runsScored(tm), as Carreras_Anotadas,
runsScoreAvg(tm) as Carreras_Anotadas_Promedio,
from teams tm
);

CREATE VIEW Dimension_Lanzador AS (
SELECT  
ab.pitcher_id as "Id Lanzador",
concat(pn.first_name,' ', pn.last_name) as "Nombre Lanzador",
case
    when ab.p_throws = 'L' then 'Izquierda'
    else 'Derecha'
end as "Mano Lanzador",
resultpitch(ab.pitcher_id,'B') as "Cant. Bolas Lanzador",
resultpitch(ab.pitcher_id,'S') as "Cant. Strikes Lanzador",
to_char(avg(p.break_angle),'9999.99')as "Break Angle Prom.",
to_char(avg(p.break_lengh),'9999.99')as "Break Length Prom.",
sum(p.current_team_score) as "Carreras Permitidas",
to_char(avg(p.end_Speed),'9999.99')as "Velocidad Promedio",
to_char(avg(p.spin_Rate),'9999.99')as "Spin Rate Promedio",
to_char(avg(p.nasty),'9999.99')as "Nasty Promedio",
cantidadevento(ab.pitcher_id,'Strikeout') as "Ponches",
cantidadevento(ab.pitcher_id,'Walk') as "Base por bolas",
cantidadevento(ab.pitcher_id,'Single') as "Hits Permitidos",
cantidadevento(ab.pitcher_id,'Double') as "Doubles Permitidos",
cantidadevento(ab.pitcher_id,'Triple') as "Triples Permitidos",
cantidadevento(ab.pitcher_id,'Home Run') as "Home Run Permitidos"
FROM pitches p
INNER JOIN atbats ab on ab.ab_id = p.ab_id
INNER JOIN player_name pn on pn.player_id = ab.pitcher_id
GROUP BY ab.pitcher_id,pn.first_name,pn.last_name,ab.p_throws,pn.*
);

CREATE VIEW Dimension_Tiempo AS (
SELECT 
to_char(game_date,'DD-MM-YYYY') as "Fecha Juego",
to_char(game_date,'DD') as "Dia Juego",
to_char(game_date,'DAY') as "Dia Semana Juego",
to_char(game_date,'MONTH') as "Mes Juego",
to_char(game_date,'YYYY') as "Año Juego",
start_time as " Hora Inicio",
to_char(start_time,'HH24') as "Hora",
elapsed_time_min as "Duracion (MIN)",
to_char((elapsed_time_min / 60.0),'9.9') as "Duracion (HORAS)",
case 
    when to_number(to_char(game_date,'MM'),'99' ) in (12,1,2) then 'WINTER'
    when to_number(to_char(game_date,'MM'),'99' ) in (3,4,5) then 'SPRING'
    when to_number(to_char(game_date,'MM'),'99' )  in (6,7,8) then 'SUMMER'
    when to_number(to_char(game_date,'MM'),'99' )  in (9,10,11) then 'FALL'
end as "Temporada Climatica"

FROM games


);
