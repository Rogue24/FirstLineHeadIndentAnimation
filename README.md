# 使用YYLabel+CADisplayLink实现文本首行缩进的动画效果

实现原理：[使用YYLabel+CADisplayLink实现文本首行缩进的动画效果](https://www.jianshu.com/p/3d8cc8b45965)

> 这是从项目抽取出来的小模块，体量可能有点大，另外数据是从json文件提取的（服务器返回的字段名称有点奇葩），使用的是MVVM开发模式，仅供参考。

**1. ``WTVPUGCProfileCellModel``，ViewModel，负责UI布局属性的存储和计算，另外由控制器调用其API改变状态（更新、调用动画）：**

![explain1](https://github.com/Rogue24/FirstLineHeadIndentAnimation/raw/master/Cover/explain1.jpg)

**2. UI布局、动画代码都在``WTVPUGCProfilePlayView.m``里面实现：**

![explain2](https://github.com/Rogue24/FirstLineHeadIndentAnimation/raw/master/Cover/explain2.jpg)

**3. 点击头像更改直播状态（单个），点击关注按钮更改关注状态（全局）**

![实现效果](https://github.com/Rogue24/FirstLineHeadIndentAnimation/raw/master/Cover/cover.gif)

## 反馈地址

    扣扣：184669029
    博客：https://www.jianshu.com/u/2edfbadd451c
