




## 6/29


### AWS cloudformation 
是 AWS 原生的 Iac ，是一種宣告式（Declarative）的服務，透過 YAML / JSON 撰寫


### cloudformation 搭配 charlice 部署


```shell script 
#!/bin/bash

# detect unbound variable
set -u
set -e

#確保本地（或 CI/CD 環境中）有安裝最新的 Python 相依套件，Chalice 在打包時需要把這些套件一起壓縮進 deployment.zip。
pip install -r requirements.txt


sed -i "s|STAGE|$STAGE|g" cfn.json 
chalice package $STAGE --stage $STAGE --merge-template cfn.json

cd ./$STAGE

aws cloudformation package \
  --template-file ./sam.json \
  --s3-bucket billing-portal-cfn \
  --s3-prefix $STAGE \
  --output-template-file sam-packaged.yaml
aws cloudformation deploy \
  --template-file sam-packaged.yaml \
  --stack-name billing-portal-$STAGE \
  --capabilities CAPABILITY_IAM
```

- set -u (Nounset)： 只要腳本裡遇到沒有被定義的變數（例如忘記設定 $STAGE），腳本就會立刻報錯並停止。這能防止因為空變數導致建立出檔名怪異的資源。

- set -e (Errexit)： 只要任何一行指令失敗（例如 pip 安裝失敗），整支腳本就會立刻中斷，不會硬著頭皮往下走，避免把壞掉的東西部署上去。





### 英單
- benchmark
- Pinecone Nexus
- vector search
- glossary
- 