//
//  NSObject+Utils.h
//  Common
//
//  Created by 黄磊 on 16/4/6.
//  Copyright © 2016年 Musjoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Utils)

- (void)performOnMainThread:(void (^)(void))block;

@end
