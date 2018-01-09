//
//  AssetPreview+Photo.m
//  YYImagePickerController
//
//  Created by Yang Yu on 2018/1/9.
//  Copyright © 2018年 Yang Yu. All rights reserved.
//

#import "AssetPreview+Photo.h"
#import "UIView+Sugar.h"

@interface AssetPreview () <UIScrollViewDelegate>

@end

@implementation AssetPreview (Photo)

#pragma mark- Public

/// 加载预览照片需要的View
- (void)configPhotoPreview {
    
    if (self.scrollViewZoom == nil) {
        self.scrollViewZoom = [[UIScrollView alloc] init];
        self.scrollViewZoom.bouncesZoom = YES;
        self.scrollViewZoom.maximumZoomScale = 2.5;
        self.scrollViewZoom.minimumZoomScale = 1.0;
        self.scrollViewZoom.multipleTouchEnabled = YES;
        self.scrollViewZoom.delegate = self;
        self.scrollViewZoom.scrollsToTop = NO;
        self.scrollViewZoom.showsHorizontalScrollIndicator = NO;
        self.scrollViewZoom.showsVerticalScrollIndicator = YES;
        self.scrollViewZoom.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.scrollViewZoom.delaysContentTouches = NO;
        self.scrollViewZoom.canCancelContentTouches = YES;
        self.scrollViewZoom.alwaysBounceVertical = NO;
        [self addSubview:self.scrollViewZoom];
    }
    
    if (self.viewImageContainer == nil) {
        self.viewImageContainer = [[UIView alloc] init];
        self.viewImageContainer.clipsToBounds = YES;
        self.viewImageContainer.contentMode = UIViewContentModeScaleAspectFill;
        [self.scrollViewZoom addSubview:self.viewImageContainer];
    }
    
    if (self.imgViewIconShow == nil) {
        self.imgViewIconShow = [[UIImageView alloc] init];
        self.imgViewIconShow.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        self.imgViewIconShow.contentMode = UIViewContentModeScaleAspectFit;
        self.imgViewIconShow.clipsToBounds = YES;
        [self.viewImageContainer addSubview:self.imgViewIconShow];
    }
}

/// 更新Frames
- (void)updatePhotoPreviewFrames {
    self.scrollViewZoom.frame = CGRectMake(10, 0, self.width - 20, self.height);
    self.viewImageContainer.frame = self.scrollViewZoom.bounds;
    self.imgViewIconShow.frame = self.viewImageContainer.bounds;
}

- (void)setModelPhoto {
//    self.model
    
    [[MJImageManager defaultManager] getPhotoWithAsset:self.model.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        if (photo) {
            self.imgViewIconShow.image = photo;
        }
    }];
 
}


#pragma mark - Private

/// 把图片居中在屏幕中间
- (void)refreshImageContainerViewCenter:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.width > scrollView.contentSize.width) ? ((scrollView.width - scrollView.contentSize.width) * 0.5) : 0.0;
    CGFloat offsetY = (scrollView.height > scrollView.contentSize.height) ? ((scrollView.height - scrollView.contentSize.height) * 0.5) : 0.0;
    
    self.viewImageContainer.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.viewImageContainer;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self refreshImageContainerViewCenter:scrollView];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    //    [self refreshScrollViewContentSize];
}




@end
