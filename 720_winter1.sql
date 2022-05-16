--Q2
DECLARE
    v_title VARCHAR2(31);
    v_num NUMBER(8,2);
    v_const CONSTANT VARCHAR2(4) := '704B';
    v_tf BOOLEAN;
    v_weekahead DATE := SYSDATE+7;
BEGIN
    DBMS_OUTPUT.PUT_LINE('The Constant value is: ' || v_const);
    DBMS_OUTPUT.PUT_LINE('The Date is: ' || TO_CHAR(v_weekahead,'Mon DD,RR'));
    v_title := 'C++ advanced';
    IF v_title LIKE '%SQL%' THEN
        DBMS_OUTPUT.PUT_LINE(v_title);
    ELSIF v_const = '704D' THEN
        IF v_title IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('Course name: ' || v_title || ' and the room name is: ' || v_const);
        ELSE
            DBMS_OUTPUT.PUT_LINE('Course is unknown and the room name is : '||v_const);
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Course and location could not be determined');
    END IF;
END;

--Q3
DECLARE 
    l CHAR(1);
BEGIN
    l := '&l';
    IF l ='s' THEN
        DBMS_OUTPUT.PUT_LINE('In the chosen province letter, there is city Sao Paulo on location number 2800 in the Province called Sao Paulo');
    ELSIF l = 'a' THEN
        DBMS_OUTPUT.PUT_LINE('In the chosen province letter, there is NO city located.');
    ELSIF l = 't' THEN
        DBMS_OUTPUT.PUT_LINE('In the chosen province letter, there is MORE THAN ONE city located.');
    END IF;
END;
    

--Lab9 
--Q1
ACCEPT scale PROMPT 'Enter the Temperature Scale (F or C)';
ACCEPT temp PROMPT 'Enter the Temperature: ';
DECLARE
    v_inputscale CHAR(1);
    v_temp NUMBER(4,1);
    v_newtemp NUMBER(4,1);
BEGIN
    v_inputscale := '&scale';
    v_temp := &temp;
    
    IF LOWER(v_inputscale) = 'c' THEN
        v_newtemp := (v_temp * 1.8) + 32;
        DBMS_OUTPUT.PUT_LINE('Your converted temperature in F is exactly ' || v_newtemp);
    ELSIF LOWER(v_inputscale) = 'f' THEN
        v_newtemp := (v_temp - 32) * 0.5556;
        DBMS_OUTPUT.PUT_LINE('Your converted temperature in C is exactly ' || v_newtemp);
    ELSE
        DBMS_OUTPUT.PUT_LINE('This is NOT a valid scale. Must be C or F');
    END IF;
END;

--Q2
ACCEPT id PROMPT 'Please enter the Instructor Id:'
DECLARE
    v_instructorid NUMBER(3);
    v_sections NUMBER(2);
    v_firstname VARCHAR2(10);
    v_lastname VARCHAR2(10);
    caseoutput VARCHAR2(100);
BEGIN
    v_instructorid := &id;
    
    SELECT COUNT(s.section_id), i.first_name, i.last_name INTO v_sections, v_firstname, v_lastname
    FROM section s
    RIGHT JOIN instructor i USING (instructor_id)
    WHERE instructor_id = v_instructorid
    GROUP BY (first_name, last_name);
    
   caseoutput := CASE
        WHEN (v_sections > 9) THEN 'Instructor, '||v_firstname||' '||v_lastname||' , teaches '||v_sections||' section(s)'||chr(10)|| 'This instructor needs to rest in the next term.'
        WHEN (v_sections <=9 AND v_sections >3) THEN 'Instructor, '||v_firstname||' '||v_lastname||' , teaches '||v_sections||' section(s)' ||chr(10)|| 'This instructor teaches enough sections.'
        WHEN (v_sections <=3) THEN 'Instructor, '||v_firstname||' '||v_lastname||' , teaches '||v_sections||' section(s)' ||chr(10)|| 'This instructor may teach more sections.'
        ELSE 'Instructor does not exist'
    END;
    DBMS_OUTPUT.PUT_LINE(caseoutput);
    EXCEPTION 
    WHEN no_data_found THEN 
      dbms_output.put_line('Instructor does not exist'); 
END;

--Q3
ACCEPT num PROMPT 'Please enter a Positive Integer:'
DECLARE
    v_num NUMBER;
    v_total_even NUMBER := 0;
    v_total_odd NUMBER := 0;
    counter NUMBER :=1;
BEGIN
    v_num := &num;
    IF v_num > 0 THEN
        WHILE counter <= v_num LOOP
            IF MOD(v_num,2)=0 THEN
                IF MOD(counter,2)=0 THEN
                    v_total_even := v_total_even + counter;
                END IF;
                
            ELSE
                IF MOD(counter,2)=1 THEN
                    v_total_odd := v_total_odd +counter;
                END IF;
            END IF;
            counter := counter+1;
        END LOOP;
        IF v_total_even > 0 THEN
            DBMS_OUTPUT.PUT_LINE('The sum of Even integers between 1 and '||v_num||' is '||v_total_even);
        ELSE
            DBMS_OUTPUT.PUT_LINE('The sum of Odd integers between 1 and '||v_num||' is '||v_total_odd);
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Please Enter a Positive Number');
    END IF;
END;
    
--Q4
ACCEPT locationid PROMPT 'Enter the department''s Location id'
DECLARE
    v_locationid departments.location_id%TYPE;
    v_department departments.department_id%TYPE;
    v_employees employees.employee_id%TYPE;
BEGIN
    v_locationid := &locationid;
    
    SELECT COUNT(department_id) INTO v_department
    FROM departments
    WHERE location_id = v_locationid;
    
    SELECT COUNT(employee_id) INTO v_employees
    FROM employees JOIN departments
    USING (department_id)
    WHERE location_id = v_locationid;
    
    FOR i IN 1..v_department LOOP
            DBMS_OUTPUT.PUT_LINE('Outer Loop: Department #'||i);
            FOR j IN 1..v_employees LOOP
                DBMS_OUTPUT.PUT_LINE('*Inner Loop: Employee #'||j);
            END LOOP;
    END LOOP;
END;

--Lab 10
--Q1
DECLARE
    CURSOR c_courses_cursor IS
    SELECT description
    FROM course
    WHERE prerequisite IS NULL;
    
    v_courses c_courses_cursor%ROWTYPE;
    counter NUMBER := 0;
    
BEGIN
    OPEN c_courses_cursor;
    LOOP
        FETCH c_courses_cursor INTO v_courses;
        EXIT WHEN c_courses_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Course Description : ' || c_courses_cursor%ROWCOUNT || ': ' || v_courses.description);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('**************************************');
    DBMS_OUTPUT.PUT_LINE('Total # of Courses without the Prerequisite is: '||c_courses_cursor%ROWCOUNT);
END;

--Q2
DECLARE
    CURSOR curs_courses IS
        SELECT description
        FROM course
        WHERE prerequisite IS NULL;
    counter NUMBER := 0;
BEGIN
    FOR v_courses IN curs_courses LOOP
        DBMS_OUTPUT.PUT_LINE('Course Description : ' || curs_courses%ROWCOUNT || ': ' || v_courses.description);
        counter := counter +1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('**************************************');
    DBMS_OUTPUT.PUT_LINE('Total # of Courses without the Prerequisite is: '||counter);
END;



ACCEPT city PROMPT 'Enter first two city letters:'
DECLARE
    CURSOR c_city_cursor IS
        SELECT zip, last_name, city
        FROM zipcode JOIN student
        USING (zip)
        WHERE LOWER(city) LIKE ('&city%');
        
    v_cities c_city_cursor%ROWTYPE;
BEGIN

    OPEN c_city_cursor;
    LOOP
        FETCH c_city_cursor INTO v_cities;
        EXIT WHEN c_city_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Zip code : ' || v_cities.zip || ' has student ' || v_cities.last_name || ' who lives in ' || v_cities.city);
        END LOOP;
        IF c_city_cursor%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('These city letters are student empty. Please, try again.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('************************************************************');
            DBMS_OUTPUT.PUT_LINE('Total # of students under ' || INITCAP('&city') || ' is ' || c_city_cursor%ROWCOUNT);
        END IF;
    CLOSE c_city_cursor;
END;
        
        


SELECT zip, last_name, city
FROM zipcode JOIN student
USING (zip)
WHERE city LIKE ('Ne%');

--Q3
ACCEPT zip PROMPT 'Enter your zipcode'
DECLARE
    CURSOR c_zips_cursor IS
        SELECT zip, COUNT(zip) AS zipcount
        FROM student
        WHERE zip LIKE ('&zip%')
        GROUP BY zip
        ORDER BY zip;
        
    zipcodes c_zips_cursor%ROWTYPE;
    zipcounter NUMBER;
    
BEGIN
    SELECT COUNT(zip) INTO zipcounter
    FROM student
    WHERE zip LIKE ('&zip%');


    OPEN c_zips_cursor;
    LOOP
    FETCH c_zips_cursor INTO zipcodes;
    EXIT WHEN c_zips_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Zip code :'|| zipcodes.zip ||' has exactly ' || zipcodes.zipcount || ' students enrolled.');
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('********************************');
    DBMS_OUTPUT.PUT_LINE('Total# of zip codes under ' || '&zip' || ' is ' || c_zips_cursor%ROWCOUNT);
    CLOSE c_zips_cursor;
    DBMS_OUTPUT.PUT_LINE('Total# of Students under zip code ' || '&zip' || ' is ' || zipcounter);
END;
    

    
--Q4
ACCEPT zip PROMPT 'Enter your zipcode'
DECLARE
    CURSOR c_zips_cursor IS
        SELECT zip, COUNT(zip) AS zipcount
        FROM student
        WHERE zip LIKE ('&zip%')
        GROUP BY zip
        ORDER BY zip;
        
    zipcodes c_zips_cursor%ROWTYPE;
    zipcounter NUMBER;
    counter NUMBER := 0;
    
BEGIN
    SELECT COUNT(zip) INTO zipcounter
    FROM student
    WHERE zip LIKE ('&zip%');


    FOR zipcodes IN c_zips_cursor LOOP
        DBMS_OUTPUT.PUT_LINE('Zip code :'|| zipcodes.zip ||' has exactly ' || zipcodes.zipcount || ' students enrolled.');
        counter := counter +1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('********************************');
    DBMS_OUTPUT.PUT_LINE('Total# of zip codes under ' || '&zip' || ' is ' || counter);
    DBMS_OUTPUT.PUT_LINE('Total# of Students under zip code ' || '&zip' || ' is ' || zipcounter);
END;





SET VERIFY OFF;
ACCEPT scale PROMPT 'Enter your input scale (C of F) for temperature'
ACCEPT temp PROMPT 'Enter your temperature value to be converted'
DECLARE
    v_scale CHAR := '&scale';
    v_temp NUMBER(3,1) := &temp;
    
BEGIN
    IF LOWER(v_scale) = 'c' THEN
        v_temp := (v_temp * 1.8) +32;
        DBMS_OUTPUT.PUT_LINE('Your converted temperature in ' || UPPER(v_scale) || ' is exactly ' || v_temp); 
    ELSIF LOWER(v_scale) = 'f' THEN
        v_temp := (v_temp - 32) * 5/9;
        DBMS_OUTPUT.PUT_LINE('Your converted temperature in ' || UPPER(v_scale) || ' is exactly ' ||  v_temp);
    ELSE
        DBMS_OUTPUT.PUT_LINE('This is NOT a valid scale. must be C of F');
    END IF;
END;

--Q2
ACCEPT instructID PROMPT 'Please enter the Instructor Id' 
DECLARE
    v_fn instructor.first_name%TYPE;
    v_ln instructor.last_name%TYPE;
    v_si section.section_id%TYPE;
    caseoutput VARCHAR2(100);

BEGIN
    SELECT i.first_name, i.last_name, COUNT(s.section_id) INTO 
    v_fn, v_ln, v_si
    FROM instructor i LEFT JOIN section s
    USING (instructor_id)
    WHERE instructor_id = &instructID
    GROUP BY (first_name, last_name);
    
       caseoutput := CASE
        WHEN (v_si > 9) THEN 'Instructor, '||v_fn||' '||v_ln||' , teaches '||v_si||' section(s)'||chr(10)|| 'This instructor needs to rest in the next term.'
        WHEN (v_si <=9 AND v_si >3) THEN 'Instructor, '||v_fn||' '||v_ln||' , teaches '||v_si||' section(s)' ||chr(10)|| 'This instructor teaches enough sections.'
        WHEN (v_si <=3) THEN 'Instructor, '||v_fn||' '||v_ln||' , teaches '||v_si||' section(s)' ||chr(10)|| 'This instructor may teach more sections.'
        ELSE 'Instructor does not exist'
    END;
    DBMS_OUTPUT.PUT_LINE(caseoutput);
END;

--Q3
ACCEPT num PROMPT 'Please enter a Positive Integer:'
DECLARE
    v_num NUMBER;
    v_total_even NUMBER := 0;
    v_total_odd NUMBER := 0;
    counter NUMBER :=1;
BEGIN
    v_num := &num;
    IF v_num > 0 THEN
        WHILE counter <= v_num LOOP
            IF MOD(v_num,2)=0 THEN
                IF MOD(counter,2)=0 THEN
                    v_total_even := v_total_even + counter;
                END IF;
            ELSE
                IF MOD(counter,2)=1 THEN
                    v_total_odd := v_total_odd +counter;
                END IF;
            END IF;
            counter := counter+1;
        END LOOP;
        IF v_total_even > 0 THEN
            DBMS_OUTPUT.PUT_LINE('The sum of Even integers between 1 and '||v_num||' is '||v_total_even);
        ELSE
            DBMS_OUTPUT.PUT_LINE('The sum of Odd integers between 1 and '||v_num||' is '||v_total_odd);
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Please Enter a Positive Number');
    END IF;
END;

SELECT * FROM section;
SELECT * FROM instructor;

ACCEPT id PROMPT 'Please enter the Instructor Id:'
DECLARE
    v_firstName instructor.first_name%TYPE;
    v_lastName instructor.last_name%TYPE;
    counter NUMBER;
    output VARCHAR2(100);
BEGIN
    SELECT i.first_name, i.last_name, COUNT(s.section_id)
    INTO v_firstName, v_lastName, counter
    FROM instructor i LEFT JOIN
    section s USING(instructor_id)
    WHERE instructor_id = 107
    GROUP BY (i.first_name, i.last_name);
    
    output := CASE
        WHEN(counter > 9) THEN
            'Instructor, '||v_firstName||' '||v_lastName||' , teaches '||counter||' section(s)'||chr(10)|| 'This instructor needs to rest in the next term.'
        WHEN(counter <=9 AND counter > 3) THEN
        'Instructor, '||v_firstName||' '||v_lastName||' , teaches '||counter||' section(s)' ||chr(10)|| 'This instructor teaches enough sections.'
        WHEN(counter <=3) THEN
        'Instructor, '||v_firstName||' '||v_lastName||' , teaches '||counter||' section(s)' ||chr(10)|| 'This instructor may teach more sections.'
        ELSE
        'Instructor Does not Exist'
    END;
    DBMS_OUTPUT.PUT_LINE(output);
END;
    
    
ACCEPT num PROMPT 'Enter a positive number:'
DECLARE
    counter NUMBER := 0;
    v_total_even NUMBER :=0;
    v_total_odd NUMBER :=0;
BEGIN
    IF &num > 0 THEN
        WHILE counter <= &num LOOP
            IF MOD(&num,2)=0 THEN
                IF MOD(counter,2)=0 THEN
                    v_total_even := v_total_even + counter;
                END IF;
            ELSE
                IF MOD(counter,2)=1 THEN
                    v_total_odd := v_total_odd +counter;
                END IF;
            END IF;
            counter := counter +1;
        END LOOP;
        IF v_total_even > 0 THEN
            DBMS_OUTPUT.PUT_LINE('The sum of Even integers between 1 and '||&num||' is '||v_total_even);
        ELSE
            DBMS_OUTPUT.PUT_LINE('The sum of Odd integers between 1 and '||&num||' is '||v_total_odd);
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Enter a positive number!');
    END IF;
END;
    


ACCEPT id PROMPT 'Enter valid location id:'
DECLARE
    v_empCount NUMBER;
    v_deptCount NUMBER;
BEGIN
    SELECT COUNT(employee_id) INTO v_empCount
    FROM employees JOIN departments
    USING (department_id)
    WHERE location_id = &id;
    
    SELECT COUNT(department_id) INTO v_deptCount
    FROM departments
    WHERE location_id = &id;
    
    FOR i IN 1..v_deptCount LOOP
        DBMS_OUTPUT.PUT_LINE('Outer Loop: Department#'||i);
        FOR j IN 1..v_empCount LOOP
            DBMS_OUTPUT.PUT_LINE('Inner Loop: Employee#'||j);
        END LOOP;
    END LOOP;
END;
    
    



UPDATE  Departments
SET     location_id = 1400
WHERE  department_id IN (40,70);



SELECT * FROM departments;
SELECT * FROM employees;




    






















