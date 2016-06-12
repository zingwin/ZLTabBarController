//
//  ZLTabBarItem.m
//  ZLTabBarController
//
//  Created by hitao on 16/6/8.
//  Copyright © 2016年 hitao. All rights reserved.
//

#import "ZLTabBarItem.h"

@interface ZLTabBarItem()
{
    NSString *_title;
    UIOffset _imagePositionAdjustment;
    NSDictionary *_unselectedTitleAttributes;
    NSDictionary *_selectedTitleAttributes;
}
@property UIImage *unselectedBackgroundImage;
@property UIImage *selectedBackgroundImage;
@property UIImage *unselectedImage;
@property UIImage *selectedImage;
@end

@implementation ZLTabBarItem
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

-(id)init{
    return [self initWithFrame:CGRectZero];
}

-(void)commonInitialization{
    //setup defaults
    _title = @"";
    _titlePositionAdjustment = UIOffsetZero;
    
    _unselectedTitleAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:11],
                                   NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    _selectedTitleAttributes = [_unselectedTitleAttributes copy];
    
    _badgeBackgroundColor = [UIColor redColor];
    _badgeTextColor = [UIColor whiteColor];
    _badgeTextFont = [UIFont systemFontOfSize:12];
    _badgePositionAdjustment = UIOffsetZero;
    
    _strokeWidth = .0f;
    _strokeColor = [UIColor clearColor];
    _strokePadding = 5;
}

-(void)drawRect:(CGRect)rect{
    CGSize frameSize = self.frame.size;
    CGSize imageSize = CGSizeZero;
    CGSize titleSize = CGSizeZero;
    NSDictionary *titleAttributes = nil;
    UIImage *backgroundImage = nil;
    UIImage *image = nil;
    CGFloat imageStartingY = 0.0f;
    
    if ([self isSelected]) {
        image = [self selectedImage];
        backgroundImage = [self selectedBackgroundImage];
        titleAttributes = [self selectedTitleAttributes];
        
        if (!titleAttributes) {
            titleAttributes = [self unselectedTitleAttributes];
        }
    }else{
        image = [self unselectedImage];
        backgroundImage = [self unselectedBackgroundImage];
        titleAttributes = [self unselectedTitleAttributes];
    }
    
    imageSize = [image size];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    //draw background image
    [backgroundImage drawInRect:self.bounds];
    
    //draw image and title
    if(![_title length]){
        [image drawInRect:CGRectMake(roundf(frameSize.width/2.0 - imageSize.width/2.0)+_imagePositionAdjustment.horizontal,roundf(frameSize.height/2.0-imageSize.height/2.0)+_imagePositionAdjustment.vertical, imageSize.width, imageSize.height)];
    }else{
        titleSize = [_title boundingRectWithSize:CGSizeMake(frameSize.width, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleAttributes context:nil].size;
        
        imageStartingY = roundf((frameSize.height-imageSize.height-titleSize.height)/2.0);
        
        [image drawInRect:CGRectMake(roundf(frameSize.width/2.0f-imageSize.width/2.0+_imagePositionAdjustment.horizontal), imageStartingY+_imagePositionAdjustment.vertical, imageSize.width, imageSize.height)];
        
        CGContextSetFillColorWithColor(context, [titleAttributes[NSForegroundColorAttributeName] CGColor]);
        
        [_title drawInRect:CGRectMake(roundf((frameSize.width-titleSize.width)/2.0)+_titlePositionAdjustment.horizontal, imageStartingY+imageSize.height+_titlePositionAdjustment.vertical, titleSize.width, titleSize.height) withAttributes:titleAttributes];
    }
    
    //darw out 圈圈
    if ([self isSelected]) {
        CGContextSetStrokeColorWithColor(context, _strokeColor.CGColor);
        CGContextSetLineWidth(context, _strokeWidth);//线的宽度
        //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度
        // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
        CGPoint center = CGPointMake(frameSize.width/2.0+_imagePositionAdjustment.horizontal, frameSize.height/2.0+_imagePositionAdjustment.vertical+_titlePositionAdjustment.vertical);
        CGFloat radius = (imageSize.height + titleSize.height+_titlePositionAdjustment.vertical+_imagePositionAdjustment.vertical)/2.0f + _strokePadding;
        CGContextAddArc(context, center.x, center.y, radius, 0, 2*3.1415926, 0); //添加一个圆
        CGContextDrawPath(context, kCGPathStroke); //绘制路径
    }
    
    //draw badges
    if ([[self badgeValue] integerValue] != 0) {
        CGSize badgeSize = CGSizeZero;
        
        badgeSize = [_badgeValue boundingRectWithSize:CGSizeMake(frameSize.width, 20)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName: [self badgeTextFont]}
                                              context:nil].size;
        
        CGFloat textOffset = 2.0f;
        
        if (badgeSize.width < badgeSize.height) {
            badgeSize = CGSizeMake(badgeSize.height, badgeSize.height);
        }
        
        CGRect badgeBackgroundFrame = CGRectMake(roundf((frameSize.width/2.0+imageSize.width/2.0)*0.9f)+_badgePositionAdjustment.horizontal, textOffset+_badgePositionAdjustment.vertical, badgeSize.width+2*textOffset, badgeSize.height+2*textOffset);
        
        if ([self badgeBackgroundColor]) {
            CGContextSetFillColorWithColor(context, [[self badgeBackgroundColor] CGColor]);
            
            CGContextFillEllipseInRect(context, badgeBackgroundFrame);
        }else{
            [[self badgeBackgroundImage] drawInRect:badgeBackgroundFrame];
        }
        
        CGContextSetFillColorWithColor(context, [self badgeTextColor].CGColor);
        
        NSMutableParagraphStyle *badgeTextStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        [badgeTextStyle setLineBreakMode:NSLineBreakByWordWrapping];
        [badgeTextStyle setAlignment:NSTextAlignmentCenter];
        
        NSDictionary *badgeTextAttributes = @{
                                              NSFontAttributeName: [self badgeTextFont],
                                              NSForegroundColorAttributeName: [self badgeTextColor],
                                              NSParagraphStyleAttributeName: badgeTextStyle,
                                              };
        
        [[self badgeValue] drawInRect:CGRectMake(CGRectGetMinX(badgeBackgroundFrame) + textOffset,
                                                 CGRectGetMinY(badgeBackgroundFrame) + textOffset,
                                                 badgeSize.width, badgeSize.height)
                       withAttributes:badgeTextAttributes];
        
        CGContextRestoreGState(context);
    }
}

#pragma mark - Image configuration
-(UIImage*)finishedSelectedImage{
    return [self selectedImage];
}

-(UIImage*)finishedUnselectedImage{
    return [self unselectedImage];
}

- (void)setFinishedSelectedImage:(UIImage *)selectedImage withFinishedUnselectedImage:(UIImage *)unselectedImage {
    if (selectedImage && (selectedImage != [self selectedImage])) {
        [self setSelectedImage:selectedImage];
    }
    
    if (unselectedImage && (unselectedImage != [self unselectedImage])) {
        [self setUnselectedImage:unselectedImage];
    }
}

- (void)setBadgeValue:(NSString *)badgeValue {
    _badgeValue = badgeValue;
    
    [self setNeedsDisplay];
}

#pragma mark - Background configuration

- (UIImage *)backgroundSelectedImage {
    return [self selectedBackgroundImage];
}

- (UIImage *)backgroundUnselectedImage {
    return [self unselectedBackgroundImage];
}

- (void)setBackgroundSelectedImage:(UIImage *)selectedImage withUnselectedImage:(UIImage *)unselectedImage {
    if (selectedImage && (selectedImage != [self selectedBackgroundImage])) {
        [self setSelectedBackgroundImage:selectedImage];
    }
    
    if (unselectedImage && (unselectedImage != [self unselectedBackgroundImage])) {
        [self setUnselectedBackgroundImage:unselectedImage];
    }
}

#pragma mark - Accessibility

- (NSString *)accessibilityLabel{
    return @"tabbarItem";
}

- (BOOL)isAccessibilityElement
{
    return YES;
}
@end
