-- create 3 regions
  -- Democratic Heavy Region
    CREATE TABLE Region_1 (voter_id INT PRIMARY KEY, name character(25), vote char(1));
  -- Neutral Region
    CREATE TABLE Region_2 (voter_id int PRIMARY KEY, name character(25), vote char(1));
  -- Republican Heavy Region
    CREATE TABLE Region_3 (voter_id int PRIMARY KEY, name character(25), vote char(1));


-- Populate regions with voters. Real data shows a tie vote
  -- Populate region with 1 more Dem than Rep
    INSERT INTO Region_1 (voter_id, name, vote)
    VALUES (1, "Dem 1", 'D'), (2, "Dem 2", 'D'), (3, "Rep 1", 'R');

  -- Populate region with equal Dems and Reps
    INSERT INTO Region_2 (voter_id, name, vote)
    VALUES (1, "Dem 3", 'D'), (2, "Rep 2", 'R');

  -- Populate region with 1 more Rep than Dem
    INSERT INTO Region_3 (voter_id, name, vote)
    VALUES (1, "Dem 4", 'D'), (2, "Rep 3", 'R'), (3, "Rep 4", 'R');



  CREATE VIEW [Region 1 Total] AS
  SELECT 'Votes' AS 'Votes',
     ( SELECT COUNT(vote) FROM Region_1 WHERE vote='D' ) AS Democratic,
     ( SELECT COUNT(vote) FROM Region_1 WHERE vote='R' ) AS Republican;

  CREATE VIEW [Region 2 Total] AS
  SELECT 'Votes' AS 'Votes',
     ( SELECT COUNT(vote) FROM Region_2 WHERE vote='D' ) AS Democratic,
     ( SELECT COUNT(vote) FROM Region_2 WHERE vote='R' ) AS Republican;


  CREATE VIEW [Region 3 Total] AS
  SELECT 'Votes' AS 'Votes',
     ( SELECT COUNT(vote) FROM Region_3 WHERE vote='D' ) AS Democratic,
     ( SELECT COUNT(vote) FROM Region_3 WHERE vote='R' ) AS Republican;


-- Democratic votes by region
  CREATE VIEW [Democratic Vote Total] AS
  SELECT 'Region 1' AS Region, COUNT(vote) AS [Democratic Vote Total]
  FROM Region_1
  WHERE  vote='D'
  UNION ALL
  SELECT 'Region 2', COUNT(vote)
  FROM Region_2
  WHERE vote='D'
  UNION ALL
  SELECT 'Region 3', COUNT(vote)
  FROM Region_3
  WHERE vote='D'

-- Democratic votes by region after voter suppression tactics
  CREATE VIEW [Democratic Vote Total] AS
  SELECT 'Region 1' AS Region, COUNT(vote) AS [Democratic Vote Total]
  FROM Region_1
  WHERE  vote='D'
  UNION ALL
  SELECT 'Region 2', COUNT(vote)
  FROM Region_2
  WHERE vote='D'
  UNION ALL
  SELECT 'Region 3', COUNT(vote)
  FROM Region_3
  WHERE vote='D'

-- Republican votes by region
  CREATE VIEW [Republican Vote Total] AS
  SELECT 'Region 1' AS Region, COUNT(vote) AS [Republican Vote Total]
  FROM Region_1
  WHERE  vote='R'
  UNION ALL
  SELECT 'Region 2', COUNT(vote)
  FROM Region_2
  WHERE vote='R'
  UNION ALL
  SELECT 'Region 3', COUNT(vote)
  FROM Region_3
  WHERE vote='R'

-- Legit election results
  CREATE VIEW [Election Results] AS
  SELECT 'Votes' AS 'Votes',
     ( SELECT SUM([Democratic Vote Total]) FROM [Democratic Vote Total] ) AS Democratic,
     ( SELECT SUM([Republican Vote Total]) FROM [Republican Vote Total] ) AS Republican;


-- Democratic votes don't count if they have joined the party too recently... >__>
  CREATE VIEW [Skewed 4 Reps] AS
  SELECT 'Votes' AS 'Votes',
    ( SELECT SUM([Democratic Vote Total]) FROM [Democratic Vote Total] ) AS Democratic,
    ( SELECT SUM([Republican Vote Total]) FROM [Republican Vote Total] ) AS Republican



-- Dems total is set to 48.5% of the total ballots cast and Reps get 51.5% to pretend the race was close
  CREATE VIEW [Skewed 4 Dems] AS
  SELECT 'Votes' AS 'Votes',
     ( SELECT ROUND( (SUM([Democratic Vote Total]) + SUM([Democratic Vote Total])) * 0.515, 0) + 1 FROM [Democratic Vote Total] ) AS Democratic,
     ( SELECT ROUND( (SUM([Republican Vote Total]) + SUM([Republican Vote Total])) * 0.485, 0) - 1 FROM [Republican Vote Total] ) AS Republican;




-- Drop Everything Commands
  drop table Region_1;
  drop table Region_2;
  drop table Region_3;

  drop view [Region 1 Total];
  drop view [Region 2 Total];
  drop view [Region 3 Total];

  drop view [Election Results];
  drop view [Skewed Results For Democrats];
  drop view [Skewed Results For Republicans];
