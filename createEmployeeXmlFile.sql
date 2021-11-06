CREATE OR REPLACE PROCEDURE createEmployeeXmlFile IS
    v_output CLOB;
BEGIN
   SELECT XmlElement("employees", XmlAgg(XmlElement("employee", 
          XmlForest(emp.first_name AS "first-name", 
                    emp.last_name AS "last-name", 
                    emp.birth_date AS "birth-date", 
                    emp.sex AS "sex", 
                    branch.name AS "branch-name", 
                    manager.first_name AS "manager-first-name", 
                    manager.last_name AS "manager-last-name"
                    )))).getclobval() INTO v_output
    FROM employee emp
    LEFT JOIN branch ON (emp.branch_id = branch.id)
    LEFT JOIN employee manager ON (emp.supervisor_id = manager.id);

    DBMS_XSLPROCESSOR.clob2file(v_output, 'DATA_PUMP_DIR', 'output.xml', nls_charset_id('AL32UTF8'));
END createEmployeeXmlFile;