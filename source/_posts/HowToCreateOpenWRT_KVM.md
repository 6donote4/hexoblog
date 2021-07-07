---
title: 「原创」OpenWRT路由系统虚拟机搭建记录
tags:  
  - OpenWRT 
  - KOOLSHARE 
  - QEMU 
  - KVM 
  - 虚拟机
categories:
  - "原创博文"
date: 2019-02-11 18:40
top: 1117
---
<font size=4>

翻墙后，即可评论博文.
放假这几天，把大把的时间都投入到OpenWRT虚拟机及其网络的搭建之研究中，现在已初现成果，物理设备均可连接到虚拟网络之中，也实现了物理设备的出国。趁着还没忘记搭建过程，写下这篇记录，以备虚拟机文件丢失的时候，又得花大把时间重新再搭建一遍，费时费力。把走过的路记下来，下次就不会迷路咯。

</font>
<!--more-->

<audio controls="controls" name="media" style='width:264px' autoplay loop=true> <source src="/musics/qianban.mp3"></audio>

***

<font size=4>

# OpenWRT 虚拟机路由系统搭建说明
本记录使用的是KOOLSHARE社区的LEDE x86_64版本镜像，因其配备非常适合中国用户使用的插件，并且有着极易配置的Web UI界面，之前使用过原版镜像，奈何搭建出国插件的过程实在漫长又低效，索性用现成的了。能用就可以了。
 
#### 安装必备的软件包                                                     

 ```bash
 apt-get install libvirt qemu brctl -y #debian类的发行版软件包，目前测试成功的网络接口管理程序是networking,需要使用配置文件，NetworkManager测试失败，暂时不用NetworkManager.
 pacman -S libivrt qemu #arch类发行版依赖包。                                                 
 ```

#### 配置网络环境                                                          
 * ARCH:使用NetworkManager创建桥接接口br0(wan),br1(lan),__br1接口必须配置静态ip，br0保持DHCP，后面会在提及__.向br0添加连接外网的接口eth1或者enp1s0,视实际情况而定,~~若是无线网卡,可先创建一vlan隧道,在vlan上添加无线接口，经测试，未成效~~
 * br1直接添加内网以太接口eth2,enp2s0,是具体情况而定，接口名可使用`ip link`进行查看，__br1接口必须设置静态ip,后面虚拟机内部的网卡设置lan口的静态地址必须与该处ip处于同一网段，比如192.168.2.x__                                               
 * Debian:需配置interface文件,~~也可使用NetworkManager进行配置,已失败~~             
 * 给连接外网的桥接网口br0设置DHCP客户端模式,添加域名解析地址也可不加,给内网桥接接口设置静态地址 
 
#### 配置防火墙转发规则，设置内核参数允许转发                              
 内核参数设置

```bash
 echo "1">/proc/sys/net/ipv4/ip_forward                                
 sysctl -p                                                             
```
```
 防火墙规则:                                                             
iptables -t nat -A POSTROUTING -o wlp4s0 -j MASQUERADE                
iptables-save                                                         
```

#### 刻写虚拟机镜像                                                        
* 完整安装一个debian基础系统环境，使用libvirt图形管理工具，创建系统盘，挂载安装镜像img文件。
* 进入debian虚拟机，使用dd命令刻写镜像到系统盘                          
`dd if=/dev/sda of=/dev/sdb` sda为镜像文件，sdb为系统盘                
* 创建虚拟机，添加系统盘，网卡两张，连接外网的设备可使用共享设备，填入桥接接口名称br0,如果是使用无线网卡作为出口，则在虚拟机中做一个NAT到无线网卡的网络
* 内网网卡必须使用共享设备网络模式,填入桥接接口名br1                    
* wan口使用NAT 模式须设置虚拟机自身DHCP,                                

#### 虚拟机路由初始配置                                                    
* 变更防火墙规则，允许外网访问                                          
```bash
vim /etc/config/firewall                                               
/wan #搜索wan口区，将option input 设为ACCEPT
```

* 设置network文件，变更lan口地址，不可与主路由同一网段                  
`vim /etc/config/network`                                               
`/etc/init.d/firewall restart`                                          
`/etc/init.d/network restart`                                           
* 安装所有带luci界面的软件包                                            
`./OpenWRT_PACK_Installation.sh`                                        

#### 进入Web浏览器界面添加额外插件                                         

#### 相关配置文件位置
debian 网口配置文件interface、OpenWRT软件包安装脚本在笔者的debian-scripts仓库中的qemu目录中

#### 附上效果图                                  

<img width="600" src="/pictures/POST_1117_OpenWRT1.png" />
<img width="600" src="/pictures/POST_1117_OpenWRT2.png" />
<img width="600" src="/pictures/POST_1117_OpenWRT3.png" />
<img width="600" src="/pictures/POST_1117_OpenWRT4.png" />
<img width="600" src="/pictures/POST_1117_OpenWRT5.png" />
<img width="600" src="/pictures/POST_1117_OpenWRT6.png" />
<img width="600" src="/pictures/POST_1117_OpenWRT7.png" />
<img width="600" src="/pictures/POST_1117_OpenWRT8.png" />

</font>

***
