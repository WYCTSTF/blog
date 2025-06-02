---
title: nginx容器反代本地端口
date: 2024-08-30 17:18:36
tags:
    - nginx
    - docker
---

使用portainer管理docker以后，总是需要 localhost:9000 来跳转，感觉一不美观二不方便。

使用nginx容器反代，记录一下踩坑的点。

<!-- more -->

## Nginx反代和hosts解析实现本地端口的自定别名

docker起一个nginx,写好配置文件。

{% fold nginx配置 %}
```nginx
server {
  listen 80;
  server_name portainer;

  location / {
    proxy_pass http://172.17.0.1:9000;
  }
}
```
{% endfold %}

这里的 `172.17.0.1` 是 `ifconfig docker0` 得到的宿主机ip,仅限linux有用，windows和mac可以使用`host.docker.internal`，但是我没有使用过，有问题请google

或者将需要互访的容器加入同一**自定**网络，通过容器别名访问也可以。

修改宿主机 `/etc/hosts`，加入

```hosts
127.0.0.1 portainer
```

按理说到这一步就好了，但是我被卡了半天找不到问题，firefox打开f12,看到一个远端ip`127.0.0.1:7897`，关掉clash的系统代理果然就没问题，在clash设置里面绕过portainer就好了。
