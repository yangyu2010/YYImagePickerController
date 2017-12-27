//
//  MJImageManager.m
//  MJImagePicker
//
//  Created by Yang Yu on 2017/12/25.
//  Copyright © 2017年 Yang Yu. All rights reserved.
//

#import "MJImageManager.h"
#import <Photos/Photos.h>

@implementation MJImageManager

+ (void)getAllAlbumsCompletion:(void (^)(NSArray <MJAlbumModel *> *arrAlbums))completion {
    
    NSMutableArray *arrAlbums = [NSMutableArray array];
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    
    PHFetchResult *myPhotoStreamAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumMyPhotoStream options:nil];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    PHFetchResult *syncedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
    PHFetchResult *sharedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumCloudShared options:nil];
    
    NSArray *allAlbums = @[myPhotoStreamAlbum,
                           smartAlbums,
                           topLevelUserCollections,
                           syncedAlbums,
                           sharedAlbums];
    
    for (PHFetchResult *fetchResult in allAlbums) {
        for (PHAssetCollection *collection in fetchResult) {
            // 有可能是PHCollectionList类的的对象，过滤掉
            if (![collection isKindOfClass:[PHAssetCollection class]]) {
                continue;
            }
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            if (fetchResult.count < 1) {
                continue;
            }
            if ([collection.localizedTitle containsString:@"Hidden"] || [collection.localizedTitle isEqualToString:@"已隐藏"]) {
                continue;
            }
            if ([collection.localizedTitle containsString:@"Deleted"] || [collection.localizedTitle isEqualToString:@"最近删除"]) {
                continue;
            }
            ///
            if (collection.assetCollectionSubtype ==
                PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
                [arrAlbums insertObject:[MJAlbumModel modelWithResult:fetchResult name:collection.localizedTitle] atIndex:0];
            } else {
                [arrAlbums addObject:[MJAlbumModel modelWithResult:fetchResult name:collection.localizedTitle]];
            }
            
//            NSLog(@"localizedTitle %@", collection.localizedTitle);
//            NSLog(@"count %ld", fetchResult.count);
//            NSLog(@"--------------");
        }
    }
    
    if (completion) {
        completion(arrAlbums.copy);
    }
}

+ (void)getAssetFromAlbum:(MJAlbumModel *)albumModel completion:(void (^)(NSArray <MJAssetModel *> *arrAssets))completion {
    
    if (albumModel == nil) {
        if (completion) {
            completion(nil);
        }
        return;
    }
    
    NSMutableArray *arrPhoto = [NSMutableArray array];
    
    PHFetchResult *fetchResult = albumModel.result;
    
    [fetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MJAssetModel *model = [MJAssetModel modelWithAsset:obj allowPickingVideo:YES];
        if (model) {
            [arrPhoto addObject:model];
        }
    }];
    
    if (completion) {
        completion(arrPhoto.copy);
    }
}

+ (void)getPostImageWithAlbumModel:(MJAlbumModel *)model completion:(void (^)(UIImage *image))completion {
    
    PHAsset *asset = [model.result lastObject];
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(80, 80) contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
//        NSLog(@"name %@", model.name);
//        NSLog(@"result %@", result);
//        NSLog(@"------------------");
//
        if (completion) {
            completion(result);
        }
    }];
    
}

+ (int32_t)getPhotoWithAssetModel:(MJAssetModel *)model photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion {
    
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    [[PHImageManager defaultManager] requestImageForAsset:model.asset targetSize:CGSizeMake(photoWidth, photoWidth) contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
                NSLog(@"name %ld", model.asset.pixelWidth);
                NSLog(@"name %ld", model.asset.pixelHeight);
                NSLog(@"result %@", result);
                NSLog(@"------------------");
        
        if (completion) {
            completion(result, info , [[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        }
    }];
    
    return 0;
}

@end
