
## 8/17
### feature flag

也可稱做feature toggle

[什麼是功能旗標 (feature flags)? 為什麼要用功能旗標?](https://www.explainthis.io/zh-hant/swe/feature-flags)


## 8/24 

### git reword 
#### git reword 在 Git 中，reword 是用來修改歷史 commit 訊息的互動式變基指令（ `git rebase -i` 的其中一個動作）。它可以讓你保留原有的程式碼變更，但重新撰寫對應的說明文字。


#### 如何使用 reword 修改舊的 Commit 訊息啟動互動式變基

1. 輸入 `git rebase -i HEAD~n`（n 代表你要回溯檢查最近幾個 commit）。
2. 在彈出的文字編輯器中，找到你想修改的那一行。將該行最前面的 `pick` 改成 `reword`（或簡寫 r）。
3. 儲存檔案並關閉編輯器。
4. Git 會再次跳出編輯器讓你修改該筆 commit 的訊息。輸入新的訊息後儲存並離開。
5. 修改後需要使用 git push --force 強制更新遠端分支（因為變更歷史）。

### Amazon Bedrock 
Amazon Bedrock 是 AWS 提供的生成式 AI（Generative AI）平台，主要功能是：讓使用者不需要管理基礎設施，就能存取多種大型語言模型（LLM）。

#### Bedrock 的主要特點
1. 免管理基礎設施
使用 Bedrock，你不需要準備伺服器，也不需要擔心 GPU 或算力不足。AWS 幫你打理所有後端，像是運算資源、維護、擴展

2. 直接 API 呼叫
Bedrock 提供簡單的 API 介面，你只要呼叫 API，就能把 AI 功能整合到你的應用程式裡。

3. 彈性模型選擇
   
4. 資料安全與隱私保護
很多企業擔心，把自家資料丟給 AI 模型會洩漏或被用來訓練別的模型。Bedrock 有明確政策：你的資料不會被用來重新訓練基礎模型，確保機密資訊安全。



### n+1問題 

N+1問題是後端開發常見的資料庫效能問題。當程式先執行 1 次查詢取得主資料（共 N 筆），再針對每筆資料在迴圈中各執行 1 次關聯查詢，總共發出 N+1 次資料庫請求。這會導致資料量大時載入變慢、伺服器負載暴增 

為什麼會發生？ORM 預設機制：如 Lazy Loading（延遲載入），讀取主表後遇到關聯資料才發出查詢。迴圈查詢：在程式碼的 for 迴圈中直接呼叫資料庫讀取單筆關聯資料。

### big o notation

[那些聽起來很專業的「演算法 Algorithm」跟「Big O notation」到底是什麼？](https://medium.com/frontend-fighter/%E9%82%A3%E4%BA%9B%E8%81%BD%E8%B5%B7%E4%BE%86%E5%BE%88%E5%B0%88%E6%A5%AD%E7%9A%84-%E6%BC%94%E7%AE%97%E6%B3%95-algorithm-%E8%B7%9F-big-o-notation-%E5%88%B0%E5%BA%95%E6%98%AF%E4%BB%80%E9%BA%BC-727cc1b0e3e1)


### 認知負荷 
[認知負荷](https://github.com/zakirullin/cognitive-load/blob/main/README.zh-cn.md)


## 8/26

### field_validator 

@field_validator 是 Pydantic 用於驗證或修改模型中特定欄位資料的裝飾器。

運作方式：它預設為類別方法（@classmethod），第一個參數是 cls（模型類別），第二個參數是欄位的值（通常命名為 v），第三個參數則是選擇性的 ValidationInfo 物件。

[官方文件](https://pydantic.dev/docs/validation/2.9/concepts/validators/)
