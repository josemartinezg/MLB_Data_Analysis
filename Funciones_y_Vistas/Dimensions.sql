CREATE VIEW Dim_Equipo as (SELECT team_id as ID,
team_name as Nombre_Equipo,
homeWins(tm) from games tm as Victorias_Home,
venue_name as Nombre_Estadio
	FROM teams;
from teams
);

CREATE VIEW Dimension_Tiempo AS (
SELECT 
to_char("game_date",'DD-MM-YYYY') as "Fecha Juego",
to_char("game_date",'DD') as "Dia Juego",
to_char("game_date",'DAY') as "Dia Semana Juego",
to_char("game_date",'MONTH') as "Mes Juego",
to_char("game_date",'YYYY') as "Año Juego",
"start_time" as " Hora Inicio",
to_char("start_time",'HH24') as "Hora",
"elapsed_time_min" as "Duracion (MIN)",
to_char(("elapsed_time_min" / 60.0),'9.9') as "Duracion (HORAS)",
case 
    when to_number(to_char("game_date",'MM'),'99' ) in (12,1,2) then 'WINTER'
    when to_number(to_char("game_date",'MM'),'99' ) in (3,4,5) then 'SPRING'
    when to_number(to_char("game_date",'MM'),'99' )  in (6,7,8) then 'SUMMER'
    when to_number(to_char("game_date",'MM'),'99' )  in (9,10,11) then 'FALL'
end as "Temporada Climatica"

FROM "games"


);
