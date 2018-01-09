//
//  AssetPreview+LivePhoto.m
//  YYImagePickerController
//
//  Created by Yang Yu on 2018/1/9.
//  Copyright © 2018年 Yang Yu. All rights reserved.
//

#import "AssetPreview+LivePhoto.h"
#import <PhotosUI/PhotosUI.h>

@implementation AssetPreview (LivePhoto)


- (void)configLivePhotoPreview {
    if (@available(iOS 9_1, *)) {
        if (self.viewLivePhoto == nil) {
            self.viewLivePhoto = [[PHLivePhotoView alloc] initWithFrame:CGRectZero];
            self.viewLivePhoto.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:self.viewLivePhoto];
        }
    }
}

- (void)updateLivePhotoPreviewFrames {
    if (@available(iOS 9_1, *)) {
        self.viewLivePhoto.frame = self.bounds;
    }
}

- (void)setModelLivePhoto {
    if (@available(iOS 9_1, *)) {
        PHLivePhotoRequestOptions *options = [[PHLivePhotoRequestOptions alloc] init];
        options.networkAccessAllowed = YES;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        
        [[PHImageManager defaultManager] requestLivePhotoForAsset:self.model.asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable info) {
            if (livePhoto) {
                self.viewLivePhoto.livePhoto = livePhoto;
            }
        }];
    }
    
}

@end
