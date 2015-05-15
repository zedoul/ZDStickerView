# ZDStickerView 

ZDStickerView is an Objective-C module for iOS and offers complete configurability, including movement, resizing, rotation and more, with one finger.

[![](https://github.com/zedoul/ZDStickerView/blob/develop/SCREENSHOT.png?raw=true)](https://github.com/zedoul/ZDStickerView/blob/develop/SCREENSHOT.png?raw=true)
[![](http://code4app.qiniudn.com/photo/51da3bcb6803faab15000001_11.gif)](http://code4app.qiniudn.com/photo/51da3bcb6803faab15000001_11.gif)

How To Use It
-------------

### Installation

Include ZDStickerView folder in your project.

### Setting up the ZDStickerView 

You'll need to #import the ZDStickerView.h header and construct a new instance of ZDStickerView. Then, set the contentView on the ZDStickerView to the view you'd like the user to interact with.

For an example of how to use ZDStickerView, please see the included example project.

### Features
Longpress event is disabled by default. If you want enable it, just define it in .pch file follows: 

```c
    #define ZDSTICKERVIEW_LONGPRESS
```

### Credits

I started from [TDResizerView](https://github.com/Thavasidurai/TDResizerView) and [SPUserResizableView](https://github.com/spoletto/SPUserResizableView).

Also [sedwo](https://github.com/sedwo/ZDStickerView) fixed lots of codes. 

Licence
========
Copyright (c) 2013 Seonghyun Kim, Scipi.
This code is distributed under the terms and conditions of the MIT license.
