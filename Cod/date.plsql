-- create tables

create table Student (
    idstudent int,
    nume varchar2(40) constraint nn_nume_student not null,
    prenume varchar2(40) constraint nn_prenume_student not null,
    email varchar2(100) constraint nn_email_student not null,
    datacreare date default to_date(sysdate, 'DD-MM-YYYY'),
    constraint pk_student primary key(idstudent),
    constraint uq_email_student unique(email)
);

create TABLE card (
    idcard int,
    idstudent int,
    detinator varchar2(100) constraint nn_detinator_card not null,
    numar number(16) constraint nn_numar_card not null,
    dataexpirare date constraint nn_dataexpirare_card not null,
    cif number(3) constraint nn_cif_card not null,
    constraint pk_card primary key(idcard),
    constraint fk_card_student foreign key(idstudent) references student(idstudent) on delete cascade,
    constraint uq_numar_card unique(numar)
);

create table Curs (
    idcurs int,
    nume varchar2(100) constraint nn_nume_curs not null,
    descriere varchar2(400),
    diploma number default 0 constraint nn_diploma_curs not null,
    pret number(5,2) constraint nn_pret_curs not null,
    limba varchar2(20),
    constraint pk_curs primary key(idcurs)
);

create table card_cumpara_curs (
    idcard int,
    idcurs int,
    datacumparare date DEFAULT to_date(sysdate, 'DD-MM-YYYY'),
    constraint pk_ccc primary key(idcard, idcurs),
    constraint fk_ccc_card foreign key(idcard) references card(idcard) on delete cascade,
    constraint fk_ccc_curs foreign key(idcurs) references curs(idcurs) on delete cascade
);

create table capitol (
    idcapitol int,
    idcurs int,
    titlu varchar2(40) constraint nn_titlu_capitol not null,
    descriere VARCHAR2(400),
    lungime number(5,2) constraint nn_lungime_capitol not null,
    constraint pk_capitol primary key(idcapitol),
    constraint fk_capitol_curs foreign key(idcurs) references curs(idcurs) on delete cascade
);

create table test (
    idtest int,
    idcapitol int,
    constraint pk_test primary key(idtest),
    constraint fk_test_capitol foreign key(idcapitol) references capitol(idcapitol) on delete cascade
);

create table tema (
    idtema int,
    idcapitol int,
    descriere VARCHAR2(400),
    enunt VARCHAR2(400) constraint nn_enunt_tema not null,
    constraint pk_tema primary key(idtema),
    constraint fk_tema_capitol foreign key(idcapitol) references capitol(idcapitol) on delete cascade
);

create table subiect (
    idsubiect int,
    nume VARCHAR2(40) constraint nn_nume_subiect not null,
    descriere VARCHAR2(400),
    constraint pk_subiect primary key(idsubiect)
);

create table instructor (
    idinstructor int,
    nume varchar2(40) constraint nn_nume_instructor not null,
    prenume varchar2(40) constraint nn_prenume_instructor not null,
    descriere VARCHAR2(400),
    constraint pk_instructor primary key(idinstructor)
);

create table intrebare (
    idintrebare int,
    idtest int,
    enunt VARCHAR2(400) constraint nn_enunt_intrebare not null,
    raspunscorect VARCHAR2(400) constraint nn_raspunscorect_tema not null,
    constraint pk_intrebare primary key(idintrebare)
);

create table instructor_preda_curs (
    idinstructor int,
    idcurs int,
    constraint pk_ipc primary key(idinstructor, idcurs),
    constraint fk_ipc_instructor foreign key(idinstructor) references instructor(idinstructor) on delete cascade,
    constraint fk_ipc_curs foreign key(idcurs) references curs(idcurs) on delete cascade
);

create table curs_are_subiect (
    idcurs int,
    idsubiect int,
    constraint pk_cas primary key(idcurs, idsubiect),
    constraint fk_cas_curs foreign key(idcurs) references curs(idcurs) on delete cascade,
    constraint fk_cas_subiect foreign key(idsubiect) references subiect(idsubiect) on delete cascade
);

create table student_rezolva_tema (
    idstudent int,
    idtema int,
    nota number(4,2),
    constraint pk_srtema primary key(idstudent, idtema),
    constraint fk_srtema_student foreign key(idstudent) references student(idstudent) on delete cascade,
    constraint fk_srtema_tema foreign key(idtema) references tema(idtema) on delete cascade
);

create table student_rezolva_test (
    idstudent int,
    idtest int,
    nota number(4,2),
    constraint pk_srtest primary key(idstudent, idtest),
    constraint fk_srtest_student foreign key(idstudent) references student(idstudent) on delete cascade,
    constraint fk_srtest_test foreign key(idtest) references test(idtest) on delete cascade
);

create table student_doreste_curs (
    idstudent int,
    idcurs int,
    dataadaugare date DEFAULT to_date(sysdate, 'DD-MM-YYYY'),
    constraint pk_sdc primary key(idstudent, idcurs),
    constraint fk_sdc_student foreign key(idstudent) references student(idstudent) on delete cascade,
    constraint fk_sdc_curs foreign key(idcurs) references curs(idcurs) on delete cascade
);

create table student_noteaza_curs (
    idstudent int,
    idcurs int,
    nota number(4,2),
    constraint pk_snc primary key(idstudent, idcurs),
    constraint fk_snc_student foreign key(idstudent) references student(idstudent) on delete cascade,
    constraint fk_snc_curs foreign key(idcurs) references curs(idcurs) on delete cascade
);

create table student_parcurge_capitol (
    idstudent int,
    idcapitol int,
    efectuat number default 0 constraint nn_efectuat_spc not null,
    constraint pk_spc primary key(idstudent, idcapitol),
    constraint fk_spc_student foreign key(idstudent) references student(idstudent) on delete cascade,
    constraint fk_spc_capitol foreign key(idcapitol) references capitol(idcapitol) on delete cascade
);

-- insert values into tables

insert into student (idstudent, nume, prenume, email, datacreare) values (1, 'Chirila', 'Alexandru Matei', 'chirilaalexandrumatei@outlook.com', sysdate - 30);
insert into student (idstudent, nume, prenume, email, datacreare) values (2, 'Costiniu', 'Gabriel', 'costiniugabriel@gmail.com', sysdate - 20);
insert into student (idstudent, nume, prenume, email, datacreare) values (3, 'Timandi', 'Livia Andreea', 'timandiliviaandreea@hotmail.com', sysdate - 150);
insert into student (idstudent, nume, prenume, email, datacreare) values (4, 'Stinga', 'Madalina', 'stingamadalina@gmail.com', sysdate - 10);
insert into student (idstudent, nume, prenume, email, datacreare) values (5, 'Balitiu', 'Teodora', 'balitiuteodora@outlook.com', sysdate - 360);
insert into student (idstudent, nume, prenume, email, datacreare) values (6, 'Stanasila', 'Ovidiu', 'stanasilaovidiu@protonmail.com', sysdate - 90);
insert into student (idstudent, nume, prenume, email, datacreare) values (7, 'Banica', 'Raul Cezar', 'banicaraulcezar@gmail.com', sysdate - 60);
select * from student;

insert into curs (idcurs, nume, descriere, diploma, pret, limba) values (1, '100 days of code', 'Ia-o de la zero cu programarea in Python! Pe parcursul celor 100 de zile vei avea ceva de codat zilnic.', 1, 49.99, 'engleza');
insert into curs (idcurs, nume, descriere, diploma, pret, limba) values (2, 'Gateste cu Sylvester Stallone', 'Esentialul in gatit, astazi predat de catre nimeni altul decat Sylvester Stallone!', 0, 69.99, 'engleza');
insert into curs (idcurs, nume, descriere, diploma, pret, limba) values (3, 'Lectii de trompeta', 'Un instrument versatil, trompeta poate indulci orice coloana sonora.', 1, 39.99, 'romana');
insert into curs (idcurs, nume, descriere, diploma, pret, limba) values (4, 'Filozofie si etica academica', null, 0, 29.99, 'romana');
insert into curs (idcurs, nume, descriere, diploma, pret, limba) values (5, 'Chitara electrica 101', 'Totul despre chitara electrica. Invata sa canti rock, metal, whatever...', 1, 59.99, 'engleza');
select * from curs;

insert into card (idcard, idstudent, detinator, numar, dataexpirare, cif) values (1, 1, 'CHIRILA ALEXANDRU MATEI', 374245455400126, to_date('01/05/2026', 'DD/MM/YYYY'), 123);
insert into card (idcard, idstudent, detinator, numar, dataexpirare, cif) values (2, 2, 'COSTINIU GABRIEL', 378282246310005, to_date('01/05/2026', 'DD/MM/YYYY'), 423);
insert into card (idcard, idstudent, detinator, numar, dataexpirare, cif) values (3, 3, 'TIMANDI LIVIA ANDREEA', 6250941006528599, to_date('01/06/2026', 'DD/MM/YYYY'), 434);
insert into card (idcard, idstudent, detinator, numar, dataexpirare, cif) values (4, 3, 'TIMANDI CRISTIAN', 6011000180331112, to_date('01/02/2026', 'DD/MM/YYYY'), 543);
insert into card (idcard, idstudent, detinator, numar, dataexpirare, cif) values (5, 4, 'STINGA MADALINA', 6011000991300009, to_date('01/12/2026', 'DD/MM/YYYY'), 564);
insert into card (idcard, idstudent, detinator, numar, dataexpirare, cif) values (6, 5, 'BALITIU TEODORA', 3566000020000410, to_date('01/02/2026', 'DD/MM/YYYY'), 954);
insert into card (idcard, idstudent, detinator, numar, dataexpirare, cif) values (7, 6, 'STANASILA ANDREEA', 3530111333300000, to_date('01/09/2026', 'DD/MM/YYYY'), 309);
insert into card (idcard, idstudent, detinator, numar, dataexpirare, cif) values (8, 6, 'STANASILA MARIAN', 5425233430109903, to_date('01/02/2026', 'DD/MM/YYYY'), 534);
insert into card (idcard, idstudent, detinator, numar, dataexpirare, cif) values (9, 7, 'BANICA RAUL CEZAR', 2222420000001113, to_date('01/03/2026', 'DD/MM/YYYY'), 890);
insert into card (idcard, idstudent, detinator, numar, dataexpirare, cif) values (10, 7, 'BANICA ADELINA', 5789432795823472, to_date('01/04/2026', 'DD/MM/YYYY'), 654);
select * from card;

insert into card_cumpara_curs (idcard, idcurs, datacumparare) values (1, 1, sysdate - 27);
insert into card_cumpara_curs (idcard, idcurs, datacumparare) values (1, 4, sysdate - 23);
insert into card_cumpara_curs (idcard, idcurs, datacumparare) values (2, 2, sysdate - 10);
insert into card_cumpara_curs (idcard, idcurs, datacumparare) values (3, 3, sysdate - 70);
insert into card_cumpara_curs (idcard, idcurs, datacumparare) values (4, 5, sysdate - 40);
insert into card_cumpara_curs (idcard, idcurs, datacumparare) values (6, 1, sysdate - 150);
insert into card_cumpara_curs (idcard, idcurs, datacumparare) values (6, 2, sysdate - 150);
insert into card_cumpara_curs (idcard, idcurs, datacumparare) values (7, 3, sysdate - 85);
insert into card_cumpara_curs (idcard, idcurs, datacumparare) values (8, 4, sysdate - 60);
insert into card_cumpara_curs (idcard, idcurs, datacumparare) values (9, 4, sysdate - 50);
insert into card_cumpara_curs (idcard, idcurs, datacumparare) values (10, 5, sysdate - 30);
select * from card_cumpara_curs;

insert into subiect (idsubiect, nume, descriere) values (1, 'Programare', null);
insert into subiect (idsubiect, nume, descriere) values (2, 'Python', null);
insert into subiect (idsubiect, nume, descriere) values (3, 'Gatit', null);
insert into subiect (idsubiect, nume, descriere) values (4, 'Instrumente', null);
insert into subiect (idsubiect, nume, descriere) values (5, 'Filozofie', null);
insert into subiect (idsubiect, nume, descriere) values (6, 'Academic', null);
insert into subiect (idsubiect, nume, descriere) values (7, 'Chitara', null);
insert into subiect (idsubiect, nume, descriere) values (8, 'Arama', null);
insert into subiect (idsubiect, nume, descriere) values (9, 'Actorie', null);
select * from subiect;

insert into curs_are_subiect (idcurs, idsubiect) values (1, 1);
insert into curs_are_subiect (idcurs, idsubiect) values (1, 2);
insert into curs_are_subiect (idcurs, idsubiect) values (2, 3);
insert into curs_are_subiect (idcurs, idsubiect) values (2, 9);
insert into curs_are_subiect (idcurs, idsubiect) values (3, 3);
insert into curs_are_subiect (idcurs, idsubiect) values (3, 8);
insert into curs_are_subiect (idcurs, idsubiect) values (4, 5);
insert into curs_are_subiect (idcurs, idsubiect) values (4, 6);
insert into curs_are_subiect (idcurs, idsubiect) values (5, 4);
insert into curs_are_subiect (idcurs, idsubiect) values (5, 7);
select * from curs_are_subiect;

insert into instructor (idinstructor, nume, prenume, descriere) values (1, 'Blidariu', 'Mihnea', null);
insert into instructor (idinstructor, nume, prenume, descriere) values (2, 'Stallone', 'Sylvester', null);
insert into instructor (idinstructor, nume, prenume, descriere) values (3, 'Yu', 'Angela', null);
insert into instructor (idinstructor, nume, prenume, descriere) values (4, 'Stoenescu', 'Constantin', null);
insert into instructor (idinstructor, nume, prenume, descriere) values (5, 'Brancoveanu', 'Romulus', null);
insert into instructor (idinstructor, nume, prenume, descriere) values (6, 'Patrunsu', 'Dorina Mihaela', null);
insert into instructor (idinstructor, nume, prenume, descriere) values (7, 'Cioaba', 'Catalin', null);
insert into instructor (idinstructor, nume, prenume, descriere) values (8, 'Malan', 'David', null);
insert into instructor (idinstructor, nume, prenume, descriere) values (9, 'Botan', 'Andrei', null);
insert into instructor (idinstructor, nume, prenume, descriere) values (10, 'Fagadar', 'Nick', null);
select * from instructor;

insert into instructor_preda_curs (idinstructor, idcurs) values (3, 1);
insert into instructor_preda_curs (idinstructor, idcurs) values (8, 1);
insert into instructor_preda_curs (idinstructor, idcurs) values (2, 2);
insert into instructor_preda_curs (idinstructor, idcurs) values (1, 3);
insert into instructor_preda_curs (idinstructor, idcurs) values (4, 4);
insert into instructor_preda_curs (idinstructor, idcurs) values (5, 4);
insert into instructor_preda_curs (idinstructor, idcurs) values (6, 4);
insert into instructor_preda_curs (idinstructor, idcurs) values (7, 4);
insert into instructor_preda_curs (idinstructor, idcurs) values (9, 5);
insert into instructor_preda_curs (idinstructor, idcurs) values (10, 5);
select * from instructor_preda_curs;

insert into capitol (idcapitol, idcurs, titlu, descriere, lungime) values (1, 1, 'Python introduction', null, 109.35);
insert into capitol (idcapitol, idcurs, titlu, descriere, lungime) values (2, 1, 'Daily assignments', null, 65.21);
insert into capitol (idcapitol, idcurs, titlu, descriere, lungime) values (3, 2, 'Salads with Adrian Balboa', null, 36.56);
insert into capitol (idcapitol, idcurs, titlu, descriere, lungime) values (4, 2, 'Steak. Meats.', null, 36.56);
insert into capitol (idcapitol, idcurs, titlu, descriere, lungime) values (5, 3, 'Ritmuri de hora in Sol Major', null, 20.15);
insert into capitol (idcapitol, idcurs, titlu, descriere, lungime) values (6, 4, 'Filozofia in Inteligenta Artificiala', null, 300.15);
insert into capitol (idcapitol, idcurs, titlu, descriere, lungime) values (7, 5, 'Stilul Grunge', null, 60.25);
select * from capitol;

insert into test (idtest, idcapitol) values (1, 1);
insert into test (idtest, idcapitol) values (2, 1);
insert into test (idtest, idcapitol) values (3, 1);
insert into test (idtest, idcapitol) values (4, 3);
insert into test (idtest, idcapitol) values (5, 4);
insert into test (idtest, idcapitol) values (6, 5);
insert into test (idtest, idcapitol) values (7, 6);
insert into test (idtest, idcapitol) values (8, 6);
insert into test (idtest, idcapitol) values (9, 6);
insert into test (idtest, idcapitol) values (10, 6);
insert into test (idtest, idcapitol) values (11, 7);
select * from test;

insert into intrebare (idintrebare, idtest, enunt, raspunscorect) values (1, 1, 'What is a list?', 'Data collection');
insert into intrebare (idintrebare, idtest, enunt, raspunscorect) values (2, 1, 'What does print() do?', 'Prints contents to the STDOUT');
insert into intrebare (idintrebare, idtest, enunt, raspunscorect) values (3, 2, 'What is the difference between a list and a tuple?', 'Tuples are immutable, lists are not');
insert into intrebare (idintrebare, idtest, enunt, raspunscorect) values (4, 2, 'How to reverse a list using slices?', 'list = list[::-1]');
insert into intrebare (idintrebare, idtest, enunt, raspunscorect) values (5, 3, 'Is backtracking efficient?', 'No.');
insert into intrebare (idintrebare, idtest, enunt, raspunscorect) values (6, 3, 'What is the most optimal sorting complexity?' , 'O(n)');
insert into intrebare (idintrebare, idtest, enunt, raspunscorect) values (7, 4, 'Ceaser salad. Dressing?', 'Light dressing.');
insert into intrebare (idintrebare, idtest, enunt, raspunscorect) values (8, 4, 'Should you add red fruits to salad?', 'Yes (but only a couple slices).');
insert into intrebare (idintrebare, idtest, enunt, raspunscorect) values (9, 5, 'Should you cook steak beyond medium-rare?', 'Yes, but only certain cuts.');
insert into intrebare (idintrebare, idtest, enunt, raspunscorect) values (10, 5, 'Does lamb go well with wine?', 'The greeks have been doing it for centuries so of course yes.');
insert into intrebare (idintrebare, idtest, enunt, raspunscorect) values (11, 6, 'Ce hora este cea mai populara in Romania?', 'Hora Unirii.');
insert into intrebare (idintrebare, idtest, enunt, raspunscorect) values (13, 7, 'Are viata sfarsit?', 'In conceptia religiei, nu.');
insert into intrebare (idintrebare, idtest, enunt, raspunscorect) values (15, 8, 'Ce este moralitatea?', 'Depinde pe cine intrebi.');
insert into intrebare (idintrebare, idtest, enunt, raspunscorect) values (17, 9, 'Este inteligenta artificiala un domeniu ce reprezinta interes academic?', 'Da.');
insert into intrebare (idintrebare, idtest, enunt, raspunscorect) values (19, 10, 'Reprezinta inteligenta arificiala nesupervizata un pericol?', 'Nu (se cer detalii).');
insert into intrebare (idintrebare, idtest, enunt, raspunscorect) values (21, 11, 'Care a fost prima trupa considerata Grunge?', 'Green River');
insert into intrebare (idintrebare, idtest, enunt, raspunscorect) values (22, 11, 'Care a fost cea mai populara trupa Grunge?', 'Nirvana');
select * from intrebare;

insert into tema (idtema, idcapitol, descriere, enunt) values (1, 1, null, 'Create a Python script that implements as many concepts as possible.');
insert into tema (idtema, idcapitol, descriere, enunt) values (2, 2, null, 'Day 20: Nth Fibonacci number');
insert into tema (idtema, idcapitol, descriere, enunt) values (3, 2, null, 'Day 40: First 100 prime numbers');
insert into tema (idtema, idcapitol, descriere, enunt) values (4, 2, null, 'Day 60: Cash register');
insert into tema (idtema, idcapitol, descriere, enunt) values (5, 2, null, 'Day 80: Bank administration');
insert into tema (idtema, idcapitol, descriere, enunt) values (6, 2, null, 'Day 100: print("I did it!");');
insert into tema (idtema, idcapitol, descriere, enunt) values (7, 5, null, 'Filmeaza ritmul tau');
insert into tema (idtema, idcapitol, descriere, enunt) values (8, 7, null, 'Canta o melodie preferata din stilul grunge');
select * from tema;

insert into student_noteaza_curs (idstudent, idcurs) values (1, 1);
insert into student_noteaza_curs (idstudent, idcurs) values (2, 2);
insert into student_noteaza_curs (idstudent, idcurs) values (3, 3);
insert into student_noteaza_curs (idstudent, idcurs) values (5, 1);
insert into student_noteaza_curs (idstudent, idcurs) values (6, 3);
insert into student_noteaza_curs (idstudent, idcurs) values (7, 4);
insert into student_noteaza_curs (idstudent, idcurs, nota) values (1, 4, 8.00);
insert into student_noteaza_curs (idstudent, idcurs, nota) values (3, 5, 9.00);
insert into student_noteaza_curs (idstudent, idcurs, nota) values (5, 2, 10.00);
insert into student_noteaza_curs (idstudent, idcurs, nota) values (6, 4, 7.50);
insert into student_noteaza_curs (idstudent, idcurs, nota) values (7, 5, 3.00);
select * from student_noteaza_curs;

insert into student_doreste_curs (idstudent, idcurs) values (4, 1);
insert into student_doreste_curs (idstudent, idcurs) values (4, 2);
insert into student_doreste_curs (idstudent, idcurs) values (4, 3);
insert into student_doreste_curs (idstudent, idcurs) values (1, 3);
insert into student_doreste_curs (idstudent, idcurs) values (3, 4);
insert into student_doreste_curs (idstudent, idcurs) values (5, 5);
insert into student_doreste_curs (idstudent, idcurs) values (6, 1);
insert into student_doreste_curs (idstudent, idcurs) values (6, 2);
insert into student_doreste_curs (idstudent, idcurs) values (7, 1);
insert into student_doreste_curs (idstudent, idcurs) values (7, 2);
select * from student_doreste_curs;

insert into student_parcurge_capitol (idstudent, idcapitol, efectuat) values (1, 1, 1);
insert into student_parcurge_capitol (idstudent, idcapitol, efectuat) values (1, 2, 0);
insert into student_parcurge_capitol (idstudent, idcapitol, efectuat) values (1, 6, 0);
insert into student_parcurge_capitol (idstudent, idcapitol, efectuat) values (2, 3, 1);
insert into student_parcurge_capitol (idstudent, idcapitol, efectuat) values (2, 4, 0);
insert into student_parcurge_capitol (idstudent, idcapitol, efectuat) values (3, 5, 0);
insert into student_parcurge_capitol (idstudent, idcapitol, efectuat) values (3, 7, 0);
insert into student_parcurge_capitol (idstudent, idcapitol, efectuat) values (5, 1, 1);
insert into student_parcurge_capitol (idstudent, idcapitol, efectuat) values (5, 2, 1);
insert into student_parcurge_capitol (idstudent, idcapitol, efectuat) values (5, 3, 1);
insert into student_parcurge_capitol (idstudent, idcapitol, efectuat) values (5, 4, 0);
insert into student_parcurge_capitol (idstudent, idcapitol, efectuat) values (6, 5, 1);
insert into student_parcurge_capitol (idstudent, idcapitol, efectuat) values (6, 6, 0);
insert into student_parcurge_capitol (idstudent, idcapitol, efectuat) values (7, 6, 1);
insert into student_parcurge_capitol (idstudent, idcapitol, efectuat) values (7, 7, 1);
select * from student_parcurge_capitol;

insert into student_rezolva_tema (idstudent, idtema, nota) values (1, 1, 10.00);
insert into student_rezolva_tema (idstudent, idtema, nota) values (1, 2, 10.00);
insert into student_rezolva_tema (idstudent, idtema, nota) values (1, 3, 10.00);
insert into student_rezolva_tema (idstudent, idtema) values (1, 4);
insert into student_rezolva_tema (idstudent, idtema) values (1, 5);
insert into student_rezolva_tema (idstudent, idtema) values (1, 6);
insert into student_rezolva_tema (idstudent, idtema) values (3, 7);
insert into student_rezolva_tema (idstudent, idtema) values (3, 8);
insert into student_rezolva_tema (idstudent, idtema, nota) values (5, 1, 10.00);
insert into student_rezolva_tema (idstudent, idtema, nota) values (5, 2, 10.00);
insert into student_rezolva_tema (idstudent, idtema, nota) values (5, 3, 10.00);
insert into student_rezolva_tema (idstudent, idtema, nota) values (5, 4, 10.00);
insert into student_rezolva_tema (idstudent, idtema, nota) values (5, 5, 10.00);
insert into student_rezolva_tema (idstudent, idtema, nota) values (5, 6, 10.00);
insert into student_rezolva_tema (idstudent, idtema, nota) values (6, 5, 9.00);
insert into student_rezolva_tema (idstudent, idtema, nota) values (7, 8, 8.00);
select * from student_rezolva_tema;

insert into student_rezolva_test (idstudent, idtest, nota) values (1, 1, 10.00);
insert into student_rezolva_test (idstudent, idtest, nota) values (1, 2, 9.00);
insert into student_rezolva_test (idstudent, idtest, nota) values (1, 3, 10.00);
insert into student_rezolva_test (idstudent, idtest, nota) values (1, 7, 7.00);
insert into student_rezolva_test (idstudent, idtest) values (1, 8);
insert into student_rezolva_test (idstudent, idtest) values (1, 9);
insert into student_rezolva_test (idstudent, idtest) values (1, 10);
insert into student_rezolva_test (idstudent, idtest) values (2, 4);
insert into student_rezolva_test (idstudent, idtest) values (3, 6);
insert into student_rezolva_test (idstudent, idtest) values (3, 11);
insert into student_rezolva_test (idstudent, idtest, nota) values (5, 1, 10.00);
insert into student_rezolva_test (idstudent, idtest, nota) values (5, 2, 10.00);
insert into student_rezolva_test (idstudent, idtest, nota) values (5, 3, 10.00);
insert into student_rezolva_test (idstudent, idtest, nota) values (5, 4, 10.00);
insert into student_rezolva_test (idstudent, idtest) values (5, 5);
insert into student_rezolva_test (idstudent, idtest, nota) values (6, 6, 10.00);
insert into student_rezolva_test (idstudent, idtest, nota) values (6, 7, 6.00);
insert into student_rezolva_test (idstudent, idtest) values (6, 8);
insert into student_rezolva_test (idstudent, idtest) values (6, 9);
insert into student_rezolva_test (idstudent, idtest) values (6, 10);
insert into student_rezolva_test (idstudent, idtest, nota) values (7, 7, 9.00);
insert into student_rezolva_test (idstudent, idtest, nota) values (7, 8, 8.50);
insert into student_rezolva_test (idstudent, idtest, nota) values (7, 9, 9.40);
insert into student_rezolva_test (idstudent, idtest, nota) values (7, 10, 10.00);
insert into student_rezolva_test (idstudent, idtest, nota) values (7, 11, 10.00);
select * from student_rezolva_test;