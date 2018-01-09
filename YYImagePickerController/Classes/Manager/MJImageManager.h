//
//  MJImageManager.h
//  MJImagePicker
//
//  Created by Yang Yu on 2017/12/25.
//  Copyright © 2017年 Yang Yu. All rights reserved.
//  图片视频资源获取管理类
/**
 1. 获取缩略图时, 可以不连接网络, 直接获取不清楚的一个图片让用户选择就行了
    还是看产品那边需要在APP里预览整个相册吧
 
 2. 高清图一定要联网获得, 这里的图片有可能是在iCloud里, 可以有progress回调
 
 */

#import <UIKit/UIKit.h>
#import "MJAlbumModel.h"
#import "MJAssetModel.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/PHLivePhoto.h>


/**
 获取Image完成回调

 @param photo 图片对象
 @param info info
 @param isDegraded PHImageResultIsDegradedKey (YES是缩略图, NO原图)
 */
typedef void(^GetPhotoWithAssetCompletion)(UIImage *photo, NSDictionary *info, BOOL isDegraded);


typedef void(^GetLivePhotoWithAssetCompletion)(PHLivePhoto *livePhoto, NSDictionary *info, BOOL isDegraded) PHOTOS_AVAILABLE_IOS_TVOS(9_1, 10_0);

/**
 获取Video完成回调

 @param item AVPlayerItem
 @param userInfo userInfo
 */
typedef void(^GetVideoWithAssetCompletion)(AVPlayerItem *item, NSDictionary *userInfo);

/**
 获取图片或者视频从iCloud中下载的进度

 @param progress 进度
 @param error error
 @param stop stop
 @param info info
 */
typedef void(^GetOriginalAssetProgressHandler)(double progress, NSError *error, BOOL *stop, NSDictionary *info);




@interface MJImageManager : NSObject

#pragma mark- DefaultManager
/// 单例
+ (instancetype)defaultManager;


#pragma mark- ColumnNumber
/// 默认4列, MJPhotoPickerController中的照片collectionView
@property (nonatomic, assign) NSInteger columnNumber;


#pragma mark- Authorization
/// Return YES if Authorized 返回YES如果得到了授权
- (BOOL)authorizationStatusAuthorized;

/// 授权状态
+ (NSInteger)authorizationStatus;

/// 请求授权
- (void)requestAuthorizationWithCompletion:(void (^)(void))completion;


#pragma mark- Albums
/**
 获取所有的相簿Model

 @param completion NSArray
 */
- (void)getAllAlbumsCompletion:(void (^)(NSArray <MJAlbumModel *> *arrAlbums))completion;

/**
 获取相簿封面

 @param model 相簿
 @param completion completion
 */
- (void)getPostImageWithAlbumModel:(MJAlbumModel *)model
                        completion:(void (^)(UIImage *image))completion;



#pragma mark- Assets
/**
 获取当前照片模型的类型

 @param model MJAssetModel
 @return MJAssetModelMediaType
 */
- (MJAssetModelMediaType)getAssetModelMediaType:(MJAssetModel *)model;

/**
 获取某个相簿下所有的照片

 @param albumModel 相簿
 @param completion completion
 */
- (void)getAssetFromAlbum:(MJAlbumModel *)albumModel
               completion:(void (^)(NSArray <MJAssetModel *> *arrAssets))completion;


/// 根据Asset来获取照片 无
- (int32_t)getPhotoWithAsset:(PHAsset *)asset
                  completion:(GetPhotoWithAssetCompletion)completion;

/// 根据Asset来获取照片, 有photoWidth
- (int32_t)getPhotoWithAsset:(PHAsset *)asset
                  photoWidth:(CGFloat)photoWidth
                  completion:(GetPhotoWithAssetCompletion)completion;

/// 根据Asset来获取照片, 有Progress回调
- (int32_t)getPhotoWithAsset:(PHAsset *)asset
                  completion:(GetPhotoWithAssetCompletion)completion
             progressHandler:(GetOriginalAssetProgressHandler)progressHandler
        networkAccessAllowed:(BOOL)networkAccessAllowed;

/**
 根据Asset来获取照片, 有photoWidth, 有Progress回调

 @param asset Asset
 @param photoWidth 宽高
 @param completion 完成回调
 @param progressHandler 从iCloud下载进度
 @param networkAccessAllowed 是否可以联网下载
 @return PHImageRequestID
 */
- (int32_t)getPhotoWithAsset:(PHAsset *)asset
                  photoWidth:(CGFloat)photoWidth
                  completion:(GetPhotoWithAssetCompletion)completion
             progressHandler:(GetOriginalAssetProgressHandler)progressHandler
        networkAccessAllowed:(BOOL)networkAccessAllowed ;



- (void)getLivePhotoWithAsset:(PHAsset *)asset
                         size:(CGSize)size
              progressHandler:(GetOriginalAssetProgressHandler)progressHandler
                   completion:(GetLivePhotoWithAssetCompletion)completion PHOTOS_AVAILABLE_IOS_TVOS(9_1, 10_0);

#pragma mark- Image Full
/**
 Get full Image 获取原图, 返回的是NSData
 这个方法我用在显示Gif图的时候
 该方法中，completion只会走一次

 @param asset PHAsset
 @param completion 完成回调
 */
- (void)getOriginalPhotoDataWithAsset:(PHAsset *)asset
                           completion:(void (^)(NSData *data, NSDictionary *info, BOOL isDegraded))completion;



#pragma mark- Video

/// Get video 获得视频
- (void)getVideoWithAsset:(PHAsset *)asset
               completion:(GetVideoWithAssetCompletion)completion;

- (void)getVideoWithAsset:(PHAsset *)asset
          progressHandler:(GetOriginalAssetProgressHandler)progressHandler
               completion:(GetVideoWithAssetCompletion)completion;


@end
