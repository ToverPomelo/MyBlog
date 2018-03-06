---
title: 利用旧安卓机打造伪家用Linux服务器
date: 2018-02-04 16:35:06
tags:
	- Android
	- Linux
categories:
	- Android安卓相关
	- Linux系统相关
src: 1.jpg
---
&emsp;&emsp;“知道有Termux后，我的红米1S复活了！”
<!--more-->
# 前言
&emsp;&emsp;Termux是一个安卓的终端模拟器，它与很多其他的终端模拟器的不同在于它多了很多命令，而我觉得最特别的是它居然内置了包管理工具apt和pkg，据说Termux自己维护了一个源，提供各种专门为termux定制的包。
&emsp;&emsp;还有一点，Termux是免root的，所以在“apt install …”时也不用加“sudo”
&emsp;&emsp;总而言之，Termux非常强大，于是我就打算利用它把我的旧红米1S打造成一个家用服务器。（好，这里广告打完了，顺便推荐一篇[写Termux写得挺好的博文](http://tonybai.com/2017/11/09/hello-termux/)）
# 准备工作
## ①安卓手机一台
&emsp;&emsp;据我所知Termux是只有安卓版本的，跟用苹果的朋友无缘了，在[官网](https://termux.com/)中也说明了：
```text
Termux is an Android terminal emulator and Linux environment app that works directly with no rooting or setup required.
```
&emsp;&emsp;对于安卓的手机也是有条件限制的——安卓的版本必须是5.0以上，不然会安装不了。这个在[官方的Wiki](https://wiki.termux.com/wiki/FAQ)中也有说明：
```text
Termux is only available on Android 5.0 or later. See https://github.com/termux/termux-app/issues/6 for more information.
```
&emsp;&emsp;如果手里的安卓机版本太低，可以考虑刷一下机（当然如果你舍得刷的话。。），像我的红米1S万年安卓4.4，为了装Termux最后还是刷了个[CM13](https://zh.wikipedia.org/wiki/CyanogenMod#CyanogenMod_13)(安卓6.0)。
## ②Termux软件一个
&emsp;&emsp;这个在[官网](https://termux.com/)下载安装就可以了，懂得"climb over the wall"的可以直接在Google Play下载，在F-Droid也可以，另外国内的应用商店里好像也有。
## ③Root(可选)
&emsp;&emsp;只是使用Termux的话是不用root的，但是想要用得更爽的话，有root会方便很多。如果不想root的可以跳过。</br>
&emsp;&emsp;Root的方法网上有很多，MIUI的话可以刷开发版，CyanogenMod的话好象是自带的，实在不行下个刷机精灵之类的软件线刷就好。
## ④Busybox(可选)(须Root)
&emsp;&emsp;据说有了[Busybox](https://zh.wikipedia.org/wiki/BusyBox)会使命令更全，虽然我觉得Termux的命令也是挺全的，但装了也没有坏处。这个可选，但安装的话需要root权限。
![busybox的介绍和它的命令](deemo2.jpg)
## ⑤一个适合打代码的键盘
&emsp;&emsp;想象一下你在用Vim的时候没有Esc键的感觉。。</br>
&emsp;&emsp;这里我推荐CodeBoard([Google Play](https://play.google.com/store/apps/details?id=com.gazlaws.codeboard) , [豌豆荚](http://www.wandoujia.com/apps/com.gazlaws.codeboard))，如果舍得的话买一个蓝牙键盘也是不错的选择。
# 探索：更多玩法
&emsp;&emsp;到这里，服务器就搭好了（你没看错！），但是一个空的服务器没什么用，接下来就要在里面安装各种应用。
## ①访问手机储存
&emsp;&emsp;Termux里的文件是放在应用的内部存储里的，看一下它的home目录，比如输入：
```bash
    echo $HOME
```
&emsp;&emsp;会得到：
```bash
    /data/data/com.termux/files/home
```
&emsp;&emsp;这样的话要访问手机里的文件就有点困难，下面介绍三种方法访问手机的文件：</br>
⑴  按照官方的方法的话，是先在手机的应用权限里授予手机储存访问权限，然后输入：
```bash
    termux-setup-storage
```
&emsp;&emsp;这样在home目录里面就会多了个storage目录，里面的文件就是手机储存里面的相应文件:
![在storage目录下还有这几个目录](deemo1.jpg)
&emsp;&emsp;参考一下官方的说法：
```text
To grant storage permissions in Android goto Settings>Apps>Termux>Permissions and select storage, then run termux-setup-storage in Termux.
```
⑵ 直接访问：
```bash
    cd /storage/emulated/0
    ls
```
&emsp;&emsp;因为这个文件夹是可读写的（在设置中授予读写权限后），所以可以直接访问，如果是外置的储存卡的话要知道外置储存卡的路径才能用这种方法。
⑶ 创建符号链接，跟方法二类似：
```bash
    ln -s /storage/emulated/0 ~/storage(←这个名字和路径是自己取的)
```
## ②OpenSSH
&emsp;&emsp;首先要远程链接的话要用到[ssh(Secure Shell)](https://zh.wikipedia.org/wiki/Secure_Shell),刚安装好的Termux是不能用ssh的，输入“ssh”的话会提示：
![](deemo002.jpg)
&emsp;&emsp;根据提示敲"pkg install openssh"或者"apt install openssh"安装OpenSSH。</br>
&emsp;&emsp;如果要链接远程设备的话可以输入（前提是对方开了ssh服务）：
```bash
#链接：
	ssh 用户名@IP地址 -p 端口号
#下载：
	scp -P 端口号 用户名@IP地址 本地路径
#上传：
	scp -P 端口号 本地路径 用户名@IP地址
```
&emsp;&emsp;端口号默认是22,是默认的话可以不输入（记得-p也不要打）。看不懂我写的可以参考一下[这里](https://www.jianshu.com/p/b70089f4c187)。</br>
&emsp;&emsp;如果要开启服务器（我说的是那个安卓手机）的ssh服务的话可以使用命令：
```bash
    sshd -p 端口号
```
&emsp;&emsp;不加端口号（"-p"也是）的话是默认端口号8022（如果是Linux的话默认是22，据说安卓为了保护端口开1024以下的端口）。</br>
&emsp;&emsp;其他设备要连接服务器时要知道服务器的IP，可以用命令：
```bash
    ifconfig
```
&emsp;&emsp;然后找到最像IP地址的那个（通常连接路由器的话是192.168.\*.\*），另外，如果没有公网IP的话（家用的估计也是没有的了。。）两个设备要连接同一个内网（Wifi）。
![最像IP的IP](deemo4.jpg)
&emsp;&emsp;上面的搞定之后还是不能直接连上的，因为Termux不支持使用密码登陆，所以只能使用免密码登陆，[官方](https://termux.com/ssh.html)原话：
```text
The Termux sshd binary does not support password logins, so a key needs to be authorized in ~/.ssh/authorized_keys before connecting. Use ssh-keygen to generate a new one if desired.
```
&emsp;&emsp;首先要在自己的设备（不是指那个安卓手机）上生成私钥（已经有的可以跳过，就是在 ~/.ssh 里有 id_rsa.pub 这个文件）：
```bash
    ssh-keygen -t rsa
```
&emsp;&emsp;在生成的时候可能会让你输一个密码（好像是“Enter passphrase (empty for no passphrase)”）不需要的可以直接回车，如果输入了的话要记住，以后每次登陆都会用到。</br>
&emsp;&emsp;然后找到 ~/.ssh 里的 id_rsa.pub 这个文件想方设法把里面的内容复制到服务器（安卓手机）的 ~/.ssh 目录下的 authorized_keys 文件里面。方法有很多，可以直接复制粘贴，也可以两个文件放在同一目录后执行(重定向输出)：
```bash
    cat id_rsa.pub >> authorized_keys
```
&emsp;&emsp;如无意外的话到这里就配置成功了，ssh免密码登陆看不懂的话可以参考[这里](https://www.jianshu.com/p/e9db116fef8c)。
## ③Vim
&emsp;&emsp;[Vim](http://www.vim.org/)是Linux上一个功能强大的文本编辑器（有多强大？用一下就知道咯。），用以下命令安装：
```bash
    pkg install vim
```
&emsp;&emsp;顺便推荐一个[可以一键安装的vim插件](https://github.com/ma6174/vim-deprecated)（这个比较旧了，都没有维护了），里面的自动安装在安卓机上是不适用的，但是可以在电脑上装好后再覆盖home目录下的 .vim 文件夹和 .vimrc 文件，这两个文件是隐藏的，可以通以下命令查看：
```bash
    ls -a
```
&emsp;&emsp;Vim的教程[网上](http://www.runoob.com/linux/linux-vim.html)很多，嫌网上找麻烦的可以在vim里输入：
```bash
   :help
```
![help文档，不过是英文的](deemo5.jpg)
&emsp;&emsp;查看官方的教程（没改过的话是英文的），如果实在嫌vim用起来麻烦的话可以用nano：
```bash
    pkg install nano
```
## ④GCC
&emsp;&emsp;如果是还在用C或C++的话应该对它非常熟悉，简单地说，[GCC](https://zh.wikipedia.org/wiki/GCC)就是个编译器，在Termux中，输入gcc的话它会提示你安装Clang，简单地说，[Clang](https://zh.wikipedia.org/wiki/Clang)也是一个编译器。
![](deemo001.jpg)
&emsp;&emsp;执行以下命令安装：
```bash
    pkg install clang
```
&emsp;&emsp;安装Clang后同样可以使用gcc或者是g++命令编译C或者C++文件。
## ⑤make
&emsp;&emsp;有了[make](https://zh.wikipedia.org/wiki/Make)，就可以[从源码安装Linux软件](https://www.linuxidc.com/Linux/2015-04/115812.htm)了，同样用pkg安装：
```bash
    pkg install make
```
## ⑥git
&emsp;&emsp;[git](https://git-scm.com/)这个东西我只是用过在[Github](https://github.com/)上下载和上传文件，所以我会的也不多- -。安装git:
```bash
    pkg install git
```
&emsp;&emsp;用来下载的话是命令：
```bash
    git clone 地址 本地路径(省略的话就是当前路径)
```
&emsp;&emsp;创建仓库的话可以参考[这个](https://lellansin.wordpress.com/2013/02/21/git-%E5%9F%BA%E7%A1%80%E6%93%8D%E4%BD%9C-%E4%B8%80/)。
## ⑦Scheme
&emsp;&emsp;如果有看[SICP](https://zh.wikipedia.org/wiki/%E8%AE%A1%E7%AE%97%E6%9C%BA%E7%A8%8B%E5%BA%8F%E7%9A%84%E6%9E%84%E9%80%A0%E5%92%8C%E8%A7%A3%E9%87%8A)的话，肯定会忍不住装一个Scheme（像我- -），在Termux里装的是 tinyscheme ，同样用pkg：
```bash
    pkg install tinyscheme
```
&emsp;&emsp;运行的话是：
```bash
#直接运行：
	tinyscheme
#运行文件：
	tinyscheme 文件
```
&emsp;&emsp;有一个不太方便的就是tinyscheme不支持方向键，如果打了一大串发现前面少了个括号的话。。。解决方法我是参考[这篇文章](http://deathking.github.io/2015/08/07/armored-your-mit-scheme/)。首先安装rlwrap：
```bash
    pkg install rlwrap
```
&emsp;&emsp;然后按照那篇文章的，生成 .scheme_completion.txt 文件：
```bash
    cd ~
    touch .scheme_completion.txt
```
&emsp;&emsp;把那个[gist](https://gist.github.com/bobbyno/3325982)里面的东西复制进去（或者直接 git clone 那个文件也行）。</br>
&emsp;&emsp;运行时用以下命令(注意这里是tinyscheme，因为我们没有scheme这个命令)：
```bash
    rlwrap -r -c -f "$HOME"/.scheme_completion.txt tinyscheme
```
&emsp;&emsp;这样的话就可以用方向键了（还有那篇文章里的SLIB我还没装成功，你们谁装好的教我一下啊~），但是每次运行都输入这么一大串命令的话也是挺麻烦的，为了方便，我先把他写成一个脚本。另外，为了可以输入 scheme 就可以运行，我把它放进bin目录里。</br>
&emsp;&emsp;首先Termux的bin目录是在home目录上层的usr目录里面：
```bash
    cd ~/../usr/bin
```
&emsp;&emsp;然后创建一个叫 scheme 的文件：
```bash
    touch scheme
```
&emsp;&emsp;给予[777权限](https://zhidao.baidu.com/question/9603503)：
```bash
    chmod 777 ./scheme
```
&emsp;&emsp;然后把脚本复制进去：
```bash
    echo rlwrap -n -r -c -f  "$HOME"/.scheme_completion.txt tinyscheme $@ > ./scheme
```
&emsp;&emsp;或者用vim打开把这个复制进去也行(注意是tinyscheme！不然就是一个递归的死循环了！)：
```bash
    rlwrap -n -r -c -f  "$HOME"/.scheme_completion.txt tinyscheme $@
```
&emsp;&emsp;然后就可以直接用 scheme 命令运行了：
```bash
#直接运行：
	scheme
#运行文件：
	scheme 文件
```
![](deemo6.jpg)
## ⑧Node.js
&emsp;&emsp;如果想用服务器（那个安卓手机）来运行网站的话，可以用[Node.js](https://nodejs.org/zh-cn/)（当然可以用其他，只是我只会这个- -），安装的话可以：
```bash
    pkg install nodejs
```
&emsp;&emsp;查看是否安装成功的话可以：
```bash
    node -v
```
![](deemo7.jpg)
&emsp;&emsp;另外npm应该也是一起安装的：
```bash
    npm -v
```
![](deemo8.jpg)
&emsp;&emsp;运行的话是用命令 node ，但有些时候好像是要用命令 nodejs 的（忘了是什么时候了），所以保险一点把这个命令复制一份：
```bash
    cp ~/../usr/bin/node ~/../usr/bin/nodejs
```
&emsp;&emsp;到这里Node.js就安装完了，如果要试着玩一下的话可以先装个[Express](https://github.com/expressjs/express):
```bash
    npm install -g express-generator
```
&emsp;&emsp;然后到你想要的目录里运行：
```bash
    express web(←这个名字是自己取的)
```
&emsp;&emsp;然后就创建了一个 web 目录，进去这个目录里，然后执行：
```bash
    cd web
    npm install
```
&emsp;&emsp;把做好的网页改名为 index.html （不改也行，改了方便一点），放到 web/public/ 里面，然后运行：
```bash
    npm start
```
![](deemo9.jpg)
&emsp;&emsp;然后就会提示网站在端口 3000 运行（没改过的话是3000）,要改端口的话是在 web/bin/www 文件里。用 ifconfig 得到IP后，在内网输入 IP:端口 就可以了。</br>
&emsp;&emsp;Node.js要讲的话东西还有很多，这里只是介绍一下。
## ⑨个性化bash
&emsp;&emsp;刚安装Termux时，bash的提示符就只有一个"$"，怎么看这个也太简单了，如果知道如何[定制个性化的bash](http://www.cnblogs.com/killkill/archive/2010/06/01/1749012.html)的话，肯定不会满足这样的提示符。下面介绍一下个性化Termux的bash的方法：
![](deemo003.jpg)
&emsp;&emsp;一个方法是[上面那篇文章](http://www.cnblogs.com/killkill/archive/2010/06/01/1749012.html)说的：
```bash
    export PS1="这里填你想要的提示符"
```
&emsp;&emsp;这里的原理其实就是修改[环境变量PS1](http://blog.51cto.com/xiaozhuang/844781)，PS1就是主提示符变量。但是我用这个方法的时候，在重启Termux后提示符就会恢复为"$"，所以就有了方法二（修改[bashrc](https://zhidao.baidu.com/question/129164766.html)）：</br>
&emsp;&emsp;在Termux中，bashrc是在 /data/data/com.termux/files/usr/etc/
或者 ~/…/usr/etc/ 里面，叫做 bash.bashrc 。要修改提示符变量的话只须在 bash.bashrc 里面添加：
```bash
    PS1='这里填你想要的提示符'
```
&emsp;&emsp;修改完以后要重启一下bash。比如说我的提示符就是：
```bash
    PS1='\[\033[01;31m\]☂  \[\033[02;00m\]\t\[\033[01;34m\] \w\n\[\033[01;32m\]\u@Android\[\033[00m\] \[\033[02;00m\]\$'
```
![](deemo10.jpg)
&emsp;&emsp;另外，如果是用vim修改显示不了unicode字符的话，可以在 ~/.vimrc 里面添加：
```bash
    set encoding=utf-8
```
## ⑩sudo(须root)
&emsp;&emsp;在真正的Linux系统中，要切换为超级用户只需要输入
```bash
    su
```
&emsp;&emsp;在Termux中使用 su 的话，虽然可以切换为超级用户，但是有很多Termux的命令都用不了（像普通的终端模拟器一样），这样在用需要root的操作时就极不方便。</br>
&emsp;&emsp;对此，Termux提供的方法是使用tsu：
```bash
    pkg install tsu
```
&emsp;&emsp;另一种获得权限的方法是 [sudo](https://zh.wikipedia.org/wiki/Sudo) ，这种方法的优点是不用切换为超级用户就可以获得权限。
```bash
    sudo 需要权限才能执行的命令
```
&emsp;&emsp;在Termux是没有sudo命令的，但是可以自己添加（前提是可以使用su）。具体参考[st42的github](https://github.com/st42/termux-sudo)。</br>
&emsp;&emsp;首先安装 ncurses-utils ：
```bash
    pkg install ncurses-utils
```
&emsp;&emsp;下载[github](https://github.com/st42/termux-sudo)上的文件：
```bash
    git clone https://github.com/st42/termux-sudo.git
```
&emsp;&emsp;进入目录后，执行以下命令把 sudo 放到 bin 目录下：
```bash
    cat sudo > /data/data/com.termux/files/usr/bin/sudo
```
&emsp;&emsp;然后给予 sudo 读写权限：
```bash
    chmod 700 /data/data/com.termux/files/usr/bin/sudo
```
&emsp;&emsp;到这里sudo就安装好了。su、tsu和sudo在Termux中各有自己的优点和缺点。我推荐的话是三个对比着用，哪个适当的话就用哪个。
![sudo的用法](deemo12.jpg)
![tsu，退出时输入exit](deemo13.jpg)
![su，可以看到bash的提示符都变了](deemo14.jpg)
## ⑪其他
&emsp;&emsp;还没想到，我想到再写吧~
# 补充
&emsp;&emsp;可能是因为安卓手机休眠后会关闭后台进程（省电），有时熄屏后会出现ssh连不上或者nodejs的网页打不开的情况，有时还会vim等了很久都还没打开，最终要按亮屏幕才能打开。这样每次都要按亮屏幕的话就会很不方便，所以就有了以下这个还算好的解决办法（须root）：</br>
&emsp;&emsp;首先让手机不休眠，这个的话通常在手机的设置里就有（如果没有不休眠的这个选项的话就选时间最长的那个，比如我的CyanogenMod最长只能选 无操作30分钟后休眠 ）。</br>
&emsp;&emsp;因为手机耗电的主要是屏幕，接下来把屏幕亮度调到最低。调节安卓手机屏幕亮度的话可以修改
```bash
    /sys/class/leds/lcd-backlight/brightness
```
&emsp;&emsp;这个文件，这个文件里面写的是一个范围在0到一个储存在同目录下叫 max_brightness 的文件里的数字，我们要最暗的话只须写入0。首先要给这个文件读写权限：
```bash
    sudo chmod 666 /sys/class/leds/lcd-backlight/brightness
```
&emsp;&emsp;然后写入0:
```bash
    echo 0 > /sys/class/leds/lcd-backlight/brightness
```
&emsp;&emsp;如无意外的话会看见手机像熄屏了一样，但是这只是设置成没有亮度，其他的还是跟亮屏时一样。</br>
&emsp;&emsp;注意这样的话会比平时更耗电，请考虑过后才操作。</br>
&emsp;&emsp;最后把它写脚本：
```bash
#比如说我的文件名叫做 brightness.sh

#检测有没有读写权限，没有的话就给予读写权限
    if [ ! -w /sys/class/leds/lcd-backlight/brightness -o ! -r  /sys/class/leds/lcd-backlight/brightness ]
    then
	sudo chmod 666 /sys/class/leds/lcd-backlight/brightness 
    fi

#判断是否在范围内
    if [ $1 -ge 0 -o $1 -le 255 ]
    then
#把亮度写进brightness文件
	echo $1 > /sys/class/leds/lcd-backlight/brightness 
	echo Setted brightness to $1
    else
	echo Error!
    fi
#最后看看亮度有没有改变
    echo Now brightness is:
    cat /sys/class/leds/lcd-backlight/brightness
```
&emsp;&emsp;使用的时候是（在文件所在路径）：
```bash
    sh ./brightness 一个亮度的数字(比如0)
```
# 总结
&emsp;&emsp;一番折腾后，手机已经比较像个服务器了，为什么一部安卓手机可以弄成一个像Linux的服务器？因为安卓的内核就是Linux！参考[☛这个](http://www.techug.com/post/linux-and-android.html)。
&emsp;&emsp;






