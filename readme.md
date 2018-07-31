# Shadowsocks Kcptun for EdgeRouter X (SFP)

基于izerosoul的版本，对组件进行了更新，并融入了Kcptun的支持。

## 组件说明：

|组件|版本说明|
|---|---|
|ChinaDNS|维持izerosoul基于1.3.2修改的版本|
|pdnsd|维持izerosoul引用的1.2.9版本|
|shadowsocks-libev|基于shadowsocks/shadowsocks-libev源码编译的3.2.0版本，包含ss-redir和ss-local|
|kcptun|引用xtaci/kcptun项目20180316版本，kcptun-linux-mipsle-20180316.tar.gz|

## 安装:

1. 下载或克隆本项目，并拷贝至路由器

2. 按照实际情况调整配置文件shadowsocks.json和kcp.json的参数（参考shadowsocks/shadowsocks-libev与xtaci/kcptun项目说明）

3. 在路由器`sudo chmod +x install.sh`后执行安装脚本

## 使用:

1. 在/etc/init.d/shadowsocks脚本中设置DNS，并配置需要BYPASS的IP段或多个IP

2. 脚本使用:

```
# 启动 
sudo /etc/init.d/shadowsocks start

# 重启 
sudo /etc/init.d/shadowsocks restart

# 终止 
sudo /etc/init.d/shadowsocks stop

# 状态 
sudo /etc/init.d/shadowsocks status
```

3. 提供SS检测脚本ss-monitor.sh，可利用crontab实现自动检测和服务重启

## 环境

*本项目在EdgeRouter X SFP v1.10.5上测试通过。*

### 以下为原项目维护者说明 

```
注意:
1.国内外流量自动分流，通过ipset对国内IP进行白名单，国内IP不会翻墙访问，只有国外流量会走shadowsocks通道翻墙
2.只能对TCP流量翻墙
3.国外网站DNS经shadowsocks服务器中转使用TCP访问8.8.8.8，防止污染，国内域名使用国内DNS解析，不会影响CDN访问
4.1080端口可以作为socks5翻墙代理使用
5.文件存放在/config目录是因为这个目录备份配置的时候会被一起备份，并且系统升级也不会删除
6.shadowsocks-libev版本:v3.1.0, chinadns版本:v1.3.2(修改版)，pdnsd版本:v1.2.9
7.EdgeRouter X EdgeOS v1.8.5,v1.9.0测试通过
8.如果想暂停shadowsocks，运行sudo /etc/init.d/shadowsocks stop
9.重新启动就运行sudo /etc/init.d/shadowsocks start
10.运行sudo crontab -e，并在文件末尾添加以下内容，就可以实现每隔5分钟检测ss状态，如果不能翻墙就自动重启服务：
*/5 * * * * sh /config/shadowsocks/bin/ss-monitor.sh

PT下载用户请注意，如果你有独立的下载机，可以设置让下载机不走SS。具体操作如下：
ss启动脚本/etc/init.d/shadowsocks里面有下面一行:
#BYPASS_RANGE=192.168.123.0/24
去掉注释(删掉#号)重启服务就可以生效，然后192.168.123.0/24这整个网段都不会走ss通道了，同时也无法翻墙了，192.168.123.0/24也可以换成单独IP或者其它网段。

DNS解析过程
chinadns    必须配置至少一个国内DNS，一个国外DNS
dnsmasq  ->    chinadns    (国外IP)->    pdnsd   -> ss-server -> dns-server:ok
			   (国内IP)->    114.114.114.114:ok

chinadns作者很久没有更新过了，但是有几个bug，会导致有些同时有国内国外CDN的域名解析出国外的IP，本方案使用的chinadns我修复了这个bug并优化了部分情况下的解析速度。
ss翻墙方案目前最容易出问题的就是DNS防污染，最近的几次更新几乎都是针对DNS，到目前版本终于让我比较满意了。
```
