CREATE OR REPLACE PACKAGE adauga AS
    function student_nou(p_nume student.nume%type, p_prenume student.prenume%type, p_email student.email%type) return number;
    function card_nou(p_idstudent card.idstudent%type, p_detinator card.detinator%type, p_numar card.numar%type, p_dataexpirare card.dataexpirare%type, p_cif card.cif%type) return number;
    function curs_nou(p_nume Curs.nume%type, p_descriere Curs.descriere%type, p_diploma Curs.diploma%type, p_pret Curs.pret%type, p_limba Curs.limba%type) return number;
    function capitol_nou(p_idcurs capitol.idcurs%type, p_titlu capitol.titlu%type, p_descriere capitol.descriere%type, p_lungime capitol.lungime%type) return number;
    function test_nou(p_idcapitol test.idcapitol%type) return number;
    function tema_noua(p_idcapitol tema.idcapitol%type, p_descriere tema.descriere%type, p_enunt tema.enunt%type) return number;
    function subiect_nou(p_nume subiect.nume%type, p_descriere subiect.descriere%type) return number;
    function instructor_nou(p_nume instructor.nume%type, p_prenume instructor.prenume%type, p_descriere instructor.descriere%type) return number;
    function intrebare_noua(p_idtest intrebare.idtest%type, p_enunt intrebare.enunt%type, p_raspunscorect intrebare.raspunscorect%type) return number;
END adauga;
/

CREATE OR REPLACE PACKAGE BODY adauga AS

    function student_nou(p_nume student.nume%type, p_prenume student.prenume%type, p_email student.email%type) return number IS
        ret_idstudent number;
    BEGIN
        ret_idstudent := seq_student.nextval;
        insert into student (idstudent, nume, prenume, email, datacreare) values (ret_idstudent, p_nume, p_prenume, p_prenume, sysdate);
        return ret_idstudent;
    END student_nou;
    
    function card_nou(p_idstudent card.idstudent%type, p_detinator card.detinator%type, p_numar card.numar%type, p_dataexpirare card.dataexpirare%type, p_cif card.cif%type) return number IS
        ret_idcard number;
    BEGIN
        ret_idcard := seq_card.nextval;
        insert into card (idcard, idstudent, detinator, numar, dataexpirare, cif) values (ret_idcard, p_idstudent, p_detinator, p_numar, p_dataexpirare, p_cif);
        return ret_idcard;
    END card_nou;
    
    function curs_nou(p_nume Curs.nume%type, p_descriere Curs.descriere%type, p_diploma Curs.diploma%type, p_pret Curs.pret%type, p_limba Curs.limba%type) return number IS
        ret_idcurs number;
    BEGIN
        ret_idcurs := seq_curs.nextval;
        insert into Curs (idcurs, nume, descriere, diploma, pret, limba) values (ret_idcurs, p_nume, p_descriere, p_diploma, p_pret, p_limba);
        return ret_idcurs;
    END curs_nou;

    function capitol_nou(p_idcurs capitol.idcurs%type, p_titlu capitol.titlu%type, p_descriere capitol.descriere%type, p_lungime capitol.lungime%type) return number IS
        ret_idcapitol number;
    BEGIN
        ret_idcapitol := seq_capitol.nextval;
        insert into capitol (idcapitol, idcurs, titlu, descriere, lungime) values (ret_idcapitol, p_idcurs, p_titlu, p_descriere, p_lungime);
        return ret_idcapitol;
    END capitol_nou;

    function test_nou(p_idcapitol test.idcapitol%type) return number IS
        ret_idtest number;
    BEGIN
        ret_idtest := seq_test.nextval;
        insert into test (idtest, idcapitol) values (ret_idtest, p_idcapitol);
        return ret_idtest;
    END test_nou;
    
    function tema_noua(p_idcapitol tema.idcapitol%type, p_descriere tema.descriere%type, p_enunt tema.enunt%type) return number IS
        ret_idtema number;
    BEGIN
        ret_idtema := seq_tema.nextval;
        insert into tema (idtema, idcapitol, descriere, enunt) values (ret_idtema, p_idcapitol, p_descriere, p_enunt);
        return ret_idtema;
    END tema_noua;

    function subiect_nou(p_nume subiect.nume%type, p_descriere subiect.descriere%type) return number IS
        ret_idsubiect number;
    BEGIN
        ret_idsubiect := seq_subiect.nextval;
        insert into subiect (idsubiect, nume, descriere) values (ret_idsubiect, p_nume, p_descriere);
        return ret_idsubiect;
    END subiect_nou;

    function instructor_nou(p_nume instructor.nume%type, p_prenume instructor.prenume%type, p_descriere instructor.descriere%type) return number IS
        ret_idinstructor number;
    BEGIN
        ret_idinstructor := seq_instructor.nextval;
        insert into instructor (idinstructor, nume, prenume, descriere) values (ret_idinstructor, p_nume, p_prenume, p_descriere);
        return ret_idinstructor;
    END instructor_nou;

    function intrebare_noua(p_idtest intrebare.idtest%type, p_enunt intrebare.enunt%type, p_raspunscorect intrebare.raspunscorect%type) return number IS
        ret_idintrebare number;
    BEGIN
        ret_idintrebare := seq_intrebare.nextval;
        insert into intrebare (idintrebare, idtest, enunt, raspunscorect) values (ret_idintrebare, p_idtest, p_enunt, p_raspunscorect);
        return ret_idintrebare;
    END intrebare_noua;

END adauga;
/