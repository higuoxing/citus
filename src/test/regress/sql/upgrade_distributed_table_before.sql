CREATE SCHEMA upgrade_distributed_table_before;
SET search_path TO upgrade_distributed_table_before, public;

CREATE TABLE t(a int);
SELECT create_distributed_table('t', 'a');
INSERT INTO t SELECT * FROM generate_series(1, 5);

CREATE TYPE tc1 AS (a int, b int);
CREATE TABLE t1 (a int PRIMARY KEY, b tc1);
SELECT create_distributed_table('t1','a');

-- We store the index of distribution column and here we check that the distribution
-- column index does not change after an upgrade if we drop a column that comes before the
-- distribution column. The index information is in partkey column of pg_dist_partition table.
CREATE TABLE t_ab(a int, b int);
SELECT create_distributed_table('t_ab', 'b');
INSERT INTO t_ab VALUES (1, 11);
INSERT INTO t_ab VALUES (2, 22);
INSERT INTO t_ab VALUES (3, 33);

ALTER TABLE t_ab DROP a;

