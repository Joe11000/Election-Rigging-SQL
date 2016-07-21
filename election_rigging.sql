-- create 3 regions
  -- Democratic Heavy Region
    CREATE TABLE Region_1 (voter_id INT PRIMARY KEY, name character(25), vote char(1));
  -- Neutral Region
    CREATE TABLE Region_2 (voter_id int PRIMARY KEY, name character(25), vote char(1));
  -- Republican Heavy Region
    CREATE TABLE Region_3 (voter_id int PRIMARY KEY, name character(25), vote char(1));


-- Populate regions with voters. Real data shows a tie vote
  INSERT INTO Region_1 (voter_id, name, vote)
  VALUES (1, "Dem 1", 'D'), (2, "Dem 2", 'D'), (3, "Rep 1", 'R');


  INSERT INTO Region_2 (voter_id, name, vote)
  VALUES (1, "Dem 3", 'D'), (2, "Rep 2", 'R');

  --
  INSERT INTO Region_3 (voter_id, name, vote)
  VALUES (1, "Dem 4", 'D'), (2, "Rep 3", 'R'), (3, "Rep 4", 'R');



-- CREATE VIEW Region_1_tally AS
-- SELECT COUNT((SELECT vote FROM Region_1 WHERE vote='D')) AS Democratic, COUNT((SELECT vote FROM Region_1 WHERE vote='R')) AS Republican
-- FROM Region_1

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


-- Democratic Break Down
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

-- Republican Break Down
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


CREATE VIEW [Election Results] AS
SELECT 'Votes' AS 'Votes',
   ( ( SELECT SUM([Democratic Vote Total]) FROM [Democratic Vote Total] ) ) AS [Democratic],
   ( ( SELECT SUM([Republican Vote Total]) FROM [Republican Vote Total] ) ) AS [Republican];
