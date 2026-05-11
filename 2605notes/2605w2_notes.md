# 2026/05 week2學習筆記

> 用來記錄每日學習的內容，先瞭解基礎，每週末回頭 review 做延伸補充

## 目錄

- [5/11](#511) — 
- [5/12](#512) — 
- [5/13]() — 
- [5/14]() - 
- [5/15]() - 
---

## 5/11


### IO bound CPU bound

### Traceroute

#### SAA course quiz review
```
Question 10:
You're planning to migrate on-premises applications to AWS. Your company has strict compliance requirements that require your applications to run on dedicated servers. You also need to use your own server-bound software license to reduce costs. Which EC2 Purchasing Option is suitable for you?

A: Dedicated Hosts.
because they provide dedicated servers, which are essential for meeting strict compliance requirements and allow you to use your own server-bound software licenses, helping to manage costs effectively. This option is ideal for your needs since it aligns perfectly with your company’s requirements for compliance and licensing.
```

### ENI（Elastic Network Interface）彈性網路介面
可以理解成虛擬網卡

用途： EC2虛擬機可掛載一個或多個ENI，支援雙主機環境或作為高可用性故障轉移策略。

### EIP (Elastic IP)彈性公網IP
用途:
Instance停止或替換，EIP仍保持不變，可快速將公網存取重新映射到另一個Instance。

一個帳號能有五個 彈性IP運用（更多要問）
SAA課程提到不建議使用 -> 反而是用隨機public IP並指定DNS，或是使用Load Balancer 不用public IP

### AWS RDS(Relational Database Service) 關聯式資料庫服務
支援類型：

- PostgreSQL
- MySQL
- MariaDB
- Oracle
- Microsoft SQL Server
- Amazon Aurora

### 資料shuffle




#### 文章閱讀
- [ETL 是什麼？資料倉儲、OLTP 與 OLAP 一次搞懂](https://realnewbie.com/posts/what-is-etl-understanding-data-warehousing-oltp-and-olap)
- [AWS Glue v.s. AWS Lambda](https://datadrivenai.wordpress.com/2019/10/21/aws-glue-v-s-lambda/)



### 英單
```
- on-premises: 本地
- BI (Business Intelligence): 商業智慧
```

