//
//  MJAssetModel.h
//  MJImagePicker
//
//  Created by Yang Yu on 2017/12/25.
//  Copyright © 2017年 Yang Yu. All rights reserved.
//  一个照片模型, 可能是段视频

#import <Foundation/Foundation.h>
@class PHAsset;

typedef enum : NSUInteger {
    MJAssetModelMediaTypePhoto = 0,
    MJAssetModelMediaTypeLivePhoto,
    MJAssetModelMediaTypePhotoGif,
    MJAssetModelMediaTypeVideo,
    MJAssetModelMediaTypeAudio
} MJAssetModelMediaType;


@interface MJAssetModel : NSObject

/// PHAsset
@property (nonatomic, strong) PHAsset *asset;

/// 当前asset唯一标识符
@property (nonatomic, copy) NSString *localIdentifier;

/// The select status of a photo, default is N
@property (nonatomic, assign) BOOL isSelected;

/// Type
@property (nonatomic, assign) MJAssetModelMediaType type;

/// 视频时长
@property (nonatomic, copy) NSString *timeLength;


/**
 类方法创建对象

 @param asset PHAsset
 @return MJAssetModel
 */
+ (MJAssetModel *)modelWithAsset:(PHAsset *)asset;

@end
