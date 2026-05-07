### 第一階段：問答 / 討論
- Public vs. Private Subnet：兩者差異？

    A:
    事實上不是兩種選項，而是兩者差異在於 **Route Table (路由表)的設定**
    
    一個 Subnet 之所以被稱為「Public」，是因為它的 Route Table 裡面有這樣一條規則：
    `Destination: 0.0.0.0/0 → Target: IGW (Internet Gateway)`
    - (`0.0.0.0/0` → 所有網際網路的流量)
    - IGW = 網際網路閘道，就是通往外網的大門

| | Public Subnet | Private Subnet |
|---|---|---|
| Route Table 規則 | 含 `0.0.0.0/0 → IGW`，可直接連外網 | 無 IGW 路由，無法直接連外網 |
| 外連內 | 可以 | 不行 |
| 內連外 | 可以 | 需透過 NAT Gateway 代理 |
| 用途| 放需要被外網直接存取的服務（如 Web Server） | 放不想被外網直接碰到的服務（如資料庫、內部 API |


- 情境題

    - 兩個 EC2 位於同個 Private Subnet，如何設定才能做到「僅限這兩台彼此互通」？
    A:設定 一個 Security Group 互相引用。 EX: `sg-pair-only`
        - Inbound 規則：僅允許來源為 `sg-pair-only` 自身的流量
        - Outbound 規則：僅允許目的地為 `sg-pair-only` 自身的流量
        - 到EC2上associated security groups 新增上`sg-pair-only`

    - Private EC2 需要下載更新（上外網），但必須禁止外網主動發起連線。
    A: 也就是 「出的去，進不來」 --> 用 `NAT Gateway`
    - 先在 Public Subnet 建立 NAT Gateway，並分配一個 Elastic IP
    - Private Subnet 的 Route Table 加一條： Destination 0.0.0.0/0   Target 到 `NAT Gateway`

    - Private EC2 在不經過 Internet 的情況下，如何安全地將 Log 傳送到 CloudWatch？
    A:使用 VPC Endpoint 走內部

    - 在 VPC 中為 CloudWatch Logs 建立一個Interface Endpoint ，會 Private Subnet 中產生一個內網 IP（ENI）(要啟用Enable DNS name就能直接透過預設的 API 網址連線)
    - 建立 Endpoint 的 Security Group Inbound ->允許來自 EC2 Security Group 的入站流量
    - 建立 EC2 的 Security Group Outbound ->允許出站流量到 Endpoint Security Group 的 IP 範圍
    - 設定 IAM Role 掛到 EC2  讓Ec2 有權限將 Log 寫入 CloudWatch


<hr>

### 第二階段：架構設計
#### 必要需求：

1.**端點 A (`GET /greet-a`)**：回傳 "Hello Alex"。

2.**端點 B (`GET /greet-b`)**：回傳 "Hello Ting"，業務邏輯實現需獨立 AP 且不可暴露外網。

3.**端點 C (`GET /weather`)**：回傳 台北當前天氣。

可選 (Nice to have)：

1.**端點 D (`GET /ip`)**：call api.ipify.org/?format=json，並且回傳 IP，業務邏輯實現需獨立 AP 且不可暴露於外網。

2.**端點 E (`GET /log-groups`)**：回傳相同 Account 內，Cloudwatch 的 log groups

#### 架構限制：

- **必備產出**：使用 **Miro** 繪製架構圖，標注流量走法與關鍵組件（如 VPC Router, ALB, NAT, VPC Endpoints 等）。

<hr>

### 第三階段：解釋 Phase 2 的各項服務選型理由
- 服務選型: 為何使用這個服務？考慮過什麼其他選項

- 高可用與擴展: 如何確保SLA？若使用量上升是否可擴充？

- 資安防禦: 如何防止惡意流量？最小權限原則？

- 成本預估: $