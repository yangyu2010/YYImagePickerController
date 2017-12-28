//
//  PhotoPreviewCell.m
//  YYImagePickerController
//
//  Created by Yang Yu on 2017/12/28.
//  Copyright © 2017年 Yang Yu. All rights reserved.
//

#import "PhotoPreviewCell.h"

@implementation PhotoPreviewCell


- (void)configSubviews {
    self.previewView = [[PhotoPreviewView alloc] initWithFrame:CGRectZero];
    __weak typeof(self) weakSelf = self;
    [self.previewView setSingleTapGestureBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.singleTapGestureBlock) {
            strongSelf.singleTapGestureBlock();
        }
    }];
    [self.previewView setImageProgressUpdateBlock:^(double progress) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.imageProgressUpdateBlock) {
            strongSelf.imageProgressUpdateBlock(progress);
        }
    }];
    [self addSubview:self.previewView];
}

- (void)setModel:(MJAssetModel *)model {
    [super setModel:model];
    _previewView.asset = model.asset;
}

- (void)recoverSubviews {
    [_previewView recoverSubviews];
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.previewView.frame = self.bounds;
}


@end
