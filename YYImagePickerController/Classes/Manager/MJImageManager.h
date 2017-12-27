//
//  MJImageManager.h
//  MJImagePicker
//
//  Created by Yang Yu on 2017/12/25.
//  Copyright © 2017年 Yang Yu. All rights reserved.
//  图片资源获取管理类

#import <UIKit/UIKit.h>
#import "MJAlbumModel.h"
#import "MJAssetModel.h"

@interface MJImageManager : NSObject


+ (void)getAllAlbumsCompletion:(void (^)(NSArray <MJAlbumModel *> *arrAlbums))completion;

+ (void)getAssetFromAlbum:(MJAlbumModel *)albumModel completion:(void (^)(NSArray <MJAssetModel *> *arrAssets))completion;


+ (void)getPostImageWithAlbumModel:(MJAlbumModel *)model completion:(void (^)(UIImage *image))completion;

+ (int32_t)getPhotoWithAssetModel:(MJAssetModel *)model photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion;

@end
