//
//  ZLTabBar.m
//  ZLTabBarController
//
//  Created by hitao on 16/6/8.
//  Copyright © 2016年 hitao. All rights reserved.
//

#import "ZLTabBar.h"
#import "ZLTabBarItem.h"

@interface ZLTabBar()
@property (nonatomic) CGFloat itemWidth;
@property(nonatomic,strong) UIView *anicontainer;
@end

@implementation ZLTabBar
- (id)initWithFrame:(CGRect)frame {
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

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (void)commonInitialization {
    self.anicontainer = [[UIView alloc] init];
    self.anicontainer.backgroundColor = [UIColor clearColor];
    self.anicontainer.userInteractionEnabled = NO;
    [self addSubview:self.anicontainer];
    
    [self setTranslucent:NO];
    
    _isShowStrokeAnimaiton = YES;
    _barItemStrokeColor = [UIColor redColor];
    _barItemLineWidth = 1;
}

-(void)layoutSubviews{
    CGSize frameSize = self.frame.size;
    CGFloat minimumContentHeight = [self minimumContentHeight];
    
    [[self anicontainer] setFrame:CGRectMake(0, frameSize.height-minimumContentHeight, frameSize.width, frameSize.height)];
    
    
    [self setItemWidth:roundf((frameSize.width - [self contentEdgeInsets].left -
                               [self contentEdgeInsets].right) / [[self items] count])];
    
    NSInteger index = 0;
    
    //layout item
    for (ZLTabBarItem *item in [self items]) {
        CGFloat itemHeight = [item itemHeight];
        
        if (!itemHeight) {
            itemHeight = frameSize.height;
        }
        
        [item setFrame:CGRectMake(self.contentEdgeInsets.left + (index * self.itemWidth),
                                  roundf(frameSize.height - itemHeight) - self.contentEdgeInsets.top,
                                  self.itemWidth, itemHeight - self.contentEdgeInsets.bottom)];
        
        if(_isShowStrokeAnimaiton){
            item.strokeColor = _barItemStrokeColor;
            item.strokeWidth = _barItemLineWidth;
        }
        
        [item setNeedsDisplay];
        
        index++;
    }
    
    [self sendSubviewToBack:self.anicontainer];
}

#pragma mark - Configuration
- (void)setItemWidth:(CGFloat)itemWidth {
    if (itemWidth > 0) {
        _itemWidth = itemWidth;
    }
}

- (void)setItems:(NSArray *)items {
    for (ZLTabBarItem *item in _items) {
        [item removeFromSuperview];
    }
    
    _items = [items copy];
    NSInteger index = 0;
    for (ZLTabBarItem *item in _items) {
        item.tag = 23234 + index;
        [item addTarget:self action:@selector(tabBarItemWasSelected:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:item];
        ++index;
    }
}

- (void)setHeight:(CGFloat)height {
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame),
                              CGRectGetWidth(self.frame), height)];
}

- (CGFloat)minimumContentHeight {
    CGFloat minimumTabBarContentHeight = CGRectGetHeight([self frame]);
    
    for (ZLTabBarItem *item in [self items]) {
        CGFloat itemHeight = [item itemHeight];
        if (itemHeight && (itemHeight < minimumTabBarContentHeight)) {
            minimumTabBarContentHeight = itemHeight;
        }
    }
    
    return minimumTabBarContentHeight;
}

#pragma mark - Item selection

-(void)tabBarItemWasSelected:(id)sender{
    if ([[self delegate] respondsToSelector:@selector(tabBar:shouldSelectItemAtIndex:)]) {
        NSInteger index = [self.items indexOfObject:sender];
        if (![[self delegate] tabBar:self shouldSelectItemAtIndex:index]) {
            return;
        }
    }
    
    [self setSelectedItem:sender];
    
    if ([[self delegate] respondsToSelector:@selector(tabBar:didSelectItemAtIndex:)]) {
        NSInteger index = [self.items indexOfObject:sender];
        [[self delegate] tabBar:self didSelectItemAtIndex:index];
    }
}

-(void)setSelectedItem:(ZLTabBarItem *)selectedItem{
    if (selectedItem == _selectedItem) {
        return;
    }
    
    if (_selectedItem == nil) {
        _selectedItem = selectedItem;
        [_selectedItem setSelected:YES];
        return;
    }
    
    [_selectedItem setSelected:NO];

    if (self.isShowStrokeAnimaiton) {
        self.userInteractionEnabled = NO;
        [self transitionToItem:selectedItem animated:YES];
    }else{
        _selectedItem = selectedItem;
        [_selectedItem setSelected:YES];
    }
}

#pragma mark - Translucency

- (void)setTranslucent:(BOOL)translucent {
    _translucent = translucent;
    
    self.alpha = _translucent?.1f:1.0f;
}

#pragma mark - Accessibility

- (BOOL)isAccessibilityElement{
    return NO;
}

- (NSInteger)accessibilityElementCount{
    return self.items.count;
}

- (id)accessibilityElementAtIndex:(NSInteger)index{
    return self.items[index];
}

- (NSInteger)indexOfAccessibilityElement:(id)element{
    return [self.items indexOfObject:element];
}

- (void)transitionToItem:(ZLTabBarItem*)newItem animated:(BOOL)animated {
    
    CAShapeLayer *animatingTabTransitionLayer = [CAShapeLayer layer];
    
    void (^completionBlock)(void) = ^{
        [animatingTabTransitionLayer removeFromSuperlayer];
        [animatingTabTransitionLayer removeAllAnimations];
        _selectedItem = newItem;
         [_selectedItem setSelected:YES];
        self.userInteractionEnabled = YES;
    };
    
    if (!animated) {
        completionBlock();
        return;
    }
    
    [self layoutIfNeeded];
    
    //layer for path transitioning from one tab to the next
    UIBezierPath *animatingTabTransitionBezierPath = [UIBezierPath bezierPath];
    animatingTabTransitionLayer.strokeColor = _barItemStrokeColor.CGColor;
    animatingTabTransitionLayer.fillColor = [UIColor clearColor].CGColor;
    animatingTabTransitionLayer.lineWidth = _barItemLineWidth;
    
    //determines direction in which we unwind
    bool clockwise = newItem.tag < self.selectedItem.tag?true:false;
    
    //vars used to determine total length later
    double circumference, distanceBetweenTabs, totalLength;
    
    if (!self.selectedItem.title) {
        
        //need to adjust when there is no text
        //first item's outline
        [animatingTabTransitionBezierPath addArcWithCenter:self.selectedItem.center radius:(self.selectedItem.finishedSelectedImage.size.width)/2.0+self.selectedItem.strokePadding startAngle:M_PI/2 endAngle:M_PI clockwise:clockwise];
        [animatingTabTransitionBezierPath addArcWithCenter:self.selectedItem.center radius:(self.selectedItem.finishedSelectedImage.size.width)/2.0+self.selectedItem.strokePadding startAngle:M_PI  endAngle:M_PI/2 clockwise:clockwise];
        
        //traveling from one item to the next
        CGSize imageSize = self.selectedItem.finishedSelectedImage.size;
        CGSize tabItemSize = self.selectedItem.frame.size;
        
        CGFloat ox = CGRectGetMidX(self.selectedItem.frame);
        CGPoint origin = CGPointMake(ox, tabItemSize.height-(tabItemSize.height-imageSize.height)/2.0f+self.selectedItem.strokePadding);
        
        CGFloat dx = CGRectGetMidX(newItem.frame);
        CGPoint destination = CGPointMake(dx, tabItemSize.height-(tabItemSize.height-imageSize.height)/2.0f+newItem.strokePadding);
        
        [animatingTabTransitionBezierPath moveToPoint:origin];
        [animatingTabTransitionBezierPath addLineToPoint:destination];
        
        //second item's outline
        clockwise = newItem.tag < self.selectedItem.tag?true:false;
        [animatingTabTransitionBezierPath addArcWithCenter:newItem.center radius:(newItem.finishedSelectedImage.size.width)/2.0+newItem.strokePadding startAngle:M_PI/2 endAngle:M_PI clockwise:clockwise];
        [animatingTabTransitionBezierPath addArcWithCenter:newItem.center radius:(newItem.finishedSelectedImage.size.height)/2.0+newItem.strokePadding startAngle:M_PI  endAngle:M_PI/2 clockwise:clockwise];
        
        //determining total length to see where the animation will begin  and end
        circumference = 2*M_PI*((imageSize.width)/2.0+self.selectedItem.strokePadding);
        distanceBetweenTabs = fabs(origin.x - destination.x);
        totalLength = 2*circumference + distanceBetweenTabs;
        
    } else {
        //need to adjust when there is text
        //first item's outline
        CGSize tabItemSize = self.selectedItem.frame.size;
        CGSize imageSize = self.selectedItem.finishedSelectedImage.size;
        CGSize textSize = [self.selectedItem.title boundingRectWithSize:CGSizeMake(self.selectedItem.frame.size.width, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:self.selectedItem.selectedTitleAttributes context:nil].size;
        
        [animatingTabTransitionBezierPath addArcWithCenter:self.selectedItem.center radius:(imageSize.height+textSize.height+self.selectedItem.titlePositionAdjustment.horizontal)/2.0f+self.selectedItem.strokePadding startAngle:M_PI/2 endAngle:M_PI clockwise:clockwise];
        [animatingTabTransitionBezierPath addArcWithCenter:self.selectedItem.center radius:(imageSize.height+textSize.height+self.selectedItem.titlePositionAdjustment.horizontal)/2.0f+self.selectedItem.strokePadding startAngle:M_PI  endAngle:M_PI/2 clockwise:clockwise];
        
        //traveling from one item to the next
        CGFloat ox = CGRectGetMidX(self.selectedItem.frame);
        CGPoint origin = CGPointMake(ox, tabItemSize.height-(tabItemSize.height-imageSize.height-textSize.height)/2.0f+self.selectedItem.strokePadding);
        
        CGFloat dx = CGRectGetMidX(newItem.frame);
        CGPoint destination = CGPointMake(dx, tabItemSize.height-(tabItemSize.height-imageSize.height-textSize.height)/2.0f+newItem.strokePadding);
        [animatingTabTransitionBezierPath moveToPoint:origin];
        [animatingTabTransitionBezierPath addLineToPoint:destination];
        
        //second item's outline
        clockwise = newItem.tag < self.selectedItem.tag?true:false;
        [animatingTabTransitionBezierPath addArcWithCenter:newItem.center  radius:(imageSize.height+textSize.height+newItem.titlePositionAdjustment.horizontal)/2.0f+newItem.strokePadding startAngle:M_PI/2 endAngle:M_PI clockwise:clockwise];
        [animatingTabTransitionBezierPath addArcWithCenter:newItem.center radius:(imageSize.height+textSize.height+newItem.titlePositionAdjustment.horizontal)/2.0f+newItem.strokePadding startAngle:M_PI  endAngle:M_PI/2 clockwise:clockwise];
        
        //determining total length to see where the animation will begin  and end
        circumference = 2*M_PI*((imageSize.width)/2.0+self.selectedItem.strokePadding);
        distanceBetweenTabs = fabs(origin.x - destination.x);
        totalLength = 2*circumference + distanceBetweenTabs;
    }
    
    //leading and trailing animations
    animatingTabTransitionLayer.path = animatingTabTransitionBezierPath.CGPath;
    
    CABasicAnimation *leadingAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    leadingAnimation.duration = 0.7;
    leadingAnimation.fromValue = @0;
    leadingAnimation.toValue = @1;
    leadingAnimation.removedOnCompletion = NO;
    leadingAnimation.fillMode =kCAFillModeForwards;
    leadingAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CABasicAnimation *trailingAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    trailingAnimation.duration = leadingAnimation.duration - 0.15;
    trailingAnimation.fromValue = @0;
    trailingAnimation.removedOnCompletion = NO;
    trailingAnimation.fillMode =kCAFillModeForwards;
    trailingAnimation.toValue = @((circumference+distanceBetweenTabs)/totalLength);
    trailingAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [CATransaction begin];
    CAAnimationGroup *transitionAnimationGroup = [CAAnimationGroup animation];
    transitionAnimationGroup.animations  = @[leadingAnimation,trailingAnimation];
    transitionAnimationGroup.duration = leadingAnimation.duration;
    transitionAnimationGroup.removedOnCompletion = NO;
    transitionAnimationGroup.fillMode =kCAFillModeForwards;
    [CATransaction setCompletionBlock:completionBlock];
    [animatingTabTransitionLayer addAnimation:transitionAnimationGroup forKey:nil];
    [CATransaction commit];
    
    [self.anicontainer.layer addSublayer:animatingTabTransitionLayer];
}
@end
