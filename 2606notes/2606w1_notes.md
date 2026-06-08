# 2026/06 week1學習筆記

> 用來記錄每日學習的內容，先瞭解基礎，每週末回頭 review 做延伸補充

## 目錄

- [6/01](#601) — 
- [6/02](#602) - 
- [6/03](#603) — 
- [6/04](#604) —
- [6/05](#605) — 

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

yaml yml 

Docker stage

FROM 
ARG 
COPY
RVN
ENV
WOKKDIR
EXPOSE
CMP

fi

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

### self.prefix


### os.environ
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

Spec driven development
加入專案要留意是否有 spec 文件 ， 應遵守優先改動文件後透過 task 開發