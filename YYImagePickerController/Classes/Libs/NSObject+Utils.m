//
//  NSObject+Utils.m
//  Common
//
//  Created by 黄磊 on 16/4/6.
//  Copyright © 2016年 Musjoy. All rights reserved.
//

#import "NSObject+Utils.h"

@implementation NSObject (Utils)

- (void)performOnMainThread:(void (^)(void))block
{
    if ([[NSThread currentThread] isMainThread]) {
        if (block) {
            block();
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block();
            }
        });
    }
}

@end
