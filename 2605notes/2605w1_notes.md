# 2026/05 week1學習筆記

> 用來記錄每日學習的內容，先瞭解基礎，每週末回頭 review 做延伸補充

## 目錄

- [5/3](#503) — 
- [5/4](#504) — 
- [5/5]() — 
- [5/6]() - 
- [5/7]() - 
---

## 5/03

### 微服務（Microservices）
微服務（Microservices）是一種將大型複雜應用程式拆分為多個小型、獨立、專注於單一業務功能的服務架構風格。各服務運行在獨立的行程中，透過 HTTP API 或輕量級訊息機制通信，並可獨立部署、擴展與使用不同技術棧。此架構能加快開發速度、提高系統靈活性與抗風險能力。
服務係針對商業功能所建立，且每項服務皆可執行單一功能。因為每項服務皆獨立運作，因此可以個別更新、部署和擴展，以滿足應用程式特定功能的需求。


微服務架構的目標是要將應用程式通過一些小的、鬆散耦合的服務組織在一起，藉此提高開發效率，特別在：
- 可維護性 (maintainability)
- 可測試性 (testability)
- 可部署性 (deployability)
- 可擴展性 (scalability)


### O11y 
可觀測性(Observability)
從對系統外部輸出的資訊推斷系統內部狀態的能力



### code review standard
TBC
https://hackmd.io/@maxcian/guides-for-design-review-and-code-review
SOLID https://hackmd.io/@maxcian/revisit-solid
dry 
kiss 

### 文章閱讀
- [什麼是 POC（Proof of Concept）？軟體銷售中的概念驗證完整指南](https://realnewbie.com/posts/what-is-poc-proof-of-concept-complete-guide-to-concept-validation-in-software-sales)

- [淺入淺出 Dependency Injection](https://medium.com/wenchin-rolls-around/%E6%B7%BA%E5%85%A5%E6%B7%BA%E5%87%BA-dependency-injection-ea672ba033ca)
- [【問題分析與解決工具】第3篇：五個為什麼(5 Whys)分析法](https://medium.com/@lingchan2050/%E5%95%8F%E9%A1%8C%E5%88%86%E6%9E%90%E8%88%87%E8%A7%A3%E6%B1%BA%E5%B7%A5%E5%85%B7-%E7%AC%AC3%E7%AF%87-%E4%BA%94%E5%80%8B%E7%82%BA%E4%BB%80%E9%BA%BC-5-whys-%E5%88%86%E6%9E%90%E6%B3%95-6fe558f63161)

### 英單
```
- implement :實作
```



## 5/04

### 鴨子型別 (Duck typing)
鴨子型別（Duck Typing）是動態程式語言（如 Python、Ruby）的一種設計風格，核心概念為「若看起來像鴨子、叫聲像鴨子，那他就是鴨子」。物件的有效語意取決於它目前擁有的「方法和屬性」集合，而非繼承自特定類別或實現特定介面。這種風格強化了程式碼的靈活性，通常用於實現運行時的多型效果。

>「只要他叫聲像鴨子、走路像鴨子，那他就是鴨子」

這樣的好處在於：

- 靈活性：不必擔心物件的具體類型，僅依據他的方法和屬性決定，不依靠繼承或類的實現。
- 易於理解：通常你只會關注可以做什麼，而非他是什麼，在大型專案中可以減少維護類型層次的複雜性。
- 提高程式碼的重用性：可以讓有相同方法和屬性的物件共享程式碼

[走路像鴨子、叫聲像鴨子，他就是鴨子？](https://www.explainthis.io/zh-hant/swe/python-tutorial/04)


### SQL cheatsheet

```SQL
-- Create and delete a database. Database and table names are case-sensitive.
CREATE DATABASE someDatabase;
DROP DATABASE someDatabase;

-- List available databases.
SHOW DATABASES;

-- Use a particular existing database.
USE employees;

-- Select all rows and columns from the current database's departments table.
-- Default activity is for the interpreter to scroll the results on your screen.
SELECT * FROM departments;

-- Retrieve all rows from the departments table,
-- but only the dept_no and dept_name columns.
-- Splitting up commands across lines is OK.
SELECT dept_no,
       dept_name FROM departments;

-- Retrieve all departments columns, but just 5 rows.
SELECT * FROM departments LIMIT 5;

-- Retrieve dept_name column values from the departments
-- table where the dept_name value has the substring 'en'.
SELECT dept_name FROM departments WHERE dept_name LIKE '%en%';

-- Retrieve all columns from the departments table where the dept_name
-- column starts with an 'S' and has exactly 4 characters after it.
SELECT * FROM departments WHERE dept_name LIKE 'S____';

-- Select title values from the titles table but don't show duplicates.
SELECT DISTINCT title FROM titles;

-- Same as above, but sorted (case-sensitive) by the title values.
-- The order can be specified by adding ASC (ascending) or DESC (descending).
-- If omitted, it will sort in ascending order by default.
SELECT DISTINCT title FROM titles ORDER BY title ASC;

-- Use the comparison operators (=, >, <, >=, <=, <>) and
-- the conditional keywords (AND, OR) to refine your queries.
SELECT * FROM departments WHERE dept_no = 'd001' OR dept_no = 'd002';

-- Same as above.
SELECT * FROM departments WHERE dept_no IN ('d001', 'd002');

-- Opposite of the above.
SELECT * FROM departments WHERE dept_no NOT IN ('d001', 'd002');

-- Select in a given range.
SELECT * from departments WHERE dept_no BETWEEN 'd001' AND 'd002';

-- Show the number of rows in the departments table.
SELECT COUNT(*) FROM departments;

-- Show the number of rows in the departments table that
-- have 'en' as a substring of the dept_name value.
SELECT COUNT(*) FROM departments WHERE dept_name LIKE '%en%';

-- Aggregate functions can be used, with GROUP BY, to compute a value
-- from a set of values. Most commonly used functions are:
-- MIN(), MAX(), COUNT(), SUM(), AVG().
-- Use HAVING to filter rows by aggregated values.

-- Retrieve the total number of employees, by department number,
-- with the condition of having more than 100 employees.
SELECT dept_no, COUNT(dept_no) FROM dept_emp GROUP BY dept_no
HAVING COUNT(dept_no) > 100;

-- Aliases, using the optional keyword AS, can be used for column/table names.
SELECT COUNT(A.*) AS total_employees, COUNT(B.*) total_departments
FROM employees AS A, departments B;

-- Common date format is "yyyy-mm-dd".
-- However, it can vary according to the implementation, the operating system, and the session's locale.
SELECT * FROM dept_manager WHERE from_date >= '1990-01-01';

-- A JOIN of information from multiple tables: the titles table shows
-- who had what job titles, by their employee numbers, from what
-- date to what date. Retrieve this information, but instead of the
-- employee number, use the employee number as a cross-reference to
-- the employees table to get each employee's first and last name
-- instead. (And only get 10 rows.)

SELECT employees.first_name, employees.last_name,
       titles.title, titles.from_date, titles.to_date
FROM titles INNER JOIN employees ON
       employees.emp_no = titles.emp_no LIMIT 10;

-- Combine the result of multiple SELECT.
-- UNION selects distinct rows, UNION ALL selects all rows.
SELECT * FROM departments WHERE dept_no = 'd001'
UNION
SELECT * FROM departments WHERE dept_no = 'd002';

-- SQL syntax order is:
-- SELECT _ FROM _ JOIN _ ON _ WHERE _ GROUP BY _ HAVING _ ORDER BY _ UNION

-- List all the tables in all the databases. Implementations typically provide
-- their own shortcut command to do this with the database currently in use.
SELECT * FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE='BASE TABLE';

-- Create a table called tablename1, with the two columns shown, for
-- the database currently in use. Lots of other options are available
-- for how you specify the columns, such as their datatypes.
CREATE TABLE tablename1 (fname VARCHAR(20), lname VARCHAR(20));

-- Insert a row of data into the table tablename1. This assumes that the
-- table has been defined to accept these values as appropriate for it.
INSERT INTO tablename1 VALUES('Richard','Mutt');

-- In tablename1, change the fname value to 'John'
-- for all rows that have an lname value of 'Mutt'.
UPDATE tablename1 SET fname='John' WHERE lname='Mutt';

-- Delete rows from the tablename1 table
-- where the lname value begins with 'M'.
DELETE FROM tablename1 WHERE lname LIKE 'M%';

-- Delete all rows from the tablename1 table, leaving the empty table.
DELETE FROM tablename1;

-- Remove the entire tablename1 table.
DROP TABLE tablename1;
```

[Tutorial Hell](https://www.linkedin.com/pulse/escaping-tutorial-hell-guide-progress-your-learning-journey-jatasra-dvdgf/)


<hr>

## 5/5

### AWS lab

錯題記錄：
Q：What is the primary purpose of a Route table in Amazon VPC?

A:

| Option | Correct answer | My selection | Rationale |
| --- | --- | --- | --- |
|A. To control network traffic between subnets || Selected | While Route tables influence traffic flow, they don't directly control traffic between subnets. This is primarily managed through Network ACLs and Security Groups. |
| B. To configure VPN connections ||| VPN connections are configured using Virtual Private Gateways and Customer Gateways, not through Route tables. |
| C. To specify the allowed routes for outbound traffic leaving a subnet | Correct || A Route table in Amazon VPC is used to determine where network traffic from your subnet or gateway is directed. It specifies the allowed routes for outbound traffic leaving a subnet. While the route table manages outbound traffic, security groups on individual instances determine which inbound traffic is allowed. |
| D. To manage IP addresses for EC2 instances ||| IP addresses for EC2 instances are managed through subnet configurations and DHCP options sets, not through Route tables.|


### AWS Glue
AWS Glue 是一款無伺服器資料整合服務，旨在簡化並自動化 ETL（擷取、轉換、載入）流程，讓從多個來源發現、準備及合併數據以進行分析與機器學習變得容易。

Why Use AWS Glue?
- 無伺服器與完全管理：無需伺服器配置、管理或擴展。您只需支付作業執行時所使用的資源，從而降低營運複雜度與成本。
- 自動資料發現（爬蟲）：膠水爬蟲掃描資料來源（如 S3、JDBC），自動推斷結構並填充中央膠水資料目錄，防止產生「資料沼澤」。
- 簡易 ETL 開發：提供視覺化（Glue Studio）及程式碼化（Python/Scala）工具，快速建立 ETL 管線，並支援 AI 程式碼生成。
- 無縫 AWS 整合：原生支援 AWS 服務，如 Amazon S3、Amazon Redshift、Amazon Athena 及 Amazon EMR。
- 彈性資料處理引擎：支援 Apache Spark 進行大規模批次/串流，Ray 用於 Python 工作負載，Python Shell 用於較小的腳本任務。
