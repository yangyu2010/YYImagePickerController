//
//  MJAssetModel.h
//  MJImagePicker
//
//  Created by Yang Yu on 2017/12/25.
//  Copyright © 2017年 Yang Yu. All rights reserved.
//  一个照片模型, 可能是段视频

#import <Foundation/Foundation.h>
#import "PhotoTypes.h"
@class PHAsset;


@interface MJAssetModel : NSObject

/// PHAsset
@property (nonatomic, strong) PHAsset *asset;

/// 当前asset唯一标识符
@property (nonatomic, copy) NSString *localIdentifier;

/// Type
@property (nonatomic, assign) MJAssetModelMediaType type;

/// 视频时长
@property (nonatomic, copy) NSString *timeLength;


/// The select status of a photo, default is N
@property (nonatomic, assign) BOOL isSelected;


/**
 类方法创建对象

 @param asset PHAsset
 @return MJAssetModel
 */
+ (MJAssetModel *)modelWithAsset:(PHAsset *)asset;


/**
 判断两个AssetModel是否是一个资源

 @param model AssetModel
 @return Yes or No
 */
- (BOOL)isSameAssetModel:(MJAssetModel *)model;

@end
