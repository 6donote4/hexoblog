---
title: 「原创」Linux Shell 简易脚本编写之记录
tags:
- LinuxShellScript SQL数据库
categories:                                                                
- 原创博文
date: 2018-09-09 23:26
top: 1116
---
<font size=4>
最近,手头上已有三个主机了,并且都配置了frp内网穿透服务以实现远程控制,随着主机的增多,便萌生了编写交互式Shell脚本来更新和登录主机的需求,以及在Linux上进行文件处理的需求。
登录主机的脚本是建立在内网穿透服务搭建完成之后实现的，这里的脚本并未将搭建过程编写在内，而是另外写了个服务文件，让其主机启动时自动运行，并连接远程主机。frp配置服务见[我的debian-scripts](https://github.com/6donote4/debian-scripts)中的myfrp压缩文件包，可搜索网上资料进行frp服务的搭建。
</font>
<!--more-->

<audio
controls="controls" name="media" style='width:264px' autoplay loop=true>
<source src="/musics/wish.mp3">
</audio>

***
<font size=4>
附一张连接主机脚本的运行效果截图:
<img width="600" src="/pictures/post_1116_connect_to_host_shot.png" />
连接主机的Shell脚本代码:
<img width="600" src="/pictures/post_1116_code_2018-09-09_23-11-03.png" />
简单说明一下代码，比较重要的变量是USERNAME PORT，这两个变量是提供ssh命令进行远程主机连接的参数，HOSTNUM则是条件选择的触发变量，read命令在和用户交互的同时，将交互结果赋值进触发变量，在case语句中，符合触发变量的条件的，就会执行相应的语句。当我们退出远程主机时或者登录异常的时候，最后的if条件语句用于提示是否继续进行连接主机或者退出这个脚本。
文件清理删除的脚本代码:
<img width="600" src="/pictures/post_1116_delfile_code_2018-09-09_23-14-01.png" />
这个脚本中，OPERATION作为触发变量，FILESIZE和FILENAME则作为find命令的参数变量，当我们按照read的交互提示输入了文件名，和文件体积时，我们就能够删除掉小于设定文件体积的文件了，带empty的语句则是将空文件夹删除。最后的条件判断，依然是询问是否继续执行该脚本。

 ```bash
#!/bin/bash
#This shell script is used to update and upgrade Linux distribution system

while true
do
	echo "1)Debian/GNU APT"
	echo "2)ArchLinux/GNU PACMAN"
	read -p "Please select a release:" NUM
	echo "Selected $NUM)"
	case $NUM in
		1)
			proxychains apt-get update -y ;
			proxychains apt-get upgrade -y ;
			echo "done"
			;;
		2)
	                yes| proxychains pacman -Suu ;
	                echo "done"
			;;
		esac
    read -p "Does continue?:(y,n) " RESPONSE
            echo "$RESPONSE"
    if [ $RESPONSE == "n" ]; then
    	break
    fi
echo "done"
done
exit 0
```
这段脚本代码用于Linux发行版的操作系统更新，因目前主要接触的是Debian和ArchLinux系的发行版，所以只熟悉这两个发行版的包管理器，其他发行版的包管理方式其实网上是可以搜索的到的，不过我想玩多个发行版的Linux的人应该不是很多吧，熟悉一两种已经足够了。
网上泄露的数据库文件:
<img width="600" src="/pictures/post_1116_leak_data_2018-09-10_00-04-35.png" />
最近搞到了网上泄漏的数据库，好奇心驱使，很想去看看这些数据库到底有什么样的信息，不过大部分数据库单个文件的体积实在太大了，以4Gb内存的主机去打开一个高达8Gb以上的数据库文件，那是不可能办到的，只有少数较小的数据库能打开。那么，该怎么办呢？吾非专业的计算机人士，但我猜这需要搭建一个数据库查询系统，将数据库文件链接到该系统，以查询的方式，应该就能看里面的内容。不过目前还没什么头绪。就留着做搭建数据库系统的实验材料吧。有空慢慢研究，看看有关数据库的书籍，或许以后可以给自己的博客搭建一个评论系统，就不用使用Disqus这个被墙了的评论平台了。
</font>
***

