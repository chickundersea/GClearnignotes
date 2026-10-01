## 9/14

### TypeVar
[Understanding TypeVar in Python](https://medium.com/pythoneers/understanding-typevar-in-python-f78e5108471d)


### artifact

artifact = 打包後、可以直接丟給 AWS Lambda 執行的產物。它是從你的 script code「包裝」出來的東西,不是 code 本身。

Lambda 有兩種 artifact 格式:

zip:把 relay.py 那些 Python 檔壓成一個 .zip,上傳給 Lambda。Lambda 解壓後執行。
container image:把 code + 執行環境(Python runtime、依賴套件)一起做成一個 Docker image,推到 ECR。Lambda 拉這個 image 來跑。


### Terragrunt
Terragrunt 是一套 Terraform 的 wrapper，它補足了一些基於 Terraform 自身限制而做不到的事，也藉此可以讓你的 IaC code 更貼近 DRY 原則。

[事半功倍 — 使用 Terragrunt 搭配 Terraform 管理基礎設施](https://medium.com/act-as-a-software-engineer/%E4%BA%8B%E5%8D%8A%E5%8A%9F%E5%80%8D-%E4%BD%BF%E7%94%A8-terragrunt-%E6%90%AD%E9%85%8D-terraform-%E7%AE%A1%E7%90%86%E5%9F%BA%E7%A4%8E%E8%A8%AD%E6%96%BD-f70c30166639)



