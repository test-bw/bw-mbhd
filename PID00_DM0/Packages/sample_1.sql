CREATE OR REPLACE PACKAGE sample_package_1 IS
  PROCEDURE say_hello;
END sample_package_1;
/

CREATE OR REPLACE PACKAGE BODY sample_package_1 IS
  PROCEDURE say_hello IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello from package 1');
  END;
END sample_package_1;
/
