# All
```
https://api.moeclub.org/HWDNS?key=<KEY>&secret=<SERCET>&action=[add|del|list]&target=[domain|record]&domain=<DOMAIN>&name=<SUBDOMAIN>&data=<RECORD>&type=[A|AAAA|TXT|MX|CNAME...]&ttl=15

```

# Usage
```
# 如果操作不需要参数,可以不用写.

key: AccessKey
sercet: AccessSercet
action: [add|del|list]     # 操作方式: 添加, 删除, 列表
target: [domain|record]    # 操作目标: 域名, 记录
domain: 操作的域名           # moeclub.org
name: 操作的子域名           # moeclub.org(@), api.moeclub.org(api), www.moeclub.org(www)
data: 记录内容              # 1.2.3.4
type: 记录类型              # A
ttl:  默认 15

```
