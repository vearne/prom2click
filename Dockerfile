FROM ubuntu:latest

# 修改时区
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y tzdata && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 添加bin文件
COPY ./bin/prom2click /prom2click


ENTRYPOINT ["/prom2click"]

