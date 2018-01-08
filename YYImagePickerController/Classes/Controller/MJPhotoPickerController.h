//
//  MJPhotoPickerController.h
//  YYImagePickerController
//
//  Created by Yang Yu on 2017/12/27.
//  Copyright © 2017年 Yang Yu. All rights reserved.
//  选中照片页面

#import <UIKit/UIKit.h>
@class MJAlbumModel;

@interface MJPhotoPickerController : UIViewController

/// 当前的相簿
@property (nonatomic, strong) MJAlbumModel *modelAlbum;

@end
