//
//  AssetPreview.h
//  YYImagePickerController
//
//  Created by Yang Yu on 2018/1/9.
//  Copyright © 2018年 Yang Yu. All rights reserved.
//  预览cell中的基础View, 该类是基类, 处理共有的东西
//  照片 视频 livephoto 其他等Preview继承该类, 处理自己的界面和逻辑

#import <UIKit/UIKit.h>
#import <PhotosUI/PHLivePhotoView.h>
#import "ProgressView.h"
#import "PhotoTypes.h"
#import "MJAssetModel.h"
#import "MJImageManager.h"


@interface AssetPreview : UIView

#pragma mark- 共用

/// Model
@property (nonatomic, strong) MJAssetModel *model;
/// 当前预览的类型(照片 视频 livephoto 其他)
@property (nonatomic, assign) MJAssetModelMediaType type;
/// 加载进度View 从iCloud
@property (nonatomic, strong) ProgressView *viewProgress;


#pragma mark- 普通图片(含gif)

/// 图片缩放的scrollview
@property (nonatomic, strong) UIScrollView *scrollViewZoom;
/// 装载图片的view, 用来根据图片的高度更改y值, 显示图片在正中间
@property (nonatomic, strong) UIView *viewImageContainer;
/// 显示的图片
@property (nonatomic, strong) UIImageView *imgViewIconShow;
/// 图片请求id, 用来取消请求
@property (nonatomic, assign) int32_t imageRequestID;

#pragma mark- livephoto

/// 显示livePhoto的View
@property (nonatomic, strong) PHLivePhotoView *viewLivePhoto PHOTOS_AVAILABLE_IOS_TVOS(9_1, 10_0);


#pragma mark- 视频

@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) UIButton *btnPlay;
@property (strong, nonatomic) UIImage *imgCover;


- (void)viewConfig;

- (void)dataConfig;

@end
