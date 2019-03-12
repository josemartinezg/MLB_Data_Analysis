CREATE TABLE Games (
  attendance bigint,
  away_final_score int,
  away_team text,
  game_date Date,
  elapsed_time_min int,
  g_id float8,
  home_final_score int,
  home_team text,
  start_time time,
  umpire_HP text,
  venue_name text,
  weather text,
  wind text,
  delay_min int,
  PRIMARY KEY (g_id)
);

CREATE TABLE Player_Name (
  player_id float8,
  first_name text,
  last_name text,
  PRIMARY KEY (player_id)
);


CREATE TABLE AtBats (
  AB_ID float8,
  batter_id float8 REFERENCES Player_Name (player_id) NOT NULL,
  event text,
  g_id float8 REFERENCES Games (g_id) NOT NULL,
  inning int,
  out_r int,
  pitcher_t_score int,
  p_throws text,
  pitcher_id float8 REFERENCES Player_Name (player_id) NOT NULL,
  stand char,
  top_inning bool,
  PRIMARY KEY (AB_ID)
);


CREATE TABLE Pitches (
  ab_id float8 references AtBats (ab_id) NOT NULL,
  ball_count int,
  current_team_score text,
  break_angle float8,
  break_lengh float8,
  pitch_code text,
  nasty int,
  on_1b bool,
  on_2b bool,
  on_3b bool,
  outs int,
  pitch_num int,
  pitch_type text,
  strike_count int,
  spin_Rate float8,
  start_Speed float8,
  end_Speed float8,
  result_of_pitch char
);
/*Ejemplo de importación de Datos en PostgreSQL*/
copy Games(
  attendance,
  away_final_score,
  away_team,
  game_date,
  elapsed_time_min,
  g_id,
  home_final_score,
  home_team,
  start_time,
  umpire_HP,
  venue_name,
  weather,
  wind,
  delay_min
) from 'D:\tmp\games.csv' DELIMITER ',' CSV HEADER;

