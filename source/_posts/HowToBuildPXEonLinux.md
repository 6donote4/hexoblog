---
title: 基于Linux搭建PXE网络引导环境之脚本编写与使用说明
tags: 
  - Linux
  - PXE
  - OpenWrt
  - Shell Script
categories: 
  - "使用说明"
date: 2020-01-04 16:26
top: 1120
---
<font size=4>
翻墙后，即可评论博文
PXE是一种可以提供网络引导启动的服务，主要用于通过网络硬盘启动计算机，即被启动的计算机内部没有硬盘，类似于网吧的运用情形。集群式的虚拟机安装操作系统的运用场景也适用（不过，一般只要安装创建了一个虚拟机之后，只要复制虚拟机就可以了，运用PXE，个人认为比较吃力费事），因笔者非专业人士，仅仅是好奇瞎折腾，在以往使用计算机的经验中，计算机启动进入操作系统的引导界面中，常常会出现网络引导的选项。笔者使用过光盘、U盘引导进入系统，现在开始试试网络引导，目前网络引导只尝试成功引导启动Linux系统网络安装镜像.
</font>
<!--more-->
<audio controls="controls" name="media" style="width:264px"  autoplay loop=true> <source src="/musics/huimengyouxian.mp3"> </audio>
<audio controls="controls" name="media" style="width:264px" loop=false> <source src="/musics/lovelovelove.mp3"> </audio>
<audio controls="controls" name="media" style="width:264px" loop=false> <source src="/musics/qianban.mp3"> </audio>
<audio controls="controls" name="media" style="width:264px" loop=false> <source src="/musics/wish.mp3"> </audio>
***

通过互联网检索资料，PXE网络引导服务的搭建需要两种服务的服务的配合，DHCP服务负责分配网络地址，并且DHCP通过配置能够识别网络引导请求，并通过文件传输服务，如tftp,nfs网络文件传输协议，来分发操作系统内核及启动文件。

在计算机获取内核和启动文件的过程中（这两个文件体积都比较小），dhcp使用ftp服务来传输给计算机，网络引导的计算机上的BIOS上存在着一个pxe客户端，可以获取到网络发送过来的内核及启动文件，计算机在获得操作系统内核时，会加载到内存运行，然后内存中的内核会驱动计算机的硬件，启动文件则会启动相关的服务。然后通过nfs网络传输协议，加载网络硬盘中的完整操作系统文件。整个过程就这样结束了。

本文参照网络上的配置过程，编写了一个交互式的配置脚本，方便以后再次配置，虽然是交互的脚本，但由于知识水平所限，目前还无法做到一键启用的效果，该脚本在使用之前，还有一些必要的准备操作要进行，因而，使用说明就是必要的了，防止以后遗忘了该脚本的用法，又得重新配置一遍。是必要的了，防止以后遗忘了该脚本的用法，又得重新配置一遍。

[点击该仓库链接](https://github.com/6donote4/debian-scripts/blob/master/OTHER/pxec.sh),可获取到该脚本。

使用该脚本需要nfs-server,dnsmasq,syslinux,若有提示缺失命令，这需要安装相应的软件包。

若提供网络引导的服务器，硬盘空间太小，比如Openwrt软路由系统，则配置前需要在另一台硬件配置较好的主机上提供nfs服务，该部分配置没在脚本中体现，所以使用前需将操作系统文件使用nfs共享出来,`vim /etc/exports`,编辑exports文件，添加共享文件路径，并附加访问权限。

==搭建步骤==

1. `bash pxec.sh -i`,执行该代码，进行搭建的初始化工作，该过程会提示输入提供nfs服务的主机地址和共享文件路径，如果网络引导服务器性能够强，则这两个参数可以任意填,并无视出错信息。

2. `bash pxe.sh -n`,执行该代码，在网络引导服务器本机提供nfs文件服务。

3. `bash pxe.sh -s`,执行该代码开始配置pxe,该代码依赖syslinux软件包，需要到[https://www.kernel.org](https://www.kernel.org) 网站上下载该软件包，或者在脚本中取消下载软件包的注释,该步骤会提示需要输入操作系统文件路径，内核文件名称，启动文件名称，根目录文件夹名称等参数。

4. `bash pxe.sh -d`,执行该代码配置dnsmasq，及dhcp服务

==相关截图与网络引导启动的效果==

初始化
<img width="600" src="/pictures/pxe/IMG_0011.JPG">

引导效果：

仅有网卡，无硬盘存储的虚拟主机
<img width="600" src="/pictures/pxe/Screenshot_20200101-225042_VNC Viewer.jpg" />

192.168.2.210为DHCP服务分配该带引导计算机的地址
<img width="600" src="/pictures/pxe/Screenshot_20200101-225231_Chrome.jpg" />

虚拟主机ipxe客户端启动界面
<img width="600" src="/pictures/pxe/Screenshot_20200101-225338_VNC Viewer.jpg" />
<img width="600" src="/pictures/pxe/Screenshot_20200101-225358_VNC Viewer.jpg" />

内核及启动文件加载到虚拟主机之后的引导界面
<img width="600" src="/pictures/pxe/Screenshot_20200101-225414_VNC Viewer.jpg" />

操作系统界面，这里使用的是debian安装盘的操作系统
<img width="600" src="/pictures/pxe/Screenshot_20200101-225448_VNC Viewer.jpg" />

***


