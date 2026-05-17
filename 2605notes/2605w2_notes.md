# 2026/05 week2學習筆記

> 用來記錄每日學習的內容，先瞭解基礎，每週末回頭 review 做延伸補充

## 目錄

- [5/11](#511) — IO bound/CPU bound、Traceroute、ENI、EIP、RDS、資料shuffle
- [5/12](#512) — S3 lab實作、Partition、SSH
- [5/13](#513) — MSCK REPAIR TABLE、Amazon QuickSight、DNS/HTTPS challenge、抽象化
- [5/14](#514) — Git LFS、Terraform 核心概念、宣告式 vs 命令式
- [5/15](#515) — MCP Gateway、Gemma、AI 相關概念
---

## 5/11


### IO bound vs CPU bound

程式效能瓶頸的兩種類型：

| | IO bound | CPU bound |
|---|---|---|
| 瓶頸 | I/O 操作（磁碟、網路、DB） | CPU 計算能力 |
| CPU 狀態 | 大多在等待（idle） | 持續高負載 |
| 範例 | 讀寫檔案、API 請求、DB query | 圖片處理、加密運算、ML 訓練 |
| 解法 | 非同步 I/O、多執行緒（threading）| 多行程（multiprocessing）、GPU |

- Python 的 GIL 限制：threading 在 CPU bound 場景幾乎無效，需用 `multiprocessing`；IO bound 場景 threading 有效因為等待期間會釋放 GIL

### Traceroute

網路診斷工具，追蹤封包從本機到目的地所經過的每一個路由節點（hop）。

```bash
traceroute google.com      # Linux / macOS
tracert google.com         # Windows
```

輸出欄位：`hop序號  延遲1  延遲2  延遲3  節點IP/hostname`

- 每個 hop 送出 3 個探測封包，顯示三次延遲
- `* * *` 表示該節點不回應（防火牆攔截或 ICMP 被封）
- 原理：透過遞增 TTL（Time To Live）值，讓每個中間路由器超時回 ICMP 訊息，藉此畫出完整路徑
- 用途：診斷網路延遲、找出封包在哪個節點開始異常

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

### 資料 Shuffle

在分散式資料處理（Spark、MapReduce）中，shuffle 是把資料**跨 partition / worker 重新分配**的過程。

- 觸發時機：`groupBy`、`join`、`orderBy`、`distinct` 等需要把相同 key 的資料集中到同一節點的操作
- 為什麼昂貴：需要跨網路傳輸大量資料，且涉及序列化/反序列化 → 是效能瓶頸的主要來源
- 最佳化方向：
  - 盡量在 shuffle 前先做 filter/projection 縮小資料量
  - 使用 `broadcast join` 把小表廣播出去避免大表 shuffle
  - 合理設定 partition 數量（Spark 預設 200，可調整 `spark.sql.shuffle.partitions`）

```
Map → [shuffle write] → 網路傳輸 → [shuffle read] → Reduce
```

#### 文章閱讀
- [ETL 是什麼？資料倉儲、OLTP 與 OLAP 一次搞懂](https://realnewbie.com/posts/what-is-etl-understanding-data-warehousing-oltp-and-olap)
- [AWS Glue v.s. AWS Lambda](https://datadrivenai.wordpress.com/2019/10/21/aws-glue-v-s-lambda/)



### 英單
```
- on-premises: 本地
- BI (Business Intelligence): 商業智慧
```

## 5/12

#### 實作筆記

##### **AWS skill builder  lab 實作： Introduction to Amazon Simple Storage Service (S3)** 		

- Create a bucket
- Upload an object to the bucket -> 重點：上傳的檔案預設為private
- Make an object public
- Test connectivity from the EC2 instance
- Create a bucket policy
	[Use policy generator](https://awspolicygen.s3.amazonaws.com/policygen.html) 產policy json
    - AWS Policy Generator: 使用 version control 服務 
    重點觀念：如果遇到相同檔名的檔案預設行為會overwrite 覆蓋掉舊檔 - >例如BP schedule generate 的帳單每次跑完都更新到最新一日的資料

##### BP
Q:4 月有出現一個 AWS Marketplace Service "Ubuntu 22.04 LTS - Jammy"，要請你們確認這個服務項目在 ETL 設定是不是給 "discount"，如果是的話要麻煩改成 "original"。
希望這週可以完成調整。
調整項目：
AWS Marketplace Service：Ubuntu 22.04 LTS - Jammy
計費方式：original (原價計費不折扣)
我看帳單顯示的計算方式應該是給 discount 的方式計費，不然帳單上方的費用總計應該要出現 "Non-Discount Service (USD)" 的欄位才對。
目前這個服務只有出現在 linked account 179170225193，FYI。

另外想請兩位順道確認目前 ETL 是如何判別 `Marketplace Service` 和 `Non-Discount Service` 的項目要用原價計費。

A:
ETL 在產出` marked_payer_billing_aio2` 時，會根據 CUR 原始資料的 `bill_billing_entity `欄位判斷：

`bill_billing_entity = 'AWS Marketplace'` → `calculation_logic = 'original'`（原價計費，不套折扣）

Lambda `billing-portal-production-generateReport`報表產生時，會依據 `calculation_logic` 欄位分類：

`'discount' → AWS Service (USD)`，套用折扣
`'original' → Non-Discount Service (USD)`，原價計費
`'private_price' → Private Price Service Fee (USD)`
這題 `Ubuntu 22.04 LTS - Jammy` 已正確標記為 original，但因原始費用為 $0.00，加總後` Non-Discount = $0`，就會因為
```py
if cost_detail['non_discount_service_fee'] > 0
```
被排除掉，所以沒有出現在帳單上。

### Partition

Partition原意就是分拆的意思，在資料的世界裡，就是把一份資料，分成許多小份。
分拆出來的多份資料，並沒有一定要分散到多台機器中，他們可以被分散到多處， 也能被放在同一台RDBMS裡的不同table， 也就是說partition並不是分散式資料庫(Distributed Database)的專利。

Partion的方式有兩種，分別為vertical及horizontal partition， 我們看資料的方式通常是使用表格的，也就是說有欄有列， vertical partition就是根據欄來做分拆，而horizontal partition是對列進行分拆。


### SSH
SSH（Secure Shell）是一種網路安全協議，它使用加密和認證機制來實現安全存取、檔案傳輸等服務。傳統的遠端登入和檔案傳輸方式，如：Telnet、FTP 等，都是以明文方式傳輸數據，不安全。隨著網路安全的重要性日益增加，這些方法逐漸變得不那麼被接受。 SSH 透過對網路資料進行加密和認證，在不安全的網路環境中提供安全的網路服務。作為 Telnet 和其他不安全的遠端 shell 協定的安全替代解決方案，SSH 協定已在世界各地廣泛使用，當今大多數設備都支援 SSH。預設情況下，SSH 伺服器使用連接埠 22。

- WHY: 在傳統的網路通訊中，資料以明文形式傳輸。數據一旦被截獲，就完全暴露，極不安全。 SSH 使用客戶端伺服器模型來驗證兩方身分並加密它們之間交換的資料。它提供了一個安全的傳輸通道，用於在不安全的網路上安全地運行網路服務。

##### SSH 金鑰管理        

- `ls -al ~/.ssh`
列出本機目前所有 SSH key

- `ssh-keygen`
產生 SSH 金鑰對，預設使用 RSA 演算法，金鑰長度為 2048 位元。

- `ssh-keygen -b 4096`
產生 SSH 金鑰對，指定金鑰長度為 4096 位元。

- `ssh-keygen -p`
修改或移除私鑰的密碼。

-`ssh-keygen -l`
顯示 SSH 金鑰的指紋。




<hr>

## 5/13

### MSCK REPAIR TABLE
一個SQL 指令用來掃描檔案系統（例如 Amazon S3）以尋找在建立表格後新增至檔案系統的 Hive 相容分割區。

Use the MSCK REPAIR TABLE command to update the metadata in the catalog after you add Hive compatible partitions.

[MSCK REPAIR TABLE ](https://docs.aws.amazon.com/athena/latest/ug/msck-repair-table.html)



### Amazon Quick Suite
from DS conference

類似GenBI 有quick sight & Analytics 

可以做Quick Research ： 產出像論文深度的報告

內建 Chat agent 可以自己自訂  




### DNS challenge vs HTTPS challenge

SSL/TLS 憑證申請（如 Let's Encrypt）時，CA 需要驗證你真的擁有該域名，有兩種驗證方式：

**HTTP challenge（也叫 HTTPS challenge）**
- CA 要求你在 `http://yourdomain.com/.well-known/acme-challenge/<token>` 路徑放置一個特定驗證文件
- CA 去 HTTP 存取這個 URL，確認文件內容正確 → 驗證通過
- 限制：server 必須能被外部存取（port 80 要開），不適合 wildcard 憑證

**DNS challenge**
- CA 要求你在域名的 DNS 記錄中新增一筆 TXT record：`_acme-challenge.yourdomain.com = <token值>`
- CA 查 DNS 確認 TXT 記錄存在 → 驗證通過
- 優點：不需要 server 對外開放，可以申請 wildcard 憑證（`*.yourdomain.com`）
- 缺點：需要有 DNS 管理權限，部分 DNS propagation 需等待幾分鐘


### 英單

```
- deprecated: 棄用、已過時。指功能雖然還存在但官方不建議使用，未來版本可能移除
- chunks: 塊、段。資料處理中指把大資料切成一段一段處理（chunked processing）
```


#### Midest notes

##### 抽象化
是一種思維或設計過程，核心在於「省略具體細節，提取共同特徵，以擴大適用範圍」。它將複雜的事物簡化為核心概念，隱藏實現細節，使人們能專注於核心邏輯。
- 定義： 縮減概念或現象的資訊含量，僅保存關鍵屬性以實現廣義化。
- 目的： 減少複雜度，提高可讀性、重用性與專注度。
[抽象化是什麼？淺談概念轉換跟降低相依性的程式哲學](https://surreal.tw/program/soul/program-abstraction)

描述事實、假設問題、驗證問題

**怎麼建立假設？**
1. 觀察現象：先描述你看到的事實（可量測、可重現）
2. 區分已知/未知：已知的是直接觀察或有數據支撐的；未知的是需要進一步確認的
3. 提出可驗證的假設：用「若 A，則 B」的格式，確保假設是**可被反駁**的
4. 設計驗證方式：用實驗、查 log、對比數據等方式來確認或推翻假設
5. 結論更新：驗證後，把假設更新成事實或排除

區分事實 vs 假設：
- 事實：「帳單上沒有出現 Non-Discount 欄位」（可觀察）
- 假設：「可能是因為費用為 $0 被條件排除」（需驗證）
- 觀點：「這個設計不好」（主觀，需要更多具體標準）

已知跟未知的框架，適合用來拆解 debug 或分析問題的思路。



## 5/14

### Git LFS（Large File Storage）

Git 本身不擅長處理大型 binary 檔案（影片、圖片、ML 模型、zip 等），每次 commit 都會把完整檔案存進 `.git`，讓 repo 越來越肥。

**Git LFS 的解法：**
- 把大型檔案的實際內容存到 LFS 伺服器（GitHub/GitLab 都有提供）
- 在 repo 中只留一個輕量的「指針文件」（pointer file），記錄檔案的 hash 和大小
- `git clone` 時預設只拉指針，實際檔案按需下載

```bash
git lfs install                    # 啟用 LFS
git lfs track "*.bin" "*.pth"     # 指定要追蹤的 binary 類型（寫入 .gitattributes）
git add .gitattributes
git add model.bin                 # 之後的操作跟一般 git 相同
git commit -m "add model"
```

- binary 檔案（如 `.pkl`, `.pth`, `.bin`, `.zip`）不適合 diff，應用 LFS 或直接用 S3/DVC 管理

---

### Terraform 核心概念

**初始化**
```bash
terraform init
```
- 下載 provider plugins（如 `hashicorp/aws`）
- 建立 `.terraform/` 資料夾存放 provider 二進位檔
- 讀取 backend 設定，連接遠端 state

**State（狀態）**
```
terraform(IaC) <-- state --> AWS 實際資源
```
- `terraform.tfstate`：記錄 Terraform 管理的所有資源的當前狀態（JSON 格式）
- 每次 `apply` 後，Terraform 會更新 state 以反映最新的 AWS 資源狀態
- Terraform 透過比對 `.tf` 設定檔 vs state vs AWS 實際狀態，決定要新增/修改/刪除什麼

**State vs Backend**
- **State**：資料本身（紀錄資源的 attribute）
- **Backend**：state 存放的位置（local 預設存 `terraform.tfstate`；遠端可存 S3 + DynamoDB 做 lock）
- 兩者一體兩面：backend 決定 state 存哪、怎麼鎖定

**常用指令補充**
```bash
terraform apply -target=aws_instance.web  # 只對特定資源 apply
terraform state rm aws_instance.web       # 從 state 移除（不刪 AWS 資源），下次 apply 排除

# output 敏感值
output "db_password" {
  value     = aws_db_instance.main.password
  sensitive = true   # 不會顯示在 log，但 state 中仍明文存在
}
terraform output db_password   # 明確查詢才顯示
```

**race condition（競態條件）**
- 多人同時執行 `terraform apply`，同時讀到相同的 state，各自計算 diff 後都去修改 AWS 資源 → 造成衝突
- 解法：用 DynamoDB 做 state locking，`apply` 時先取得 lock，完成後釋放，其他人要等待

**`du` — disk usage**
```bash
du -sh .          # 顯示當前目錄總大小（human-readable）
du -sh *          # 顯示每個子目錄/檔案的大小
du -sh .terraform # 查看 terraform plugin 占用多少空間
```

### 宣告式（Declarative）vs 命令式（Imperative）

| | 宣告式 | 命令式 |
|---|---|---|
| 描述方式 | 描述「**要什麼結果**」| 描述「**怎麼一步步做到**」|
| 例子 | Terraform `.tf`、K8s YAML、SQL | Bash script、Python 程式碼流程 |
| 由誰決定怎麼做 | 工具/runtime 自行決定 | 開發者明確指定每一步 |
| 優點 | 可讀性高、冪等性強 | 控制細節能力強 |

- Terraform 是宣告式：你寫「我要一台 t3.micro EC2」，Terraform 決定怎麼 API call 建出來
- 好處：重複執行結果相同（冪等），不用擔心狀態殘留


## 5/15
 
### MCP Gateway

MCP（Model Context Protocol）是 Anthropic 提出的開放協議，讓 AI 模型可以標準化地連接外部工具和資料來源。

**MCP Gateway** 的概念：
- 作為 AI model 和多個 MCP Server 之間的統一入口（gateway）
- 類似 API Gateway，負責路由、認證、管理多個工具的連線
- 讓一個 AI agent 可以同時使用資料庫查詢、外部 API、檔案系統等不同工具

```
AI Model
   ↕
MCP Gateway
   ├── MCP Server A（資料庫）
   ├── MCP Server B（GitHub）
   └── MCP Server C（Slack）
```

- 好處：解耦 AI model 和工具實作，工具可以獨立開發和替換

---

### Gemma（Google 開源 LLM）

- Google DeepMind 發布的開源大型語言模型系列
- **Open source**：權重公開，可本地部署、fine-tune、商業使用（部分版本）
- 對比 GPT / Claude 等 **closed source** 模型（不公開權重）

**Fine-tune（微調）**
- 在已預訓練的基礎模型上，用特定領域資料繼續訓練，讓模型在特定任務表現更好
- 比從頭訓練省資源，適合特定領域（醫療、法律、客服）的客製化需求
- 常見方法：Full fine-tuning、LoRA（低秩適應，只調整少量參數，更省記憶體）

---

### 其他關鍵概念

**Quota（配額）**
- API 或雲端服務對使用量設定的上限，如：每分鐘請求數（RPM）、每日 token 數
- 超過 quota 會收到 `429 Too Many Requests` 錯誤
- 可向服務商申請提高 quota

**Sequence（序列）**
- 在 ML/NLP 中，sequence 指有順序的資料，例如文字（token 序列）、時間序列
- Transformer 架構最初就是設計來處理 sequence to sequence 任務（如翻譯）

**Scenarios（情境/場景）**
- 測試或設計時定義的使用情境，描述「在什麼條件下，系統應該怎麼反應」
- 類似 BDD（行為驅動開發）中的 Given-When-Then 格式

**Wiring（連線配置）**
- 指不同系統元件之間的連接和整合設定
- 例如：把 MCP Server 接到 AI model、把 Lambda 接到 API Gateway，都算是 wiring
- 在軟體架構中，wiring 通常指依賴注入（dependency injection）或設定檔中定義的元件關係