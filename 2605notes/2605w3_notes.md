# 2026/05 week3學習筆記

> 用來記錄每日學習的內容，先瞭解基礎，每週末回頭 review 做延伸補充

## 目錄

- [5/18](#518) —  
- [5/19](#519) - 
- [5/20](#520) - 
- [5/21](#521) - 
- [5/22](#522) - 

---

## 5/18

### vertical scalability 垂直擴展 vs horizontal scalability 水平擴展


### 遙測訊號與 SLO/SLI 基本概念
#### 基礎遙測訊號
- Logs：事件細節，適合看「發生了什麼」
- Metrics：數值化趨勢，適合監控「是否正常」
- Traces：端到端鏈路，適合找「哪裡出問題」

#### 演示其關聯性
- Log → Trace（trace_id）
- Metrics → Trace（exemplar）
- Trace ↔ Logs/Metrics（上下文串連）

#### SLO/SLI
- SLI：可量測的可靠性指標（例：成功率 99%）
- SLO：服務目標（例：99.9% 可用性）



#### SAA EBS/EFS Quiz Review

Question 2:
You have launched an EC2 instance with two EBS volumes, Root volume type and the other EBS volume type to store the data. A month later you are planning to terminate the EC2 instance. What's the default behavior that will happen to each EBS volume?

A:
When you terminate an EC2 instance, the Root volume is deleted by default because its "Delete On Termination" attribute is enabled, while other EBS volumes do not have this attribute enabled, so they remain intact. This understanding is crucial for managing your data and instance lifecycle effectively.

Question 9:
You are running a high-performance database that requires an IOPS of 310,000 for its underlying storage. What do you recommend?

A: 
Use an EC2 Instance Store
You can run a database on an EC2 instance that uses an Instance Store, but you'l have a problem that the data will be lost if the EC2 instance is stopped (it can be restarted without problems). One solution is that you can set up a replication mechanism on another EC2 instance with an Instance Store to have a standby copy. Another solution is to set up backup mechanisms for your data. It's all up to you how you want to set up your architecture to validate your requirements. In this use case, it's around IOPS, so we have to choose an EC2 Instance


### Context Engineering

Context Engineering 是 AI Agent 作為「守門人」，透過複雜運算篩選並管理 LLM 輸入長度的核心技術，其目的是讓模型在有限的視窗內，獲得長度適中且資訊密度最高的內容，主要技術手段如下：
- 高效壓縮：利用 LLM 摘要或 Observation Masking (將冗長輸出改為簡短標記) 來大幅降低 token 成本。
- 記憶與過濾：將資訊拆分為 P (Prompt，模型可見) 與 N (硬碟存儲)，配合智慧讀取與動態載入技能 (Skill Loading) 避免資訊過載。
- 自主管理：透過 Subagents 執行子任務並僅回傳結果來實現自主壓縮；或由模型自主維護動態手則 (Playbook) 來應對極長輸入。
這項技術確保 Agent 既不會因資訊冗餘而「梗塞」，也不會因重要指令在壓縮中遺失而導致上下文崩潰 (Context Collapse)

[AI Agent (1/3)：核心技術 Context Engineering 基本概念解說](https://www.youtube.com/watch?v=urwDLyNa9FU)


### 文章閱讀

MDN [Using server-sent events](https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events/Using_server-sent_events#sending_events_from_the_server)

[淺談 Server-Sent Events](https://blackbing.medium.com/%E6%B7%BA%E8%AB%87-server-sent-events-9c81ef21ca8e)




1.欄位做index ?  不用
mcp services 共用小service 的restapi endpoint 

service 內還 service 外  （service之間呼叫）

clean architechure (DDD)

- 業務邏輯 放usecase 

- 檢查dependency 注入

next-release 