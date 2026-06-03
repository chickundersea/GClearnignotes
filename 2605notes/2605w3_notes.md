# 2026/05 week3學習筆記

> 用來記錄每日學習的內容，先瞭解基礎，每週末回頭 review 做延伸補充

## 目錄

- [5/18](#518) — Vertical/Horizontal Scaling、遙測訊號 SLO/SLI、EBS Quiz、Context Engineering
- [5/19](#519) — 
- [5/20](#520) — *args 與 **kwargs
- [5/21](#521) — grep 指令、aws-vault exec vs login、 docker-up 失敗紀錄
- [5/22](#522) — 

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


<hr>

## 5/19



### 文章閱讀


## 5/20

### *args 與 **kwargs 

*args = arguments 代表「位置引數」




>**kwargs =  keyword arguments，代表「關鍵字引數」。它的功能是讓Function接收不定數量、且帶有「名稱 = 值」的參數，並自動將這些參數打包成一個 字典。
>> 雙星號的作用：變數名稱前加上 ** 是解包（Unpacking）或打包字典的語法。


```py
def print_user_info(**kwargs):
    # kwargs 會被轉換為字典
    print(type(kwargs))  # 輸出: <class 'dict'>
    
    # 遍歷字典中的所有鍵值對
    for key, value in kwargs.items():
        print(f"{key}: {value}")

# 呼叫函式，傳入不固定數量的關鍵字參數
print_user_info(name="小明", age=25, city="Taipei")

```
輸出結果：
```
<class 'dict'>
name: 小明
age: 25
city: Taipei
```

- [Python *args and **kwargs](https://www.w3schools.com/python/python_args_kwargs.asp)
- [Python *args 與 **kwargs 使用方式](https://medium.com/jimmy-wang/python-note-%E8%88%87-%E4%BD%BF%E7%94%A8%E6%96%B9%E5%BC%8F-32c8f5eeb06e)



## 5/21

### grep 指令


#### aws-vault   exec 跟 login  的差異

`aws-vault exec`
用途：在 terminal 裡執行 AWS CLI 指令
- 把臨時憑證（Access Key / Secret / Session Token）注入到當前的 shell 環境變數
- 讓你在 terminal 裡用 AWS CLI、Terraform 等工具操作 AWS
- 憑證只存在那個 session，時間到就失效

`aws-vault login`
用途：用瀏覽器打開 AWS Console
- 產生一個臨時的 sign-in URL，自動在瀏覽器開啟 AWS 管理介面
- 讓你用那個 profile 的身份登入網頁版 Console
- 不需要自己輸入帳密


### **always daubt everything**





###  docker-up 失敗紀錄

讓 Docker CLI 指向 Podman 的 socket：
確認 socket 存在：
```bash
ls /Users/umacheng/.docker/run/docker.sock
# 或
ls /var/run/docker.sock
```
-> 只有`/var/run/docker.sock` 
，沒有`/Users/umacheng/.docker/run/docker.sock`

因為 Podman 的 Docker 相容 socket 路徑不同，可以建 symlink：
```bash
mkdir -p ~/.docker/run
ln -sf $(podman machine inspect --format '{{.ConnectionInfo.PodmanSocket.Path}}') ~/.docker/run/docker.sock
```

遇到 

```bash
Error response from daemon: getting graph driver info "d66544c0b8b1da9bde2c4f4214641d15715a23751c91aa7bc3b30c50074ab6f2": readlink /var/lib/containers/storage/overlay: invalid argument

What's next:
    Filter, search, and stream logs from all your Compose services
    in one place with Docker Desktop's Logs view. docker-desktop://dashboard/logs
make: *** [docker-up] Error 1
```

執行 
```bash
podman system reset
```

```zsh
Error response from daemon: getting graph driver info "d66544c0b8b1da9bde2c4f4214641d15715a23751c91aa7bc3b30c50074ab6f2": readlink /var/lib/containers/storage/overlay: invalid argument

What's next:
    Filter, search, and stream logs from all your Compose services
    in one place with Docker Desktop's Logs view. docker-desktop://dashboard/logs
make: *** [docker-up] Error 1
```

reset完重跑 build 到一半 還是fail 

> 考慮刪除machine 

刪完重建
>可以docker up 

但遇到新問題
migration-runner fail 缺少 alembic 這個套件

>懷疑lfs 檔案沒有pull

用 
```
ls -lh */**/*.tar.gz
```
看lfs檔案容量大小來判斷


 再次 `git lfs pull`

 發生 
 ```zsh
error transferring "b9754e708b92c21308abeac93d16de21c8bfcf745ba4a58066854c86cc3e7454": [1] Error downloading file: No downloadable version of the file was found

Failed to fetch some objects from '[REDACTED-REPO]'
 ```
 檔案拉取路徑還是指向git hub

 用 ` git config --local --list | grep -i lfs`
 確認 lfs 對應s3 的設定完整

 #### 嚴重注意！！ ～～
 
 ```
 aws-vault exec <profile> 
 ```
 登到shell
 用`aws s3 ls`確認可以看到s3的bucket 

 `make docker-up` again 

 >migration-runner 一樣error
 
 用
  ```zsh
   docker image ls | grep migration
  ```
看migration image 的容量 是否跟其他同事一致
：
>沒有，表示build 有問題

重跑    `make docker-build`
 再用
  ```
  docker image ls | grep migration
  ```
看migration image 的容量 是否跟其他同事一致：
>是

`make docker-up ` again 

#### **成功 !** 

