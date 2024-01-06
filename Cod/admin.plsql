exec dbms_output.enable(NULL);
SET SERVERoutput on format wrapped;


select 'drop ' || object_type || ' ' || object_name || ';' from user_objects;

select * from user_tables;
select * from user_objects;

