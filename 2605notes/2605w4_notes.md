
# 2026/05 week3學習筆記

> 用來記錄每日學習的內容，先瞭解基礎，每週末回頭 review 做延伸補充

## 目錄

- [5/25](#525) — 強型別 vs 弱型別、顯式/隱式轉換、何時用 Any、git --amend
- [5/26](#526) — Walrus Operator、Pydantic、Discriminated Union、服務邊界、__future__、Race Condition、zstd、git rev-parse
- [5/27](#527) — linux file 指令、| grep、AWS Aurora Replica Auto-Scaling、docker build & up、AWS ALB
- [5/28](#528) — 
- [5/29](#529) — 



## 5/25

 ---
  強型別 vs 弱型別

  強型別（Python、TypeScript）：型別不會偷偷自動轉換，操作前必須明確。
  弱型別（JavaScript、PHP）："5" + 3 = "53" 或 8，語言自動猜你要什麼。

  ---
  顯式轉換 vs 隱式轉換

  # 隱式（Python 不做這個）
  x: int = "5"  # 型別錯誤

  # 顯式（你主動轉）
  x: int = int("5")  # 明確說我要轉

  我們在 router 做的正是顯式轉換：
  # Router 明確把 Pydantic DTO 轉成 domain dataclass
  TopicData(text=topic.text, category=topic.category, metadata=topic.metadata)

  ---
  何時收緊、何時放鬆型別

  放鬆（用 Any）的合理時機：

  # ✅ 合理 — 資料庫的 JSON 欄位，值真的可以是任何東西
  metadata: dict[str, Any] | None

  # ✅ 合理 — 泛用工具函式，設計上就是接受任意型別
  def log(value: Any) -> None: ...

  不該用 Any 的時機：

  # ❌ 我們本來的問題 — 其實知道結構，但用 Any 偷懶
  topics_data: list[dict[str, Any]]
  # value 裡面有 text: str, category: str | None，有明確結構，應該用 TopicData


### git --amend

amend（修正）
##### 用來修正「最近一次」的 commit，所以撰寫位置會在我們已經很熟的 git commit 之後:
```bash
git commit --amend
```
用來修正「最近一次」的 commit，所以撰寫位置會在我們已經很熟的 git commit 之後


##### 要更新最近一次 commit 的「標題訊息」，只要在 git commit --amend 之後，繼續接著寫 -m 加 要改的訊息 即可：
```zsh
git commit --amend -m "新的訊息"
```

>舉例來說：在 commit 一個版本之後，發現某個檔案 `console.log()` 沒刪到，或是某個排版看了不滿意，就可以用下列說明步驟來修改：

1.直接編輯要想修改的檔案。(此時檔案會處在 未暫存 的狀態)
2.使用 git add 把檔案加到暫存區。
```bash
git add "修改好的檔案"
```
3.執行這個指令：
```bash
git commit --amend --no-edit
# 這裡的 --no-edit 參數，用意是告訴 Git，這次的修改沒有要輸入訊息，這樣 Git 就不會跳出視窗要求我們修改訊息了。
```



## 5/26



### Walrus Operator 海象運算子

`:=` 是 Python 3.8 引入的語法，讓你在**表達式中同時賦值並使用該值**，減少重複計算或重複呼叫。

名稱由來：`:=` 長得像海象的眼睛和牙齒 🦭

```python
# ❌ 沒有 walrus — 要呼叫兩次或先存變數
data = get_data()
if data:
    process(data)

# ✅ 用 walrus — 賦值和判斷一行搞定
if (data := get_data()):
    process(data)
```

常見使用場景：

```python
# while loop 中避免重複呼叫
while (line := file.readline()) != "":
    process(line)

# list comprehension 中避免重複計算
results = [y for x in data if (y := expensive(x)) > threshold]
```

注意事項：
- 不能用在 `=` 可以用的所有地方（例如不能直接當 statement）
- 過度使用會降低可讀性，適合用在「計算一次、判斷一次、使用一次」的場景


### Pydantic

Python 的資料驗證與設定管理庫，核心功能是用 type annotation 自動驗證資料結構。

```python
from pydantic import BaseModel, Field

class UserRequest(BaseModel):
    name: str
    age: int = Field(ge=0, le=150)  # 限制範圍
    email: str | None = None        # 可選欄位

# 自動驗證 + 型別轉換
user = UserRequest(name="Uma", age="25", email=None)
# age 會自動從 str 轉成 int（coercion）

# 驗證失敗會拋 ValidationError
UserRequest(name="Uma", age=-1)  # ❌ ValidationError
```

核心概念：
- **BaseModel**：所有 DTO / schema 的基底類別
- **Field()**：加上額外驗證規則（ge、le、min_length、regex 等）
- **Coercion（強制轉換）**：Pydantic v2 預設會嘗試把 `"25"` 轉成 `25`
- **Serialization**：`.model_dump()` 轉 dict、`.model_dump_json()` 轉 JSON string

在 FastAPI 中的角色：
- Request body → Pydantic model 自動驗證
- Response model → 自動序列化 + 過濾欄位
- 搭配 `response_model` 可以控制 API 回傳的 schema


### Discriminated union

又叫 Tagged Union，是一種讓 Pydantic 能根據某個「標記欄位」自動判斷要用哪個 model 來解析資料的技巧。

```python
from pydantic import BaseModel, Field
from typing import Literal, Annotated, Union

class Cat(BaseModel):
    pet_type: Literal["cat"]
    meow_volume: int

class Dog(BaseModel):
    pet_type: Literal["dog"]
    bark_volume: int

# 用 Discriminator 告訴 Pydantic：看 pet_type 欄位來決定用哪個 model
Pet = Annotated[Union[Cat, Dog], Field(discriminator="pet_type")]

class Owner(BaseModel):
    pet: Pet

# Pydantic 看到 pet_type="cat" 就知道要用 Cat model
owner = Owner(pet={"pet_type": "cat", "meow_volume": 5})
```

為什麼需要：
- 沒有 discriminator 時，Pydantic 會逐一嘗試每個 Union 成員，效能差且錯誤訊息不明確
- 有 discriminator 時，直接看標記欄位就知道用哪個 model，O(1) 判斷

實際應用場景：
- API 接收不同類型的 event（`type: "message"` vs `type: "reaction"`）
- 多種 notification 格式共用同一個 endpoint


### 服務邊界

指在微服務架構中，每個服務「負責什麼」和「不負責什麼」的界線。

核心原則：
- 一個服務只負責一個 bounded context（限界上下文）
- 服務之間透過明確的 API contract 溝通，不共享資料庫
- 邊界內的邏輯可以自由重構，不影響其他服務

```
┌─────────────────┐     API call     ┌─────────────────┐
│  Conversation   │ ───────────────→ │     Memory      │
│    Service      │                  │    Service      │
│                 │                  │                 │
│ - 管理對話流程   │                  │ - 管理儲存/檢索  │
│ - 驗證 user     │                  │ - 向量搜尋      │
│ - 路由 request  │                  │ - 持久化        │
└─────────────────┘                  └─────────────────┘
```

判斷邊界的方法：
- 這個功能改動時，會不會影響到其他團隊？→ 會的話可能邊界畫錯了
- 這兩個功能的部署頻率一樣嗎？→ 不一樣的話適合拆開
- 資料的 ownership 屬於誰？→ 誰擁有資料，誰就是那個服務


### `__future__`

Python 的特殊模組，用來在舊版 Python 中啟用未來版本的語法特性。

```python
from __future__ import annotations
```

最常見的用途 — `annotations`（Python 3.7+）：
- 讓所有 type annotation 變成**延遲求值**（lazy evaluation）
- 解決「前向引用」問題：class 還沒定義完就要在 type hint 中引用自己

```python
from __future__ import annotations

class TreeNode:
    # 沒有 __future__ 的話，這裡 TreeNode 還沒定義完，會報 NameError
    def __init__(self, children: list[TreeNode]):
        self.children = children
```

其他效果：
- annotation 不會在 import 時被求值，減少 import 時間
- 所有 annotation 都變成字串，需要時才用 `typing.get_type_hints()` 解析
- Python 3.12+ 已經預設這個行為，不需要再 import


### Race condition 競態條件

多個 process / thread / request 同時存取共享資源，因為執行順序不確定，導致結果不可預期。

```
Thread A: 讀取餘額 = 100
Thread B: 讀取餘額 = 100
Thread A: 餘額 - 50 = 50，寫回
Thread B: 餘額 - 30 = 70，寫回   ← 覆蓋了 A 的結果！
# 正確應該是 100 - 50 - 30 = 20
```

常見場景：
- 資料庫：兩個 request 同時更新同一筆資料
- Terraform：多人同時 `apply`，各自讀到相同 state
- 檔案系統：多個 process 同時寫同一個 log 檔

解法：
- **Lock（鎖）**：一次只讓一個人操作（mutex、DynamoDB lock）
- **Optimistic locking**：讀取時記版本號，寫入時檢查版本是否被改過
- **Atomic operation**：用資料庫的 `UPDATE ... WHERE` 或 Redis 的 `INCR` 確保操作不可分割
- **Queue**：把並發請求排隊，依序處理


### zstd 檔

Zstandard（zstd）是 Facebook 開發的壓縮演算法/格式，副檔名為 `.zst` 或 `.zstd`。

特點：
- 壓縮/解壓速度極快（比 gzip 快很多），壓縮率接近甚至超過 gzip
- 支援字典壓縮（dictionary compression）：對小檔案特別有效
- 廣泛用於：Linux kernel、Docker image layer、資料庫備份、log 壓縮

```bash
# 壓縮
zstd file.tar           # 產生 file.tar.zst

# 解壓
zstd -d file.tar.zst    # 或 unzstd file.tar.zst

# 指定壓縮等級（1-19，預設 3）
zstd -9 file.tar        # 更高壓縮率，但更慢
```

vs 其他格式：
| 格式 | 壓縮率 | 速度 | 常見用途 |
|------|--------|------|----------|
| gzip | 中 | 中 | 通用、HTTP 壓縮 |
| zstd | 中高 | 快 | Docker、DB backup |
| xz | 高 | 慢 | 軟體發布包 |
| lz4 | 低 | 極快 | 即時壓縮、記憶體 |


### git rev-parse

Git 的底層工具指令，用來把各種 Git 引用（branch name、HEAD、tag）解析成實際的 commit SHA。

```bash
# 取得當前 HEAD 的完整 SHA
git rev-parse HEAD
# 輸出: a1b2c3d4e5f6...（40 字元）

# 取得短 SHA
git rev-parse --short HEAD
# 輸出: a1b2c3d

# 取得當前 branch 名稱
git rev-parse --abbrev-ref HEAD
# 輸出: feature/my-branch

# 取得 repo 的根目錄路徑
git rev-parse --show-toplevel
# 輸出: /Users/umacheng/projects/my-repo

# 確認是否在 git repo 裡
git rev-parse --is-inside-work-tree
# 輸出: true
```

常見用途：
- CI/CD 中取得 commit SHA 作為 image tag：`docker build -t app:$(git rev-parse --short HEAD) .`
- Script 中判斷當前 branch 來決定部署環境
- 驗證某個引用是否存在：`git rev-parse --verify feature/xxx`


### 英單

```
- Citations: 引用、引文。學術或文件中標註資料來源的標記
- Annotations: 註解、標註。程式碼中的 metadata 標記（如 Python type annotation、Java @Override）
```



## 5/27



### linux 指令 file
#### file

`file` 指令用來判斷檔案的**實際類型**，不是看副檔名，而是讀取檔案內容的 magic bytes 來判斷。

```bash
file document.pdf
# 輸出: document.pdf: PDF document, version 1.4

file mystery_file
# 輸出: mystery_file: ELF 64-bit LSB executable（Linux 執行檔）

file image.png
# 輸出: image.png: PNG image data, 1920 x 1080, 8-bit/color RGBA

file script.sh
# 輸出: script.sh: Bourne-Again shell script, ASCII text executable
```

實用場景：
- 檔案沒有副檔名時，判斷它到底是什麼
- 確認 Git LFS pointer 是否已被替換成實際檔案（pointer 會顯示 `ASCII text`，實際檔案會顯示正確格式）
- 確認下載的檔案是否完整（損壞的檔案可能顯示 `data`）

#### | grep

Pipe（`|`）把前一個指令的輸出，當作下一個指令的輸入。搭配 `grep` 可以從大量輸出中篩選特定內容。

```bash
# 從 file 指令的輸出中篩選特定類型
file * | grep "ASCII text"
# 只顯示純文字檔案

# 找出哪些 .tar.gz 其實是 LFS pointer（不是真正的壓縮檔）
file *.tar.gz | grep "ASCII"
# 如果顯示 ASCII text 代表是 LFS pointer，沒有真正拉到檔案

# 搭配其他指令
ps aux | grep python        # 找正在跑的 python process
env | grep AWS              # 查看 AWS 相關環境變數
docker image ls | grep migration  # 找 migration 相關的 image
```



### AWS Aurora

Amazon Aurora 是 AWS 自研的雲端關聯式資料庫，相容 MySQL 和 PostgreSQL，效能是標準 MySQL 的 5 倍、PostgreSQL 的 3 倍。

核心架構：
- 儲存層與計算層分離：storage 自動擴展，最大 128 TB
- 資料自動複製 6 份，分散在 3 個 AZ
- 寫入只需 4/6 份確認（quorum write），讀取只需 3/6

#### Replica Auto-Scaling

Aurora 支援自動擴展 Read Replica 的數量，根據負載動態增減。

```
                    ┌── Reader 1 (固定)
Writer ──→ Storage ─┼── Reader 2 (固定)
                    ├── Reader 3 (auto-scaled) ← 流量大時自動加
                    └── Reader 4 (auto-scaled) ← 流量大時自動加
```

設定方式：
- 透過 Application Auto Scaling 設定 scaling policy
- 指標可以用：CPU utilization、connections 數量、自訂 CloudWatch metric
- 設定最小/最大 replica 數量（例如 min=1, max=15）

```
Auto Scaling Policy:
- Target metric: CPU > 70%
- Min replicas: 1
- Max replicas: 15
- Scale-out cooldown: 300s
- Scale-in cooldown: 300s
```

搭配 Aurora 的 Reader Endpoint：
- Aurora 提供一個 reader endpoint，自動 load balance 到所有 read replica
- 新增的 replica 會自動加入 reader endpoint，不需要改 application 設定

vs EC2 Auto Scaling：
- EC2 ASG 是擴展整台機器
- Aurora Replica Auto Scaling 是擴展資料庫的讀取節點
- 概念類似，都是根據 metric 動態調整資源數量



### docker build & docker up

兩個不同階段的指令，常搭配使用：

**docker build** — 建立 image

```bash
docker build -t my-app:latest .
# -t: 指定 image 名稱和 tag
# .: 指定 Dockerfile 所在的 context 目錄

# 指定 Dockerfile
docker build -f Dockerfile.prod -t my-app:prod .

# 不使用 cache（確保完全重建）
docker build --no-cache -t my-app:latest .
```

**docker compose up**（舊版是 `docker-compose up`）— 啟動多個 container

```bash
docker compose up          # 前景執行，看得到 log
docker compose up -d       # 背景執行（detached）
docker compose up --build  # 先 build 再 up（確保用最新 image）
```

在  專案中的流程：
```bash
make docker-build    # 1. 先 build 所有 service 的 image
make docker-up       # 2. 再啟動所有 container
```

常見問題排查：
- image 容量不對 → build 過程不完整（可能缺少 LFS 檔案）
- container 啟動失敗 → 看 `docker logs <container_name>` 找錯誤訊息
- port 衝突 → `lsof -i :<port>` 找出佔用的 process


### AWS ALB（Application Load Balancer）

ALB 是 AWS 的第 7 層（應用層）負載均衡器，能根據 HTTP/HTTPS 的內容來路由流量。

```
Client
  │
  ▼
┌─────────────────────────────────┐
│           ALB                    │
│  ┌─────────────────────────┐    │
│  │ Listener (port 443)     │    │
│  │  ├─ Rule: /api/*  → TG1 │    │
│  │  ├─ Rule: /web/*  → TG2 │    │
│  │  └─ Default       → TG3 │    │
│  └─────────────────────────┘    │
└─────────────────────────────────┘
         │          │          │
         ▼          ▼          ▼
      Target     Target     Target
      Group 1    Group 2    Group 3
     (API EC2)  (Web EC2)  (Default)
```

核心元件：
- **Listener**：監聽特定 port + protocol（如 HTTPS:443）
- **Rule**：根據條件（path、host header、HTTP method）決定流量去向
- **Target Group**：一組接收流量的目標（EC2、ECS task、Lambda、IP）

#### Listener Rule

每個 Listener 可以設定多條 Rule，每條 Rule 包含 condition + action：

**Action 類型：**
- **forward**：把流量轉發到指定的 Target Group
- **redirect**：回傳 HTTP 301/302，把 client 導向另一個 URL（常用於 HTTP → HTTPS）
- **fixed-response**：直接回傳固定的 HTTP response（如維護頁面回 503）

```
Rule 1: IF path = /api/*     → forward to API Target Group
Rule 2: IF host = old.com    → redirect to new.com (301)
Rule 3: IF path = /health    → fixed-response 200 "OK"
Rule 4: Default              → forward to Web Target Group
```

#### Path-based routing

根據 URL path 把流量導向不同的 Target Group，實現一個 ALB 服務多個微服務：

```
https://app.com/api/users   → Target Group: user-service
https://app.com/api/orders  → Target Group: order-service
https://app.com/*           → Target Group: frontend
```

好處：
- 一個 domain + 一個 ALB 就能服務多個後端服務
- 省成本（不用每個服務各開一個 ALB）
- 搭配 host-based routing 可以更細緻（`api.app.com` vs `web.app.com`）

vs NLB（Network Load Balancer）：
| | ALB | NLB |
|---|---|---|
| 層級 | Layer 7（HTTP/HTTPS）| Layer 4（TCP/UDP）|
| 路由依據 | URL path、host、header | Port、IP |
| 效能 | 較高延遲 | 極低延遲（百萬級 RPS）|
| 適用場景 | Web app、微服務 | 遊戲、IoT、極高吞吐 |



### 英單

```
- Constraint: 約束、限制。程式中指對資料或行為施加的規則（如 DB constraint、type constraint）
```



## 5/28


### 對比 host 和 docker container 時間
```shell
date -u && docker run --rm alpine date -u
```
```
Thu May 28 09:05:00 UTC 2026
Unable to find image 'alpine:latest' locally
d17f077ada11: Already exists 
2ffb2ff4aab3: Download complete 
Thu May 28 09:05:04 UTC 2026
```