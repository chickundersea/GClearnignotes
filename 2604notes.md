# 2026/04 學習筆記

> 用來記錄每日學習的內容，先瞭解基礎，每週末回頭 review 做延伸補充

## 目錄

- [4/22](#422) — SIT / UAT / Smoke Testing / SSE / useMemo / 密碼學
- [4/23](#423) — 依賴注入 / OLTP OLAP / DynamoDB GSI / IaC / 跨帳號 S3 存取
- [4/24](#424) — ARN / Terraform IAM Policy Module 解析
- [4/27](#427) - 

---

## 4/22

### SIT (System Integration Testing) - 系統整合測試

專注於測試模組間的整合功能、資料傳輸與錯誤處理，通常由測試工程師在專門環境執行


### UAT (User Acceptance Testing) - 使用者驗收測試

是上線前最後的驗收，由使用者或業務代表確認系統是否符合需求、好用，注重用戶體驗。

>#### 簡言之，SIT 是確認系統「能用」，而 UAT 是確認系統「好用」且「符合業務」。

### Smoke Testing 冒煙測試
是軟體開發中的一種快速驗證流程，旨在軟體新版本發布或程式碼變更後，優先確認「核心功能」是否正常運行。若最基礎的功能（如啟動程式、登入）失敗，則不需進行後續細緻測試，節省時間成本，常用於自動化測試
>可以理解一下其在 SDLC Software Development Life Cycle 和 DevOps 之間的關係



Functional Test（功能性測試）
Integration Test（整合性測試）
System Test（系統測試）
Regression Test（回歸測試）
Ad Hoc Test（隨機測試）


### Server-Sent Events (SSE)
是一種伺服器推送技術，它允許客戶端透過 HTTP 連接自動接收來自伺服器的更新。 SSE 描述了伺服器如何在建立初始客戶端連線後向客戶端發起資料傳輸。

[Using server-sent events](https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events/Using_server-sent_events)

[淺談 Server-Sent Events](https://blackbing.medium.com/%E6%B7%BA%E8%AB%87-server-sent-events-9c81ef21ca8e)

SSE 的延伸：WebSocket


### useMemo

`useMemo` is a React Hook that lets you cache the result of a calculation between re-renders.

```js
const cachedValue = useMemo(() => computeExpensiveValue(a, b), [a, b])
```

**為什麼需要 useMemo？**

React 每次 re-render 時，元件內的所有程式碼都會重新執行。
若某個計算很昂貴（如大量過濾、排序），每次 render 都重算會浪費效能。
`useMemo` 會快取上次的結果，只在依賴項改變時才重新計算。

**React 如何 render？**

1. 觸發條件：`setState` / `props 改變` / `Context 改變`
2. React 重新執行整個元件函式（包含所有變數、函式宣告）
3. 比對新舊 Virtual DOM（Reconciliation）
4. 只更新真正變動的 DOM 節點

→ 問題在步驟 2：**每次都重算 + 重新建立函式**，即使結果沒變

**dependencies（依賴陣列）**
- 依賴項改變 → 重新計算，回傳新值
- 依賴項不變 → 直接回傳快取值，跳過計算
- `[]` → 只算一次（mount 時）

**常見使用場景**
- 大量資料的過濾 / 排序
- 根據 props 衍生出複雜的計算結果
- 避免傳給子元件的物件/陣列每次都是新參考（搭配 `React.memo`）

----
## 密碼學

### Hash （雜湊）
「單方面的將數據轉換成亂碼（或稱為 Hash Value，雜湊值）」，並且這個 Hash Value，他是「不能夠」轉換回原始的字串的。

### Encode （編碼）
「數據可以直接被編碼」，並且中間「不需要」任何的密鑰參與

### Encrypt （加密）
所謂的 Encrypt（加密），就是「將數據加密成密文」

又可以再細分成兩種加密方式，分別是：

- 對稱加密
- 非對稱加密


密碼學的延伸： Hashing 的過程有哪些 components 和他們為何被需要

From input

Algo 演算法
?? 1
?? 2
...?? N
To outpu


<hr>

## 4/23

> [aws_learnig.md](https://github.com/chickundersea/GClearnignotes/blob/main/aws_learnig.md) 同步更新

### 依賴注入 (Dependency Injection, DI)
TBC

ref:<br>
[消除你程式碼的臭味 Day 20- 依賴注入：鬆開那個耦合](https://ithelp.ithome.com.tw/m/articles/10385298)


### OLTP/OLAP

- **線上交易處理 (OLTP (Online Transactional Processing))**
<br>
這個詞中 Transactional 是非常重要的，代表的是說他的處理通常包含了讀以及寫，通常 OLTP 是指系統能夠處理大量的更新以及新增的查詢。 

- **線上分析處理 (OLAP (Online Analytical Processing))**
<br>
一般的 OLAP 的系統可以讓數據聚合 (data aggregation) 以及批次處理 (Batch processing)，OLAP 大部分是用來做歷史資料的分析以及報告。


[OLAP 和 OLTP 有什麼區別？](https://aws.amazon.com/tw/compare/the-difference-between-olap-and-oltp/)

###  Amazon DynamoDB GSI (全域次要索引)
- **功能**：GSI 允許使用與基礎資料表（Base Table）不同的分割鍵（Partition Key）和排序鍵（Sort Key）來查詢資料。
- **特點**：GSI 中的資料是從基礎資料表異步複製過來的。它可以包含基礎資料表中所有屬性或部分屬性（投影），並提供高度靈活的查詢能力。
- **效能與限流**：GSI 有自己的讀寫容量單位（RCU/WCU）。如果 GSI 的寫入容量不足，會導致基礎資料表的寫入操作遭遇背壓（Throttling）限流。

### 基礎架構即程式碼 (IaC)

基礎架構即程式碼 (IaC, Infrastructure as Code) 是一種使用設定檔（定義檔）來管理和配置雲端或本地資源的自動化技術，而非手動操作實體硬體或 Web UI。這種方法能實現版本控制、自動化部署、一致性管理並顯著提高效率，是 DevOps 實踐的基礎，

#### Why  
```md
- 文件維護不易
傳統配置基礎架構幾乎都是透過原廠提供的 Client 工具
隨著工具及硬體升級
往往介面操作不太一樣
造成文件無法對齊現有操作

- 版本控管
以管理域名為例
添加 A Record 及 CName Record 都是簡單操作就完成
但透過介面的操作
無法回朔前一個操作
使用 IaC 配置基礎架構
程式碼進入版控以後
很容易可以查找過去修改歷程

- 學習多套工具
IT 單位從虛擬機械到網域管理
如果每個導入的系統都要學習
則需要熟悉多套工具或熟悉多套軟體的 GUI 操作
使用支援廣泛的 IaC 工具
則可以使用一套工具
應用於其他地方
```

**AWS IAM情境題**
#### A account 裡的 X user 可以直接存取 B account 裡 S3 服務的 Y 資源嗎？ 在 S3 已經有 allow X user 且 X user allow put y 的情況下 ?

A: 可以！因為是建立在雙方都 Allow 的前提下
```txt
帳號 A (來源端)： 使用者 X 的 IAM Policy 必須允許存取帳號 B 的資源 Y。

帳號 B (資源端)： 資源 Y 的 S3 Bucket Policy 必須允許帳號 A 的使用者 X 進行存取。
```
S3 之所以能「直接存取」，不需要透過 Role  是因為 S3 支援「資源型策略（Resource-based Policy）」。

而不同 account 之間，是有預設 Implicit Deny （隱含拒絕），如果 A 帳號沒給 permission user 就無法跨出門，B 帳號沒有開存取權們也是鎖死的，而只要任何一端設定 Deny 或是沒有說 Allow ， 這個請求就會直接失效。

這邊說的「門」 指的是由 AWS Policy Evaluation Engine (權限評估引擎) 在每一次 API 呼叫時，即時運算出來的邏輯牆。
<br>




case:<br>
[Example 2: Bucket owner granting cross-account bucket permissions](https://docs.aws.amazon.com/AmazonS3/latest/userguide/example-walkthroughs-managing-access-example2.html)
<br>
ref:<br>
[IAM 中的跨帳戶資源存取](https://docs.aws.amazon.com/zh_tw/IAM/latest/UserGuide/access_policies-cross-account-resource-access.html)



### 英單
```txt
- Aggregation:聚合
- feasibility: 可行性
- Transactional:  交易型 (指一連串的資料操作)
```
<hr>

## 4/24




### What is 「arn」?
ARN = Amazon Resource Name
 >A unique identifier for components like Lambda functions, EC2 instances, or IAM roles, typically in the format 
 `arn:partition:service:region:account-id:resource`
 <br>
 ex: `arn:aws:ec2:us-east-1:123456789012:instance/i-1234567890abcdef0`



### Take a look in `gc-host` / `role.tf`
```hcl
  custom_role = {
    developer = {
      policy_arns = [
        module.iam_policy.tf_states_management_arn,
        data.aws_iam_policy.cloudwatch_readonly.arn,
        aws_iam_policy.eks_developer.arn,
      ]
    }
    regionalAdmin = {
      policy_arns = [
        module.iam_policy.regional_admin_arn
      ]
    }

    readonly = {
      policy_arns = [
        data.aws_iam_policy.readonly.arn
      ]
    }
  }
```
可以看到，gc-host 底下有的role 為 `developer`,`regionalAdmin`, `readonly`
<br>
`policy_arns` 代表要附加的IAM policy 清單 用陣列[]條列

```
module.iam_policy.tf_states_management_arn,
```
- `module` : 引用另一個 Terraform 模組設定
- `iam_policy`:模組名稱
- `tf_states_management_arn`:模組的value > 管理terraform state 的 policy ARN

這裡的 module 引用了 `module "iam_policy"` 呼叫`"../../modules/policy"`傳入設定 (透過`source `)
```
module "iam_policy" {
  source = "../../modules/policy"

  regional_admin = {
    enabled = true
    region  = "ap-northeast-1"
  }
    tf_states_management = {
    enabled    = true
    bucket_arn = module.backend.bucket_arn
    table_arn  = module.backend.table_arn
  }
}
```
接著看到 `modules/policy` 資料夾，由`output.tf`把 ARN 輸出
```
├── modules/
│   └── policy/
│       ├── outputs.tf                      # 定義 Module 輸出結果（ARN 給外層使用）
│       ├── variables.tf                    # 定義 Module 輸入變數（enabled、region 等參數）
│       ├── policy-regional-admin.tf        # 定義 區域管理員 IAM Policy 資源
│       ├── policy-secret-management.tf     # 定義 Secret 管理 IAM Policy 資源
│       ├── policy-tf-state-management.tf   # 定義 Terraform State（S3+DynamoDB）IAM Policy 資源
│       ├── providers.tf                    # 定義 AWS Provider 設定（region、assume role 等）
│       └── README.md

```
- 為什麼每個policy可以直接讀取？
Ａ：Terraform 的機制讓同資料夾內的`.tf`檔自動被解析並整合在一起。執行得時候就會一起被讀取，不需要 import 或 require ，因此可透過命名將不同資源分開以方便維護。


```
資料流
variable.tf          定義輸入參數的型別與預設值
     ↓
policy-regional-admin.tf   接收 var.xxx，建立 aws_iam_policy 資源
     ↓
output.tf            讀取建立好的資源的 .arn，輸出給外層
     ↓
外層 module.iam_policy.regional_admin_arn

```
### 英單
```txt
- compilance:合規
```

<hr>

## 4/27

> [aws_learnig.md](https://github.com/chickundersea/GClearnignotes/blob/main/aws_learnig.md) 同步更新 Route 53

### 多重因素驗證機制
- Time-based One Time Password (TOTP)
- Fast Identity Online (FIDO)

### SSOT 
SSOT = > Single Source of Truth  (單一事實來源)
<br>
一個資訊或行為就只應該只能在同一個地方存取修改，其他地方可以透過參照（reference）的方式來使用。SSOT 的最大好處是，大家所獲得的資料永遠都是一樣的，因為我們都是參照同一個來源。

### 英單
```txt
- compiler: 編譯器
```
## 4/28


### useCallback

`useCallback` is a React Hook that lets you cache a function definition between re-renders.

```js
const cachedFn = useCallback(fn, dependencies)
```
**為什麼需要 useCallback？**

React 每次 re-render 時，函式都會被重新建立（新的記憶體位址）。
當這個函式被當作 props 傳給子元件，子元件會認為 props 改變了，進而觸發不必要的 re-render。

**useCallback vs useMemo**

| | useCallback | useMemo |
|---|---|---|
| 快取的對象 | **函式本身** | **函式的回傳值** |
| 使用場景 | 傳給子元件的 callback | 昂貴的計算結果 |
| 等價寫法 | `useCallback(fn, deps)` | `useMemo(() => fn, deps)` |

**dependencies（依賴陣列）**
- 陣列內的值改變時，才會重新建立函式
- 若為 `[]`，函式只在初次 render 建立一次
- 若省略，每次 render 都會重建（等於沒用）

**常見搭配場景**
- 搭配 `React.memo` 的子元件，避免因父元件 re-render 導致子元件也 re-render
- 作為 `useEffect` 的依賴項時，避免 effect 無限觸發

