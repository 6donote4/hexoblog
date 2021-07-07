---
title: 「原创」如何为软路由编译OpenWRT固件
tags:
  - OpenWRT 
  - 固件编译 
  - 软路由
  - LEDE
  - 精神出国
categories:
  - "原创博文"
date: 2019-05-30 21:26
updated: 2019-05-30 21:36
comments: true
top: 1118
---
<font size=4>

翻墙后，即可评论博文
之前一篇博文记录关于虚拟机路由器的搭建过程，使用了KoolShare家的固件进行搭建。由于KoolShare固件并不是开源的，运行这个固件只有二进制代码，非常不透明，我们并不知道这个固件是否会有后门，偷偷的将我们的精神出国工具收集上传到所谓的酷软中心服务器。为了避免这种可能性，选择了开源的适合国内网络环境的LEDE代码仓库，自行编译定制属于自己的软路由固件。本篇博文出于这个目的，来记录软路由固件的编译过程。待重新编译时，可回顾一下这个过程。
编译过程使用了恩山社区L大的源码包进行编译，在此基础上，汇整了ChinaDNS,Koolproxy源码包，解除ssr-plus插件的解锁代码，纠正一处Makefile错误，使得SSR-plus可以顺利编译。
因amule和softetherVPN在编译过程中出错，无法解决问题，只能放弃了这两个包。
因硬件路由性能并不如软路由，而且需要考虑各种架构问题。因此只编译x86_amd64的固件。

</font>

<!--more-->
<audio controls="controls" name="media" style="width:264px"  autoplay loop=true> <source src="/musics/huimengyouxian.mp3"> </audio>
<audio controls="controls" name="media" style="width:264px" loop=false> <source src="/musics/lovelovelove.mp3"> </audio>
<audio controls="controls" name="media" style="width:264px" loop=false> <source src="/musics/qianban.mp3"> </audio>
<audio controls="controls" name="media" style="width:264px" loop=false> <source src="/musics/wish.mp3"> </audio> 

***

<font size=4>

1. 搭建编译环境
  - 使用任意平台的宿主机和任意一种虚拟化软件，下载Ubuntu 14 64 Bit Linux server 发行版并安装到虚拟机中，Ubuntu系统盘可只分配8Gb的硬盘空间，安装时选择ssh server,编译时需要另外创建一块40GB的虚拟磁盘，用于存放编译产生的对象文件。我选择使用Manjaro作为宿主系统平台，使用qemu+libvirt(KVM虚拟机）来搭建编译环境。
  - 安装完系统到虚拟机后，使用``/etc/init.d/ssh enable`` 和 ``/etc/init.d/ssh start `` 启用ssh 服务。
  - 宿主机ssh登录Ubuntu虚拟机， ``ssh username@vmip`` ip地址可使用 ``ifconfig``查看。
  - 更新系统源，并安装编译固件所需的依赖包

  ```sh
sudo apt-get update
sudo apt-get -y install build-essential asciidoc binutils bzip2 gawk gettext git libncurses5-dev libz-dev patch unzip zlib1g-dev lib32gcc1 libc6-dev-i386 subversion flex uglifyjs git-core gcc-multilib p7zip p7zip-full msmtp libssl-dev texinfo libglib2.0-dev xmlto qemu-utils upx libelf-dev autoconf automake libtool autopoint proxychains 
  ```

2. 为编译工作配置一个通畅的网络环境
由于众所周知的原因，在中国下载编译某些软件源码包时，网络环境非常糟糕。这时，需要路由器提供全局代理服务。如果路由器没有全局代理的话，可以考虑使用宿主机建立代理，proxychains 让虚拟机终端命令走宿主机代理的方式。
现记录proxychains配置的网络环境。
  - 宿主机使用v2ray，shadowsocks , shadowsocksr 等，使用自行搭建的远程服务器或者其他机场账号建立代理。
  - ``echo "http 192.168.10.1 3120" >> /etc/proxychains.conf `` ,192.168.10.1为宿主机在虚拟机网络中的IP地址，可自行设置任意ip,设置proxychains的配置文件。

3. 编译流程
  - 获取源码
  ```sh
proxychains git clone https://github.com/openwrt/openwrt.git
proxychains git clone https://github.com/6donote4/kvmLeanWRT.git
  ```
  - 拷贝已经配置好的编译配置文件及Lean包到OpenWRT编译目录
  ```sh
cp -rf ./kvmLeanWRT/package/lean ./openwrt/package/ 
cp -rf ./kvmLeanWRT/config ./openwrt/.config
  ```
  - 拉取源码更新并编译
  ```sh
cd openwrt 
proxychains ./scripts/feeds update -a 
proxychains ./scripts/feeds install -a 
make -j4 V=s menuconfig 
proxychains make -j1 V=s
  ```
  - 编译过程注意点
弹出编译选择框之后，移动光标选择load,保持.config不动,选确定 目录内的编译配置文件已经编译成功过，保持该配置，如果梯子没问题 可一次成功。编译前下载dl包到openwrt目录。可以缩短编译时间。 本人在重编译的过程中，因梯子未配置ipv6,在编译python包的出现错误， 此时撤掉梯子，直接make -j4 V=s，就不会有问题了。
  - 完成编译
编译完成后的目标文件在 openwrt/bin/target/x86_64 目录下。 编译时，虚拟机磁盘最好分配40GB。编译成功的输出结果见下图:
<img width="600" src="/pictures/OpenWRT_Compilation/Screenshot_20190525-184223_VNC Viewer.jpg">
生成的目标文件:
<img width="600" src="/pictures/OpenWRT_Compilation/Screenshot_20190525-184331_VNC Viewer.jpg">
  - 固件烧写
在任意一种虚拟化平台上运行任意Linux发行版(vbox,vmware,kvm等),创建一块虚拟机空白磁盘用于烧写固件，选择固件镜像以虚拟磁盘方式挂到虚拟机中，作为烧写输入文件。
  ```sh
sudo fdisk -l #查找盘符,确认出镜像盘如(/dev/sda),目标盘如(/dev/sdb),开始烧写。
sudo dd if=/dev/sda of=/dev/sdb
  ```
使用gparted 调整sdb磁盘空间。 烧写完成。
- 配置OpenWRT，软路由开始运作。
挂载到虚拟机实例，进入openWRT后，在openwrt虚拟机内更改密码， 启动web服务，设置LAN ip地址。
  ```sh
passwd 
/etc/init.d/uhttpd enable 
/etc/init.d/uhttpd start 
vi /etc/config/network 
/etc/init.d/network restart
  ```
  - 运行效果图:
<img width="600" src="/pictures/OpenWRT_Compilation/Screenshot_20190525-195634_Firefox.jpg">
<img width="600" src="/pictures/OpenWRT_Compilation/Screenshot_20190525-195659_Firefox.jpg">
<img width="600" src="/pictures/OpenWRT_Compilation/Screenshot_20190525-195911_Firefox.jpg">
<img width="600" src="/pictures/OpenWRT_Compilation/Screenshot_20190525-200015_Firefox.jpg">
<img width="600" src="/pictures/OpenWRT_Compilation/Screenshot_20190525-200115_Firefox.jpg">
<img width="600" src="/pictures/OpenWRT_Compilation/Screenshot_20190525-200205_Firefox.jpg">
<img width="600" src="/pictures/OpenWRT_Compilation/Screenshot_20190525-200219_Firefox.jpg">
<img width="600" src="/pictures/OpenWRT_Compilation/Screenshot_20190525-200237_Firefox.jpg">
<img width="600" src="/pictures/OpenWRT_Compilation/Screenshot_20190525-200257_Firefox.jpg">
<img width="600" src="/pictures/OpenWRT_Compilation/Screenshot_20190525-200342_Firefox.jpg">
<img width="600" src="/pictures/OpenWRT_Compilation/Screenshot_20190525-200629_Firefox.jpg">
<img width="600" src="/pictures/OpenWRT_Compilation/Screenshot_20190525-200648_Firefox.jpg">
<img width="600" src="/pictures/OpenWRT_Compilation/Screenshot_20190525-200706_Firefox.jpg">
<img width="600" src="/pictures/OpenWRT_Compilation/Screenshot_20190525-200721_Firefox.jpg">
<img width="600" src="/pictures/OpenWRT_Compilation/Screenshot_20190525-200733_Firefox.jpg">
<img width="600" src="/pictures/OpenWRT_Compilation/Screenshot_20190525-200738_Firefox.jpg">
<img width="600" src="/pictures/OpenWRT_Compilation/Screenshot_20190525-200757_Firefox.jpg">
<img width="600" src="/pictures/OpenWRT_Compilation/Screenshot_20190525-200824_Firefox.jpg">
<img width="600" src="/pictures/OpenWRT_Compilation/Screenshot_20190525-201121_YouTube.jpg">
<img width="600" src="/pictures/OpenWRT_Compilation/Screenshot_20190525-201144_YouTube.jpg">
[点击此处获取固件](https://github.com/6donote4/kvmLeanWRT/releases)

 </font>

 ***     
