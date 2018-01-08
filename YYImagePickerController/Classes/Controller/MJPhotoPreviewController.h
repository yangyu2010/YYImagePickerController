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

@property (nonatomic, strong) NSMutableArray <MJAssetModel *> *arrAssetModels;

@property (nonatomic, assign) NSInteger currentIndex;

@end
