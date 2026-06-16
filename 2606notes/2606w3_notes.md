
# 2026/06 week3學習筆記

> 用來記錄每日學習的內容，先瞭解基礎，每週末回頭 review 做延伸補充

## 目錄

- [6/15](#615) — 
- [6/16](#616) - 
- [6/17](#617) — 
- [6/18](#618) —
- [6/19](#619) — 



## 06/15
### iloc 
iloc 是 Python pandas 函式庫中，用於 基於整數索引（integer-position） 定位資料的屬性。它的運作方式類似於 Python 的標準串列（List）切片，完全不理會資料本身的自訂標籤名稱。

`df.iloc[row_index, column_index]`
- row_index：指定要選取的列（Row）的整數位置。
- column_index：指定要選取的欄（Column）的整數位置。
- 索引範圍：範圍包含起始索引，但不包含結束索引（例如 0:3 會選取 0, 1, 2 三列，不包含第 3 列） 


### monkey patch

[深入解析 monkeypatch：Python 測試中的強大工具](https://realnewbie.com/posts/deep-dive-monkeypatch-powerful-tool-python-testing)

--------------

## 06/16
### URI (Uniform Resource Identifier)
個會指向資訊來源的字串。其中又以定位網址 URLs 最為常見，會把該位址傳給網站，好讓網站辨認資訊來源。不過，統一資源名稱 URNs 就不一樣了，是用命名空間允許的名稱指向資訊來源，例如國際標準書碼 (International Standard Book Number，一般以 ISBN 縮寫)

[URI與URL有什麼區別？](https://www.iware.com.tw/blog-1236.html)

### 「爆炸半徑」（Blast Radius）

### git commit --allow-empty

- Parsing
- 