exec dbms_output.enable(NULL);
SET SERVERoutput on format wrapped;


select 'drop ' || object_type || ' ' || object_name || ';' from user_objects;

select * from user_tables;
select * from user_objects;

drop TABLE STUDENT;
drop INDEX PK_STUDENT;
drop INDEX UQ_EMAIL_STUDENT;
drop TABLE CARD;
drop INDEX PK_CARD;
drop INDEX UQ_NUMAR_CARD;
drop TABLE CURS;
drop INDEX PK_CURS;
drop TABLE CARD_CUMPARA_CURS;
drop INDEX PK_CCC;
drop TABLE CAPITOL;
drop INDEX PK_CAPITOL;
drop TABLE TEST;
drop INDEX PK_TEST;
drop TABLE TEMA;
drop INDEX PK_TEMA;
drop TABLE SUBIECT;
drop INDEX PK_SUBIECT;
drop TABLE INSTRUCTOR;
drop INDEX PK_INSTRUCTOR;
drop TABLE INTREBARE;
drop INDEX PK_INTREBARE;
drop TABLE INSTRUCTOR_PREDA_CURS;
drop INDEX PK_IPC;
drop TABLE CURS_ARE_SUBIECT;
drop INDEX PK_CAS;
drop TABLE STUDENT_REZOLVA_TEMA;
drop INDEX PK_SRTEMA;
drop TABLE STUDENT_REZOLVA_TEST;
drop INDEX PK_SRTEST;
drop TABLE STUDENT_DORESTE_CURS;
drop INDEX PK_SDC;
drop TABLE STUDENT_NOTEAZA_CURS;
drop INDEX PK_SNC;
drop TABLE STUDENT_PARCURGE_CAPITOL;
drop INDEX PK_SPC;
drop SEQUENCE SEQ_STUDENT;
drop SEQUENCE SEQ_CURS;
drop SEQUENCE SEQ_CARD;
drop SEQUENCE SEQ_SUBIECT;
drop SEQUENCE SEQ_INSTRUCTOR;
drop SEQUENCE SEQ_CAPITOL;
drop SEQUENCE SEQ_TEST;
drop SEQUENCE SEQ_INTREBARE;
drop PROCEDURE AFISARE_SARCINI_DE_LUCRU;
drop PROCEDURE AFISARE_CUMPARATURI;
drop FUNCTION NUMAR_CLIENTI;
drop PROCEDURE MEDIE_TESTE_CAPITOL;
drop SEQUENCE SEQ_TEMA;