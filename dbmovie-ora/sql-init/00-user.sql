set termout off
column pdb_name new_value pdb_name
SELECT name AS pdb_name FROM v$pdbs WHERE name != 'PDB$SEED';
set termout on

ALTER SESSION SET CONTAINER=&pdb_name;

create user umovie identified by password;
grant connect, resource to umovie;
alter user umovie quota unlimited on users;
