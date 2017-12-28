//
//  PhotoPreviewView.h
//  YYImagePickerController
//
//  Created by Yang Yu on 2017/12/28.
//  Copyright © 2017年 Yang Yu. All rights reserved.
//  预览Cell里包含的View, 处理图片显示功能

#import <UIKit/UIKit.h>
#import "MJAssetModel.h"

@interface PhotoPreviewView : UIView

@property (nonatomic, strong) MJAssetModel *model;
@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, copy) void (^singleTapGestureBlock)(void);
@property (nonatomic, copy) void (^imageProgressUpdateBlock)(double progress);

@property (nonatomic, assign) int32_t imageRequestID;

- (void)recoverSubviews;

@end
