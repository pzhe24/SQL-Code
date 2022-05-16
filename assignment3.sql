--Assignment 3 
--Q1
ACCEPT v_region_id PROMPT 'Enter value for region: ';
DECLARE
  v_region_id regions.region_id%TYPE := &v_region_id;
  v_country_name countries.country_name%TYPE;
  v_counter NUMBER := 0;
  
BEGIN
    SELECT country_name INTO v_country_name
    FROM countries
    WHERE country_id NOT IN(SELECT country_id FROM locations)
    AND region_id = v_region_id;

    SELECT COUNT(country_name) INTO v_counter
    FROM countries
    WHERE country_id NOT IN(SELECT country_id FROM locations);

    UPDATE countries
    SET flag ='EMPTY_'||region_id
    WHERE country_id NOT IN(SELECT country_id FROM locations);
    
    DBMS_OUTPUT.PUT_LINE('In the region '||v_region_id||' there is ONE country '||v_country_name||' with NO city.');
    DBMS_OUTPUT.PUT_LINE('Number of countries with NO cities listed is: '||v_counter);
    
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
          DBMS_OUTPUT.PUT_LINE('This region ID does NOT exist: ' || v_region_id);  
      WHEN TOO_MANY_ROWS THEN
          DBMS_OUTPUT.PUT_LINE('This region ID has MORE THAN ONE country without cities listed: ' || v_region_id);
END;
/
SELECT *
FROM countries 
WHERE flag IS NOT NULL
ORDER BY region_id, country_name;
ROLLBACK;
/



--Q2
ACCEPT coursedesc PROMPT 'Enter the piece of the course description in UPPER case'
ACCEPT lastname PROMPT 'Enter the beginning of Instructor last name in UPPER case'
DECLARE
    CURSOR c_course_cursor IS
        SELECT c.course_no, c.description, s.section_id, i.last_name, s.section_no
        FROM course c JOIN 
        section s ON (c.course_no = s.course_no) JOIN
        instructor i ON (i.instructor_id = s.instructor_id)
        WHERE UPPER(c.description) LIKE ('%&coursedesc%')
        AND UPPER(i.last_name) LIKE ('&lastname%');
        
    CURSOR c_stucount_cursor (sect NUMBER) IS
        SELECT COUNT(student_id) AS count 
        FROM enrollment
        WHERE section_id = sect;
        
        v_hasClass BOOLEAN := false;
        v_studentCount NUMBER := 0;
                        
BEGIN
    FOR i IN c_course_cursor LOOP
        v_hasClass := true;
        DBMS_OUTPUT.PUT_LINE('Course No: ' || i.course_no || ' ' || i.description || ' with Section Id: ' || i.section_id || ' is taught by ' || i.last_name);
        FOR j IN c_stucount_cursor(i.section_id) LOOP
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('This Section Id has an enrollment of: ' || j.count);
            v_studentCount := v_studentCount + j.count;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('*********************************************************************');
   END LOOP;
        IF v_hasClass = false THEN
            DBMS_OUTPUT.PUT_LINE('There is NO data for this input match between the course description piece and the surname start of Instructor. Try again!');
        ELSE
            DBMS_OUTPUT.PUT_LINE('This input match has a total enrollment of: ' || v_studentCount || ' students.');
        END IF;
END;
    


