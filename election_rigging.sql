-- create 3 regions
  -- Bernie Heavy Region
    CREATE TABLE Region_1 (voter_id INT PRIMARY KEY, name character(25), vote char(1));
  -- Neutral Region
    CREATE TABLE Region_2 (voter_id int PRIMARY KEY, name character(25), vote char(1));
  -- Hillary Heavy Region
    CREATE TABLE Region_3 (voter_id int PRIMARY KEY, name character(25), vote char(1));


--
INSERT INTO Region_1 (voter_id, name, vote)
VALUES (1, "Berner 1", 'B'), (2, "Berner 2", 'B'), (3, "Tumbler Fem 1", 'H');


INSERT INTO Region_2 (voter_id, name, vote)
VALUES (1, "Berner 3", 'B'), (2, "Tumbler Fem 2", 'H');

--
INSERT INTO Region_3 (voter_id, name, vote)
VALUES (1, "Berner 4", 'B'), (2, "Tumbler Fem 3", 'H'), (3, "Tumbler Fem 4", 'H');



-- CREATE VIEW Region_1_tally AS
-- SELECT COUNT((SELECT vote FROM Region_1 WHERE vote='B')) AS Bernie, COUNT((SELECT vote FROM Region_1 WHERE vote='H')) AS Hillary
-- FROM Region_1

CREATE VIEW [Region 1 Total] AS
SELECT 'Votes' AS 'Votes',
   ( SELECT SUM(vote) FROM Region_1 WHERE vote='B' ) AS Bernie,
   ( SELECT SUM(vote) FROM Region_1 WHERE vote='H' ) AS Hillary;


CREATE VIEW [Region 2 Total] AS
SELECT COUNT((SELECT vote FROM Region_2 WHERE vote='B')) AS Bernie, COUNT((SELECT vote FROM Region_2 WHERE vote='H')) AS Hillary
FROM Region_2

CREATE VIEW [Region 3 Total] AS
SELECT COUNT((SELECT vote FROM Region_3 WHERE vote='B')) AS Bernie, COUNT((SELECT vote FROM Region_3 WHERE vote='H')) AS Hillary
FROM Region_3


-- Bernie Break Down
CREATE VIEW [Bernie Vote Total] AS
SELECT 'Region 1' AS Region, COUNT(vote) AS [Bernie Vote Total]
FROM Region_1
WHERE  vote='B'
UNION ALL
SELECT 'Region 2', COUNT(vote)
FROM Region_2
WHERE vote='B'
UNION ALL
SELECT 'Region 3', COUNT(vote)
FROM Region_3
WHERE vote='B'

-- Hillary Break Down
CREATE VIEW [Hillary Vote Total] AS
SELECT 'Region 1' AS Region, COUNT(vote) AS [Hillary Vote Total]
FROM Region_1
WHERE  vote='H'
UNION ALL
SELECT 'Region 2', COUNT(vote)
FROM Region_2
WHERE vote='H'
UNION ALL
SELECT 'Region 3', COUNT(vote)
FROM Region_3
WHERE vote='H'


CREATE VIEW [Primary Results] AS
SELECT 'Votes' AS 'Votes',
   ( ( SELECT SUM([Bernie Vote Total]) FROM [Bernie Vote Total] ) ) AS [Bernie],
   ( ( SELECT SUM([Hillary Vote Total]) FROM [Hillary Vote Total] ) ) AS [Hillary];











--  Somehow tripling answer
SELECT 'Voting' AS 'votes', SUM(b.[Bernie Vote Total]) AS [Bernie], SUM(h.[Hillary Vote Total]) AS [Hillary]
FROM [Bernie Vote Total] AS b, [Hillary Vote Total] as h;

SELECT SUM(b.[Bernie Vote Total]) AS [Bernie]
FROM [Bernie Vote Total] AS b;
SELECT SUM(h.[Hillary Vote Total]) AS [Hillary]
FROM [Hillary Vote Total] as h;
