```sql
-- ==========================================
-- STUDENT MANAGEMENT SYSTEM
-- Using Oracle SQL and PL/SQL
-- ==========================================

-- 1. CREATE STUDENT TABLE

CREATE TABLE students (
    student_id NUMBER PRIMARY KEY,
    student_name VARCHAR2(50) NOT NULL,
    course VARCHAR2(30),
    email VARCHAR2(100)
);

-- 2. INSERT SAMPLE RECORDS

INSERT INTO students VALUES
(101, 'Rahul Sharma', 'MCA', 'rahul@gmail.com');

INSERT INTO students VALUES
(102, 'Priya Singh', 'BCA', 'priya@gmail.com');

INSERT INTO students VALUES
(103, 'Aman Kumar', 'MCA', 'aman@gmail.com');

COMMIT;

-- 3. PROCEDURE TO ADD A STUDENT

CREATE OR REPLACE PROCEDURE add_student (
    p_id IN NUMBER,
    p_name IN VARCHAR2,
    p_course IN VARCHAR2,
    p_email IN VARCHAR2
)
AS
BEGIN
    INSERT INTO students
    VALUES (p_id, p_name, p_course, p_email);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Student added successfully.');

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Error: Student ID already exists.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

-- 4. FUNCTION TO COUNT STUDENTS

CREATE OR REPLACE FUNCTION total_students
RETURN NUMBER
AS
    v_total NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_total
    FROM students;

    RETURN v_total;
END;
/

-- 5. PROCEDURE TO SEARCH A STUDENT

CREATE OR REPLACE PROCEDURE search_student (
    p_id IN NUMBER
)
AS
    v_name students.student_name%TYPE;
    v_course students.course%TYPE;
    v_email students.email%TYPE;
BEGIN
    SELECT student_name, course, email
    INTO v_name, v_course, v_email
    FROM students
    WHERE student_id = p_id;

    DBMS_OUTPUT.PUT_LINE('Student ID: ' || p_id);
    DBMS_OUTPUT.PUT_LINE('Name: ' || v_name);
    DBMS_OUTPUT.PUT_LINE('Course: ' || v_course);
    DBMS_OUTPUT.PUT_LINE('Email: ' || v_email);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Student not found.');
END;
/

-- 6. PROCEDURE TO UPDATE STUDENT COURSE

CREATE OR REPLACE PROCEDURE update_student_course (
    p_id IN NUMBER,
    p_course IN VARCHAR2
)
AS
BEGIN
    UPDATE students
    SET course = p_course
    WHERE student_id = p_id;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Student not found.');
    ELSE
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Student updated successfully.');
    END IF;
END;
/

-- 7. PROCEDURE TO DELETE A STUDENT

CREATE OR REPLACE PROCEDURE delete_student (
    p_id IN NUMBER
)
AS
BEGIN
    DELETE FROM students
    WHERE student_id = p_id;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Student not found.');
    ELSE
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Student deleted successfully.');
    END IF;
END;
/

-- 8. TRIGGER TO DISPLAY INSERT MESSAGE

CREATE OR REPLACE TRIGGER student_insert_trigger
AFTER INSERT ON students
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE(
        'New student record inserted: ' || :NEW.student_name
    );
END;
/

-- 9. DISPLAY ALL STUDENTS USING EXPLICIT CURSOR

DECLARE
    CURSOR student_cursor IS
        SELECT student_id, student_name, course, email
        FROM students
        ORDER BY student_id;

    v_id students.student_id%TYPE;
    v_name students.student_name%TYPE;
    v_course students.course%TYPE;
    v_email students.email%TYPE;
BEGIN
    OPEN student_cursor;

    LOOP
        FETCH student_cursor
        INTO v_id, v_name, v_course, v_email;

        EXIT WHEN student_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('-------------------------');
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_id);
        DBMS_OUTPUT.PUT_LINE('Name: ' || v_name);
        DBMS_OUTPUT.PUT_LINE('Course: ' || v_course);
        DBMS_OUTPUT.PUT_LINE('Email: ' || v_email);
    END LOOP;

    CLOSE student_cursor;
END;
/

-- 10. TEST THE SEARCH PROCEDURE

BEGIN
    search_student(101);
END;
/

-- 11. DISPLAY TOTAL NUMBER OF STUDENTS

BEGIN
    DBMS_OUTPUT.PUT_LINE(
        'Total Students: ' || total_students()
    );
END;
/

-- 12. TEST UPDATE PROCEDURE

BEGIN
    update_student_course(103, 'MCA');
END;
/

-- 13. DISPLAY FINAL TABLE

SELECT * FROM students ORDER BY student_id;
```
