//
//  PhotoPreviewCell.h
//  YYImagePickerController
//
//  Created by Yang Yu on 2017/12/28.
//  Copyright © 2017年 Yang Yu. All rights reserved.
//  预览View Collection Cell

#import <UIKit/UIKit.h>
#import "AssetPreviewBaseCell.h"
#import "PhotoPreviewView.h"
#import "PhotoPreviewView.h"

@interface PhotoPreviewCell : AssetPreviewBaseCell

@property (nonatomic, strong) PhotoPreviewView *previewView;

- (void)recoverSubviews;

@end
