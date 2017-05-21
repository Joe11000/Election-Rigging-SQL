
-- create 3 regions
  -- Democratic Heavy Region
    CREATE TABLE `Region 1` (voter_id INT PRIMARY KEY, name character(25), vote char(1), member_since date NOT NULL DEFAULT '2016-11-16');
  -- Neutral Region
    CREATE TABLE `Region 2` (voter_id int PRIMARY KEY, name character(25), vote char(1), member_since date NOT NULL DEFAULT '2016-11-16');
  -- Republican Heavy Region
    CREATE TABLE `Region 3` (voter_id int PRIMARY KEY, name character(25), vote char(1), member_since date NOT NULL DEFAULT '2016-11-16');



-- Populate regions with voters. Real data shows a tie vote
  -- Populate region with 1 more Dem than Rep
    INSERT INTO `Region 1` (voter_id, name, vote, member_since)
    VALUES (1, "Dem 1", 'D', '2016-10-10'), (2, "Dem 2", 'D', '2008-11-10'), (3, "Rep 1", 'R', '2008-11-10');

  -- Populate region with equal Dems and Reps
    INSERT INTO `Region 2` (voter_id, name, vote, member_since)
    VALUES (1, "Dem 3", 'D', '2008-11-10'), (2, "Rep 2", 'R', '2008-11-10');

  -- Populate region with 1 more Rep than Dem
    INSERT INTO `Region 3` (voter_id, name, vote, member_since)
    VALUES (1, "Dem 4", 'D', '2008-11-10'), (2, "Rep 3", 'R', '2008-11-10'), (3, "Rep 4", 'R', '2008-11-10');



-- At each Region, see the vote total for each candidate
  CREATE VIEW `Region 1 Total` AS
  SELECT 'Votes' AS 'Votes',
     ( SELECT COUNT(vote) FROM `Region 1` WHERE vote='D' ) AS Democratic,
     ( SELECT COUNT(vote) FROM `Region 1` WHERE vote='R' ) AS Republican;

  CREATE VIEW `Region 2 Total` AS
  SELECT 'Votes' AS 'Votes',
     ( SELECT COUNT(vote) FROM `Region 2` WHERE vote='D' ) AS Democratic,
     ( SELECT COUNT(vote) FROM `Region 2` WHERE vote='R' ) AS Republican;

  CREATE VIEW `Region 3 Total` AS
  SELECT 'Votes' AS 'Votes',
     ( SELECT COUNT(vote) FROM `Region 3` WHERE vote='D' ) AS Democratic,
     ( SELECT COUNT(vote) FROM `Region 3` WHERE vote='R' ) AS Republican;



-- Democratic votes by region
  CREATE VIEW `Vote Total: Democrats` AS
  SELECT 'Region 1' AS Region, COUNT(vote) AS `Vote Total: Democrats`
  FROM `Region 1`
  WHERE  vote='D'
  UNION ALL
  SELECT 'Region 2', COUNT(vote)
  FROM `Region 2`
  WHERE vote='D'
  UNION ALL
  SELECT 'Region 3', COUNT(vote)
  FROM `Region 3`
  WHERE vote='D';

-- Democratic votes by region after voter suppression tactics
  CREATE VIEW `Democratic Vote Suppression Total` AS
  SELECT 'Region 1' AS Region, COUNT(vote) AS `Vote Total: Democrats`
  FROM `Region 1`
  WHERE  vote='D'
  AND   member_since < '2016-1-1'
  UNION ALL
  SELECT 'Region 2', COUNT(vote)
  FROM `Region 2`
  WHERE vote='D'
  AND   member_since < '2016-1-1'
  UNION ALL
  SELECT 'Region 3', COUNT(vote)
  FROM `Region 3`
  WHERE vote='D'
  AND   member_since < '2016-1-1';

-- Republican votes by region
  CREATE VIEW `Vote Total: Republicans` AS
  SELECT 'Region 1' AS Region, COUNT(vote) AS `Vote Total: Republicans`
  FROM `Region 1`
  WHERE  vote='R'
  UNION ALL
  SELECT 'Region 2', COUNT(vote)
  FROM `Region 2`
  WHERE vote='R'
  UNION ALL
  SELECT 'Region 3', COUNT(vote)
  FROM `Region 3`
  WHERE vote='R';



-- Legit election results
  CREATE VIEW `Election Results` AS
  SELECT 'Votes' AS 'Votes',
     ( SELECT SUM(`Vote Total: Democrats`) FROM `Vote Total: Democrats` ) AS Democratic,
     ( SELECT SUM(`Vote Total: Republicans`) FROM `Vote Total: Republicans` ) AS Republican;

-- Democratic votes don't count if they have joined the party too recently... >__>
  CREATE VIEW `Election Results: Skewed For Republicans` AS
  SELECT 'Votes' AS 'Votes',
    ( SELECT SUM(`Vote Total: Democrats`) FROM `Democratic Vote Suppression Total` ) AS Democratic,
    ( SELECT SUM(`Vote Total: Republicans`) FROM `Vote Total: Republicans` ) AS Republican;

-- Dems total is set to 48.5% of the total ballots cast and Reps get 51.5% to pretend the race was close
  CREATE VIEW `Election Results: Skewed For Democrats` AS
  SELECT 'Votes' AS 'Votes',
     ( SELECT ROUND( (SUM(`Vote Total: Democrats`) + SUM(`Vote Total: Democrats`)) * 0.515, 0) + 1 FROM `Vote Total: Democrats` ) AS Democratic,
     ( SELECT ROUND( (SUM(`Vote Total: Republicans`) + SUM(`Vote Total: Republicans`)) * 0.485, 0) - 1 FROM `Vote Total: Republicans` ) AS Republican;












-- Drop Everything Commands
  DROP TABLE `Region 1`;
  DROP TABLE `Region 2`;
  DROP TABLE `Region 3`;

  DROP VIEW `Region 1 Total`;
  DROP VIEW `Region 2 Total`;
  DROP VIEW `Region 3 Total`;

  DROP VIEW `Vote Total: Democrats`;
  DROP VIEW `Democratic Vote Suppression Total`;
  DROP VIEW `Vote Total: Republicans`;

  DROP VIEW `Election Results`;
  DROP VIEW `Election Results: Skewed For Republicans`;
  DROP VIEW `Election Results: Skewed For Democrats`;
