# 2026/04 學習筆記

> 用來記錄每日學習的內容

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


