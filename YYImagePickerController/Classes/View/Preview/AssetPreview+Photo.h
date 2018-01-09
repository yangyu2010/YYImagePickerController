//
//  AssetPreview+Photo.h
//  YYImagePickerController
//
//  Created by Yang Yu on 2018/1/9.
//  Copyright © 2018年 Yang Yu. All rights reserved.
//  图片预览

#import "AssetPreview.h"

@interface AssetPreview (Photo)

- (void)setModelPhoto;

/// 加载预览照片需要的View
- (void)configPhotoPreview;

/// 更新Frames
- (void)updatePhotoPreviewFrames;

@end
