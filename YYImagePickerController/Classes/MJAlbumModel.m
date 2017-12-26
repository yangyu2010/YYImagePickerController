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
    [MJImageManager getPostImageWithAlbumModel:model completion:^(UIImage *image) {
        model.albumIcon = image;
    }];
    return model;
}


@end
