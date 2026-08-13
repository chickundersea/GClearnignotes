## 8/3

### toset (Terraform / HCL)

`toset(v dynamic) → set of dynamic`

將引數轉為 set。常用於 `for_each` 需要一個 set 時把 list 轉型：

```hcl
resource "aws_instance" "web" {
  for_each = toset(["a", "b", "c"])
  ami      = "ami-xxxx"
}
```

---

### datetime.UTC vs timezone.utc (Python)

```python
# 舊寫法 (Python 3.2+)
from datetime import datetime, timezone
def _now_iso():
    return datetime.now(timezone.utc).isoformat()

# 新寫法 (Python 3.11+)
from datetime import UTC, datetime
def _now_iso():
    return datetime.now(UTC).isoformat()
```

**Q: 為什麼要改成 UTC？**

ruff 的 **UP017** rule 偵測到 Python 3.11+ 新增了 `datetime.UTC` 常數（是 `timezone.utc` 的 alias），會自動把 import 和用法替換成較短的版本。功能完全相同，只是更簡潔。

---

### urlparse (Python `urllib.parse`)

將 URL 拆解為各組成部分：

```python
from urllib.parse import urlparse

r = urlparse("https://example.com:8080/path?q=1#frag")
r.scheme   # 'https'
r.netloc   # 'example.com:8080'
r.path     # '/path'
r.query    # 'q=1'
r.fragment # 'frag'
```

回傳的是 `ParseResult` namedtuple，可用 `.hostname`、`.port` 等屬性存取更細的欄位。

---

### hasattr (Python built-in)

```python
hasattr(obj, name: str) → bool
```

檢查物件是否具有某屬性或方法。內部其實就是嘗試 `getattr(obj, name)` 看會不會拋 `AttributeError`。

```python
class Dog:
    sound = "woof"

d = Dog()
hasattr(d, "sound")  # True
hasattr(d, "fly")    # False
```

---

### getattr (Python built-in)

```python
getattr(obj, name: str, default=...) → value
```

動態取得物件的屬性值。可提供 default，若屬性不存在就回傳 default 而非拋例外。

```python
getattr(d, "sound")         # "woof"
getattr(d, "fly", "nope")  # "nope"
```

常搭配 `hasattr` 或 default 做防禦性存取。

---

### aclose (Python async)

非同步資源的關閉方法，對應同步版的 `.close()`。常見於：

- **Async Generator**：`await gen.aclose()` 讓 generator 做 cleanup（觸發 finally block）。
- **Async Context Manager** 的底層：`async with` 結束時呼叫 `__aexit__` → 通常內部呼叫 `aclose()`。

```python
async def stream_data():
    try:
        while True:
            yield await fetch_chunk()
    finally:
        await cleanup()

gen = stream_data()
data = await gen.__anext__()
await gen.aclose()  # 觸發 finally 裡的 cleanup
```

---

### ainvoke (LangChain)

LangChain 中 Runnable 介面的非同步呼叫方法：

```python
# 同步
result = chain.invoke({"question": "hi"})

# 非同步
result = await chain.ainvoke({"question": "hi"})
```

所有 LangChain 的 Chain / LLM / Tool 都實作了 `Runnable`，所以都有 `invoke` / `ainvoke` / `batch` / `abatch` / `stream` / `astream` 等方法。在 async 環境（FastAPI、async Lambda handler）要用 `ainvoke` 才不會 block event loop。

---

### noqa: ARG001 vs 底線命名慣例

`# noqa: ARG001` 的作用：告訴 Ruff 的 ARG001 規則（unused function argument）「我知道這個參數沒用，別報錯」。

`_context` 的作用：Python 社群慣例中，`_` 前綴代表「這個變數是故意不用的」。Ruff 預設就不會對 `_` 開頭的參數觸發 ARG001。

**為什麼 `_context` 比 `# noqa` 更好：**

- **自文件化** — 讀程式碼的人不需要查 ARG001 是什麼意思，`_` 前綴一看就懂
- **不會意外壓掉其他 lint 警告** — `# noqa` 可能讓同一行的其他問題被靜默忽略
- **更 Pythonic** — PEP 8 標準做法（`for _ in range(10)` 也是同理）

結論：能用命名慣例解決的就不要用 noqa 壓制。

---

### model_dump() (Pydantic v2)

Pydantic v2 用來將 Model 實例序列化為 dict 的方法（取代 v1 的 `.dict()`）：

```python
from pydantic import BaseModel

class User(BaseModel):
    name: str
    age: int

u = User(name="Alice", age=30)
u.model_dump()                 # {'name': 'Alice', 'age': 30}
u.model_dump(exclude={"age"})  # {'name': 'Alice'}
u.model_dump(mode="json")     # 所有值都轉為 JSON-compatible 型別
```

常用參數：`include`、`exclude`、`by_alias`、`exclude_none`、`mode`。

對應的 JSON string 版本是 `model_dump_json()`。
