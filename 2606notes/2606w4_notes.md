



## 6/22


### SQL scalar_one()

SQLAlchemy 中用來從查詢結果取出**恰好一筆**資料的**單一欄位值**。

```python
from sqlalchemy import select

# 取得單一值
stmt = select(User.name).where(User.id == 1)
name = session.execute(stmt).scalar_one()
# 回傳: "Uma"（直接是值，不是 Row 物件）
```

行為規則：
- 結果**恰好 1 筆** → 回傳該值
- 結果**0 筆** → 拋 `NoResultFound`
- 結果**多於 1 筆** → 拋 `MultipleResultsFound`

相關方法比較：
| 方法 | 回傳 | 0 筆 | 多筆 |
|------|------|------|------|
| `scalar_one()` | 單一值 | 拋錯 | 拋錯 |
| `scalar_one_or_none()` | 單一值或 None | 回傳 None | 拋錯 |
| `scalar()` | 第一筆的第一欄 | 回傳 None | 取第一筆（不拋錯）|
| `one()` | 整個 Row | 拋錯 | 拋錯 |

```python
# 安全版本：查不到時回傳 None 而不是拋錯
name = session.execute(stmt).scalar_one_or_none()
```


### SQL ALTER TABLE

用來修改已存在的資料表結構（不是改資料，是改表的 schema）。

```sql
-- 新增欄位
ALTER TABLE users ADD COLUMN email VARCHAR(255);

-- 刪除欄位
ALTER TABLE users DROP COLUMN phone;

-- 修改欄位型別
ALTER TABLE users ALTER COLUMN age TYPE INTEGER;

-- 重新命名欄位
ALTER TABLE users RENAME COLUMN name TO full_name;

-- 重新命名表格
ALTER TABLE users RENAME TO members;

-- 新增約束
ALTER TABLE users ADD CONSTRAINT unique_email UNIQUE (email);

-- 設定預設值
ALTER TABLE users ALTER COLUMN status SET DEFAULT 'active';
```

在 Alembic migration 中的對應：
```python
# alembic migration file
def upgrade():
    op.add_column('users', sa.Column('email', sa.String(255)))
    op.drop_column('users', 'phone')

def downgrade():
    op.add_column('users', sa.Column('phone', sa.String(20)))
    op.drop_column('users', 'email')
```

注意事項：
- ALTER TABLE 在大表上可能需要很長時間（lock table）
- PostgreSQL 的某些操作（如加 NOT NULL）需要 rewrite 整張表
- 生產環境建議用 migration 工具（Alembic）管理，避免手動下 DDL


### SQL COALESCE() Function

回傳參數列表中**第一個非 NULL** 的值。適合設定預設值或處理可能為 NULL 的欄位。

```sql
-- 基本用法：如果 nickname 是 NULL，就用 name；name 也是 NULL 就用 'Anonymous'
SELECT COALESCE(nickname, name, 'Anonymous') AS display_name
FROM users;

-- 實際場景：計算折扣後價格，折扣可能為 NULL
SELECT 
    product_name,
    price * (1 - COALESCE(discount, 0)) AS final_price
FROM products;

-- 搭配 JOIN：左表欄位可能因為 JOIN 不到而為 NULL
SELECT 
    u.name,
    COALESCE(o.total, 0) AS order_total
FROM users u
LEFT JOIN orders o ON u.id = o.user_id;
```

vs IFNULL / NVL：
- `COALESCE` 是 SQL 標準，所有資料庫都支援，且可接受多個參數
- `IFNULL(a, b)` 是 MySQL 專用，只接受兩個參數
- `NVL(a, b)` 是 Oracle 專用


### isoformat()

Python `datetime` 物件轉成 **ISO 8601 格式字串**的方法。

```python
from datetime import datetime, date, timezone

# datetime → ISO string
now = datetime(2026, 6, 22, 14, 30, 0)
now.isoformat()
# '2026-06-22T14:30:00'

# 帶時區
now_utc = datetime(2026, 6, 22, 14, 30, 0, tzinfo=timezone.utc)
now_utc.isoformat()
# '2026-06-22T14:30:00+00:00'

# date → ISO string
today = date(2026, 6, 22)
today.isoformat()
# '2026-06-22'

# 自訂分隔符
now.isoformat(sep=" ")
# '2026-06-22 14:30:00'
```

為什麼用 ISO 8601：
- 國際標準格式，API 交換資料時不會有歧義
- JSON 中日期通常就是用這個格式（Pydantic 序列化預設也是）
- 字串排序 = 時間排序（因為是 YYYY-MM-DD 格式）

反向解析：
```python
from datetime import datetime
dt = datetime.fromisoformat('2026-06-22T14:30:00+00:00')
```


### timedelta

Python `datetime` 模組中表示**時間差**的物件，用來做時間的加減運算。

```python
from datetime import datetime, timedelta

now = datetime.now()

# 建立時間差
one_day = timedelta(days=1)
two_hours = timedelta(hours=2)
half_second = timedelta(milliseconds=500)

# 時間加減
tomorrow = now + timedelta(days=1)
yesterday = now - timedelta(days=1)
next_week = now + timedelta(weeks=1)
two_hours_later = now + timedelta(hours=2, minutes=30)

# 計算兩個時間的差
start = datetime(2026, 6, 1)
end = datetime(2026, 6, 22)
diff = end - start          # 回傳 timedelta 物件
print(diff.days)            # 21
print(diff.total_seconds()) # 1814400.0
```

常見應用場景：
```python
# Token 過期時間
expires_at = datetime.utcnow() + timedelta(hours=1)

# 判斷是否超時
if datetime.now() - last_heartbeat > timedelta(minutes=5):
    mark_as_offline()

# 排程間隔
interval = timedelta(minutes=30)
next_run = last_run + interval
```

支援的參數：`weeks`、`days`、`hours`、`minutes`、`seconds`、`milliseconds`、`microseconds`


 ### 英單
 - param 參數