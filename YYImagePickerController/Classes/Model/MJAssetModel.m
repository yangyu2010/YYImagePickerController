//
//  MJAssetModel.m
//  MJImagePicker
//
//  Created by Yang Yu on 2017/12/25.
//  Copyright © 2017年 Yang Yu. All rights reserved.
//

#import "MJAssetModel.h"
#import <Photos/Photos.h>
#import "MJImageManager.h"

@implementation MJAssetModel


/**
 类方法创建对象
 */
+ (MJAssetModel *)modelWithAsset:(PHAsset *)asset
               allowPickingVideo:(BOOL)allowPickingVideo {
    
    MJAssetModel *model = [[MJAssetModel alloc] init];
    
    model.asset = asset;
    model.type = [[MJImageManager defaultManager] getAssetModelMediaType:model];
    if (model.type == MJAssetModelMediaTypeVideo) {
        if (!allowPickingVideo) {
            return nil;
        }
        model.timeLength = [NSString stringWithFormat:@"%0.0f",asset.duration];
    }

    return model;
}




@end
