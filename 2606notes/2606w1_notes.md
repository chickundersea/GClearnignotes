# 2026/06 week1學習筆記

> 用來記錄每日學習的內容，先瞭解基礎，每週末回頭 review 做延伸補充

## 目錄

- [6/01](#601) — Type Annotations、TTFT、busybox、Docker stage & Dockerfile 指令、yaml/yml、fi
- [6/02](#602) — AWS ECS（cluster、Fargate、Task Definitions）
- [6/03](#603) — 資料粒度、iloc[]、self.prefix、os.environ、DDD
- [6/04](#604) — Python iterator、Generator、Decorator、yield
- [6/05](#605) — Python basic、Kiro best practices

## 6/01

###  Python 類型註解 (Type Annotations)

typing.Annotated 用於在型別提示中附加自訂的中繼資料（Metadata）。它完全不會改變 Python 原生的執行行為，但能為 IDE、靜態檢查工具（如 mypy）或套件（如 FastAPI、Pydantic）提供額外的驗證與文件資訊。

[全方位指南：初學者學習 Python 類型註解 (Type Annotations)](https://realnewbie.com/posts/comprehensive-guide-python-type-annotations-for-beginners)

#### TTFT (Time to first token)
是大型語言模型（LLM）推論效能的核心指標，指從使用者送出請求，到模型開始生成第一個字（Token）之間的延遲時間。它直接決定了系統的「反應速度」，在對話機器人等即時互動應用中至關重要。

TFT 主要由以下階段組成：
- 排隊延遲（Queueing Delay）： 系統資源忙碌時，請求在伺服器等待處理的時間。
- 預填充時間（Prefill Time）： 模型讀取並理解整個輸入提示詞（Prompt）的時間。提示詞越長，此階段耗時越久。
- 初次解碼（Initial Decoding）： 開始生成並傳回第一個字的時間。
- 網路傳輸（Network Overhead）： 資料透過 API 傳回前端的網路延遲。

busybox 

超輕量的 Linux 工具集合，把常用的 Unix 指令（ls、cat、sh、wget 等）打包成一個小執行檔（約 1-2 MB）。
在 Docker 中常用作最小化的 base image，適合除錯或作為 init container。

```bash
# 用 busybox image 快速進入一個極簡 shell 環境
docker run -it busybox sh
```

---

yaml yml 

YAML（YAML Ain't Markup Language）的兩種副檔名，功能完全相同，純粹是命名慣例差異。
- `.yaml` 是官方推薦的副檔名
- `.yml` 是早期 3 字元副檔名限制留下的慣例（Windows 時代）
- 選一個統一用就好，團隊一致即可

---

Docker stage（Multi-stage build）

在一個 Dockerfile 中使用多個 `FROM`，每個 `FROM` 是一個 stage。
好處：build 階段用完整工具鏈編譯，最終 image 只保留執行所需的檔案，大幅縮小 image 容量。

```dockerfile
# Stage 1: Build（用完整的 node image 來 build）
FROM node:20 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: Production（只複製 build 產物到輕量 image）
FROM node:20-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
EXPOSE 3000
CMD ["node", "dist/main.js"]
```

---

#### Dockerfile 常用指令

**FROM** — 指定 base image，每個 Dockerfile 必須以此開頭
```dockerfile
FROM python:3.11-slim
FROM node:20-alpine AS builder   # 可以命名 stage
```

**ARG** — 定義 build 階段的變數，只在 build 時存在，不會留在最終 image
```dockerfile
ARG APP_VERSION=1.0.0
RUN echo "Building version ${APP_VERSION}"
# 使用：docker build --build-arg APP_VERSION=2.0.0 .
```

**COPY** — 把 host 的檔案複製進 image
```dockerfile
COPY . /app                       # 複製當前目錄到 image 的 /app
COPY --from=builder /app/dist .   # 從另一個 stage 複製（multi-stage）
```

**RUN** — 在 build 階段執行指令（安裝套件、編譯等），每個 RUN 產生一個新 layer
```dockerfile
RUN apt-get update && apt-get install -y curl
RUN pip install --no-cache-dir -r requirements.txt
```

**ENV** — 設定環境變數，會留在最終 image 中（container 執行時可用）
```dockerfile
ENV NODE_ENV=production
ENV PORT=8080
```

**WORKDIR** — 設定工作目錄，後續的 RUN、CMD、COPY 等指令都以此為基準
```dockerfile
WORKDIR /app    # 如果不存在會自動建立
```

**EXPOSE** — 宣告 container 會使用的 port（只是文件性質，實際要用 -p 映射）
```dockerfile
EXPOSE 8080
EXPOSE 443
```

**CMD** — 定義 container 啟動時的預設指令（只能有一個，多個只取最後一個）
```dockerfile
CMD ["python", "main.py"]            # exec 格式（推薦）
CMD python main.py                    # shell 格式
```

ARG vs ENV 比較：
| | ARG | ENV |
|---|---|---|
| 存在時機 | build 階段 | build + runtime |
| 用途 | 傳入 build 參數（版本號、flag）| 設定 app 的環境變數 |
| 覆蓋方式 | `--build-arg` | `docker run -e` 或 `.env` |

---

fi

Shell script 中 `if` 語句的結束關鍵字（`if` 反過來寫）。

```bash
if [ "$ENV" = "production" ]; then
    echo "Running in production"
elif [ "$ENV" = "staging" ]; then
    echo "Running in staging"
else
    echo "Running in development"
fi    # ← if 區塊結束
```

Shell 中類似的配對：
- `if ... fi`
- `case ... esac`（case 反過來）
- `do ... done`（for/while loop）

[Pydantic 的介紹](https://medium.com/kiwibyteswalk/pydantic-%E7%9A%84%E4%BB%8B%E7%B4%B9-3721a0691162)


## 6/02

AWS ECS

cluster 
fargate

Task: 類似docker compose 包多個container

IMAGE URI: 所在位置
IMAGE Digest : image ID

Task Definitions 
  - task role 
  - task execution role 

JSON --> compose 看 revision 版差異
改完JSON --> create 
回cluster update --> force depoly 


英單
- Fargate
- ephemeral
- prefix


## 6/03

### 資料粒度（Data Granularity）
是指資料的詳細程度或聚合層級。粒度越細，資料越貼近原始明細，包含的細節越多；粒度越粗，資料經過彙總，細節較少但整體趨勢更明顯。

#### 細粒度數據 (Fine-grained)
- 記錄最原始、最單一的事件明細。
- 細節完整，但資料量龐大、查詢速度較慢。
- 適用：個別交易明細、即時報表、除錯分析。
- 
#### 粗粒度數據 (Coarse-grained)
- 將多筆細節資料按時間、類別等彙總。
- 資料量小，利於看出宏觀趨勢；但喪失具體細節。
- 適用：管理層決策、年度銷售預測、趨勢分析。


#### 常見的粒度維度
 - 時間粒度：秒 > 分鐘 > 小時 > 天 > 週 > 月 > 季 > 年。
 - 地理粒度：門市 > 郵遞區號 > 城市 > 國家。
 - 產品粒度：單一商品型號 > 產品子類別 > 產品大類。
  
### statistic.iloc[]

Pandas DataFrame 的**位置索引**方法，用整數（index location）來選取資料。

```python
import pandas as pd

df = pd.DataFrame({
    'name': ['Alice', 'Bob', 'Charlie', 'David'],
    'score': [85, 92, 78, 95],
    'grade': ['B', 'A', 'C', 'A']
})

# 單一值
df.iloc[0]          # 第 0 列（整列，回傳 Series）
df.iloc[0, 1]       # 第 0 列、第 1 欄 → 92

# 切片
df.iloc[1:3]        # 第 1~2 列（不含第 3 列）
df.iloc[:, 0:2]     # 所有列、前 2 欄（name, score）

# 搭配條件篩選後取特定位置
top = df.sort_values('score', ascending=False)
top.iloc[0]         # 分數最高的那列
```

iloc vs loc：
| | iloc | loc |
|---|---|---|
| 索引方式 | 整數位置（0, 1, 2...）| 標籤名稱（index name / column name）|
| 範圍 | 不含結尾（Python style）| 含頭含尾 |
| 適用 | 不在意 index 名稱時 | index 有意義時（如日期、ID）|

```python
df.iloc[0:2]   # 取第 0, 1 列
df.loc[0:2]    # 取 index 標籤 0, 1, 2（含結尾）
```


### self.prefix

Python class 中用 `self` 儲存的 instance attribute，用來作為名稱前綴（prefix），在多個地方重複使用時保持命名一致。

```python
class S3Storage:
    def __init__(self, environment: str):
        self.prefix = f"data/{environment}"   # 例如 "data/production"

    def get_key(self, filename: str) -> str:
        return f"{self.prefix}/{filename}"
        # "data/production/report.csv"

    def list_objects(self):
        return s3.list_objects(Prefix=self.prefix)
        # 只列出 "data/production/" 底下的物件
```

為什麼用 `self.prefix` 而不是每次組字串：
- 統一管理：改一個地方就能影響所有路徑
- 可讀性：`self.prefix` 比到處寫 `f"data/{self.env}"` 更清楚意圖
- 可測試：測試時可以替換 prefix 指向 test 路徑

常見應用場景：
- S3 key 的路徑前綴（依環境 / 租戶區分）
- Log message 加上 service name prefix
- Cache key 前綴避免命名衝突


### os.environ

Python 標準庫中用來存取**系統環境變數**的 dict-like 物件。

```python
import os

# 讀取環境變數
aws_region = os.environ["AWS_REGION"]          # key 不存在會拋 KeyError
db_host = os.environ.get("DB_HOST", "localhost")  # 不存在回傳預設值

# 設定環境變數（只影響當前 process）
os.environ["MY_VAR"] = "hello"

# 檢查是否存在
if "API_KEY" in os.environ:
    do_something()

# 列出所有環境變數
for key, value in os.environ.items():
    print(f"{key}={value}")
```

常見搭配 pattern：

```python
# 搭配 pydantic Settings 管理設定
from pydantic_settings import BaseSettings

class Config(BaseSettings):
    db_host: str = "localhost"
    db_port: int = 5432
    aws_region: str = "ap-northeast-1"

    class Config:
        env_file = ".env"   # 自動從 .env 檔讀取

config = Config()  # 自動從環境變數或 .env 載入
```

注意事項：
- `os.environ` 修改只影響當前 process 和子 process，不影響系統
- 敏感資訊（API key、DB password）不要 hardcode，透過環境變數注入
- 本地開發用 `.env` + `python-dotenv` 或 `pydantic-settings` 管理
- 部署時由 CI/CD、Docker、或 AWS Parameter Store / Secrets Manager 注入
### 領域驅動設計(Domain-driven design，DDD)
提供一個框架，支持結構良好的微服務設計。 DDD 有 戰略 階段和 戰術 階段。 在策略性DDD中，你定義了大規模系統結構。 策略性DDD確保您的架構始終聚焦於業務能力。 戰術式 DDD 提供設計模式，可以用來建立領域模型。 這些模式包括實體、彙總和領域服務。 這些戰術模式幫助你設計鬆散耦合且具凝聚力的微服務。

#### 英單
- decimal place 小數位


[簡明 Linux Shell Script 入門教學](https://blog.techbridge.cc/2019/11/15/linux-shell-script-tutorial/)


[什麼是微服務？](https://www.paloaltonetworks.tw/cyberpedia/what-are-microservices)

[軟體架構 : 微服務模式 (Microservice)](https://medium.com/%E7%A8%8B%E5%BC%8F%E6%84%9B%E5%A5%BD%E8%80%85/%E8%BB%9F%E9%AB%94%E6%9E%B6%E6%A7%8B-%E5%BE%AE%E6%9C%8D%E5%8B%99%E6%A8%A1%E5%BC%8F-microservice-9fbb15bdeeed)


## 6/04

### Python iterator (迭代器)

### Python Generator 

https://www.w3schools.com/python/python_generators.asp

### Python Decorator


### Python yield keyword

https://www.w3schools.com/python/ref_keyword_yield.asp


# 6/05


### python basic 

`print ()` ---> 用來換行

也可以用 **\n**
`print ('Blank line \nin the middle')`
--->
```shell
Blank line
in the middle 
```

```py
sentence = 'The dog is named Sammy'
print(sentence.upper()) --> THE DOG IS NAMES SAMMY # 全大寫
print(sentence.lower()) --> the dog is named sammy # 全小寫
print(sentence.capitalize()) --> The dog is named Sammy # 首字大寫
print(sentence.count('a')) --> 2 # 算有幾個 a
```



### Kiro

AWS 推出的 AI IDE，核心理念是 **Spec-Driven Development**：先寫規格，再透過 task 驅動開發，而不是直接跳進去改 code。

---

#### 兩種 Session 模式

**Vibe mode**（對話模式）
- 適合探索、問問題、快速迭代小改動
- 直接跟 Kiro 對話，像 pair programming

**Spec mode**（規格模式）
- 適合功能開發、需要多檔案修改的任務
- 流程：Requirements → Design → Tasks → Implementation
- 每個 task 完成後 Kiro 會標記狀態，保持進度清晰

---

#### 兩種自主模式

**Autopilot**（預設）
- Kiro 自主完成整個任務，不需要每步確認
- 完成後可以看 diff、revert 或繼續

**Supervised**
- 每次有檔案修改時，Kiro 會暫停等你 approve
- 每個 hunk 可以獨立 accept / reject，控制更細緻
- 適合不確定影響範圍的大改動

---

#### Context 注入技巧

用 `#` 把特定內容帶進對話：

```
#File       → 指定某個檔案
#Folder     → 指定整個資料夾
#Problems   → 當前檔案的 lint / type error
#Terminal   → 最近的 terminal 輸出
#Git Diff   → 當前未 commit 的修改
```

範例用法：
```
「幫我 review #Git Diff，有沒有哪裡邏輯不對」
「根據 #File router.py 補上缺少的 test」
「#Terminal 這個錯誤是什麼意思」
```

---

#### Steering（持久指令）

放在 `.kiro/steering/*.md`，讓 Kiro 在每次對話都自動套用特定規則。

常見用途：
- 專案的 coding convention（命名規則、格式）
- 常用指令說明（怎麼跑 test、怎麼 build）
- 架構說明（service 的分層規則、哪些東西不能混用）

```
.kiro/steering/
├── conventions.md    # 命名、格式規範
├── build.md          # 如何跑 test / build
└── architecture.md   # 架構限制與邊界
```

---

#### Hooks（自動觸發）

在特定 IDE 事件發生時，自動執行動作。

常見使用情境：
```
fileEdited  → 存檔時自動跑 lint
agentStop   → Kiro 完成任務後自動跑 test
preToolUse  → 在 Kiro 寫檔前先做 review check
```

---

#### Spec-Driven Development 使用原則

1. **加入新專案時，先找 spec 文件** — 確認有沒有 `.kiro/specs/` 下的規格
2. **要改功能，先改 spec** — 讓文件和實作保持同步，不要先動 code
3. **透過 task 推進** — 每個 task 對應一個原子操作，完成一個標記一個
4. **大改動用 Supervised mode** — 避免 Autopilot 一次改太多、範圍失控
5. **用 Steering 固定團隊規範** — 讓所有人的 Kiro 行為一致，不用每次重新說明
6. **善用 `#` context 提高精準度** — 給越精確的 context，輸出品質越高
7. **不確定時先 Vibe，確定了再 Spec** — 探索階段用對話，方向確定後再寫規格開發


