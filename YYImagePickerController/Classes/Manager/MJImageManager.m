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

CGSize _kAssetGridThumbnailSize;
CGFloat _kScreenWidth;
CGFloat _kScreenScale;

#pragma mark- 单例

/**
 单例
 */
static MJImageManager *manager;
static dispatch_once_t onceToken;
+ (instancetype)defaultManager {
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        // 设置默认4列
        [manager setColumnNumber:4];
    });
    return manager;
}

#pragma mark- Size

- (void)configScreenWidth {
    _kScreenWidth = [UIScreen mainScreen].bounds.size.width;
    // 测试发现，如果scale在plus真机上取到3.0，内存会增大特别多。故这里写死成2.0
    _kScreenScale = 2.0;
    if (_kScreenWidth > 700) {
        _kScreenScale = 1.5;
    }
}

- (void)setColumnNumber:(NSInteger)columnNumber {
    [self configScreenWidth];
    _columnNumber = columnNumber;
    
    CGFloat margin = 5;
    CGFloat itemWH = (_kScreenWidth - (columnNumber + 1) * margin) / columnNumber;
    _kAssetGridThumbnailSize = CGSizeMake(itemWH * _kScreenScale, itemWH * _kScreenScale);
}

#pragma mark- 授权

/**
 Return YES if Authorized 返回YES如果得到了授权
 */
- (BOOL)authorizationStatusAuthorized {
    NSInteger status = [self.class authorizationStatus];
    if (status == 0) {
        /**
         * 当某些情况下AuthorizationStatus == AuthorizationStatusNotDetermined时，无法弹出系统首次使用的授权alertView，系统应用设置里亦没有相册的设置，此时将无法使用，故作以下操作，弹出系统首次使用的授权alertView
         */
        [self requestAuthorizationWithCompletion:nil];
    }
    
    return status == 3;
}

/**
 授权状态
 */
+ (NSInteger)authorizationStatus {
    return [PHPhotoLibrary authorizationStatus];
}

/**
 请求授权
 */
- (void)requestAuthorizationWithCompletion:(void (^)(void))completion {
    
    void (^callCompletionBlock)(void) = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            callCompletionBlock();
        }];
    });
}



#pragma mark- 相簿相关

/**
 获取所有的相簿Model
  */
- (void)getAllAlbumsCompletion:(void (^)(NSArray <MJAlbumModel *> *arrAlbums))completion; {
    
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
            
            if (collection.assetCollectionSubtype ==
                PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
                MJAlbumModel *model = [MJAlbumModel modelWithResult:fetchResult name:collection.localizedTitle];
                if (model) {
                    [arrAlbums insertObject:model atIndex:0];
                }
            } else {
                MJAlbumModel *model = [MJAlbumModel modelWithResult:fetchResult name:collection.localizedTitle];
                if (model) {
                    [arrAlbums addObject:model];
                }
            }
        }
    }
    
    if (completion) {
        completion(arrAlbums.copy);
    }
}

/**
 获取相簿封面
 */
- (void)getPostImageWithAlbumModel:(MJAlbumModel *)model completion:(void (^)(UIImage *image))completion {
    
    if (model == nil) {
        if (completion) {
            completion(nil);
        }
        return;
    }
    
    PHAsset *asset = [model.result lastObject];
    
    [[MJImageManager defaultManager] getPhotoWithAsset:asset photoWidth:80 completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        if (completion) {
           completion(photo);
        }
    }];

}



#pragma mark- 照片相关

/**
 获取当前照片模型的类型
 */
- (MJAssetModelMediaType)getAssetModelMediaType:(MJAssetModel *)model {
    MJAssetModelMediaType type = MJAssetModelMediaTypePhoto;
    if (model.asset.mediaType == PHAssetMediaTypeVideo) {
        type = MJAssetModelMediaTypeVideo;
    }
    else if (model.asset.mediaType == PHAssetMediaTypeAudio) {
        type = MJAssetModelMediaTypeAudio;
    }
    else if (model.asset.mediaType == PHAssetMediaTypeImage) {
        if (@available(iOS 9.1, *)) {
            if (model.asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
                type = MJAssetModelMediaTypeLivePhoto;
            }
        }
        if ([[model.asset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
            type = MJAssetModelMediaTypePhotoGif;
        }
    }
    
    return type;
}


/**
 获取某个相簿下所有的照片
 */
- (void)getAssetFromAlbum:(MJAlbumModel *)albumModel completion:(void (^)(NSArray <MJAssetModel *> *arrAssets))completion; {
    
    if (albumModel == nil) {
        if (completion) {
            completion(nil);
        }
        return;
    }
    
    NSMutableArray *arrPhoto = [NSMutableArray array];
    PHFetchResult *fetchResult = albumModel.result;
    
    [fetchResult enumerateObjectsUsingBlock:^(id  _Nonnull asset, NSUInteger idx, BOOL * _Nonnull stop) {
        MJAssetModel *model = [MJAssetModel modelWithAsset:asset];
        if (model) {
            [arrPhoto addObject:model];
        }
    }];
    
    if (completion) {
        completion(arrPhoto.copy);
    }
}

- (int32_t)getPhotoWithAsset:(PHAsset *)asset completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion {
    
    return [self getPhotoWithAsset:asset photoWidth:_kScreenWidth completion:completion progressHandler:nil networkAccessAllowed:YES];
}

- (int32_t)getPhotoWithAsset:(PHAsset *)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion {
    
    return [self getPhotoWithAsset:asset photoWidth:photoWidth completion:completion progressHandler:nil networkAccessAllowed:YES];
}

- (int32_t)getPhotoWithAsset:(PHAsset *)asset completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed {
    
    return [self getPhotoWithAsset:asset photoWidth:_kScreenWidth completion:completion progressHandler:progressHandler networkAccessAllowed:networkAccessAllowed];
}

- (int32_t)getPhotoWithAsset:(PHAsset *)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed {
    
    /// 测试代码
    networkAccessAllowed = NO;
    
    CGSize imageSize;
    if (photoWidth < _kScreenWidth) {
        imageSize = _kAssetGridThumbnailSize;
    } else {
        CGFloat aspectRatio = asset.pixelWidth / (CGFloat)asset.pixelHeight;
        CGFloat pixelWidth = photoWidth * _kScreenScale * 1.5;
        // 超宽图片
        if (aspectRatio > 1.8) {
            pixelWidth = pixelWidth * aspectRatio;
        }
        // 超高图片
        if (aspectRatio < 0.2) {
            pixelWidth = pixelWidth * 0.5;
        }
        CGFloat pixelHeight = pixelWidth / aspectRatio;
        imageSize = CGSizeMake(pixelWidth, pixelHeight);
    }
    
    __block UIImage *image;
    // 修复获取图片时出现的瞬间内存过高问题
    // 下面两行代码，来自hsjcom，他的github是：https://github.com/hsjcom 表示感谢
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    int32_t imageRequestID = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:imageSize contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (result) {
            image = result;
        }
        
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] &&
                                ![info objectForKey:PHImageErrorKey]);
        if (downloadFinined && result) {
            if (completion) {
                completion(result,info,[[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
            }
        }
        
        // Download image from iCloud, 需要联网, Only WiFi的问题要注意
        if ([info objectForKey:PHImageResultIsInCloudKey] &&
                                                  !result &&
                                    networkAccessAllowed) {
            
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.networkAccessAllowed = YES;
            options.resizeMode = PHImageRequestOptionsResizeModeFast;
            options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (progressHandler) {
                        progressHandler(progress, error, stop, info);
                    }
                });
            };
           
            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                UIImage *resultImage = [UIImage imageWithData:imageData];
                resultImage = [self scaleImage:resultImage toSize:imageSize];
                if (!resultImage) {
                    resultImage = image;
                }
                if (completion) {
                    completion(resultImage,info,NO);
                }
            }];
            
        }
        
    }];
    
    return imageRequestID;
}


//
/**
 Get full Image 获取原图
 该方法中，completion只会走一次
 */
- (void)getOriginalPhotoDataWithAsset:(PHAsset *)asset
                           completion:(void (^)(NSData *data, NSDictionary *info, BOOL isDegraded))completion {
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.networkAccessAllowed = YES;
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] &&
                                ![info objectForKey:PHImageErrorKey]);
        if (downloadFinined && imageData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(imageData,info,NO);
                }
            });
        }
    }];
}

#pragma mark- LivePhoto

- (void)getLivePhotoWithAsset:(PHAsset *)asset
                         size:(CGSize)size
              progressHandler:(GetOriginalAssetProgressHandler)progressHandler
                   completion:(GetLivePhotoWithAssetCompletion)completion PHOTOS_AVAILABLE_IOS_TVOS(9_1, 10_0) {
    
    PHLivePhotoRequestOptions *options = [[PHLivePhotoRequestOptions alloc] init];
    options.networkAccessAllowed = YES;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    options.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progressHandler) {
                progressHandler(progress, error, stop, info);
            }
        });
    };
    
    [[PHImageManager defaultManager] requestLivePhotoForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:options resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable info) {
        if (livePhoto && !info[PHImageResultIsDegradedKey]) {
            if(completion) {
                completion(livePhoto, info, NO);
            }
        }
    }];
}


#pragma mark- Video

/// Get video 获得视频
- (void)getVideoWithAsset:(PHAsset *)asset
               completion:(GetVideoWithAssetCompletion)completion {
    [self getVideoWithAsset:asset progressHandler:nil completion:completion];
}

- (void)getVideoWithAsset:(PHAsset *)asset
          progressHandler:(GetOriginalAssetProgressHandler)progressHandler
               completion:(GetVideoWithAssetCompletion)completion {
    PHVideoRequestOptions *option = [[PHVideoRequestOptions alloc] init];
    option.networkAccessAllowed = YES;
    option.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progressHandler) {
                progressHandler(progress, error, stop, info);
            }
        });
    };
    
    [[PHImageManager defaultManager] requestPlayerItemForVideo:asset options:option resultHandler:^(AVPlayerItem *playerItem, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(playerItem,info);
            }
        });
    }];
}



#pragma mark- Private


/**
 压缩图片

 @param image 图片
 @param size 尺寸
 @return 图片
 */
- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size {
    
    if (image.size.width <= size.width) {
        return image;
    }
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



                       
@end
