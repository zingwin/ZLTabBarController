//
//  UIColor+ColorFromHex.m
//  ZLTabBarController
//
//  Created by hitao on 16/6/12.
//  Copyright © 2016年 hitao. All rights reserved.
//

#import "UIColor+ColorFromHex.h"
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation UIColor (ColorFromHex)
+ (UIColor*)colorWithHex:(int)hex {
    return UIColorFromRGB(hex);
}
@end
