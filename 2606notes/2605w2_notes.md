# 2026/06 week1學習筆記

> 用來記錄每日學習的內容，先瞭解基礎，每週末回頭 review 做延伸補充

## 目錄

- [6/08](#608) — Docker 核心概念、Dockerfile 寫法、docker-compose、常見指令
- [6/09](#609) — FastAPI 路由、Python OOP
- [6/10](#610) — 
- [6/11](#611) — 
- [6/12](#612) — opaque string、OpenID Connect (OIDC)



#6/08

### Docker 

Image 
Container 
Volume 
Registry
Host Machine
Docker Engine


### Dockerfile 怎麼寫


### docker-compose 

### docker-compose.yml 怎麼寫
這個檔案是用來告訴 app
1. 如何連接資料庫、用哪種DB? 等配置 
2. DB名稱、User name 、 各種參數 --> 寫成環境變數  `env` 

### docker 常見指令

```
docker build -t <filename>  # 在currnet folder copy 一份到 docker engine  / -t = target 指定路徑
docker run -p 80:5000 -d <filename> # -p 指定 port <本地>:<web>/ -d = detached 背景執行
docker ps  # 列出所有 container
docker ps -a #查看 所有 container 的運行狀態
docker stop <container ID>  # 停止 container
docker restart  # 重啟 container
docker rm <container ID>  # 刪除 container
docker rmi <image ID> # 刪除 image
docker logs <container ID> # 查看該 container 輸出的 log
```
[使用 Docker Compose 摻在一起做懶人包]
(https://ithelp.ithome.com.tw/articles/10243618)

[Docker Compose 建置 Web service 起步走入門教學]
(https://blog.techbridge.cc/2018/09/07/docker-compose-tutorial-intro/)

[Docker Compose 初學者指南：使用範例解析]
(https://realnewbie.com/posts/docker-compose-beginner-guide-sample-usage) 



## 6/09



[Python新手的FastAPI之旅3：FastAPI建構路由](https://medium.com/seaniap/python%E6%96%B0%E6%89%8B%E7%9A%84fastapi%E4%B9%8B%E6%97%853-fastapi%E5%BB%BA%E6%A7%8B%E8%B7%AF%E7%94%B1-dd02c002ef65)
[Python 基礎教學 一切皆為物件，到底什麼是物件 Object ?](https://www.maxlist.xyz/2021/01/11/python-object/)
[Python教學 物件導向-Class類的封裝/繼承/多型](https://www.maxlist.xyz/2019/12/12/python-oop/)
### 6/12


opaque string 


OpenID Connect(OIDC)

[GitHub OIDC](https://docs.github.com/en/actions/concepts/security/openid-connect)