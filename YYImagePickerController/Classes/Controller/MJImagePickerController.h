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

/**
 默认最大可选数, 如果是0则不限制
 */
@property (nonatomic, assign) NSInteger maxImagesCount;

/**
 用户选择的所有照片或资源
 最后返回给用户的是这个数组
 */
@property (nonatomic, strong) NSMutableArray *arrSelectedModels;


@end




@protocol ImagePickerControllerDelegate <NSObject>

- (void)imagePickerController:(MJAlbumsController *)picker
       didFinishPickingAssets:(NSArray<MJAssetModel *> *)assets;

@end
