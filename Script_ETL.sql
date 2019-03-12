Create Table "atbats_ODS" as (select * from "atbats");
Create Table "games_ODS" as (select * from "games");
Create table "pitches_ODS" as (select * from "pitches");
Create Table "player_name_ODS" as (select * from "player_name");
Create Table "teams_ODS" as (select * from "teams");

INSERT INTO "atbats_ODS"(
  select * from "atbats"
  except SELECT * FROM "atbats_ODS"
);

INSERT INTO "games_ODS"(
  select * from "games"
  except SELECT * FROM "games_ODS"
);

INSERT INTO "pitches_ODS"(
  select * from "pitches"
  except SELECT * FROM "pitches_ODS"
);

INSERT INTO "player_name_ODS"(
  select * from "player_name"
  except SELECT * FROM "player_name_ODS"
);

INSERT INTO "teams_ODS"(
  select * from "teams"
  except SELECT * FROM "teams_ODS"
);

--Triggers para los updates automaticos:--
​	
Create function update_atbats_ODS() 
Returns Trigger as
$cuerpo$
Begin
​	INSERT INTO "atbats_ODS"
​	(select * from new.atbats except SELECT * FROM old.atbats);
Return New;
End;
$cuerpo$ 
Language plpgsql;

CREATE TRIGGER Update_atbats
​    AFTER UPDATE or INSERT ON atbats
​    FOR EACH ROW
​    EXECUTE PROCEDURE update_atbats_ODS();

Create function update_games_ODS() 
Returns Trigger as
$cuerpo$
Begin
​	INSERT INTO "games_ODS"
​	(select * from new.games except SELECT * FROM old.games);
Return New;
End;
$cuerpo$ 
Language plpgsql;

CREATE TRIGGER Update_games
​	AFTER UPDATE or INSERT ON games
​	FOR EACH ROW
​	EXECUTE PROCEDURE update_games_ODS();

Create function update_pitches_ODS() 
Returns Trigger as
$cuerpo$
Begin
​	INSERT INTO "pitches_ODS"
​	(select * from new.pitches except SELECT * FROM old.pitches);
Return New;
End;
$cuerpo$ 
Language plpgsql;

CREATE TRIGGER Update_pitches
​	AFTER UPDATE or INSERT ON pitches
​	FOR EACH ROW
​	EXECUTE PROCEDURE update_pitches_ODS();

Create function update_player_name_ODS() 
Returns Trigger as
$cuerpo$
Begin
​	INSERT INTO "player_name_ODS"
​	(select * from new.player_name except SELECT * FROM old.player_name);
Return New;
End;
$cuerpo$ 
Language plpgsql;

CREATE TRIGGER Update_player_name
​	AFTER UPDATE or INSERT ON player_name
​	FOR EACH ROW
​	EXECUTE PROCEDURE update_player_name_ODS();

Create function update_teams_ODS() 
Returns Trigger as
$cuerpo$
Begin
​	INSERT INTO "teams_ODS"
​	(select * from new.teams_name except SELECT * FROM old.teams_name);
Return New;
End;
$cuerpo$ 
Language plpgsql;

CREATE TRIGGER Update_teams
​	AFTER UPDATE or INSERT ON teams
​	FOR EACH ROW
​	EXECUTE PROCEDURE update_teams_ODS();