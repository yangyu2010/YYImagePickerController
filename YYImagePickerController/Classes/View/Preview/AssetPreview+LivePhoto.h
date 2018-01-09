//
//  AssetPreview+LivePhoto.h
//  YYImagePickerController
//
//  Created by Yang Yu on 2018/1/9.
//  Copyright © 2018年 Yang Yu. All rights reserved.
//  livePhoto图片预览

#import "AssetPreview.h"
PHOTOS_CLASS_AVAILABLE_IOS_TVOS(9_1, 10_0)

@interface AssetPreview (LivePhoto) 

- (void)configLivePhotoPreview;

- (void)updateLivePhotoPreviewFrames;

- (void)setModelLivePhoto;

@end
