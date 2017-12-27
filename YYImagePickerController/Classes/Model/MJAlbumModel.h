//
//  MJAlbumModel.h
//  MJImagePicker
//
//  Created by Yang Yu on 2017/12/25.
//  Copyright © 2017年 Yang Yu. All rights reserved.
//  相簿集 对应的Model

#import <UIKit/UIKit.h>

@class PHFetchResult;

@interface MJAlbumModel : NSObject

/// 相簿名
@property (nonatomic, strong) NSString *name;               ///< The album name
/// 照片的个数
@property (nonatomic, assign) NSInteger count;              ///< Count of photos the album contain
/// 相簿封面, 取最后一张照片
//@property (nonatomic, strong) UIImage *albumIcon;
/// 对应的result
@property (nonatomic, strong) PHFetchResult *result;        ///< PHFetchResult <PHAsset>


/// 相簿里AssetModel
@property (nonatomic, strong) NSArray *models;
/// 选中的model
@property (nonatomic, strong) NSArray *selectedModels;
/// 选中的个数
@property (nonatomic, assign) NSUInteger selectedCount;



/**
 类方法初始化

 @param result PHFetchResult
 @param name 相册名
 @return MJAlbumModel
 */
+ (MJAlbumModel *)modelWithResult:(PHFetchResult *)result
                             name:(NSString *)name;


@end
