# 2026/05 week3學習筆記

> 用來記錄每日學習的內容，先瞭解基礎，每週末回頭 review 做延伸補充

## 目錄

- [5/16](#516) — 
- [5/17](#517) -
- [5/18](#518) —  
- [5/19](#519) - 
- [5/20](#520) - 
---

## 5/16


### vertical scalability 垂直擴展 vs horizontal scalability 水平擴展






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