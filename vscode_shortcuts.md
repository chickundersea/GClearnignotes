# VSCode 快捷鍵練習場

> 請在以下各區塊中實際操作對應的快捷鍵來練習。每個區塊都有說明要練習的快捷鍵與操作指引。

---

## 1. 基本編輯 (Basic Editing)

### 練習 ⌘X / ⌘C — 剪下/複製整行（無選取時）
把游標放在下面任一行上（不要選取任何文字），按 ⌘X 剪下整行，再按 ⌘V 貼上。

```
這是第三行，移動我到別的位置
這是第一行，試試剪下我
這是第二行，試試複製我
這是第二行，試試複製我
```

### 練習 ⌥↓ / ⌥↑ — 移動整行
把游標放在某一行，用 ⌥↑ 和 ⌥↓ 來重新排序下面的清單：

```
1. 蘋果
2. 橘子
3. 香蕉
4. 西瓜
5. 葡萄
```

### 練習 ⇧⌥↓ / ⇧⌥↑ — 複製整行
把游標放在下面這行，按 ⇧⌥↓ 來複製它：

```
console.log("複製這一行到下方");
console.log("複製這一行到下方");
console.log("複製這一行到下方");
console.log("複製這一行到下方");
console.log("複製這一行到下方");
console.log("複製這一行到下方");
console.log("複製這一行到下方");
console.log("複製這一行到下方");
console.log("複製這一行到下方");
console.log("複製這一行到下方");
console.log("複製這一行到下方");
console.log("複製這一行到下方");
```

# 練習 ⇧⌘K — 刪除整行
刪除下面多餘的行，只留下 "保留這行"：

```
保留這行
```

### 練習 ⌘Enter / ⇧⌘Enter — 在下方/上方插入空行
在下面兩行之間插入新行（游標放在第一行，按 ⌘Enter）：

```


第一行（游標放這裡，按 ⌘Enter 在下方插入空行）

第二行（游標放這裡，按 ⇧⌘Enter 在上方插入空行）

```

### 練習 ⌘] / ⌘[ — 增加/減少縮排
調整下面程式碼的縮排層級：

```
function example() {
    let x = 1;
    if (x > 0) {
        console.log(x);
        }
    }
```

### 練習 ⌘/ — 切換行註解
選取下面幾行，按 ⌘/ 來切換註解：

```
const a = 1;
const b = 2;
<!-- const c = a + b; -->
<!-- console.log(c); -->
```

### 練習 ⇧⌥A — 切換區塊註解
選取下面的程式碼，按 ⇧⌥A 加上區塊註解：

```
<!-- function add(a, b) {
    return a + b;
} -->
```

### 練習 ⌥Z — 切換自動換行
按 ⌥Z 來切換自動換行，觀察下面這段超長文字的顯示變化：

```
這是一段非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常長的文字，用來測試自動換行功能是否正常運作。
```

### 練習 ⌥⌘[ / ⌥⌘] — 摺疊/展開區域
試著用 ⌥⌘[ 摺疊下面的函式，再用 ⌥⌘] 展開：

```javascript
function calculateTotal(items) {
    let total = 0;
    for (const item of items) {
        if (item.price > 0) {
            total += item.price * item.quantity;
        }
    }
    return total;
}
```

---

## 2. 多重游標與選取 (Multi-cursor and Selection)

### 練習 ⌥ + click — 插入多個游標
按住 ⌥ 並點擊下面每一行的開頭，同時在多行前面加上 "- "：

```
- 買牛奶
- 買雞蛋
- 買麵包
- 買水果
- 買咖啡
```

# 練習 ⌥⌘↑ / ⌥⌘↓ — 在上方/下方插入游標
把游標放在第一行，連按 ⌥⌘↓ 在下方新增游標，然後同時編輯所有行：

```
item1: same new value
item2: same new value
item3: same new value
item4: same new value
item5: same new value
```

# 練習 ⌘D — 選取下一個相同的文字
把游標放在第一個 "foo" 上，連續按 ⌘D 來逐一選取所有 "foo"，然後打字替換成 "bar"：

```
const bar = 1;
let result = bar + 10;
console.log(bar);
if (bar > 0) {
    return bar;
}
```

# 練習 ⇧⌘L — 選取所有相同的文字
選取下面第一個 "DONE"，按 ⇧⌘L 一次選取所有 "DONE"，然後替換成 "DONE"：

```
DONE: 完成登入功能
DONE: 修復搜尋 bug
DONE: 更新文件
DONE: 新增測試
DONE: 部署上線
```

### 練習 ⌘L — 選取整行
按 ⌘L 選取當前行，連按可以擴展選取範圍：

```
第一行：連按 ⌘L 
第二行：會往下擴展
第三行：一直擴展選取
```

### 練習 ⇧⌥I — 在每個選取行的末尾插入游標
先用 ⌘L 連選下面多行，然後按 ⇧⌥I 在每行末尾插入游標，加上分號：

```
const name = "Alice"
const age = 30
const city = "Taipei"
const job = "Engineer"
```

---

## 3. 搜尋與取代 (Search and Replace)

### 練習 ⌘F — 尋找
按 ⌘F 搜尋 "apple"，用 ⌘G 跳到下一個，⇧⌘G 跳到上一個：

```
I have an apple.
She bought an apple pie.
The apple tree is tall.
He ate an apple for lunch.
Apple juice is refreshing.
```

### 練習 ⌥⌘F — 取代
按 ⌥⌘F 把所有 "cat" 替換成 "dog"：

```
The dog sat on the mat.
My dog likes to play.
A dog and a dog walked together.
That dog is very cute.
```

### 練習 ⌘D / ⌘K ⌘D — 逐一選取/跳過
游標放在第一個 "error" 上，按 ⌘D 選取，再按 ⌘D 加選下一個。如果要跳過某個，按 ⌘K ⌘D：

```
log.error("connection failed");
log.info("this is not an error");
log.error("timeout exceeded");
log.error("file not found");
log.warn("minor error detected");
```

---

## 4. 導航 (Navigation)

### 練習 ⌃G — 跳到指定行
按 ⌃G 輸入行號跳到指定行。試試跳到不同的區塊標題。

### 練習 ⌘P — 快速開啟檔案
按 ⌘P 輸入檔名來快速切換檔案。試試搜尋專案中的其他檔案。

### 練習 ⇧⌘O — 跳到符號
按 ⇧⌘O 可以看到這個檔案中的所有標題（Markdown 中是 heading），試試跳到不同段落。

### 練習 ⌃- / ⌃⇧- — 前進/後退
先用 ⌃G 或 ⌘P 跳到不同位置，然後用 ⌃- 回到上一個位置，⌃⇧- 前進。

### 練習 ⇧⌘M — 顯示問題面板
按 ⇧⌘M 開啟問題面板，查看目前檔案中的警告或錯誤。

---

## 5. 編輯器管理 (Editor Management)

### 練習 ⌘\ — 分割編輯器
按 ⌘\ 把當前編輯器分割成兩個。

### 練習 ⌘1 / ⌘2 / ⌘3 — 切換編輯器群組
分割後用 ⌘1, ⌘2, ⌘3 在不同的群組間切換焦點。

### 練習 ⌘W — 關閉編輯器
按 ⌘W 關閉目前的編輯器分頁。

### 練習 ⇧⌘T — 重新開啟已關閉的編輯器
關閉一個分頁後，按 ⇧⌘T 重新打開它。

---

## 6. 程式語言編輯 (Rich Languages Editing)


### 練習 ⌘. — 快速修復
在有波浪底線的程式碼上按 ⌘. 查看可用的快速修復建議。

### 練習 ⇧⌥F — 格式化文件
按 ⇧⌥F 自動格式化，觀察下面混亂的程式碼如何被整理：

```javascript
const obj={name:"test",value:42,items:[1,2,3],nested:{a:1,b:2}};function process(data){if(data.value>0){return data.items.map(i=>i*2)}else{return[]}}
```

# 練習 ⇧⌘\ — 跳到對應的括號
把游標放在下面的某個括號上，按 ⇧⌘\ 跳到對應的括號：

```javascript
function complex(data) {
    if (data) {
        for (let i = 0; i < data.length; i++) {
            if (data[i].active) {
                process(data[i].items.filter((item) => {
                    return item.valid && (item.count > 0);
                }));
            }
        }
    }
}
```

---

## 7. 檔案管理 (File Management)

### 常用快捷鍵提醒
- ⌘N — 新增檔案
- ⌘S — 儲存
- ⇧⌘S — 另存新檔
- ⌥⌘S — 全部儲存
- ⌘K P — 複製檔案路徑
- ⌘K R — 在 Finder 中顯示檔案

試試按 ⌘K P 複製這個檔案的路徑，再貼到下面：

```
檔案路徑：（貼在這裡）/Users/umacheng/Desktop/Daily_learnig/vscode_shortcuts.md
```

---

## 8. 顯示 (Display)

### 練習各種面板切換
依序按下這些快捷鍵，觀察 VSCode 的介面變化：

- ⌘B — 切換側邊欄
- ⇧⌘E — 顯示檔案總管
- ⇧⌘F — 顯示搜尋
- ⌃⇧G — 顯示原始碼控制
- ⇧⌘D — 顯示除錯
- ⇧⌘X — 顯示擴充功能
- ⇧⌘U — 顯示輸出面板
- ⌘= / ⇧⌘- — 放大/縮小

---

## 9. 除錯 (Debug)

### 常用除錯快捷鍵
在有除錯設定的專案中練習：

- F9 — 切換中斷點（把游標放在下面某行，按 F9）
- F5 — 開始/繼續除錯
- F10 — 逐步執行（不進入函式）
- F11 — 逐步執行（進入函式）
- ⇧F11 — 跳出函式
- ⇧F5 — 停止除錯

```javascript
function fibonacci(n) {
    if (n <= 1) return n;
    const a = fibonacci(n - 1);
    const b = fibonacci(n - 2);
    return a + b;
}

for (let i = 0; i < 10; i++) {
    console.log(`fib(${i}) = ${fibonacci(i)}`);
}
```

---

## 10. 終端機 (Integrated Terminal)

### 練習終端機快捷鍵
- ⌃` — 顯示/隱藏終端機
- ⌃⇧` — 新增終端機
- ⌘↑ / ⌘↓ — 在終端機中上下捲動

試試按 ⌃` 打開終端機，輸入一些指令，再用 ⌃⇧` 開第二個終端機。

---

## 11. 綜合練習

### 挑戰：重構下面的程式碼
使用你學到的快捷鍵完成以下任務：
1. 用 ⌘D 或 ⌘F2 把所有 "temp" 改成 "result"
2. 用 ⌥↑/⌥↓ 重新排列函式順序
3. 用 ⌘/ 註解掉 console.log
4. 用 ⌘] 修正縮排
5. 用 ⇧⌘K 刪除空行

```javascript
function calculate(a, b) {
    let ressult = a + b;
        console.log(ressult);
    if (ressult > 10) {
        ressult = ressult * 2;
            console.log("doubled:", ressult);
        }
    return ressult;
}
function validate(ressult) {
console.log("validating:", ressult);
    if (ressult < 0) {
            return false;
    }
return true;
}
let ressult = calculate(5, 8);
    console.log("final:", ressult);
validate(ressult);
```

---

> 💡 **提示**：可以用 ⌘K ⌘S 打開鍵盤快捷鍵設定，查看或自訂所有快捷鍵。
