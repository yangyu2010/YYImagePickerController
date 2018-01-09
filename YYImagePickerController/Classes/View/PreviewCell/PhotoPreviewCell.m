//
//  PhotoPreviewCell.m
//  YYImagePickerController
//
//  Created by Yang Yu on 2017/12/28.
//  Copyright © 2017年 Yang Yu. All rights reserved.
//

#import "PhotoPreviewCell.h"

@implementation PhotoPreviewCell


- (void)viewConfig {
    
    self.contentView.backgroundColor = [UIColor blackColor];
    
    self.previewView = [[PhotoPreviewView alloc] initWithFrame:CGRectZero];

    [self addSubview:self.previewView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.previewView.frame = self.bounds;
}

- (void)recoverSubviews {
    //[_previewView recoverSubviews];
}

#pragma mark- Set

- (void)setModel:(MJAssetModel *)model {
    [super setModel:model];
    
    _previewView.model = model;
}



@end
