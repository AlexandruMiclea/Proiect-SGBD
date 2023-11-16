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
    constraint fk_card_student foreign key(idstudent) references student(idstudent),
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
    constraint fk_ccc_card foreign key(idcard) references card(idcard),
    constraint fk_ccc_curs foreign key(idcurs) references curs(idcurs)
);

create table capitol (
    idcapitol int,
    idcurs int,
    titlu varchar2(40) constraint nn_titlu_capitol not null,
    descriere VARCHAR2(400),
    lungime number(5,2) constraint nn_lungime_capitol not null,
    constraint pk_capitol primary key(idcapitol),
    constraint fk_capitol_curs foreign key(idcurs) references curs(idcurs)
);

create table test (
    idtest int,
    idcapitol int,
    constraint pk_test primary key(idtest),
    constraint fk_test_capitol foreign key(idcapitol) references capitol(idcapitol)
);

create table tema (
    idtema int,
    idcapitol int,
    descriere VARCHAR2(400),
    enunt VARCHAR2(400) constraint nn_enunt_tema not null,
    constraint pk_tema primary key(idtema),
    constraint fk_tema_capitol foreign key(idcapitol) references capitol(idcapitol)
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
    constraint fk_ipc_instructor foreign key(idinstructor) references instructor(idinstructor),
    constraint fk_ipc_curs foreign key(idcurs) references curs(idcurs)
);

create table curs_are_subiect (
    idcurs int,
    idsubiect int,
    constraint pk_cas primary key(idcurs, idsubiect),
    constraint fk_cas_curs foreign key(idcurs) references curs(idcurs),
    constraint fk_cas_subiect foreign key(idsubiect) references subiect(idsubiect)
);

create table student_rezolva_tema (
    idstudent int,
    idtema int,
    nota number(4,2),
    constraint pk_srtema primary key(idstudent, idtema),
    constraint fk_srtema_student foreign key(idstudent) references student(idstudent),
    constraint fk_srtema_tema foreign key(idtema) references tema(idtema)
);

create table student_rezolva_test (
    idstudent int,
    idtest int,
    nota number(4,2),
    constraint pk_srtest primary key(idstudent, idtest),
    constraint fk_srtest_student foreign key(idstudent) references student(idstudent),
    constraint fk_srtest_test foreign key(idtest) references test(idtest)
);

create table student_doreste_curs (
    idstudent int,
    idcurs int,
    dataadaugare date DEFAULT to_date(sysdate, 'DD-MM-YYYY'),
    constraint pk_sdc primary key(idstudent, idcurs),
    constraint fk_sdc_student foreign key(idstudent) references student(idstudent),
    constraint fk_sdc_curs foreign key(idcurs) references curs(idcurs)
);

create table student_noteaza_curs (
    idstudent int,
    idcurs int,
    nota number(4,2),
    constraint pk_snc primary key(idstudent, idcurs),
    constraint fk_snc_student foreign key(idstudent) references student(idstudent),
    constraint fk_snc_curs foreign key(idcurs) references curs(idcurs)
);

create table student_parcurge_capitol (
    idstudent int,
    idcapitol int,
    efectuat number default 0 constraint nn_efectuat_spc not null,
    constraint pk_spc primary key(idstudent, idcapitol),
    constraint fk_spc_student foreign key(idstudent) references student(idstudent),
    constraint fk_spc_capitol foreign key(idcapitol) references capitol(idcapitol)
);

-- insert values into tables