ALTER TABLE pitches ALTER COLUMN current_team_score TYPE int USING (current_team_score::int);

create index score_idx on games(away_final_score, home_final_score);

ALTER TABLE atbats ALTER COLUMN ab_id TYPE double precision USING (ab_id::double precision);

create index score_idx on games(away_final_score, home_final_score);

delete from atbats
where g_id = 201802431;

delete from atbats
where g_id = 201802430;

