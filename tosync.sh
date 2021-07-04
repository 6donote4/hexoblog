#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#========================================
#Distribution:All
#Describtion:rsync my github blog and web blog code to a directory
#Author:6donote4 <mailto:do_note@hotmail.com>
#Version:0.0.1
#Dependencies:rsync
#Blogs: https://www.donote.tk https://6donote4.github.io
#=======================================
#git pull
#hexo g
#rsync -avz public/ $HOME/mygitrepo/6donote4.github.io
#rsync -avz public/ /var/www/blog/html
#rsync -avz public/ $HOME/mygitrepo/temp/6donote4.gitlab.io/public
rsync -avz public/ $HOME/mygitrepo/donote_blog
#hexo clean
exit 0



