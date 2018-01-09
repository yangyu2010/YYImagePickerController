//
//  AssetPreview.m
//  YYImagePickerController
//
//  Created by Yang Yu on 2018/1/9.
//  Copyright © 2018年 Yang Yu. All rights reserved.
//

#import "AssetPreview.h"
#import "AssetPreview+Photo.h"
#import "AssetPreview+LivePhoto.h"
#import "AssetPreview+Video.h"

#define kPhotoPreviewViewProgressWH     40.0f


@implementation AssetPreview

#pragma mark- Init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self viewConfig];
        [self dataConfig];
    }
    return self;
}


#pragma mark- UI

- (void)viewConfig {
    _viewProgress = [[ProgressView alloc] init];
    _viewProgress.hidden = YES;
    [self addSubview:_viewProgress];
    
//    [self configView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _viewProgress.bounds = CGRectMake(0, 0, kPhotoPreviewViewProgressWH, kPhotoPreviewViewProgressWH);
    _viewProgress.center = self.center;
    
    [self updateSubViewFrames];
}

#pragma mark- Data

- (void)dataConfig {
    
}

//- (void)setModel:(MJAssetModel *)model {
//    _model = model;
//}


#pragma mark- Private

- (void)setModel:(MJAssetModel *)model {
    _model = model;
    
//    self.type = model.type;
//    [self configView];
    
    if (model.type == MJAssetModelMediaTypePhoto ||
        model.type == MJAssetModelMediaTypePhotoGif) {
        [self setModelPhoto];
    } else if (model.type == MJAssetModelMediaTypeLivePhoto) {
        [self setModelLivePhoto];
    } else if (model.type == MJAssetModelMediaTypeVideo ||
               model.type == MJAssetModelMediaTypeAudio) {
//        [self configVideoPreview];
    }
    
}

/// 根据type来设置view
- (void)configView {
    if (self.type == MJAssetModelMediaTypePhoto ||
        self.type == MJAssetModelMediaTypePhotoGif) {
        [self configPhotoPreview];
    } else if (self.type == MJAssetModelMediaTypeLivePhoto) {
        [self configLivePhotoPreview];
    } else if (self.type == MJAssetModelMediaTypeVideo ||
               self.type == MJAssetModelMediaTypeAudio) {
        [self configVideoPreview];
    }
}

/// 更新frame
- (void)updateSubViewFrames {
    if (self.type == MJAssetModelMediaTypePhoto ||
        self.type == MJAssetModelMediaTypePhotoGif) {
        [self updatePhotoPreviewFrames];
    } else if (self.type == MJAssetModelMediaTypeLivePhoto) {
        [self updateLivePhotoPreviewFrames];
    } else if (self.type == MJAssetModelMediaTypeVideo ||
               self.type == MJAssetModelMediaTypeAudio) {
        [self updateVideoPreviewFrames];
    }
}

@end
