---
title: 限制EasyUI窗口的移动区域
date: 2018-02-10 17:25:43
tags:
	- web
	- 前端
categories:
	- Web网络相关
src: 1.jpg
---
&emsp;&emsp;前段时间使用EasyUI的Window插件时发现生成的窗口移动范围是整个页面，不能限制在一个区域，折腾了许久才找到解决方法。
<!--more-->
# 关于EasyUI的Window插件
&emsp;&emsp;利用EasyUI的Window插件可以方便快速地、仅利用几行代码就可以生成一个窗口（没错，就是像Windows系统里面的窗口）。EasyUI还有很多插件，具体可以看看[EasyUI中文网](http://www.jeasyui.net/)。</br>
&emsp;&emsp;EasyUI的入门与安装可以参考[这篇博客](http://www.cnblogs.com/xdp-gacl/p/4075079.html)，生成窗口的方法和演示可以参考[这里](http://www.jeasyui.net/demo/421.html)（这个是内联的，下面要用到）。</br>
&emsp;&emsp;从上面的演示中，也可以看到，窗口是会移出父节点那个框框的，甚至有这种尴尬情况：
![](deemo1.jpg)
&emsp;&emsp;在网上找解决办法时，找到的都是像[这样的](http://www.bkjia.com/webzh/977413.html)高度雷同的文章（我也不知道谁才是原文- -），但是里面的方法还是有不足的：拖拽只考虑了左方和上方；拉伸只考虑了右方和下方。于是我利用了他的方法做了一些改进：
# 解决方法
&emsp;&emsp;边上代码边说吧：</br>
&emsp;&emsp;首先创建一个放窗口的区域,我把它取id为"area"，位置是绝对位置放在中间，为了可以看见这个区域，我加了边框和灰色背景色：
```html
<div id="area" style="position:absolute;width:600px;height:600px;left:200px;top:100px;border-style:solid;background-color:gray"></div>
```
&emsp;&emsp;然后把EasyUI中文网上的窗口（内联，其实就是加个"inline:true"）代码放进去：
```html
<div style="margin:20px 0;">
	<a href="javascript:void(0)" class="easyui-linkbutton" onclick="$('#w').window('open')">Open</a>
	<a href="javascript:void(0)" class="easyui-linkbutton" onclick="$('#w').window('close')">Close</a>
</div>

<div id="area" style="position:absolute;width:600px;height:600px;left:200px;top:100px;border-style:solid;background-color:gray">
	<div id="w" class="easyui-window" title="Basic Window" data-options="iconCls:'icon-save',inline:true" style="width:500px;height:200px;padding:10px;">
		The window content.
    </div>
</div>
```
&emsp;&emsp;这样生成的窗口和网站上的演示一样，不能限制在那个区域内。于是下面是script：
```javascript
$(document).ready(function() { //页面（包括图像）已经完全呈现时，会发生 ready 事件
    var moving = false;  //用来标志用户是否在拖动窗口，原因是onResize与onMove会互作
    
    $("#w").window({
    //拖动时
        onMove:function(left,top){ //onMove事件，用户拖动时触发
            moving = true; //标志正在拖动

            var w=$("#area").width(); //限制区域的宽度
            var h=$("#area").height(); //限制区域的高度
            var width=$("#w").window("options").width; //窗口宽度
            var height=$("#w").window("options").height; //窗口高度
            
			//如果窗口上端超出限制区域上端（因为是内联，所以是0）
            if(top<0){ 
                $("#w").window("resize",{top:0}); 
                //把窗口上端限制在区域上端
            }
            //如果窗口下端超出限制区域下端（height+top就是bottom了）
            if((height+top)>h){ 
                $("#w").window("resize",{top:h-height}); 
                //把窗口下端限制在区域下端
            }
            //如果窗口左端超出限制区域左端（因为是内联，所以是0）
            if(left<0){ 
                $("#w").window("resize",{left:0}); 
                //把窗口左端限制在区域左端
            }
            //如果窗口右端超出限制区域右端（width+left就是right了）
            if((width+left)>w){ 
                $("#w").window("resize",{left:w-width}); 
                //把窗口右端限制在区域右端
            }
            moving = false; //完成，标志为没有在拖动
        },
        
    //拉伸时
        onResize:function(width, height){ //onResize事件
            if(moving){return;}	  
            //有时候拖动时会触发onResize（比如拖到左上角，左边和上边同时越界时）
            //所以如果在拖动的话直接跳过onResize
            
            var w=$("#area").width(); //限制区域的宽度
            var h=$("#area").height(); //限制区域的高度
            var left=$("#w").window("options").left; //窗口左端
            var top=$("#w").window("options").top; //窗口顶端

            if(top<0){ //如果窗口上端超出限制区域上端（因为是内联，所以是0）
                $("#w").window("resize",{height:height+top,top:0}); 
                //把窗口上端限制在区域上端，同时保持高度不变（这时top是负值，且绝对值为超出的长度）
            }
            //如果窗口下端超出限制区域下端
            if((height+top)>h){
                $("#w").window("resize",{height:h-top});
                //因为拉伸下面时top没改变，所以直接保持高度不变就行了（height的计算就是if表达式里面的变形）
            }
            //如果窗口左端超出限制区域左端
            if(left<0){
                $("#w").window("resize",{width:width+left,left:0});
                //把窗口左端限制在区域左端，同时保持宽度不变（这时left是负值，且绝对值为超出的长度）
            }
            //如果窗口右端超出限制区域右端
            if((width+left)>w){
                $("#w").window("resize",{width:w-left});
                //因为拉伸右面时left没改变，所以直接保持宽度不变就行了
            }
        }
    });
});
```
&emsp;&emsp;一不小心就把代码打全了，注释虽然有点密密麻麻，但应该看得懂的。
</br></br>
&emsp;&emsp;最后发一个演示：[☞戳我☜](http://jsfiddle.net/kwV9G/423/)


