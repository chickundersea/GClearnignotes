# AWS 學習與實作筆記

> 用來整理 AWS 服務觀念、實際應用方式、操作步驟、踩坑紀錄與成本思維。

---

## 1. 簡介區

### 1.1 學習目標
- 了解 AWS 核心服務的用途與彼此關係
- 能依需求選出合適的服務組合
- 能完成常見架構的實作與部署
- 建立成本、權限、安全與維運的基本觀念

### 1.2 目前學習狀態
| 項目 | 狀態 | 備註 |
| --- | --- | --- |
| 核心概念 | 學習中 | 已完成 S3 第一版整理 |
| 常用服務 | 學習中 | S3 已整理，其他待補 |
| 實作案例 | 學習中 | 已新增靜態網站部署案例 |
| 維運與監控 | 未開始 | |
| 成本管理 | 未開始 | |

### 1.3 AWS 全貌速覽
- 運算：EC2、Lambda、ECS、EKS、Elastic Beanstalk
- 儲存：S3、EBS、EFS、Glacier
- 資料庫：RDS、DynamoDB、Aurora、ElastiCache
- 網路：VPC、Route 53、CloudFront、API Gateway、ELB
- 安全：IAM、KMS、WAF、Shield、Secrets Manager
- 監控與維運：CloudWatch、CloudTrail、Config、Systems Manager

### 1.4 常用術語
| 術語 | 說明 |
| --- | --- |
| Region | AWS 資源部署的地理區域 |
| Availability Zone | 區域內的獨立機房群 |
| IAM | 權限管理服務 |
| Scalability | 可隨流量調整資源的能力 |
| High Availability | 系統高可用設計能力 |
| Fault Tolerance | 容錯能力 |

---

## 2. 服務介紹區

> 這一區用來記錄各服務的用途、重點設定、限制與實務觀察。每新增一個服務，就複製同樣模板。

### 2.1 運算服務

#### EC2
**服務定位**
- 用途：
- 適合場景：
- 不適合場景：

**核心概念**
- Instance Type：
- AMI：
- Security Group：
- Key Pair：

**常見操作**
- 建立執行個體：
- 綁定安全群組：
- 設定彈性 IP：
- 查看系統狀態：

**限制與注意事項**
- 

**成本觀察**
- 計費方式：
- 可優化方式：

**實務筆記**
- 

#### Lambda
**服務定位**
- 用途：
- 適合場景：
- 不適合場景：

**核心概念**
- Trigger：
- Runtime：
- Timeout：
- Concurrency：

**常見操作**
- 建立函式：
- 綁定事件來源：
- 部署版本：

**限制與注意事項**
- 

**成本觀察**
- 

**實務筆記**
- 

### 2.2 儲存服務

#### S3
**服務定位**
- 用途：物件儲存
- 適合場景：靜態網站、檔案備份、資料湖
- 不適合場景：需要傳統檔案系統即時掛載的情境

**核心概念**
- Bucket：S3 的容器，名稱需全域唯一，且建議依環境拆分（dev/staging/prod）
- Object：實際檔案本體，包含 Key、Metadata、Version
- Storage Class：依存取頻率選擇（Standard、Standard-IA、Glacier 等）
- Bucket Policy：以資源為中心的權限控管，常搭配 IAM policy 使用
- Lifecycle：自動搬移或刪除舊資料，常用於備份與封存降本

**常見操作**
- 建立 Bucket：選擇就近 Region，關閉不必要公開存取
- 上傳檔案：確認 MIME type 正確（例如 text/css、application/javascript）
- 啟用靜態網站託管：設定 Index document（index.html）與 Error document（error.html）
- 設定公開/私有權限：優先走 CloudFront + OAC，不建議直接 Public Bucket

**限制與注意事項**
- Bucket 名稱需全域唯一
- 權限設定錯誤容易造成資料外洩
- S3 具最終一致性考量的歷史脈絡，設計上仍應避免強依賴即時覆寫可見性
- 不適合作為一般 Linux 檔案系統掛載替代品（該需求更接近 EFS）

**成本觀察**
- 儲存容量費用：按 GB/月計價，不同 Storage Class 價格差異大
- 請求次數費用：GET、PUT、LIST 都會影響成本，高頻小檔案要特別留意
- 資料傳輸費用：跨區與對外傳輸可能是主要成本來源之一

**實務筆記**
- 若要公開網站，優先用 CloudFront 當入口，S3 維持私有並用 OAC 授權
- 建議預設開啟 Versioning，避免誤刪或誤覆蓋檔案難以回復
- 可先用 Standard，觀察 2-4 週後再加 Lifecycle 降到 IA/Glacier

#### EBS
**服務定位**
- 用途：
- 適合場景：
- 不適合場景：

**核心概念**
- Volume Type：
- Snapshot：

**常見操作**
- 建立磁碟：
- 掛載到 EC2：
- 建立快照：

**限制與注意事項**
- 

**成本觀察**
- 

**實務筆記**
- 

### 2.3 資料庫服務

#### RDS
**服務定位**
- 用途：
- 適合場景：
- 不適合場景：

**核心概念**
- Engine：
- Multi-AZ：
- Read Replica：
- Backup：

**常見操作**
- 建立資料庫：
- 設定安全群組：
- 啟用自動備份：

**限制與注意事項**
- 

**成本觀察**
- 

**實務筆記**
- 

#### DynamoDB
**服務定位**
- 用途：
- 適合場景：
- 不適合場景：

**核心概念**
- Partition Key：
- Sort Key：
- On-Demand / Provisioned：

**常見操作**
- 建立資料表：
- 設定索引：
- 查詢資料：

**限制與注意事項**
- 

**成本觀察**
- 

**實務筆記**
- 

### 2.4 網路與傳輸服務

#### VPC
**服務定位**
- 用途：
- 適合場景：

**核心概念**
- Subnet：
- Route Table：
- Internet Gateway：
- NAT Gateway：
- NACL：

**常見操作**
- 建立 VPC：
- 切分公有/私有子網：
- 設定路由：

**限制與注意事項**
- 

**實務筆記**
- 

#### CloudFront
**服務定位**
- 用途：
- 適合場景：

**核心概念**
- Distribution：
- Origin：
- Cache Behavior：

**常見操作**
- 綁定 S3 或 ALB：
- 設定快取：
- 綁定 HTTPS：

**限制與注意事項**
- 

**實務筆記**
- 

### 2.5 安全與權限服務

#### IAM
**服務定位**
- 用途：管理使用者、角色與權限
- 適合場景：所有 AWS 資源權限控制

**核心概念**
- User：可以是一個人或應用程式，會擁有一組登入用的帳密各別管理 group：多個 user 的集合，用來分類管理權限，例如部門或專案區分
- Group：使用者的集合，指派進groups的user都會帶上group permission
- Role：代表一個身份或服務，不需要登入，可以指定權限，例如指定S3可以訪問哪些資源
- Policy：JSON格式定義具體規範誰能做什麼事在什麼資源上
- Least Privilege(最低權限原則)：一種資訊安全概念，指將用戶、程式或系統的權限限制在僅能執行其工作所需的「最低限度」。此原則旨在降低因帳戶被竊、內部威脅或軟體漏洞導致的資訊外洩風險，限制攻擊者在系統中的橫向移動能力，是零信任（Zero Trust）架構的關鍵要素。

**常見操作**
- 建立使用者：建立使用者的目的是為人員或應用程式提供專屬的操作身分。
根據 AWS 的最佳實務，強烈建議人類使用者應透過身分提供者進行聯合驗證（Federation），並利用 AWS IAM Identity Center 來集中管理存取權，以取得臨時安全憑證，而非直接在系統中建立帶有長期金鑰的傳統 IAM 使用者。

- 指派角色：IAM Roles 是一種帶有特定許可的身分，其最大特點是透過核發「臨時安全憑證」來授權，而非依賴長期的靜態金鑰。指派角色的核心操作是為該角色設定「信任政策（Trust policy）」。這是一份 JSON 格式的政策文件，明確定義了「哪一個主體（Principal）」可以被允許執行 sts:AssumeRole（代入角色）的動作。

- 套用政策：users 跟 roles 預設沒有任何存取權限，您必須透過建立並附加 JSON 格式的「政策（Policies）」文件來授予操作許可。
在實務流程中，可以先套用 AWS 預先建立的 AWS 受管政策（AWS managed policies） 來快速獲得職務所需的權限，接著再依循「最低權限原則」，撰寫專屬於使用情境的 客戶受管政策（Customer managed policies） 以進一步縮小權限範圍。這些policy會精確規範是否允許（Allow）或拒絕（Deny）對哪些資源（Resource）執行特定的動作（Action），甚至可加上嚴格的生效條件（Condition）

**限制與注意事項**
- 避免使用根帳號進行日常操作
- 權限過大會提高風險

**案例筆記**
- 針對運行在企業內部資料中心（On-premises）的伺服器，為什麼使用 IAM Roles Anywhere 會比管理長期 IAM 使用者存取金鑰（Access Keys）更具安全性？<br><br>
A: 利用現有的X.509憑證體系（PKI）交換暫時憑證（自動過期機制），消除了管理長期金鑰的風險<br><br>
- 為什麼在開發過程中進行權限測試時，AWS 建議優先使用 STS 工作階段政策（Session Policies）而非直接修改 IAM 角色的身分型政策？<br><br>
A:因為IAM


**SAA考古題**





### 2.6 監控與維運服務

#### CloudWatch
**服務定位**
- 用途：監控資源、收集指標與建立告警

**核心概念**
- Metrics：
- Logs：
- Alarm：
- Dashboard：

**常見操作**
- 建立告警：
- 查看日誌：
- 追蹤錯誤率：

**限制與注意事項**
- 

**實務筆記**
- 

---

## 3. 實際應用區塊

> 這一區記錄真實使用情境，不只寫服務名稱，也記錄為什麼這樣設計、怎麼驗證是否成功。

### 3.1 案例模板

#### 案例名稱
**目標**
- 

**使用服務**
- 

**架構說明**
- 使用者請求如何進來：
- 資料如何流動：
- 哪些元件負責安全與監控：

**實作步驟**
1. 
2. 
3. 

**驗證方式**
- 

**問題與排查**
- 問題：
- 原因：
- 解法：

**成本觀察**
- 

**可重用結論**
- 

### 3.2 常見應用情境

#### 靜態網站部署
- 可用服務：S3、CloudFront、Route 53、ACM
- 想理解的重點：公開存取、CDN、HTTPS、網域綁定

### 3.3 實作案例：S3 + CloudFront 靜態網站部署

**目標**
- 建立可用 HTTPS 存取的靜態網站
- 讓 S3 保持私有，透過 CloudFront 提供對外流量

**使用服務**
- S3
- CloudFront
- Route 53（選配，若要自訂網域）
- ACM（選配，若要 HTTPS 憑證）

**架構說明**
- 使用者請求如何進來：User -> CloudFront -> S3
- 資料如何流動：CloudFront 快取靜態檔案，未命中時回源到 S3
- 哪些元件負責安全與監控：CloudFront + OAC 控制存取，CloudWatch 監看錯誤率

**實作步驟**
1. 建立 S3 Bucket，保持 Block Public Access 開啟，上傳 index.html 與靜態資源。
2. 建立 CloudFront Distribution，Origin 指向 S3，並建立 OAC。
3. 更新 S3 Bucket Policy，只允許指定 CloudFront Distribution 存取物件。
4. 在 CloudFront 設定 Default Root Object 為 index.html。
5. 若有自訂網域：在 ACM 申請憑證並綁定 CloudFront，Route 53 建立 A/AAAA Alias。
6. 部署後執行失效（Invalidation），確保使用者看到最新內容。

**驗證方式**
- 使用 CloudFront 網域可正常開啟首頁與子頁面
- 確認 S3 物件 URL 直接存取會被拒絕（AccessDenied）
- 使用瀏覽器 DevTools 檢查快取命中與回應標頭

**問題與排查**
- 問題：刷新子路由出現 403/404
- 原因：S3 靜態網站與 SPA 路由設定不一致
- 解法：CloudFront 自訂 Error Response 導回 /index.html

**成本觀察**
- 小流量情境通常成本低，主要來自 CloudFront 請求與對外傳輸
- 若圖片很多，先壓縮與長快取可有效降低流量費

**可重用結論**
- 靜態內容優先選 S3 + CloudFront，安全性與效能兼顧
- 先求可用，再做快取策略與版本管理優化

#### 動態網站後端
- 可用服務：EC2、RDS、ALB、Auto Scaling、CloudWatch
- 想理解的重點：高可用、擴展性、資料庫連線、安全群組

#### Serverless API
- 可用服務：API Gateway、Lambda、DynamoDB、CloudWatch
- 想理解的重點：事件驅動、無伺服器架構、請求流程

#### 檔案備份與封存
- 可用服務：S3、S3 Glacier、Lifecycle、IAM
- 想理解的重點：版本控制、生命週期、成本最佳化

#### 日誌蒐集與監控
- 可用服務：CloudWatch、CloudTrail、SNS、Lambda
- 想理解的重點：事件追蹤、告警、自動處理流程

---

## 4. 維運與安全區

### 4.1 權限管理重點
- 是否遵守最小權限原則
- 是否避免使用根帳號
- 是否啟用 MFA
- 是否針對服務建立專用 Role

### 4.2 監控與告警
- 哪些指標需要監控
- 哪些異常要即時通知
- 是否建立 Dashboard 追蹤關鍵系統狀態

### 4.3 成本管理
- 哪些服務是主要花費來源
- 是否有閒置資源
- 是否能改用較低成本方案
- 是否設定 Budget 告警

### 4.4 常見錯誤紀錄
| 問題 | 原因 | 解法 | 下次如何避免 |
| --- | --- | --- | --- |
| | | | |

---

## 5. 複習與追蹤區

### 5.1 本週新增
- 完成 S3 服務第一版筆記（定位、概念、操作、成本、踩坑）
- 新增「S3 + CloudFront 靜態網站部署」實作案例

### 5.2 待補強主題
- CloudFront 快取策略與 Invalidation 成本平衡
- Route 53 路由政策（Simple、Weighted、Latency）
- IAM policy 最小權限實作範例

### 5.3 常考或常用重點
- IAM 的 Role 與 Policy 差異
- S3、EBS、EFS 的使用差異
- RDS 與 DynamoDB 的選型思路
- Public Subnet 與 Private Subnet 的差異

### 5.4 下週學習計畫
- 

### 5.5 快速索引
| 主題 | 是否已整理 | 備註 |
| --- | --- | --- |
| EC2 | 否 | |
| S3 | 是 | 已完成第一版 |
| IAM | 否 | |
| VPC | 否 | |
| RDS | 否 | |
| Lambda | 否 | |
| CloudWatch | 否 | |

---

## 6. 使用規則

- 每學一個服務，就先補「服務定位」與「核心概念」
- 每做一個實作，就補「實際應用區塊」的案例紀錄
- 每遇到問題，就補到「常見錯誤紀錄」
- 每週至少更新一次「本週新增」與「下週學習計畫」
- 盡量用自己的話寫，避免只貼官方文件內容
