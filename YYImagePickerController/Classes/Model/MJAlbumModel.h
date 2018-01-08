//
//  MJAlbumModel.h
//  MJImagePicker
//
//  Created by Yang Yu on 2017/12/25.
//  Copyright © 2017年 Yang Yu. All rights reserved.
//  相簿集 对应的Model

#import <UIKit/UIKit.h>

@class PHFetchResult;
@class MJAssetModel;

@interface MJAlbumModel : NSObject

/// 相簿名
@property (nonatomic, strong) NSString *name;               ///< The album name
/// 照片的个数
@property (nonatomic, assign) NSInteger count;              ///< Count of photos the album contain
/// 对应的result
@property (nonatomic, strong) PHFetchResult *result;        ///< PHFetchResult <PHAsset>


/// 相簿里AssetModel
@property (nonatomic, strong) NSArray <MJAssetModel *> *arrModels;
/// 选中的model, 有可能选中的, 当前相簿里没有
@property (nonatomic, strong) NSArray <MJAssetModel *> *arrSelectedModels;
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
