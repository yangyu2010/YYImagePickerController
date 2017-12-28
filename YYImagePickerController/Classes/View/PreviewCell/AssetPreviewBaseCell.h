//
//  AssetPreviewBaseCell.h
//  YYImagePickerController
//
//  Created by Yang Yu on 2017/12/28.
//  Copyright © 2017年 Yang Yu. All rights reserved.
//  图片预览中 基础的 Cell

#import <UIKit/UIKit.h>
#import "MJAssetModel.h"

@interface AssetPreviewBaseCell : UICollectionViewCell

@property (nonatomic, strong) MJAssetModel *model;
@property (nonatomic, copy) void (^singleTapGestureBlock)(void);

- (void)configSubviews;
- (void)photoPreviewCollectionViewDidScroll;

@end
