---
title: 使用Audacity制作音乐伴奏过程
toc: false
tags:
  - Audacity 音乐伴奏
categories:
  - "教程记录"
date: 2020-07-19 16:26
top: 1122
---
<font size=4>
翻墙后，即可评论博文

本博文用于记录音乐伴奏的制作过程
</font>
<!--more-->
<audio controls="controls" name="media" style="width:264px"  autoplay loop=true> <source src="/musics/huimengyouxian.mp3"> </audio>
<audio controls="controls" name="media" style="width:264px" loop=false> <source src="/musics/lovelovelove.mp3"> </audio>
<audio controls="controls" name="media" style="width:264px" loop=false> <source src="/musics/qianban.mp3"> </audio>
<audio controls="controls" name="media" style="width:264px" loop=false> <source src="/musics/wish.mp3"> </audio>
***
<font size=4>

① 导入音频文件，分离音轨。

<img width="600" src="/pictures/Audacity/audicaty1.png" />

② 选择其中一个声道，应用反相(上下)特效。

<img width="600" src="/pictures/Audacity/audicaty2.png" />

③ 补正高音，再次导入源音频文件，选择音频文件的立体声轨，并运用增幅效果将幅值衰减10dB

<img width="600" src="/pictures/Audacity/audicaty3.png" />

<img width="600" src="/pictures/Audacity/audicaty4.png" />

④ 再次选中立体声轨，运用曲线过滤器(Filter Curve),将100Hz-5000Hz区间内的数值全部降至最低，（-∞，100]与[5000,+∞]Hz区间的数值调高至10dB

<img width="600" src="/pictures/Audacity/audicaty5.png" />

<img width="600" src="/pictures/Audacity/audicaty6.png" />

⑤ 导出已编辑的音频。

<img width="600" src="/pictures/Audacity/audicaty7.png" />

</font>


***

