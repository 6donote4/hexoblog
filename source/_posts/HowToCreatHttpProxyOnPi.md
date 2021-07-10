---
title: 「原创」基于树莓派配合Shadowsocks-libev和Privoxy搭建透明网关
toc: false
tags:
  - RaspberryPi 
  - Shadowsocks-libev 
  - Privoxy
  - 透明代理
categories:
  - "原创博文"
date: 2017-08-20 09:30
top: 1106
---

<font size=4>
翻墙后，即可评论博文


</font>
<!--more-->

<audio controls="controls" name="media" style='width:264px' autoplay loop=true><source src="/musics/wish.mp3"></audio>

***

<font size=4>
之前，曾经尝试过网上的教程去建立透明网关，但是没有成功。最近开始深入了解Privoxy这个软件，它是一款开源软件，能够进行端口转发。能够让Socks代理转换为大多数设备支持的http代理协议，即透明代理。今天稍稍说明一下，利用这个软件结合SS，在树莓派上搭建透明网关。个人认为，这种方法还算简单，配置也不复杂。当然，树莓派也可以配置成翻墙路由，只是要更折腾一些了，配置成网关相对来说，就不需要整双网卡和iptables的配置，以及各种服务文件。总之，我是被网上的各种教程整晕了。今天，换了个方法，算是成功了。不说废话了。进入正题。

这里，仅提供透明代理建立的过程说明。树莓派系统及测试设备的配置不在讨论范畴。请自行搜索。


```sh
ssh pi@192.168.1.252
```
登录树莓派，Win下使用Putty登录。

```sh
sudo apt-get install　shadowsocks-libev privoxy
cp /etc/privoxy/config /home/pi
touch config.json
```
安装shadowsocks-libev和privoxy,把Privoxy的配置文件从/etc目录复制到用户的家目录。创建SS配置文件，用文本编辑器打开config.json,将SS分享站上的SS配置贴到这个文本中。

```sh
#vim config
listen-address 0.0.0.0:8118
forward-socks5 / 127.0.0.1:1080 .
```
打开privoxy的配置文件，在末尾加入上述信息，0.0.0.0:8118表示树莓派系统内的任意软件以及外部的设备都可以通过树莓派地址及端口访问到Privoxy提供的数据转发服务。注意forward-socks5语句末尾有<font color=red> <b>一个小数点</b></font>。如果你想要再加一层http代理，可以用搜索到的代理服务器的地址及端口替换掉小数点。这样,你的访问请求就会从浏览器到Privoxy,再从Privoxy通过Socks5协议到达SS服务器，最后从SS服务器到达目标网站。网站的响应则沿着这个路线反向发送数据。
附图:
<img width="600" src="/pictures/post_1106_ss_pi_privoxy_2.png" />
<img width="600" src="/pictures/post_1106_ss_pi_privoxy_3.png" />

```sh
ss-local -c /home/pi/config.json
privoxy config
```
运行Shadowsocks和Privoxy。

```sh
netstat -anp | grep LISTEN
```
查看1080和8118端口是否启用。如果两个都启用了，说明建立成功。

设备测试状况：
Linux(PC):
<img width="600" src="/pictures/post_1106_ss_pi_privoxy.png" />
iOS:
<img width="600" src="/pictures/post_1106_ss_pi_privoxy_4.png" />
<img width="600" src="/pictures/post_1106_ss_pi_privoxy_5.png" />
3DS:
<img width="600" src="/pictures/post_1106_ss_pi_privoxy_6.JPG" />
<img width="600" src="/pictures/post_1106_ss_pi_privoxy_7.JPG" />

其实如果路由器能将树莓派设置为网关的话，那么所有连接到路由器信号的设备就不必设置代理，就能摆脱大局域网了。
</font>

***
