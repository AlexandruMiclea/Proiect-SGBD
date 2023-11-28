exec dbms_output.enable(NULL);
SET SERVERoutput on format wrapped;


-- exercitiul 6
-- pentru un student al carui ID se da de la tastatura sa se afiseze cursurile pe care le-a cumparat
-- pentru fiecare curs cumparat sa se enumere intrebarile din testele aferente fiecarui capitol al cursului, cat
-- si raspunsurile corecte
select * from student;

CREATE OR REPLACE PROCEDURE afisare_cursuri (v_id student.idstudent%type) as
    TYPE date_curs IS RECORD (id curs.idcurs%type, nume curs.nume%type);
    TYPE date_intrebare IS RECORD (enunt intrebare.enunt%type, raspuns intrebare.raspunscorect%type);
    TYPE date_capitol IS RECORD (id capitol.idcapitol%type, titlu capitol.titlu%type);
    TYPE t_curs IS TABLE OF date_curs INDEX BY PLS_INTEGER;
    TYPE t_capitol IS TABLE OF date_capitol;
    TYPE t_intrebare IS TABLE OF date_intrebare;
    TYPE t_test IS VARRAY(6) of test.IDTEST%type; -- 6 este scos din neant, teoretic nu pot avea mai mult de 6 teste la un capitol
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
    DBMS_OUTPUT.PUT_LINE('Studentul ' || nume_s || ', care s-a intregistrat la data de ' || datacreare_s ||  'a cumparat urmatoarele cursuri: ');
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
                dbms_output.PUT_LINE(teste.count || ' teste:');
                for k in teste.first..teste.last LOOP
                    -- ia intrebarile din test
                    dbms_output.put_line('        Testul ' || k || ':');
                    select enunt, raspunscorect bulk collect into intrebari
                    from INTREBARE
                    where idtest = teste(k);
                    for l in intrebari.first..intrebari.last LOOP
                    -- TODO see how to correct output
                        DBMS_OUTPUT.PUT_line('            Intrebarea ' || l || ': ' || intrebari(l).enunt);
                        DBMS_OUTPUT.PUT_LINE('            Raspunsul corect este ' || intrebari(l).raspuns);

                    end loop;
                end loop;
            ELSE
                DBMS_OUTPUT.PUT_LINE('nu are teste.');
            end if;
        end loop;
    end loop;
END afisare_cursuri;
/

BEGIN
    afisare_cursuri(&cod_student);
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


-- exercitiul 8
-- pentru un instructor al carui nume se da la tastatura sa se afiseze cate copii ale tuturor cursurilor pe care le preda au fost cumparate?

CREATE OR REPLACE FUNCTION numar_clienti (nume_instr instructor.nume%type) RETURN number AS
BEGIN
END numar_clienti;
/