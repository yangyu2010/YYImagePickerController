//
//  PhotoPickerToolView.h
//  YYImagePickerController
//
//  Created by Yang Yu on 2018/1/8.
//  Copyright © 2018年 Yang Yu. All rights reserved.
//  选中照片页面 下面的toolView

#import <UIKit/UIKit.h>
@class PhotoPickerToolView;

@protocol PhotoPickerToolViewDelegate <NSObject>

/// 选中所有
- (void)photoPickerToolViewSelectAllClick:(BOOL)isSelected;

/// 预览
- (void)photoPickerToolViewPreviewClick;

/// 完成
- (void)photoPickerToolViewDoneClick;

@end

@interface PhotoPickerToolView : UIView

/// 当前选中的个数
@property (nonatomic, assign) NSUInteger countSelected;

@property (nonatomic, weak) id <PhotoPickerToolViewDelegate> delegate;

/// 设置当前要选中所有
- (void)setSelectedAll;

@end
