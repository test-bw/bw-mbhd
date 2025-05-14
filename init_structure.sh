#!/bin/bash

schemas=("PID00_DSA" "PID00_DM0" "PID00_REPORTS")
folders=("Tables" "Views" "MaterializedViews" "Packages" "Procedures" "Functions" "Triggers" "Data" "Migrations")

echo "📁 Tworzenie struktury katalogów dla repozytorium mbhd-oracle..."

for schema in "${schemas[@]}"; do
  for folder in "${folders[@]}"; do
    path="./$schema/$folder"
    mkdir -p "$path"

    # Tworzenie przykładowych plików .sql
    for i in {1..3}; do
      file="$path/sample_${i}.sql"
      case $folder in
        Tables)
          cat <<EOF > "$file"
CREATE TABLE sample_table_${i} (
  id NUMBER PRIMARY KEY,
  name VARCHAR2(100),
  created_at DATE DEFAULT SYSDATE
);
EOF
          ;;
        Views)
          cat <<EOF > "$file"
CREATE OR REPLACE VIEW sample_view_${i} AS
SELECT * FROM sample_table_${i};
EOF
          ;;
        MaterializedViews)
          cat <<EOF > "$file"
CREATE MATERIALIZED VIEW sample_mv_${i}
REFRESH COMPLETE ON DEMAND
AS
SELECT * FROM sample_table_${i};
EOF
          ;;
        Packages)
          cat <<EOF > "$file"
CREATE OR REPLACE PACKAGE sample_package_${i} IS
  PROCEDURE say_hello;
END sample_package_${i};
/

CREATE OR REPLACE PACKAGE BODY sample_package_${i} IS
  PROCEDURE say_hello IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello from package ${i}');
  END;
END sample_package_${i};
/
EOF
          ;;
        Procedures)
          cat <<EOF > "$file"
CREATE OR REPLACE PROCEDURE sample_proc_${i} IS
BEGIN
  DBMS_OUTPUT.PUT_LINE('Sample procedure ${i}');
END;
/
EOF
          ;;
        Functions)
          cat <<EOF > "$file"
CREATE OR REPLACE FUNCTION sample_func_${i} RETURN NUMBER IS
BEGIN
  RETURN ${i};
END;
/
EOF
          ;;
        Triggers)
          cat <<EOF > "$file"
CREATE OR REPLACE TRIGGER trg_sample_${i}
BEFORE INSERT ON sample_table_${i}
FOR EACH ROW
BEGIN
  :NEW.created_at := SYSDATE;
END;
/
EOF
          ;;
        Data)
          cat <<EOF > "$file"
INSERT INTO sample_table_${i} (id, name)
VALUES (${i}, 'Sample name ${i}');
EOF
          ;;
        Migrations)
          cat <<EOF > "$file"
ALTER TABLE sample_table_${i} ADD column_${i} VARCHAR2(50);
EOF
          ;;
      esac
    done

    echo "✔️  Utworzono: $path z 3 przykładowymi plikami SQL"
  done
done

# Katalogi deploy
mkdir -p ./deploy/{dev,uat,prod}
touch ./deploy/dev/run_all.sql ./deploy/uat/run_all.sql ./deploy/prod/run_all.sql
echo "✔️  Utworzono katalog: ./deploy z plikami run_all.sql"

echo "✅ Gotowe! Struktura katalogów i pliki SQL zostały utworzone."

