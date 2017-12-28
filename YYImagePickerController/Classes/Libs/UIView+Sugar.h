//
//  UIView+Sugar.h
//  GetFriends
//
//  Created by Yu Yang on 2017/9/23.
//  Copyright © 2017年 Musjoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Sugar)

#pragma mark - Frame
/// 视图原点
@property (nonatomic) CGPoint origin;
/// 视图尺寸
@property (nonatomic) CGSize size;

#pragma mark - Frame Origin
/// frame 原点 x 值
@property (nonatomic) CGFloat x;
/// frame 原点 y 值
@property (nonatomic) CGFloat y;

#pragma mark - Frame Size
/// frame 尺寸 width
@property (nonatomic) CGFloat width;
/// frame 尺寸 height
@property (nonatomic) CGFloat height;

@property (nonatomic, assign, readonly) CGFloat top;
@property (nonatomic, assign, readonly) CGFloat left;
@property (nonatomic, assign, readonly) CGFloat bottom;
@property (nonatomic, assign, readonly) CGFloat right;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;


@end
