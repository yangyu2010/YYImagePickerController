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

- (void)configSubviews {

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
    //    _previewView.asset = model.asset;
    
    
    CGSize size = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
    
    
    PHLivePhotoRequestOptions *options = [[PHLivePhotoRequestOptions alloc] init];
    options.networkAccessAllowed = YES;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    [[PHImageManager defaultManager] requestLivePhotoForAsset:model.asset targetSize:size contentMode:PHImageContentModeAspectFill options:options resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable info) {
        
        if (livePhoto) {
            self.livePhotoView.livePhoto = livePhoto;
        }
        
    }];
    
}

@end
