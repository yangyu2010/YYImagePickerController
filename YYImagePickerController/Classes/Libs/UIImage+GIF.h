//
//  UIImage+GIF.h
//  YYImagePickerController
//
//  Created by Yang Yu on 2017/12/28.
//  Copyright © 2017年 Yang Yu. All rights reserved.
//  UIImage 显示GIF

#import <UIKit/UIKit.h>

@interface UIImage (GIF)

/**
 根据NSData返回一个图片对象

 @param data NSData
 @return GIF图
 */
+ (UIImage *)animatedGIFWithData:(NSData *)data;

@end
