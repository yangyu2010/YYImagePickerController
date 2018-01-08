//
//  MJAlbumModel.m
//  MJImagePicker
//
//  Created by Yang Yu on 2017/12/25.
//  Copyright © 2017年 Yang Yu. All rights reserved.
//

#import "MJAlbumModel.h"
#import <Photos/Photos.h>
#import "MJImageManager.h"

@implementation MJAlbumModel

/**
 类方法初始化
*/
+ (MJAlbumModel *)modelWithResult:(PHFetchResult *)result
                             name:(NSString *)name {
    
    if (result == nil || name.length == 0) {
        return nil;
    }
    
    MJAlbumModel *model = [[MJAlbumModel alloc] init];
    model.result = result;
    model.name = name;
    model.count = result.count;
    model.selectedCount = 0;
    [model getAllAssetModel];
    return model;
}


#pragma mark- Set

- (void)setArrSelectedModels:(NSArray<MJAssetModel *> *)arrSelectedModels {
    _arrSelectedModels = arrSelectedModels;
    
    if (_arrModels) {
        [self checkSelectedModels];
    }
}

#pragma mark- Private

/// 获取Model下所有资源对象
- (void)getAllAssetModel {
    [[MJImageManager defaultManager] getAssetFromAlbum:self completion:^(NSArray<MJAssetModel *> *arrAssets) {
        if (arrAssets.count > 0) {
            self.arrModels = arrAssets;
        }
    }];
}

/// 对比当前数组下被选中的model
- (void)checkSelectedModels {
    self.selectedCount = 0;

    for (MJAssetModel *selectedModel in _arrSelectedModels) {
        for (MJAssetModel *model in _arrModels) {
            if ([selectedModel isSameAssetModel:model]) {
                self.selectedCount ++;
                model.isSelected = YES;
            }
        }
        
    }
    
//    NSMutableArray *selectedAssets = [NSMutableArray array];
//    for (MJAssetModel *model in _arrSelectedModels) {
//        [selectedAssets addObject:model.asset];
//    }
//
//    for (MJAssetModel *model in _arrModels) {
//        if ([selectedAssets containsObject:model.asset]) {
//            self.selectedCount ++;
//            model.isSelected = YES;
//        }
//
//    }

}

@end
