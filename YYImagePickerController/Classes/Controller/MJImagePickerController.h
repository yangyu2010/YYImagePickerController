//
//  MJImagePickerController.h
//  YYImagePickerController
//
//  Created by Yang Yu on 2018/1/6.
//  Copyright © 2018年 Yang Yu. All rights reserved.
//  图片Picker Nav

#import <UIKit/UIKit.h>
#import "MJAlbumsController.h"

@protocol ImagePickerControllerDelegate;
@class MJAssetModel;

@interface MJImagePickerController : UINavigationController

- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount
                          columnNumber:(NSInteger)columnNumber
                              delegate:(id<ImagePickerControllerDelegate>)delegate
                     pushPhotoPickerVc:(BOOL)pushPhotoPickerVc;


@end




@protocol ImagePickerControllerDelegate <NSObject>

- (void)imagePickerController:(MJAlbumsController *)picker
       didFinishPickingAssets:(NSArray<MJAssetModel *> *)assets;

@end
