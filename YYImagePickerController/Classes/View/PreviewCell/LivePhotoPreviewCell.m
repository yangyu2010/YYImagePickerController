//
//  LivePhotoPreviewCell.m
//  YYImagePickerController
//
//  Created by Yang Yu on 2017/12/29.
//  Copyright © 2017年 Yang Yu. All rights reserved.
//

#import "LivePhotoPreviewCell.h"
#import "MJImageManager.h"

@interface LivePhotoPreviewCell ()

@property (nonatomic, strong) PHLivePhotoView *livePhotoView;

@end

@implementation LivePhotoPreviewCell

- (void)viewConfig {
    [super viewConfig];

    _livePhotoView = [[PHLivePhotoView alloc] initWithFrame:CGRectZero];
    _livePhotoView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_livePhotoView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _livePhotoView.frame = self.contentView.bounds;
}

- (void)setModel:(MJAssetModel *)model {
    [super setModel:model];
    
    CGSize size = CGSizeMake(self.bounds.size.width, self.bounds.size.height);

    self.viewProgress.hidden = NO;
    self.viewProgress.progress = 0;
    
    [[MJImageManager defaultManager] getLivePhotoWithAsset:model.asset size:size progressHandler:^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        
        self.viewProgress.progress = progress;
        if (progress >= 1.0) {
            self.viewProgress.hidden = YES;
        }
        
    } completion:^(PHLivePhoto *livePhoto, NSDictionary *info, BOOL isDegraded) {
        if (livePhoto) {
            self.livePhotoView.livePhoto = livePhoto;
        }
    }];
    
}

@end
