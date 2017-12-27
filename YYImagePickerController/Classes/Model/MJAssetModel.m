//
//  MJAssetModel.m
//  MJImagePicker
//
//  Created by Yang Yu on 2017/12/25.
//  Copyright © 2017年 Yang Yu. All rights reserved.
//

#import "MJAssetModel.h"
#import <Photos/Photos.h>

@implementation MJAssetModel


/**
 类方法创建对象
 */
+ (MJAssetModel *)modelWithAsset:(PHAsset *)asset
               allowPickingVideo:(BOOL)allowPickingVideo {
    
    MJAssetModel *model = [[MJAssetModel alloc] init];
    
    model.asset = asset;
    model.type = [model getModelMediaType];
    if (model.type == MJAssetModelMediaTypeVideo) {
        if (!allowPickingVideo) {
            return nil;
        }
        
        model.timeLength = [NSString stringWithFormat:@"%0.0f",asset.duration];
    }

    return model;
}




#pragma mark- Private

/// 获取当前照片类型
- (MJAssetModelMediaType)getModelMediaType {
    MJAssetModelMediaType type = MJAssetModelMediaTypePhoto;
    if (self.asset.mediaType == PHAssetMediaTypeVideo) {
        type = MJAssetModelMediaTypeVideo;
    }
    else if (self.asset.mediaType == PHAssetMediaTypeAudio) {
        type = MJAssetModelMediaTypeAudio;
    }
    else if (self.asset.mediaType == PHAssetMediaTypeImage) {
        if (@available(iOS 9.1, *)) {
            if (self.asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
                type = MJAssetModelMediaTypeLivePhoto;
            }
        }
        if ([[self.asset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
            type = MJAssetModelMediaTypePhotoGif;
        }
    }
    
    return type;
}

@end
