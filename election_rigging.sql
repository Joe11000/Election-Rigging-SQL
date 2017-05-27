-- STEP 1 -> 5       Copy paste for a valid Election
-- STEP 6(Optional)  Additional steps to Rig Election


-- STEP 1: Create 3 regions
  -- Democrats Heavy Region
    CREATE TABLE `Region 1` (voter_id INT PRIMARY KEY, name character(25), vote char(1), member_since date NOT NULL DEFAULT '2016-11-16');
  -- Neutral Region
    CREATE TABLE `Region 2` (voter_id int PRIMARY KEY, name character(25), vote char(1), member_since date NOT NULL DEFAULT '2016-11-16');
  -- Republican Heavy Region
    CREATE TABLE `Region 3` (voter_id int PRIMARY KEY, name character(25), vote char(1), member_since date NOT NULL DEFAULT '2016-11-16');



-- STEP 2: Populate regions with voters. Real data shows a tie vote
  -- Populate region with 1 more Dem than Rep
    INSERT INTO `Region 1` (voter_id, name, vote, member_since)
    VALUES (1, "Dem 1", 'D', '2016-10-10'), (2, "Dem 2", 'D', '2008-11-10'), (3, "Rep 1", 'R', '2008-11-10');

  -- Populate region with equal Dems and Reps
    INSERT INTO `Region 2` (voter_id, name, vote, member_since)
    VALUES (1, "Dem 3", 'D', '2008-11-10'), (2, "Rep 2", 'R', '2008-11-10');

  -- Populate region with 1 more Rep than Dem
    INSERT INTO `Region 3` (voter_id, name, vote, member_since)
    VALUES (1, "Dem 4", 'D', '2008-11-10'), (2, "Rep 3", 'R', '2008-11-10'), (3, "Rep 4", 'R', '2008-11-10');



-- STEP 3: At each Region, see the vote total for each candidate
  CREATE VIEW `Region 1 Total` AS
  SELECT 'Votes' AS 'Votes',
     ( SELECT COUNT(vote) FROM `Region 1` WHERE vote='D' ) AS Democrats,
     ( SELECT COUNT(vote) FROM `Region 1` WHERE vote='R' ) AS Republican;

  CREATE VIEW `Region 2 Total` AS
  SELECT 'Votes' AS 'Votes',
     ( SELECT COUNT(vote) FROM `Region 2` WHERE vote='D' ) AS Democrats,
     ( SELECT COUNT(vote) FROM `Region 2` WHERE vote='R' ) AS Republican;

  CREATE VIEW `Region 3 Total` AS
  SELECT 'Votes' AS 'Votes',
     ( SELECT COUNT(vote) FROM `Region 3` WHERE vote='D' ) AS Democrats,
     ( SELECT COUNT(vote) FROM `Region 3` WHERE vote='R' ) AS Republican;


-- STEP 4: create views to view all votes for each party per region each region
  -- Democrats votes by region
    CREATE VIEW `Regional Results: Democrats` AS
    SELECT 'Region 1' AS Region, COUNT(vote) AS votes
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

  -- Republican votes by region
    CREATE VIEW `Regional Results: Republicans` AS
    SELECT 'Region 1' AS Region, COUNT(vote) AS votes
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


-- Step 5: Create View for Legit election results
  CREATE VIEW `Election Results` AS
  SELECT '' AS 'Votes',
     ( SELECT SUM(votes) FROM `Regional Results: Democrats` ) AS Democrats,
     ( SELECT SUM(votes) FROM `Regional Results: Republicans` ) AS Republican;


-- OPTIONAL!!!! Rig the election
-- Step 6:

  -- Option 1: Cheat For Republicans
    -- Create a new view to hold new regional result after voter suppression tactic
      CREATE VIEW `Regional Results: Skewed for Republicans` AS
      SELECT 'Region 1' AS Region, COUNT(vote) AS votes
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

    -- Democrats votes don't count if they have joined/switched the party too recently... >__>
      CREATE VIEW `Election Results: Skewed For Republicans` AS
      SELECT '' AS 'Votes',
        ( SELECT SUM(votes) FROM `Regional Results: Skewed for Republicans` ) AS Democrats,
        ( SELECT SUM(votes) FROM `Regional Results: Republicans` ) AS Republican;


  -- Option 2: Cheat For Democrats
    -- Make Dems win by 1 vote no matter what
    CREATE VIEW `Election Results: Skewed For Democrats` AS
    SELECT '' AS 'Votes',
      ( SELECT FLOOR( (COUNT(votes) / 2) + 0.5 ) FROM
        (
          SELECT votes  FROM `Regional Results: Democrats`
          UNION ALL
          SELECT votes FROM `Regional Results: Republicans`
        ) as derived_classes_must_have_names
      ) as Democrats,

      ( SELECT CEILING( (COUNT(votes) / 2) - 0.5 )  FROM
        (
          SELECT votes  FROM `Regional Results: Democrats`
          UNION ALL
          SELECT votes FROM `Regional Results: Republicans`
        ) as derived_classes_must_have_names
      ) as Republicans;












-- Drop Everything Commands
  DROP TABLE `Region 1`;
  DROP TABLE `Region 2`;
  DROP TABLE `Region 3`;

  DROP VIEW `Region 1 Total`;
  DROP VIEW `Region 2 Total`;
  DROP VIEW `Region 3 Total`;

  DROP VIEW `Regional Results: Democrats`;
  DROP VIEW `Regional Results: Skewed for Republicans`;
  DROP VIEW `Regional Results: Republicans`;

  DROP VIEW `Election Results`;
  DROP VIEW `Election Results: Skewed For Republicans`;
  DROP VIEW `Election Results: Skewed For Democrats`;
