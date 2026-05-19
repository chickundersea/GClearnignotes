# 2026/05 week1學習筆記

> 用來記錄每日學習的內容，先瞭解基礎，每週末回頭 review 做延伸補充

## 目錄

- [5/3](#503) — 微服務、O11y、Code Review Standard
- [5/4](#504) — 鴨子型別、SQL cheatsheet
- [5/5](#55) — AWS lab（Route Table）、AWS Glue
- [5/6](#56) — AWS Step Functions
- [5/7](#57) — SOLID 原則、DRY、KISS
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



### Code Review Standard

Code Review 的核心目標是確保程式碼品質、知識共享、及早發現缺陷。Review 時常見的檢查面向：

**可讀性與命名**
- 變數/函式命名是否清楚表達意圖（self-documenting）
- 是否有不必要的註解（好的程式碼本身就是文件）
- 函式長度是否合理（單一職責）

**設計原則**

#### SOLID 原則
| 原則 | 全名 | 說明 |
|---|---|---|
| S | Single Responsibility | 一個類別只負責一件事，只有一個改變的理由 |
| O | Open/Closed | 對擴展開放，對修改封閉（用抽象/介面擴展功能，不改既有程式碼）|
| L | Liskov Substitution | 子類別必須能替換父類別而不破壞程式行為 |
| I | Interface Segregation | 不應強迫實作用不到的介面方法，介面要小而專注 |
| D | Dependency Inversion | 高層模組不依賴低層模組，兩者都依賴抽象（介面）|

[Revisit SOLID](https://hackmd.io/@maxcian/revisit-solid)

#### DRY（Don't Repeat Yourself）
- 避免重複邏輯散落在多處，抽取共用函式或模組
- 注意：過度 DRY 反而會造成不必要的耦合，需要判斷重複是「巧合」還是「本質相同」

#### KISS（Keep It Simple, Stupid）
- 用最簡單的方式解決問題，避免過度設計（over-engineering）
- 如果一段程式碼需要大量註解才能理解，通常代表它太複雜了

**其他 Review 重點**
- 錯誤處理是否完善（edge case、null check）
- 是否有潛在的效能問題（N+1 query、不必要的迴圈）
- 安全性（SQL injection、XSS、敏感資訊外洩）
- 測試覆蓋率是否足夠

[Code Review 會注意哪些事？](https://ithelp.ithome.com.tw/articles/10278207)
[Guides for Design Review and Code Review](https://hackmd.io/@maxcian/guides-for-design-review-and-code-review)

### 文章閱讀
- [什麼是 POC（Proof of Concept）？軟體銷售中的概念驗證完整指南](https://realnewbie.com/posts/what-is-poc-proof-of-concept-complete-guide-to-concept-validation-in-software-sales)

- [淺入淺出 Dependency Injection](https://medium.com/wenchin-rolls-around/%E6%B7%BA%E5%85%A5%E6%B7%BA%E5%87%BA-dependency-injection-ea672ba033ca)
- [【問題分析與解決工具】第3篇：五個為什麼(5 Whys)分析法](https://medium.com/@lingchan2050/%E5%95%8F%E9%A1%8C%E5%88%86%E6%9E%90%E8%88%87%E8%A7%A3%E6%B1%BA%E5%B7%A5%E5%85%B7-%E7%AC%AC3%E7%AF%87-%E4%BA%94%E5%80%8B%E7%82%BA%E4%BB%80%E9%BA%BC-5-whys-%E5%88%86%E6%9E%90%E6%B3%95-6fe558f63161)
- [[面試][設計模式]Code Review 會注意哪些事？會依照什麼原則對程式做 Refactoring？0](https://ithelp.ithome.com.tw/articles/10278207)


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


> Notice!
[Tutorial Hell](https://www.linkedin.com/pulse/escaping-tutorial-hell-guide-progress-your-learning-journey-jatasra-dvdgf/)


<hr>

## 5/5

### AWS lab

錯題記錄：
Q：What is the primary purpose of a Route table in Amazon VPC?

A:

| Option | Correct answer | My selection | Rationale |
| --- | --- | --- | --- |
|A. To control network traffic between subnets || Selected | While Route tables influence traffiflow, they don't directly control traffic between subnets. This is primarily managed through NetworACLs and Security Groups. |
| B. To configure VPN connections ||| VPN connections are configured using Virtual Private Gatewayand Customer Gateways, not through Route tables. |
| C. To specify the allowed routes for outbound traffic leaving a subnet | Correct || A Route tablin Amazon VPC is used to determine where network traffic from your subnet or gateway is directed. Ispecifies the allowed routes for outbound traffic leaving a subnet. While the route table manageoutbound traffic, security groups on individual instances determine which inbound traffic iallowed. |
| D. To manage IP addresses for EC2 instances ||| IP addresses for EC2 instances are managed througsubnet configurations and DHCP options sets, not through Route tables.|


### AWS Glue
AWS Glue 是一款無伺服器資料整合服務，旨在簡化並自動化 ETL（擷取、轉換、載入）流程，讓從多個來源發現、準備及合併數據以進行分析與機器學習變得容易。

Why Use AWS Glue?
- 無伺服器與完全管理：無需伺服器配置、管理或擴展。您只需支付作業執行時所使用的資源，從而降低營運複雜度與成本。
- 自動資料發現（爬蟲）：膠水爬蟲掃描資料來源（如 S3、JDBC），自動推斷結構並填充中央膠水資料目錄，防止產生「資料沼澤」。
- 簡易 ETL 開發：提供視覺化（Glue Studio）及程式碼化（Python/Scala）工具，快速建立 ETL 管線，並支援 AI 程式碼生成。
- 無縫 AWS 整合：原生支援 AWS 服務，如 Amazon S3、Amazon Redshift、Amazon Athena 及 Amazon EMR。
- 彈性資料處理引擎：支援 Apache Spark 進行大規模批次/串流，Ray 用於 Python 工作負載，Python Shell 用於較小的腳本任務。


## 5/6

### AWS Step Functions
**What is Step Function**
AWS Step Functions是一種無伺服器的協調器，可以透過視覺化的方式來建立及執行一連串的檢查點及應用程式(可以是Lambda或AWS Service)，簡化步驟型的應用開發複雜度。

它透過狀態機 (State Machine) 概念，以 JSON 格式的 Amazon States Language (ASL) 定義執行步驟，無需自行管理故障、重試機制或服務間的並行邏輯。


- **視覺化工作流程：** 在 AWS 管理主控台中，Step Functions 能自動繪製流程圖，直觀顯示任務順序、狀態切換、成功與失敗路徑。
- **狀態機器 (State Machine)：** 應用程式由一連串的「狀態」組成，包括任務 (Task)、選擇 (Choice)、等待 (Wait)、並行 (Parallel) 等，可將複雜的應用程序邏輯拆分為簡單的步驟。
- **無伺服器整合：** 深度整合 AWS 服務，例如：觸發一個 AWS Lambda 函數進行資料處理，根據結果利用 Amazon SNS 發送通知，完全不用配置伺服器。
- **高可靠性與自動化：** 自動處理錯誤與重試機制。若任務失敗，Step Functions 可執行自定義的錯誤處理路徑，確保應用程式健壯。

<hr>

## 5/7

### SOLID 原則深入理解

SOLID 是物件導向設計的五大原則，目的是讓程式碼更容易維護、擴展和測試。

#### S — Single Responsibility Principle（單一職責原則）

一個類別應該只有一個改變的理由。

```python
# Bad: 一個類別做太多事
class UserService:
    def create_user(self, data):
        # 建立使用者
        pass
    def send_email(self, user):
        # 寄信
        pass
    def generate_report(self, user):
        # 產報表
        pass

# Good: 各司其職
class UserService:
    def create_user(self, data):
        pass

class EmailService:
    def send_email(self, user):
        pass

class ReportService:
    def generate_report(self, user):
        pass
```

#### O — Open/Closed Principle（開放封閉原則）

對擴展開放，對修改封閉。新增功能時不應修改既有程式碼，而是透過擴展（繼承、介面）來實現。

```python
# Bad: 每新增一種折扣就要改這個函式
def calculate_discount(order_type, amount):
    if order_type == "vip":
        return amount * 0.8
    elif order_type == "student":
        return amount * 0.9

# Good: 用多型擴展
class DiscountStrategy:
    def calculate(self, amount):
        raise NotImplementedError

class VIPDiscount(DiscountStrategy):
    def calculate(self, amount):
        return amount * 0.8

class StudentDiscount(DiscountStrategy):
    def calculate(self, amount):
        return amount * 0.9
```

#### D — Dependency Inversion Principle（依賴反轉原則）

高層模組不應依賴低層模組，兩者都應依賴抽象。這也是 Dependency Injection（依賴注入）的理論基礎。

```python
# Bad: 直接依賴具體實作
class OrderService:
    def __init__(self):
        self.db = MySQLDatabase()  # 綁死 MySQL

# Good: 依賴抽象介面
class OrderService:
    def __init__(self, db: DatabaseInterface):
        self.db = db  # 可以注入任何實作了 DatabaseInterface 的物件
```

### DRY vs WET

| 原則 | 說明 |
|---|---|
| DRY (Don't Repeat Yourself) | 每一段知識在系統中只有一個明確的表示 |
| WET (Write Everything Twice) | 有時候適度重複比過度抽象更好 |

判斷是否該抽取共用：
- 重複出現 3 次以上（Rule of Three）
- 重複的邏輯是「本質相同」而非「巧合相似」
- 抽取後不會造成不自然的耦合

### KISS 與 YAGNI

- **KISS（Keep It Simple, Stupid）**：用最簡單的方式解決當前問題
- **YAGNI（You Aren't Gonna Need It）**：不要為了「未來可能需要」而提前設計

```python
# Bad: 過度設計，目前只需要一種通知方式
class NotificationFactory:
    def create(self, type, strategy, config, ...):
        ...

# Good: 先做最簡單的版本，需要時再重構
def send_slack_notification(message):
    slack_client.post(channel, message)
```

### 英單
```
- scalability: 可擴展性
- coupling: 耦合（模組之間的依賴程度）
- cohesion: 內聚（模組內部元素的相關程度）
- idempotent: 冪等（重複執行結果相同）
```


