//
//  PhotoCollectionCell.m
//  YYImagePickerController
//
//  Created by Yang Yu on 2017/12/27.
//  Copyright © 2017年 Yang Yu. All rights reserved.
//

#import "PhotoCollectionCell.h"
#import "MJImageManager.h"

@interface PhotoCollectionCell ()

@property (nonatomic, strong) UIImageView *imgViewPhoto;

@end

@implementation PhotoCollectionCell

#pragma mark- Init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self viewConfig];
        
        /// mark 测试
        self.imgViewPhoto.image = [UIImage imageNamed:@"default"];
    }
    return self;
}


#pragma mark- View
- (void)viewConfig {
    [self.contentView addSubview:self.imgViewPhoto];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imgViewPhoto.frame = self.contentView.bounds;
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
    }];
    
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


@end
