//
//  AssetPreviewCell.h
//  YYImagePickerController
//
//  Created by Yang Yu on 2018/1/9.
//  Copyright © 2018年 Yang Yu. All rights reserved.
//  图片预览中的Cell

#import <UIKit/UIKit.h>
@class MJAssetModel;

@interface AssetPreviewCell : UICollectionViewCell

@property (nonatomic, strong) MJAssetModel *model;

@end
