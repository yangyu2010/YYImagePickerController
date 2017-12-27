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

/**
 获取照片完成回调

 @param photo 图片对象
 @param info info
 @param isDegraded PHImageResultIsDegradedKey
 */
typedef void(^GetPhotoWithAssetCompletion)(UIImage *photo, NSDictionary *info, BOOL isDegraded);


/**
 获取照片从iCloud中下载的进度

 @param progress 进度
 @param error error
 @param stop stop
 @param info info
 */
typedef void(^GetPhotoWithAssetProgressHandler)(double progress, NSError *error, BOOL *stop, NSDictionary *info);


@interface MJImageManager : NSObject


/// 单例
+ (instancetype)defaultManager;

/// 默认4列, MJPhotoPickerController中的照片collectionView
@property (nonatomic, assign) NSInteger columnNumber;


/// Return YES if Authorized 返回YES如果得到了授权
- (BOOL)authorizationStatusAuthorized;

/// 授权状态
+ (NSInteger)authorizationStatus;

/// 请求授权
- (void)requestAuthorizationWithCompletion:(void (^)(void))completion;



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



/**
 获取某个相簿下所有的照片

 @param albumModel 相簿
 @param completion completion
 */
- (void)getAssetFromAlbum:(MJAlbumModel *)albumModel
               completion:(void (^)(NSArray <MJAssetModel *> *arrAssets))completion;


/// 根据Asset来获取照片
- (int32_t)getPhotoWithAsset:(PHAsset *)asset
                  completion:(GetPhotoWithAssetCompletion)completion;

/// 根据Asset来获取照片
- (int32_t)getPhotoWithAsset:(PHAsset *)asset
                  photoWidth:(CGFloat)photoWidth
                  completion:(GetPhotoWithAssetCompletion)completion;

/// 根据Asset来获取照片
- (int32_t)getPhotoWithAsset:(PHAsset *)asset
                  completion:(GetPhotoWithAssetCompletion)completion
             progressHandler:(GetPhotoWithAssetProgressHandler)progressHandler
        networkAccessAllowed:(BOOL)networkAccessAllowed;

/**
 根据Asset来获取照片

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
             progressHandler:(GetPhotoWithAssetProgressHandler)progressHandler
        networkAccessAllowed:(BOOL)networkAccessAllowed;



@end