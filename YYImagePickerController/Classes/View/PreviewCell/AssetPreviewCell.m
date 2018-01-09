//
//  AssetPreviewCell.m
//  YYImagePickerController
//
//  Created by Yang Yu on 2018/1/9.
//  Copyright © 2018年 Yang Yu. All rights reserved.
//

#import "AssetPreviewCell.h"
#import "MJAssetModel.h"
#import "AssetPreview.h"

@interface AssetPreviewCell ()

@property (nonatomic, strong) AssetPreview *preview;


@end

@implementation AssetPreviewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self viewConfig];
        [self dataConfig];
    }
    return self;
}


#pragma mark- UI

- (void)viewConfig {
    _preview = [[AssetPreview alloc] init];
    [self.contentView addSubview:_preview];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _preview.frame = self.contentView.bounds;
    
}

#pragma mark- Data

- (void)dataConfig {
    
}

#pragma mark- Set
- (void)setModel:(MJAssetModel *)model {
    _model = model;
    
    _preview.model = model;

}




@end
