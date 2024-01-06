-- exercitiul 6
-- pentru un student al carui ID se da de la tastatura sa se afiseze cursurile pe care le-a cumparat
-- pentru fiecare curs cumparat sa se enumere intrebarile din testele aferente fiecarui capitol al cursului, cat
-- si raspunsurile corecte

CREATE OR REPLACE PROCEDURE afisare_sarcini_de_lucru (v_id student.idstudent%type) as
    TYPE date_curs IS RECORD (id curs.idcurs%type, nume curs.nume%type);
    TYPE date_intrebare IS RECORD (enunt intrebare.enunt%type, raspuns intrebare.raspunscorect%type);
    TYPE date_capitol IS RECORD (id capitol.idcapitol%type, titlu capitol.titlu%type);
    TYPE t_curs IS TABLE OF date_curs INDEX BY PLS_INTEGER;
    TYPE t_capitol IS TABLE OF date_capitol;
    TYPE t_intrebare IS TABLE OF date_intrebare;
    TYPE t_test IS VARRAY(100) of test.IDTEST%type; 
    nume_curs t_curs;
    titluri_capitol t_capitol := t_capitol(); 
    intrebari t_intrebare := t_intrebare(); 
    teste t_test := t_test();
    v_idcurs curs.IDCURS%type;
    nume_s student.nume%type;
    datacreare_s student.datacreare%type;
BEGIN
    -- cursurile detinute de studentul dat ca parametru
    select nume || ' ' || prenume, datacreare into nume_s, datacreare_s from student where idstudent = v_id;
    DBMS_OUTPUT.PUT_LINE('Studentul ' || nume_s || ', care s-a intregistrat la data de ' || datacreare_s ||  ' a cumparat urmatoarele cursuri: ');
    select cu.idcurs, cu.nume bulk COLLECT INTO nume_curs
    from card ca, CARD_CUMPARA_CURS ccc, curs cu
    where v_id = ca.IDSTUDENT and ccc.IDCARD = ca.IDCARD and cu.IDCURS = ccc.IDCURS;
    for i in nume_curs.first..nume_curs.last LOOP
        DBMS_OUTPUT.PUT_LINE('Cursul ' || nume_curs(i).nume || ' are urmatoarele capitole: ');
        v_idcurs := nume_curs(i).id;
        select idcapitol, titlu bulk collect into titluri_capitol
        from capitol
        where idcurs = v_idcurs;
        for j in titluri_capitol.first..titluri_capitol.last loop 
            DBMS_OUTPUT.PUT('    ' || titluri_capitol(j).titlu || ', care ');
            -- ia testele aferente capitolului
            select idtest bulk collect into teste
            from TEST
            where IDCAPITOL = titluri_capitol(j).id;
            if teste.count != 0 then
                dbms_output.PUT_LINE('are ' || teste.count || ' teste:');
                for k in teste.first..teste.last LOOP
                    -- ia intrebarile din test
                    dbms_output.put_line('        Testul ' || k || ':');
                    select enunt, raspunscorect bulk collect into intrebari
                    from INTREBARE
                    where idtest = teste(k);
                    for l in intrebari.first..intrebari.last LOOP
                    -- TODO see how to correct output
                        DBMS_OUTPUT.PUT_line('            Intrebarea ' || l || ': ' || intrebari(l).enunt);
                        DBMS_OUTPUT.PUT_LINE('            Raspunsul corect este: ' || intrebari(l).raspuns);

                    end loop;
                end loop;
            ELSE
                DBMS_OUTPUT.PUT_LINE('nu are teste.');
            end if;
        end loop;
    end loop;
END afisare_sarcini_de_lucru;
/

BEGIN
    afisare_sarcini_de_lucru(&cod_student);
END;
/

-- exercitiul 7
-- pentru fiecare student, sa se afiseze cardurile pe care si le-a inregistrat, si ce cursuri a cumparat cu fiecare


CREATE OR REPLACE PROCEDURE afisare_cumparaturi as
    id_s student.idstudent%type;
    nume_s student.nume%type;
    nume_c curs.nume%type;
    pret_c curs.pret%type;
    -- cursor explicit
    cursor studenti is 
        select idstudent, nume || ' ' || prenume
        from student;

    cursor cursuri (id_c card.idcard%type) IS
        select idcurs from CARD_CUMPARA_CURS where idcard = id_c;
BEGIN
    open studenti;
    loop
        fetch studenti into id_s, nume_s;
        exit when studenti%notfound;
        dbms_output.put_line('Studentul ' || nume_s || ' are inregistrate urmatoarele carduri:');

        -- cursor implicit
        for i in (select idcard, detinator, numar from card where idstudent = id_s) LOOP
            DBMS_OUTPUT.PUT_LINE('    ' || i.detinator || ', cu codul ' || i.numar || ', de pe care a cumparat urmatoarele cursuri:');
            
            for j in cursuri(i.idcard) LOOP
                select nume, pret into nume_c, pret_c
                from curs where idcurs = j.idcurs;
                DBMS_OUTput.PUT_LINE('        ' || nume_c || ', care costa ' || pret_c || ' lei.');
            end loop;

        end loop;

    end loop;

END afisare_cumparaturi;
/
BEGIN
    afisare_cumparaturi();
END;
/


-- pentru un instructor al carui nume se da la tastatura sa se afiseze cate copii ale tuturor cursurilor pe care
-- le preda au fost cumparate, pentru fiecare curs

CREATE OR REPLACE FUNCTION numar_clienti (nume_instr instructor.nume%type) RETURN number AS
    ret_nrvanzari number;
    v_nrinst int;
    v_idinst int;
    
    nu_exista_instructor EXCEPTION;
    PRAGMA EXCEPTION_INIT (nu_exista_instructor, -20000);
    mai_multi_instructori EXCEPTION;
    PRAGMA EXCEPTION_INIT (mai_multi_instructori, -20001);
BEGIN

    select count(*) into v_nrinst from instructor where nume = nume_instr;
    if v_nrinst > 1 then
        raise_application_error(-20000, 'Sunt mai multi instructori cu numele dat!');
    elsif v_nrinst < 1 then
        raise_application_error(-20001, 'Nu exista instructori cu numele dat!');
    end if;
    
    dbms_output.put_line('Despre instructorul ' || nume_instr || ' stim urmatoarele: ');
    
    for linie in (select c.nume, count(ccc.idcard) cumparari 
    from instructor i, instructor_preda_curs ipc, card_cumpara_curs ccc, curs c
    where i.nume = nume_instr and i.idinstructor = ipc.idinstructor and ipc.idcurs = ccc.idcurs and ipc.idcurs = c.idcurs
    group by c.nume) loop
        ret_nrvanzari := ret_nrvanzari + linie.cumparari;
        dbms_output.put_line('    Cursul ' || linie.nume || ' are ' || linie.cumparari || ' vanzari.');
    end loop;
    
    return ret_nrvanzari;
END numar_clienti;
/

BEGIN
    dbms_output.put_line(numar_clienti('Blidariu'));
    dbms_output.put_line(numar_clienti('Blidari'));
END;
/

-- exercitiul 9
-- sa se creeze o procedura care, pentru un student al carui nume si prenume este dat, afiseaza progresul acestuia 
-- la un curs al carui nume este dat. sa se verifice daca este inrolat la acel curs, iar pentru fiecare capitol al cursului
-- sa se afiseze procentul de teme si teste pe care l-a facut

CREATE OR REPLACE PROCEDURE medie_teste_capitol(p_numestudent student.nume%type, p_prenumestudent student.prenume%type, p_titlucapitol capitol.titlu%type) AS
    v_aux number;
    
    v_numestudent student.nume%type;
    v_prenumestudent student.prenume%type;
    v_titlucapitol capitol.titlu%type;
    v_medienote number(4,2);
    
BEGIN

    select s.nume, s.prenume, c.titlu, avg(nvl(srtest.nota,0)) medie into v_numestudent, v_prenumestudent, v_titlucapitol, v_medienote
    from student s, capitol c, student_parcurge_capitol spc, student_rezolva_test srtest, test
    where lower(s.nume) = lower(p_numestudent) and lower(s.prenume) = lower(p_prenumestudent) and spc.idstudent = s.idstudent and spc.idcapitol = c.idcapitol
    and srtest.idstudent = s.idstudent
    and test.idtest = srtest.idtest
    and test.idcapitol = c.idcapitol
    and instr(lower(c.titlu), lower(p_titlucapitol), 1) > 0
    group by s.nume, s.prenume, c.titlu;
    
    dbms_output.put_line('Studentul ' || v_numestudent || ' ' || v_prenumestudent || ' are media ' || v_medienote || ' la testele din capitolul ' || v_titlucapitol);
EXCEPTION
    when no_data_found then
        select count(*) into v_aux
        from student
        where lower(student.nume) = lower(p_numestudent) and lower(student.prenume) = lower(p_prenumestudent);
    
        if v_aux = 0 then
            dbms_output.put_line('Studentul cu numele si prenumele dat nu exista!');
        end if;
        
        select count(distinct c.titlu) into v_aux
        from student s, capitol c, student_parcurge_capitol spc, test
        where spc.idstudent = s.idstudent and spc.idcapitol = c.idcapitol
        and instr(lower(c.titlu), lower(p_titlucapitol), 1) > 0
        and spc.efectuat = 1
        and test.idcapitol = c.idcapitol
        and lower(s.nume) = lower(p_numestudent) and lower(s.prenume) = lower(p_prenumestudent);
        
        if v_aux = 0 then
            dbms_output.put_line('Nu s-a putut gasi un capitol cu subsirul dat!');
        end if;
    when too_many_rows then
        select count(*) into v_aux
        from student
        where lower(student.nume) = lower(p_numestudent) and lower(student.prenume) = lower(p_prenumestudent);
    
        if v_aux > 1 then
            dbms_output.put_line('Exista mai multi studenti cu numele si prenumele dat!');
        end if;
        
        select count(distinct c.titlu) into v_aux
        from student s, capitol c, student_parcurge_capitol spc, test
        where spc.idstudent = s.idstudent and spc.idcapitol = c.idcapitol
        and instr(lower(c.titlu), lower(p_titlucapitol), 1) > 0
        and spc.efectuat = 1
        and test.idcapitol = c.idcapitol
        and lower(s.nume) = lower(p_numestudent) and lower(s.prenume) = lower(p_prenumestudent);
        
        if v_aux > 1 then
            dbms_output.put_line('Exista mai multe capitole care au in componenta subsirul dat (fiti mai explicit)!');
        end if;
END medie_teste_capitol;
/

BEGIN
    medie_teste_capitol('', '', ''); -- nu exista student & nu exista capitol
    medie_teste_capitol('Chirila','Alexandru Matei','vertical'); -- nu exista capitol
    -- pentru urmatoarea exceptie creez un student care sa aibe acelasi nume
    insert into student (idstudent, nume, prenume, email, datacreare) values (100, 'Chirila', 'Alexandru Matei', 'chirilaalexandrumatei2@outlook.com', sysdate);
    medie_teste_capitol('Chirila', 'Alexandru Matei', 'i'); -- mai multi studenti
    delete from student where idstudent = 100;
    medie_teste_capitol('Banica', 'Raul Cezar', 'i'); -- mai multe capitole
    medie_teste_capitol('Chirila', 'Alexandru Matei', 'introduction'); -- ok
END;
/

-- 10. doar adminul bazei de date poate modifica, insera sau sterge un curs din baza de date

create or replace trigger t_admincurs
    before insert or update or delete on curs
declare
begin

    if (lower(sys.login_user) != 'sys') then
        raise_application_error(-20900, 'Doar administratorul bazei de date poate efectua modificari pe tabela de cursuri!');
    end if;
end;
/

insert into curs (idcurs, nume, descriere, diploma, pret, limba) values (100, '100 days of code', 'Ia-o de la zero cu programarea in Python! Pe parcursul celor 100 de zile vei avea ceva de codat zilnic.', 1, 49.99, 'engleza');

-- 11. Trigger care adauga linii in tabele asociative odata cu cumpararea unui curs 

create or replace trigger t_cumparare
    after insert on card_cumpara_curs
    for each row
declare
    v_numarlinii int;
    v_idstudent int;
    v_idcapitol int;
    type v_iduri is varray(10) of int;
    v_idcapitole v_iduri;
    v_idteste v_iduri;
    v_idteme v_iduri;
    
begin
    if inserting then 
        select c.idstudent into v_idstudent
        from card c
        where c.idcard = :NEW.idcard;
        
        select idcapitol bulk collect into v_idcapitole
        from capitol
        where idcurs = :NEW.idcurs;
        
        for i in v_idcapitole.first..v_idcapitole.last loop
            insert into student_parcurge_capitol (idstudent, idcapitol, efectuat) values (v_idstudent, i, 0);
            
            select count(*) into v_numarlinii
            from test where idcapitol = i;
            
            if (v_numarlinii > 0) then
                select idtest bulk collect into v_idteste
                from test
                where idcapitol = i;
            end if;
            
            select count(*) into v_numarlinii
            from tema where idcapitol = i;
            
            if (v_numarlinii > 0) then
                select idtema bulk collect into v_idteme
                from tema
                where idcapitol = i;
            end if;
        end loop;
        
        insert into student_noteaza_curs (idstudent, idcurs) values (v_idstudent, :NEW.idcurs);
        
        for i in v_idteste.first..v_idteste.last loop
            insert into student_rezolva_test (idstudent, idtest) values (v_idstudent, i);
        end loop;
        
        for i in v_idteme.first..v_idteme.last loop
            insert into student_rezolva_tema (idstudent, idtema) values (v_idstudent, i);
        end loop;
    end if;
end;
/

insert into student (idstudent, nume, prenume, email, datacreare) values (100, 'Damian', 'Andrei', 'damianandrei@gmail.com', sysdate);
insert into card (idcard, idstudent, detinator, numar, dataexpirare, cif) values (100, 100, 'DAMIAN ANDREI', 2345890567828972, to_date('01/05/2026', 'DD/MM/YYYY'), 757);
insert into card_cumpara_curs values (100, 1, sysdate);

select * from card_cumpara_curs;
select * from student_parcurge_capitol;
select * from student_noteaza_curs;
select * from student_rezolva_tema;
select * from student_rezolva_test;

-- 12. tabela care tine minte modificari produse in tabela

create table modificari (
    utilizator varchar2(50),
    bazadedate varchar2(50),
    modificare varchar2(50),
    numeobiect varchar2(50),
    dataefectuare date default sysdate
);

create or replace trigger t_modificari
    after alter or create or drop on schema
begin
    insert into modificari (utilizator, bazadedate, modificare, numeobiect)
    values (sys.login_user, sys.database_name, sys.sysevent, sys.dictionary_obj_name);
end;
/

select * from modificari;