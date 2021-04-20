# 安装
```
curl -fsSL https://get.docker.com | bash -s docker
```
# 登陆
```
docker login
```
# 获取镜像
```
docker pull vicer/app:debian9
```
# 列出镜像
```
docker images
```
# 打标签
```
docker tag <ImageID> <UserName>/debian9:latest
```
# 上传
```
docker push <UserName>/debian9:latest
```
# 注销登录
```
docker logout
```
