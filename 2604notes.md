# 2026/04 學習筆記

> 用來記錄每日學習的內容，先瞭解基礎，每週末回頭 review 做延伸補充

## 4/22

### SIT (System Integration Testing) - 系統整合測試

專注於測試模組間的整合功能、資料傳輸與錯誤處理，通常由測試工程師在專門環境執行


### UAT (User Acceptance Testing) - 使用者驗收測試

是上線前最後的驗收，由使用者或業務代表確認系統是否符合需求、好用，注重用戶體驗。

>#### 簡言之，SIT 是確認系統「能用」，而 UAT 是確認系統「好用」且「符合業務」。

### Smoke Testing 冒煙測試
是軟體開發中的一種快速驗證流程，旨在軟體新版本發布或程式碼變更後，優先確認「核心功能」是否正常運行。若最基礎的功能（如啟動程式、登入）失敗，則不需進行後續細緻測試，節省時間成本，常用於自動化測試

### Server-Sent Events (SSE)
是一種伺服器推送技術，它允許客戶端透過 HTTP 連接自動接收來自伺服器的更新。 SSE 描述了伺服器如何在建立初始客戶端連線後向客戶端發起資料傳輸。

[Using server-sent events](https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events/Using_server-sent_events)

[淺談 Server-Sent Events](https://blackbing.medium.com/%E6%B7%BA%E8%AB%87-server-sent-events-9c81ef21ca8e)


### useMemo

`useMemo` is a React Hook that lets you cache the result of a calculation between re-renders.

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


## 4/23

> [aws_learnig.md](https://github.com/chickundersea/GClearnignotes/blob/main/aws_learnig.md) 同步更新

### 依賴注入 (Dependency Injection, DI)
TBC

ref:<br>
[消除你程式碼的臭味 Day 20- 依賴注入：鬆開那個耦合](https://ithelp.ithome.com.tw/m/articles/10385298)


### OLTP/OLAP
TBC

###  Amazon DynamoDB GSI (全域次要索引)
- **功能**：GSI 允許使用與基礎資料表（Base Table）不同的分割鍵（Partition Key）和排序鍵（Sort Key）來查詢資料。
- **特點**：GSI 中的資料是從基礎資料表異步複製過來的。它可以包含基礎資料表中所有屬性或部分屬性（投影），並提供高度靈活的查詢能力。
- **效能與限流**：GSI 有自己的讀寫容量單位（RCU/WCU）。如果 GSI 的寫入容量不足，會導致基礎資料表的寫入操作遭遇背壓（Throttling）限流。

### 基礎架構即程式碼 (IaC)
>what / how
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
**情境題**
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
```


## 4/24




### What is 「arn」?
ARN = Amazon Resource Name
 >A unique identifier for components like Lambda functions, EC2 instances, or IAM roles, typically in the format 
 `arn:partition:service:region:account-id:resource`
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

##### 資料流
```
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
- 
```


