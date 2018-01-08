//
//  AlbumsCell.m
//  YYImagePickerController
//
//  Created by Yang Yu on 2017/12/27.
//  Copyright © 2017年 Yang Yu. All rights reserved.
//

#import "AlbumsCell.h"
#import "UIView+Sugar.h"
#import "MJImageManager.h"

/// lblSelectedCount宽高
#define kAlbumsCellSelectedCountLabelWH  24.0f

/// lblSelectedCount距离右边的距离
#define kAlbumsCellSelectedCountLabelRight 30.0f

@interface AlbumsCell ()

/// 封面图
@property (nonatomic, strong) UIImageView *imgViewPoster;

/// 相簿标题
@property (nonatomic, strong) UILabel *lblTitle;

/// 当前相簿里有多少个被选中的
@property (nonatomic, strong) UILabel *lblSelectedCount;

@end

@implementation AlbumsCell

#pragma mark- Init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self viewConfig];
        
        /// mark 测试
//        self.imgViewPoster.image = [UIImage imageNamed:@"default"];
//        self.lblSelectedCount.text = @"99";
//        self.lblTitle.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

#pragma mark- View
- (void)viewConfig {
    //  UITableViewCellAccessoryDisclosureIndicator
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [self.contentView addSubview:self.imgViewPoster];
    [self.contentView addSubview:self.lblSelectedCount];
    [self.contentView addSubview:self.lblTitle];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imgViewPoster.frame = CGRectMake(0, 0, self.contentView.height, self.contentView.height);
    self.lblSelectedCount.frame = CGRectMake(self.contentView.width - kAlbumsCellSelectedCountLabelWH, self.imgViewPoster.centerY - kAlbumsCellSelectedCountLabelWH * 0.5, kAlbumsCellSelectedCountLabelWH, kAlbumsCellSelectedCountLabelWH);

    self.lblTitle.frame = CGRectMake(self.imgViewPoster.right + 10, 0, self.contentView.width - self.imgViewPoster.right - kAlbumsCellSelectedCountLabelWH - 20, self.contentView.height);
}

#pragma mark- Data
- (void)dataConfig {
    
}

#pragma mark- Set
- (void)setModel:(MJAlbumModel *)model {
    _model = model;

    NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:model.name attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor blackColor]}];
    NSAttributedString *countString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  (%zd)",model.count] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    [nameString appendAttributedString:countString];
    self.lblTitle.attributedText = nameString;
    
    self.lblSelectedCount.hidden = (model.selectedCount == 0);
    self.lblSelectedCount.text = [NSString stringWithFormat:@"%ld", (unsigned long)model.selectedCount];
    
    [[MJImageManager defaultManager] getPostImageWithAlbumModel:model completion:^(UIImage *image) {
        self.imgViewPoster.image = image;
    }];
    
    self.lblSelectedCount.text = [NSString stringWithFormat:@"%ld", (unsigned long)model.selectedCount];
}

#pragma mark- Get

- (UIImageView *)imgViewPoster {
    if (_imgViewPoster == nil) {
        _imgViewPoster = [[UIImageView alloc] init];
        _imgViewPoster.contentMode = UIViewContentModeScaleAspectFill;
        _imgViewPoster.clipsToBounds = YES;
    }
    return _imgViewPoster;
}

- (UILabel *)lblTitle {
    if (_lblTitle == nil) {
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.font = [UIFont boldSystemFontOfSize:17];
        _lblTitle.textColor = [UIColor blackColor];
        _lblTitle.textAlignment = NSTextAlignmentLeft;
        _lblTitle.numberOfLines = 2;
    }
    return _lblTitle;
}

- (UILabel *)lblSelectedCount {
    if (_lblSelectedCount == nil) {
        _lblSelectedCount = [[UILabel alloc] init];
        _lblSelectedCount.font = [UIFont boldSystemFontOfSize:15];
        _lblSelectedCount.textColor = [UIColor whiteColor];
        _lblSelectedCount.backgroundColor = [UIColor redColor];
        _lblSelectedCount.textAlignment = NSTextAlignmentCenter;
        _lblSelectedCount.layer.cornerRadius = 12;
        _lblSelectedCount.clipsToBounds = YES;
    }
    return _lblSelectedCount;
}

@end
