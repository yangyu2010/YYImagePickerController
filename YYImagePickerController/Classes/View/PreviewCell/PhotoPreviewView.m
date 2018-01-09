//
//  PhotoPreviewView.m
//  YYImagePickerController
//
//  Created by Yang Yu on 2017/12/28.
//  Copyright © 2017年 Yang Yu. All rights reserved.
//

#import "PhotoPreviewView.h"
#import "ProgressView.h"
#import "UIView+Sugar.h"
#import "MJImageManager.h"
#import "UIImage+GIF.h"
#import <Photos/Photos.h>

#define kPhotoPreviewViewProgressWH     40.0f

@interface PhotoPreviewView () <UIScrollViewDelegate>

/// 下载iCloud图片时 加载进度
@property (nonatomic, strong) ProgressView *viewProgress;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIView *imageContainerView;

@property (nonatomic, strong) UIScrollView *scrollView;


@end

@implementation PhotoPreviewView

#pragma mark- Init

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        [self viewConfig];
//    }
//    return self;
//}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self viewConfig];
    }
    return self;
}

#pragma mark- View
- (void)viewConfig {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.bouncesZoom = YES;
    _scrollView.maximumZoomScale = 2.5;
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.multipleTouchEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.scrollsToTop = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.delaysContentTouches = NO;
    _scrollView.canCancelContentTouches = YES;
    _scrollView.alwaysBounceVertical = NO;
    [self addSubview:_scrollView];
    
    _imageContainerView = [[UIView alloc] init];
    _imageContainerView.clipsToBounds = YES;
    _imageContainerView.contentMode = UIViewContentModeScaleAspectFill;
    [_scrollView addSubview:_imageContainerView];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.clipsToBounds = YES;
    [_imageContainerView addSubview:_imageView];
    
    _viewProgress = [[ProgressView alloc] init];
    _viewProgress.hidden = YES;
    [self addSubview:_viewProgress];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tap2.numberOfTapsRequired = 2;
    [tap1 requireGestureRecognizerToFail:tap2];
    [self addGestureRecognizer:tap2];
    
}

- (void)recoverSubviews {
    [_scrollView setZoomScale:1.0 animated:NO];
    [self resizeSubviews];
}

- (void)resizeSubviews {
    _imageContainerView.frame = CGRectMake(0, 0, self.scrollView.width, 0);
    
    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > self.height / self.scrollView.width) {
        _imageContainerView.height = floor(image.size.height / (image.size.width / self.scrollView.width));
    } else {
        CGFloat height = image.size.height / image.size.width * self.scrollView.width;
        if (height < 1 || isnan(height)) height = self.height;
        height = floor(height);
        _imageContainerView.height = height;
        _imageContainerView.centerY = self.height / 2;
    }
    if (_imageContainerView.height > self.height && _imageContainerView.height - self.height <= 1) {
        _imageContainerView.height = self.height;
    }
    CGFloat contentSizeH = MAX(_imageContainerView.height, self.height);
    _scrollView.contentSize = CGSizeMake(self.scrollView.width, contentSizeH);
    [_scrollView scrollRectToVisible:self.bounds animated:NO];
    _scrollView.alwaysBounceVertical = _imageContainerView.height <= self.height ? NO : YES;
    _imageView.frame = _imageContainerView.bounds;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _scrollView.frame = CGRectMake(10, 0, self.width - 20, self.height);

    CGFloat progressX = (self.width - kPhotoPreviewViewProgressWH) / 2;
    CGFloat progressY = (self.height - kPhotoPreviewViewProgressWH) / 2;
    _viewProgress.frame = CGRectMake(progressX, progressY, kPhotoPreviewViewProgressWH, kPhotoPreviewViewProgressWH);
    
    [self recoverSubviews];
}

#pragma mark- Data
- (void)dataConfig {
    
}

#pragma mark- Set

- (void)setModel:(MJAssetModel *)model {
    _model = model;
    [_scrollView setZoomScale:1.0 animated:NO];
    
    if (model.type == MJAssetModelMediaTypePhotoGif) {
        // 先显示缩略图
        [[MJImageManager defaultManager] getPhotoWithAsset:model.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
            self.imageView.image = photo;
            [self resizeSubviews];
            
             // 再显示gif动图
            [[MJImageManager defaultManager] getOriginalPhotoDataWithAsset:model.asset completion:^(NSData *data, NSDictionary *info, BOOL isDegraded) {
                if (!isDegraded) {
//                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                        UIImage *image = [UIImage animatedGIFWithData:data];
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            self.imageView.image = image;
//                            [self resizeSubviews];
//                        });
//                    });
//                    self.imageView.image = [UIImage animatedGIFWithData:data];
//                    [self resizeSubviews];
                }
            }];
        } progressHandler:nil networkAccessAllowed:NO];
        
    } else {
        self.asset = model.asset;
    }
}

- (void)setAsset:(PHAsset *)asset {
    
    /// 图片复用清空
    self.imageView.image = nil;
    
    if (_asset && self.imageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
    }
    
    _asset = asset;
    
    self.imageRequestID = [[MJImageManager defaultManager] getPhotoWithAsset:asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        if (![asset isEqual:_asset]) return;
        self.imageView.image = photo;
        [self resizeSubviews];
        _viewProgress.hidden = YES;
        if (self.imageProgressUpdateBlock) {
            self.imageProgressUpdateBlock(1);
        }
        if (!isDegraded) {
            self.imageRequestID = 0;
        }
    } progressHandler:^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        if (![asset isEqual:_asset]) return;
        _viewProgress.hidden = NO;
        [self bringSubviewToFront:_viewProgress];
        progress = progress > 0.02 ? progress : 0.02;
        _viewProgress.progress = progress;
        if (self.imageProgressUpdateBlock && progress < 1) {
            self.imageProgressUpdateBlock(progress);
        }
        
        if (progress >= 1) {
            _viewProgress.hidden = YES;
            self.imageRequestID = 0;
        }
    } networkAccessAllowed:YES];
}

#pragma mark - UITapGestureRecognizer Event

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_scrollView.zoomScale > 1.0) {
        _scrollView.contentInset = UIEdgeInsetsZero;
        [_scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self.imageView];
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
        CGFloat xsize = self.frame.size.width / newZoomScale;
        CGFloat ysize = self.frame.size.height / newZoomScale;
        [_scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)singleTap:(UITapGestureRecognizer *)tap {
    if (self.singleTapGestureBlock) {
        self.singleTapGestureBlock();
    }
}

#pragma mark - Private

- (void)refreshImageContainerViewCenter {
    CGFloat offsetX = (_scrollView.width > _scrollView.contentSize.width) ? ((_scrollView.width - _scrollView.contentSize.width) * 0.5) : 0.0;
    CGFloat offsetY = (_scrollView.height > _scrollView.contentSize.height) ? ((_scrollView.height - _scrollView.contentSize.height) * 0.5) : 0.0;
    self.imageContainerView.center = CGPointMake(_scrollView.contentSize.width * 0.5 + offsetX, _scrollView.contentSize.height * 0.5 + offsetY);
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageContainerView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self refreshImageContainerViewCenter];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
//    [self refreshScrollViewContentSize];
}



@end
