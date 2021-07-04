---
title: 【原创】基于Debian10环境下搭建OpenWrt实体软路由系统之文档说明与演示
tags: 
  - Debian
  - OpenWrt
  - Shell Script
categories: 
  - "使用说明"
date: 2020-01-30 22:16
top: 1121
---
<font size=4>

关于OpenWrt固件的升级，在虚拟机中，笔者一直倾向于使用rootfs-combined-ext4来刷写升级，然后，在另外的虚拟机系统中扩展OpenWrt 根分区容量。
而rootfs-combined-squashfs 则可直接web升级，但是不能扩展分区容量。对磁盘空间来说，是一种浪费。
关于实体软路由的OpenWrt 固件升级，运用在虚拟机上的方案亦是可行的,但缺点是进行升级维护操作的时候，要挂载U盘系统，进入U盘系统，需不断按启动引导菜单键。

于是，便有了安装OpenWrt/Debian10 双系统的想法，这样就能ssh登录debian系统，将所有配置文件及脚本scp传送过去，即便是在手机上，也能完成的OpenWrt的维护。

实现上述需求需要使用rootfs-ext4文件镜像及vmlinuz内核文件,开篇提及的两种镜像格式则是将这两者合并起来的。只有这两者分离，才可实现双系统的部署。
正好，前篇博文涉及了pxe的部署，对于Linux系统的运作原理有了一定的了解，给笔者部署双系统提供了方向。即，vmlinuz 放置在"/boot"，Grub引导程序配置文件设置好内核及"/"目录路径，电脑启动时，先加载内核文件到内存运行，通过CPU，内核不断的加载相关的硬件驱动，并挂载系统更目录，然后运行相关服务，计算机启动完成。

本博文用于对该部署脚本进行使用上的说明，以及相关操作的动画演示，方便以后，再次部署时，快速完成部署，节省时间。

</font>
<!--more-->
<audio controls="controls" name="media" style="width:264px"  autoplay loop=true> <source src="/musics/huimengyouxian.mp3"> </audio>
<audio controls="controls" name="media" style="width:264px" loop=false> <source src="/musics/lovelovelove.mp3"> </audio>
<audio controls="controls" name="media" style="width:264px" loop=false> <source src="/musics/qianban.mp3"> </audio>
<audio controls="controls" name="media" style="width:264px" loop=false> <source src="/musics/wish.mp3"> </audio>
***
<font size=9>
# 基于Debian 10环境的OpenWrt镜像刷写脚本
[脚本仓库地址](https://github.com/6donote4/OpenWrt-Debian-Grub)

使用虚拟机搭建软路由者可略过本文档说明，使用本人仓库中的脚本反而更加复杂。

## 什么样的情况需要使用本脚本 ?

- 不想使用rootfs-squashfs格式的系统镜像将硬盘全盘刷写,避免磁盘空间的浪费
- 使用rootfs-ext4来避免rootfs-suqshfs格式镜像无法扩展分区容量的情况
- 避免升级系统的时候，需要额外挂载磁盘来进行维护的情况
- 确保上述条件下，快速搭建实体软路由系统

## 依赖

- Debian 10 Linux发行版
- parted 分区工具
- update-grub2 引导启动器
- OpenWrt-x86-64-rootfs-ext4.img 根目录文件镜像
- OpenWrt-x86-64-vmlinuz 内核文件
- Linux发行版安装经验
- Linux系统分区知识

## 功能

- 在Debian发行版环境下，刷写OpenWrt 固件到指定分区，并扩展OpenWrt的根分区
- 在OpenWrt/Debian双系统的情况下，变更系统启动顺序，使OpenWrt为默认启动系统
- 使用备份文件恢复OpenWrt配置
- 使用最新的镜像及系统内核文件升级OpenWrt固件

## 用法：
### 纯命令行脚本 

1. 给磁盘分区并格式化
    - 划分四个分区(MBR): 
        swap交换分区 boot(ext2)启动文件分区 root(ext4 being used to mount Debian / directory)Debian系统根分区 
    - 剩余的磁盘空间用于烧写、挂载OpenWrt根分区(ext4)
2. 安装Debian 10 发行版到磁盘中
3. 复制本仓库目录，并在目录中包含OpenWrt-x86-64-rootfs-ext4.img.gz 、 OpenWrt-x86-64-vmlinuz和 OpenWrt 配置备份文件到Debian发行版所在磁盘目录(使用ssh登录机器进行操作)
4. 执行openwrt_grub_config.sh脚本 :
    - 完整配置:

        ```sh
        ./openwrt_grub_config.sh -m
        ```

    - 升级OpenWrt:

        ```sh
        ./openwrt_grub_config.sh -u
        ```

    - 恢复OpenWrt配置:

        ```sh
        ./openwrt_grub_config.sh -r
        ```

    - 调整OpenWrt分区大小:

        ```sh
        ./openwrt_grub_config.sh -s
        ```
    - 重启计算机:
    
        ```sh
        reboot
        ```

### 带UI脚本，基于dialog

  执行  `./openwrt_grub_config.sh`

## 操作动画:
<img width="600" src="/pictures/Peek2020-1-30.gif">
<img width="600" src="/pictures/Peek2020-02-03-23-33.gif">
</font>
***


