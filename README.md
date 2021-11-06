# Generating XML File From Oracle Database


The purpose of this project is to generate a xml file using employee data from [company database](https://github.com/kmjenniferng/oracle-company-db-project).

### 1. Generating XML using SQL Functions
In order to construct xml data, we can use XmlElement, XmlAgg and XmlForest Oracle SQL functions. 
For more details, please see [Oracle SQL/XML functions](https://docs.oracle.com/cd/E11882_01/appdev.112/e23094/xdb13gen.htm#ADXDB4987)

```
   SELECT XmlElement("employees", XmlAgg(XmlElement("employee", 
          XmlForest(emp.first_name AS "first-name", 
                    emp.last_name AS "last-name", 
                    emp.birth_date AS "birth-date", 
                    emp.sex AS "sex", 
                    branch.name AS "branch-name", 
                    manager.first_name AS "manager-first-name", 
                    manager.last_name AS "manager-last-name"
                    ))))
    FROM employee emp
    LEFT JOIN branch ON (emp.branch_id = branch.id)
    LEFT JOIN employee manager ON (emp.supervisor_id = manager.id);
```

### 2. Create createEmployeeXmlFile procedure
Once the xml data is constructed, we can save the data into [output.xml](https://github.com/kmjenniferng/oracle-create-xml-file-project/blob/main/output.xml). 
In order to do that, we need to create a procedure.

```
create or replace PROCEDURE createEmployeeXmlFile IS
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
```

### 3. Execute createEmployeeXmlFile procedure in SQL Developer

```
exec createEmployeeXmlFile;
```

### 4. Sample xml data in [output.xml](https://github.com/kmjenniferng/oracle-create-xml-file-project/blob/main/output.xml) file.
```
<employees>
<employee>
<first-name>Jan</first-name>
<last-name>Levinson</last-name>
<birth-date>1961-05-11</birth-date>
<sex>F</sex>
<branch-name>Corporate</branch-name>
<manager-first-name>David</manager-first-name>
<manager-last-name>Wallace</manager-last-name>
</employee>

<employee>
<first-name>Michael</first-name>
<last-name>Scott</last-name>
<birth-date>1964-03-15</birth-date>
<sex>M</sex>
<branch-name>Scranton</branch-name>
<manager-first-name>David</manager-first-name>
<manager-last-name>Wallace</manager-last-name>
</employee>
...
</employees>
```

