//
//  AssetPreviewBaseCell.m
//  YYImagePickerController
//
//  Created by Yang Yu on 2017/12/28.
//  Copyright © 2017年 Yang Yu. All rights reserved.
//

#import "AssetPreviewBaseCell.h"
#import "UIView+Sugar.h"

#define kPhotoPreviewViewProgressWH     40.0f

@implementation AssetPreviewBaseCell

#pragma mark- Init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self viewConfig];
        [self dataConfig];
    }
    return self;
}

#pragma mark- UI

- (void)viewConfig {
    self.backgroundColor = [UIColor blackColor];

    [self.contentView addSubview:self.viewProgress];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.width -= 20;
    
    self.viewProgress.bounds = CGRectMake(0, 0, kPhotoPreviewViewProgressWH, kPhotoPreviewViewProgressWH);
    self.viewProgress.center = self.contentView.center;
}

#pragma mark- Data

- (void)dataConfig {
    
}


#pragma mark- Get

- (ProgressView *)viewProgress {
    if (_viewProgress == nil) {
        _viewProgress = [[ProgressView alloc] init];
        _viewProgress.hidden = YES;
    }
    return _viewProgress;
}



@end
