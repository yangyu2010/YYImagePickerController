//
//  PhotoCollectionCell.m
//  YYImagePickerController
//
//  Created by Yang Yu on 2017/12/27.
//  Copyright © 2017年 Yang Yu. All rights reserved.
//

#import "PhotoCollectionCell.h"
#import "MJImageManager.h"
#import <Photos/Photos.h>
#import "UIView+Sugar.h"

@interface PhotoCollectionCell ()

/// Icon
@property (nonatomic, strong) UIImageView *imgViewPhoto;

/// 背景
@property (nonatomic, strong) UIView *viewBg;

/// 选中对勾
@property (nonatomic, strong) UIImageView *imageViewSelected;


@end

@implementation PhotoCollectionCell

#pragma mark- Init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self viewConfig];
    
    }
    return self;
}


#pragma mark- View
- (void)viewConfig {
    [self.contentView addSubview:self.imgViewPhoto];
    [self.contentView addSubview:self.viewBg];
    self.viewBg.hidden = YES;
    [self.contentView addSubview:self.imageViewSelected];
    self.imageViewSelected.hidden = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imgViewPhoto.frame = self.contentView.bounds;
    self.viewBg.frame = self.contentView.bounds;
    self.imageViewSelected.frame = CGRectMake(self.contentView.width - self.imageViewSelected.image.size.width, 0, self.imageViewSelected.image.size.width, self.imageViewSelected.image.size.height);
}

#pragma mark- Data
- (void)dataConfig {
    
}

#pragma mark- Set

- (void)setModel:(MJAssetModel *)model {
    _model = model;
    
    [[MJImageManager defaultManager] getPhotoWithAsset:model.asset photoWidth:self.contentView.bounds.size.width completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        if (photo) {
            self.imgViewPhoto.image = photo;
        }
        
        // 当前图片存在iCloud里, 可以在ui上有表示
        if (info[PHImageResultIsInCloudKey]) {
            
        }
    }];
    
    self.viewBg.hidden = YES;
    self.imageViewSelected.hidden = YES;
    
    self.viewBg.hidden = !model.isSelected;
    self.imageViewSelected.hidden = !model.isSelected;
}

#pragma mark- Get
- (UIImageView *)imgViewPhoto {
    if (_imgViewPhoto == nil) {
        _imgViewPhoto = [[UIImageView alloc] init];
        _imgViewPhoto.contentMode = UIViewContentModeScaleAspectFill;
        _imgViewPhoto.clipsToBounds = YES;
    }
    return _imgViewPhoto;
}

- (UIView *)viewBg {
    if (_viewBg == nil) {
        _viewBg = [[UIView alloc] init];
        _viewBg.backgroundColor = [UIColor blackColor];
        _viewBg.alpha = 0.6;
    }
    return _viewBg;
}

- (UIImageView *)imageViewSelected {
    if (_imageViewSelected == nil) {
        _imageViewSelected = [[UIImageView alloc] init];
        _imageViewSelected.image = [UIImage imageNamed:@"photo_sel_previewVc"];
    }
    return _imageViewSelected;
}

@end
