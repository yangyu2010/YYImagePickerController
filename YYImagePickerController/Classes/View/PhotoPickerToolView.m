//
//  PhotoPickerToolView.m
//  YYImagePickerController
//
//  Created by Yang Yu on 2018/1/8.
//  Copyright © 2018年 Yang Yu. All rights reserved.
//

#import "PhotoPickerToolView.h"
#import "UIView+Sugar.h"
#import "UILabel+Category.h"

@interface PhotoPickerToolView ()

@property (nonatomic, strong) UIButton *btnSelectAll;

@property (nonatomic, strong) UIButton *btnPreview;

@property (nonatomic, strong) UILabel *lblCount;

@property (nonatomic, strong) UIImageView *imgViewNumber;

@property (nonatomic, strong) UIButton *btnDone;

@property (nonatomic, strong) UIView *viewLine;


@end

@implementation PhotoPickerToolView

#pragma mark- Init


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self viewConfig];
        [self dataConfig];
        
//        self.btnDone.backgroundColor = [UIColor lightGrayColor];
//        self.btnAllIn.backgroundColor = [UIColor lightGrayColor];
//        self.btnPreview.backgroundColor = [UIColor lightGrayColor];
//        self.lblCount.backgroundColor = [UIColor lightGrayColor];
        
    }
    return self;
}


#pragma mark- UI

- (void)viewConfig {
    
    CGFloat rgb = 253 / 255.0;
    self.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];

    [self addSubview:self.btnSelectAll];
    [self addSubview:self.btnPreview];
    [self addSubview:self.btnDone];
    [self addSubview:self.imgViewNumber];
    [self addSubview:self.lblCount];

}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.viewLine.frame = CGRectMake(0, 0, self.width, 1.0);
    
    // cell的间距
    CGFloat margin = 5.0;
    CGFloat btnAllInW = 111.0f;
    CGFloat btnPreviewW = 80.0f;
    CGFloat btnDoneWH = 50.0f;
    CGFloat lblCountWh = [self.lblCount contentWidth];
    
    self.btnSelectAll.frame = CGRectMake(margin, 0, btnAllInW, self.height);
    self.btnPreview.frame = CGRectMake(self.width * 0.5 - btnPreviewW * 0.5, 0, btnPreviewW, self.height);
    self.btnDone.frame = CGRectMake(self.right - btnDoneWH - margin, 0, btnDoneWH, self.height);

    self.lblCount.frame = CGRectMake(self.btnDone.left - lblCountWh, self.height * 0.5 - lblCountWh * 0.5, lblCountWh, lblCountWh);
    self.imgViewNumber.frame = self.lblCount.frame;
}

#pragma mark- Data

- (void)dataConfig {
//    self.btnPreview.enabled = NO;
//    self.btnDone.enabled = NO;
}


#pragma mark- Action
/// 全选
- (void)actionAllInButtonClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoPickerToolViewSelectAllClick:)]) {
        [self.delegate photoPickerToolViewSelectAllClick:btn.selected];
    }
}

/// 预览
- (void)actionPreviewButtonClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoPickerToolViewPreviewClick)]) {
        [self.delegate photoPickerToolViewPreviewClick];
    }
}

/// 完成
- (void)actionDoneButtonClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoPickerToolViewDoneClick)]) {
        [self.delegate photoPickerToolViewDoneClick];
    }
}

#pragma mark- Public
/// 设置当前要选中所有
- (void)setSelectedAll {
    self.btnSelectAll.selected = YES;
}

#pragma mark- Set

- (void)setCountSelected:(NSUInteger)countSelected {
    _countSelected = countSelected;
    
    self.lblCount.text = [NSString stringWithFormat:@"%ld", (unsigned long)countSelected];
    [self layoutIfNeeded];
    [self setNeedsLayout];
    
    self.btnPreview.enabled = !(countSelected == 0);
    self.btnDone.enabled = !(countSelected == 0);
    
    [self.class showOscillatoryAnimationWithLayer:self.imgViewNumber.layer];
}

#pragma mark- Get
/// 选中所有Btn
- (UIButton *)btnSelectAll {
    if (_btnSelectAll == nil) {
        _btnSelectAll = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnSelectAll setTitle:@"Select All" forState:UIControlStateNormal];
        [_btnSelectAll addTarget:self action:@selector(actionAllInButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btnSelectAll setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnSelectAll setImage:[UIImage imageNamed:@"photo_original_def"] forState:UIControlStateNormal];
        [_btnSelectAll setImage:[UIImage imageNamed:@"photo_def_photoPickerVc"] forState:UIControlStateSelected];
        _btnSelectAll.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
        _btnSelectAll.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _btnSelectAll;
}

/// 预览Btn
- (UIButton *)btnPreview {
    if (_btnPreview == nil) {
        _btnPreview = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnPreview addTarget:self action:@selector(actionPreviewButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_btnPreview setTitle:@"Preview" forState:UIControlStateNormal];
        [_btnPreview setTitle:@"Preview" forState:UIControlStateDisabled];
        [_btnPreview setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnPreview setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    }
    return _btnPreview;
}

/// 完成按钮
- (UIButton *)btnDone {
    if (_btnDone == nil) {
        _btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnDone.titleLabel.font = [UIFont systemFontOfSize:16];
        [_btnDone addTarget:self action:@selector(actionDoneButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_btnDone setTitle:@"Done" forState:UIControlStateNormal];
        [_btnDone setTitle:@"Done" forState:UIControlStateDisabled];
        [_btnDone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnDone setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    }
    return _btnDone;
}

/// 数字的背景图
- (UIImageView *)imgViewNumber {
    if (_imgViewNumber == nil) {
        _imgViewNumber = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo_number_icon"]];
        _imgViewNumber.backgroundColor = [UIColor clearColor];
    }
    return _imgViewNumber;
}

/// 数字label
- (UILabel *)lblCount {
    if (_lblCount == nil) {
        _lblCount = [[UILabel alloc] init];
        _lblCount.font = [UIFont systemFontOfSize:15];
        _lblCount.textColor = [UIColor whiteColor];
        _lblCount.textAlignment = NSTextAlignmentCenter;
        _lblCount.backgroundColor = [UIColor clearColor];
        _lblCount.text = @"0";
    }
    return _lblCount;
}

- (UIView *)viewLine {
    if (_viewLine == nil) {
        _viewLine = [[UIView alloc] init];
        _viewLine.backgroundColor = [UIColor colorWithRed:222 / 255.0 green:222 / 255.0 blue:222 / 255.0 alpha:1.0];
    }
    return _viewLine;
}


#pragma mark- Private

+ (void)showOscillatoryAnimationWithLayer:(CALayer *)layer {
    NSNumber *animationScale1 = @(0.5);
    NSNumber *animationScale2 = @(1.15);
    
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        [layer setValue:animationScale1 forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            [layer setValue:animationScale2 forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                [layer setValue:@(1.0) forKeyPath:@"transform.scale"];
            } completion:nil];
        }];
    }];
}

@end
