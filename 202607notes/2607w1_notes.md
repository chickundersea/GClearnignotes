




## 6/29


### AWS cloudformation 
是 AWS 原生的 Iac ，是一種宣告式（Declarative）的服務，透過 YAML / JSON 撰寫


### cloudformation 搭配 charlice 部署


```shell script 
#!/bin/bash

# detect unbound variable
set -u
set -e

#確保本地（或 CI/CD 環境中）有安裝最新的 Python 相依套件，Chalice 在打包時需要把這些套件一起壓縮進 deployment.zip。
pip install -r requirements.txt


sed -i "s|STAGE|$STAGE|g" cfn.json 
chalice package $STAGE --stage $STAGE --merge-template cfn.json

cd ./$STAGE

aws cloudformation package \
  --template-file ./sam.json \
  --s3-bucket billing-portal-cfn \
  --s3-prefix $STAGE \
  --output-template-file sam-packaged.yaml
aws cloudformation deploy \
  --template-file sam-packaged.yaml \
  --stack-name billing-portal-$STAGE \
  --capabilities CAPABILITY_IAM
```

- set -u (Nounset)： 只要腳本裡遇到沒有被定義的變數（例如忘記設定 $STAGE），腳本就會立刻報錯並停止。這能防止因為空變數導致建立出檔名怪異的資源。

- set -e (Errexit)： 只要任何一行指令失敗（例如 pip 安裝失敗），整支腳本就會立刻中斷，不會硬著頭皮往下走，避免把壞掉的東西部署上去。





### 英單
- benchmark
- Pinecone Nexus
- vector search
- glossary



## 6/30

### Using Microsoft Presidio to detect PII

 the analyzer, which identifies PII in a given text, and the anonymizer, which can mask out PII in text:

```py
presidio_analyzer = AnalyzerEngine()
presidio_anonymizer= AnonymizerEngine()
```


### Field 標註屬性 
[ref PR CE-1067] 
Field 是 Pydantic 提供的欄位描述器，讓你在定義 type + default 之外，還能附加 metadata 和驗證規則。

對比
```
# 不用 Field — 只有 type 和 default
quota_type: str = "conversation"

# 用 Field — 多了 description、驗證、範例
quota_type: str = Field(
    default="conversation",
    description="Quota type: 'conversation' or 'ai_summary'",
    examples=["conversation", "ai_summary"],
)

```
兩者運作邏輯完全一樣（type 是 str，default 是 "conversation"），差異在 metadata。

#### Field 能做什麼
| 功能   | 範例                              | 效果                        |
|------|---------------------------------|---------------------------|
| 文件描述 | description="..."               | 自動出現在 OpenAPI/Swagger UI  |
| 範例值  | examples=[...]                  | Swagger 的「Try it out」顯示範例 |
| 數值限制 | ge=1, le=100                    | 小於 1 或大於 100 自動 422       |
| 字串限制 | min_length=1, max_length=50     | 空字串或超長自動 422              |
| 正則驗證 | pattern=r"^[a-z_]+$"            | 不符合 pattern 自動 422        |
| 必填標記 | Field(...) 或 Field(default=...) | ... 表示沒有 default，必須提供     |

#### 實際好處
自動生成 API 文件：FastAPI 把 description 和 examples 直接放到 Swagger UI，其他開發者看 /docs 就知道怎麼用
自動驗證：加上 ge、max_length 等，不需要自己寫 if 判斷，Pydantic 直接回 422
程式碼即文件：不用另外寫註解，欄位本身就清楚描述用途
你專案裡的 lock.py 範例
ttl_seconds: int = Field(
    default=settings.lock_ttl_seconds,  # 預設值
    ge=1,                                # 最小值 1
    le=settings.max_lock_ttl_seconds,    # 最大值
    description="Lock TTL in seconds",   # API 文件描述
)
如果有人送 {"ttl_seconds": 0} 進來，Pydantic 會自動回 422 說 ge=1 驗證失敗，不需要你在 router 裡手動檢查。

什麼時候不用 Field
如果欄位沒有額外驗證需求、也不需要在 Swagger 上顯示描述，quota_type: str = "conversation" 就夠用了。Field 是 nice-to-have，不是必須。你們 reviewer 建議加，主要是為了 API 文件品質和專案一致性。



### 英單
- anonymizer


## 7/1


### Literal 是什麼
Literal 是 Python typing 模組提供的型別標註，用來限制一個變數「只能是這幾個固定值的其中一個」。

```py
from typing import Literal

# 這個變數只能是 "conversation" 或 "ai_summary"，給其他值就是型別錯誤
quota_type: Literal["conversation", "ai_summary"]
```
對比三種寫法：
 
```
# 1. 純 str — 什麼字串都收，沒有驗證
quota_type: str = "conversation"
# ✅ "conversation"
# ✅ "ai_summary"
# ✅ "banana"       ← 不會報錯，但邏輯上是錯的

# 2. Literal — 限定只接受列出的值
quota_type: Literal["conversation", "ai_summary"] = "conversation"
# ✅ "conversation"
# ✅ "ai_summary"
# ❌ "banana"       ← Pydantic 自動回 422

# 3. Enum — 功能類似，但要額外定義 class
class QuotaType(str, Enum):
    CONVERSATION = "conversation"
    AI_SUMMARY = "ai_summary"

quota_type: QuotaType = QuotaType.CONVERSATION
# ✅ "conversation"
# ✅ "ai_summary"
# ❌ "banana"       ← 同樣會回 422

```

###cloudwatch metrics alert

如何設計error alart ？



### 英單

-  tailization
-  


## 7/2

stack 

error trace 



### FreeableMemory 可用的隨機存取記憶體的數量。

AWS RDS Cloudwatch 


### InvocationClientErrors 因「發出請求端」的問題（例如語法錯誤、參數無效或權限不足）被系統拒絕時，這個錯誤計數就會增加。


Application Inference Profile (AIP) │ 每個 agent 用不同的 inference profile，CloudWatch 可以按 profile 區分

### 英單

- Threshold 臨界值
- 








