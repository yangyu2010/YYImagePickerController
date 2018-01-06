//
//  MJAlbumsController.h
//  MJImagePicker
//
//  Created by Yang Yu on 2017/12/26.
//  Copyright © 2017年 Yang Yu. All rights reserved.
//  相簿页面控制器

#import <UIKit/UIKit.h>
@class MJAlbumModel;

@interface MJAlbumsController : UIViewController

/// 所有的相册数组
@property (nonatomic, strong) NSArray<MJAlbumModel *> *arrAllAlbums;


@end



