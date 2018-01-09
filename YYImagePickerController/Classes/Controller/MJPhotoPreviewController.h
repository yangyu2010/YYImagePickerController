//
//  MJPhotoPreviewController.h
//  YYImagePickerController
//
//  Created by Yang Yu on 2017/12/28.
//  Copyright © 2017年 Yang Yu. All rights reserved.
//  照片预览页面

#import <UIKit/UIKit.h>
@class MJAssetModel;

@interface MJPhotoPreviewController : UIViewController

/// 需要预览哪些图片
@property (nonatomic, strong) NSMutableArray <MJAssetModel *> *arrAssetModels;

/// 从哪个index开始预览, 默认是0
@property (nonatomic, assign) NSInteger currentIndex;

@end
