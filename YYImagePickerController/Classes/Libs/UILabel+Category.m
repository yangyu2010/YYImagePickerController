//
//  UILabel+Category.m
//  YYImagePickerController
//
//  Created by Yang Yu on 2018/1/8.
//  Copyright © 2018年 Yang Yu. All rights reserved.
//

#import "UILabel+Category.h"

@implementation UILabel (Category)

/// 当前文本内容的宽度
- (CGFloat)contentWidth {

    NSDictionary *dic = @{NSFontAttributeName : self.font};
    CGSize size = [self.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.bounds.size.height) options: NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
//    NSLog(@"contentWidth %@", NSStringFromCGSize(size));
    
    if (size.width < 34) {
        return 34.0;
    }
    
    return size.width;
}

@end
