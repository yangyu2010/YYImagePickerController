//
//  AssetPreviewBaseCell.h
//  YYImagePickerController
//
//  Created by Yang Yu on 2017/12/28.
//  Copyright © 2017年 Yang Yu. All rights reserved.
//  图片预览中 基础的 Cell

#import <UIKit/UIKit.h>
#import "MJAssetModel.h"
#import "ProgressView.h"

@interface AssetPreviewBaseCell : UICollectionViewCell

/// 模型
@property (nonatomic, strong) MJAssetModel *model;

/// 单击回调, 用来隐藏状态栏
@property (nonatomic, copy) void (^singleTapGestureBlock)(void);

/// 加载进度View
@property (nonatomic, strong) ProgressView *viewProgress;



#pragma mark- Pubulic

/// 加载subView
- (void)viewConfig;

- (void)dataConfig;

@end
