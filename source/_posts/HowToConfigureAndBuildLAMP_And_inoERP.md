---
title: 「原创」LAMP环境部署与ERP系统部署记录
toc: false
tags:
  - LAMP
  - ERP 
categories:
  - "原创博文"
date: 2019-08-25 14:26
comments: true
top: 1119
---
<font size=4>

翻墙后，即可评论博文

本篇博文用于记录LAMP环境及ERP的部署过程。

LAMP即Linux，Apache，MySQL，PHP，也就是web服务环境。ERP即enterprise resources planning，也就是企业资源规划系统用于管理，监控企业的各种资源。
ERP系统不仅适用于企业实体，普通网店，个体经营户也可以使用。仅仅使用模块的多少之区别而已。
笔者的搭建环境为:Debian 10,使用的是开源的ERP系统[inoERP](https://github.com/inoerp/inoERP)进行部署。
另外，还配置了[Webmin](https://www.webmin.com),用于在Web浏览器上管理服务器，省去了更改配置文件及敲代码的时间。毕竟Mysql语句，笔者懂得并不多。使用Web页面管理数据库比较直观。
inoERP系统的模块有:仓库管理，销售管理,采购管理，BOM物料账单，成本管理，人力资源管理等。。。。

</font>
<!--more-->
<audio controls="controls" name="media" style="width:264px"  autoplay loop=true> <source src="/musics/huimengyouxian.mp3"> </audio>
<audio controls="controls" name="media" style="width:264px" loop=false> <source src="/musics/lovelovelove.mp3"> </audio>
<audio controls="controls" name="media" style="width:264px" loop=false> <source src="/musics/qianban.mp3"> </audio>
<audio controls="controls" name="media" style="width:264px" loop=false> <source src="/musics/wish.mp3"> </audio> 
***

<font size=4>

1. 下载，运行自动配置脚本，笔者已经将大部分的配置过程写成了自动脚本，运行完脚本可节省部署时间

```sh
apt-get install git
git clone https://github.com/6donote4/ERP.git
cd ERP
bash configure_env_for_inoERP.sh -c
```

安装完成之后，系统就已经自动配置好了LAMP环境,并且配置了Webmin管理面板,inoERP安装文件也在web根目录中。

2. 打开浏览器，在地址栏输入部署了LAMP的服务器其ip地址及webmin端口:10000,笔者的地址为: `https://192.168.2.20:10000`;登录账号为root账号，密码为root账号的密码。

3. 配置MySQL数据库 
  -  在webmin页面下,找到MySQL Database Server页面，点击Create Database,在Database输入数据库名称，点Create,返回Database list。
<img width="600" src="/pictures/Screenshot_20190825-130929_Firefox.jpg">
<img width="600" src="/pictures/Screenshot_20190825-141112_Samsung Internet.jpg">
  -  设置用户权限，点击User Permissions,点击Create new user,点user输入用户名,点any host,将permissions除superuser以外,全部勾选;点Create后，返回Database list,将permissions除superuser以外,全部勾选;点Create后，返回Database list。
<img width="600" src="/pictures/Screenshot_20190825-130929_Firefox.jpg">
<img width="600" src="/pictures/Screenshot_20190825-130955_Firefox.jpg">
  -  设置数据库权限,点击Database Permissions,点击Create new database Permissions,选中数据库selected ,输入上一步创建的用户名，Host选择any,Permissions全部选上后保存,返回Database list页面。
<img width="600" src="/pictures/Screenshot_20190825-130929_Firefox.jpg">
<img width="600" src="/pictures/Screenshot_20190825-131108_Firefox.jpg">
  -  变更MySQL Server监听地址,点击MySQL Sserver Configuration,将MySQL server listening address 选中any后Save and Restart MySQL。
<img width="600" src="/pictures/Screenshot_20190825-130929_Firefox.jpg">
<img width="600" src="/pictures/Screenshot_20190825-131156_Firefox.jpg">

4. 安装,部署inoERP系统
在浏览器地址栏输入服务器IP地址不需要带端口号。笔者的地址为: `http://192.168.2.20` ,浏览器会跳转到inoERP安装页面,点击Continue,Database Type选择MySQL/MariaDB;Database Host为服务器IP地址，Database Port为3306, 数据库名称及用户名均使用第3步配置的名称。填完后，点击Save and proceed。
经过一段时间之后，系统便会自动安装完成，完成后，刷新页面，点击右上角的login按钮,使用admin/admin或inoerp/inoerp,并选择好语言，按login就可登陆到ERP系统

<img width="600" src="/pictures/Screenshot_20190825-143219_VNC Viewer.jpg">
<img width="600" src="/pictures/Screenshot_20190825-143259_VNC Viewer.jpg">
<img width="600" src="/pictures/Screenshot_20190825-130414_VNC Viewer.jpg">
<img width="600" src="/pictures/Screenshot_20190825-131513_VNC Viewer.jpg">
<img width="600" src="/pictures/Screenshot_20190825-143450_VNC Viewer.jpg">

5. 在ERP系统内,修改管理员账号密码，创建新的用户名,并配置好权限，ERP系统就可以正式上线啦！
<img width="600" src="/pictures/Screenshot_20190825-131652_VNC Viewer.jpg">

6. 变更数据库字符集以支持中文字符
  ```sh
  mysql
  select CONCAT('alter table ',a.table_name,' convert to character set utf8mb4 collate utf8mb4_bin;')from (select table_name from information_schema.`TABLES` where TABLE_SCHEMA = '这里写数据库的名字其他地方不用改') a;
  ```
  输入上述代码获得inoERP数据库中，替换所有数据表字符集的命令。
  使用文本编辑器替换掉与命令无关的特殊符号。
  ```sh
  use 数据库名称
  粘贴编辑好的命令
  ```
  
### 补充 
  因inoERP开发团队已不再维护代码，且该系统缺乏说明文档，故弃掉inoERP.转向dolibarr.
  部署代码
  ```sh
  git clone https://github.com/6donote4/ERP.git
  cd ERP
  bash configure_env_for_dolibarr.sh -c
  ```
 </font>

 ***     
