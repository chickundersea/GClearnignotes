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


#### 英單
```txt
- Aggregation:
- 
```