## AWS SAA Course

AWS data centers 

AZ
考慮： 政府 延遲性 成本

#### AWS local zones 
low latency  -> better for gaming
#### edge location
caching of data 
-> better user experiance

### architect responsibilites
Plan / Research / Build

### AWS Well-Architected Framework pillars
1.Security
2.Cost optimization
3.Reliability
4.Performance efficiency
5.Operational excellence
6.Sustainability

### IAM
- Authentication 
- Authorization


#### AWS STS (Security Token Service)

loose coupling 鬆耦合度


### AWS Compute Optimizer

Scan your AS infra and Cloudwatch Metrics


### s3

s3 北美設備的合規性更高(因應當地法規)，


s3 versoning 版控
s3 replicating 副本
- SRR Same Region
- CRR Cross Region

#### multipule upload
#### transfer acceleration

>  filewatch --> event --> event handler 
用 lambda 來針對事件採取行動
EX: - 上傳資料後發送通知 ， 上傳資料後複製到另一個bucket

#### s3 express one zone 
在單一 AZ 內，for高速存取需求

## AWS Storage Gateway
- file gateway
- tape gateway
- volume gateway


## AWS DataSync 
地端 雲端 資料同步工具

## Storage

relational and nonrelational databases


## Databases Caching

### lazy loading
先找cache 再找 database 接著存到cache 下次就從cache 找
### write-through
資料寫入datebase 時同時寫入 cache

### AWS schema conversion tool (SCT)
地到雲端 schema 轉移工具

### Amazon Data Firehose


### AWS Elastic Beanstalk

### AWS Solutions Library
### AWS CDK

### VPC Peering 


### Kinesis Data Streams overview

### AWS WAF


### RPO(Recovery Point Objective) vs RTO(Recovery Time Objective)
