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

/// The select status of a photo, default is N
@property (nonatomic, assign) BOOL isSelected;

/// Type
@property (nonatomic, assign) MJAssetModelMediaType type;

/// 视频时长
@property (nonatomic, copy) NSString *timeLength;


/**
 类方法创建对象

 @param asset PHAsset
 @param allowPickingVideo 是否可以加载视频,
                          当前对象是视频, 则返回nil
 @return MJAssetModel
 */
+ (MJAssetModel *)modelWithAsset:(PHAsset *)asset
               allowPickingVideo:(BOOL)allowPickingVideo;

@end