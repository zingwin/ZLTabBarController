//
//  ZLTabBar.h
//  ZLTabBarController
//
//  Created by hitao on 16/6/8.
//  Copyright © 2016年 hitao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZLTabBar, ZLTabBarItem;

@protocol ZLTabBarDelegate <NSObject>

/**
 * Asks the delegate if the specified tab bar item should be selected.
 */
- (BOOL)tabBar:(ZLTabBar *)tabBar shouldSelectItemAtIndex:(NSInteger)index;

/**
 * Tells the delegate that the specified tab bar item is now selected.
 */
- (void)tabBar:(ZLTabBar *)tabBar didSelectItemAtIndex:(NSInteger)index;

@end

@interface ZLTabBar : UIView

/**
 * The tab bar’s delegate object.
 */
@property (nonatomic, weak) id <ZLTabBarDelegate> delegate;

/**
 * The items displayed on the tab bar.
 */
@property (nonatomic, copy) NSArray *items;

/**
 * The currently selected item on the tab bar.
 */
@property (nonatomic, weak) ZLTabBarItem *selectedItem;

/**
 * backgroundView stays behind tabBar's items. If you want to add additional views,
 * add them as subviews of backgroundView.
 */
@property (nonatomic, readonly) UIView *backgroundView;

/*
 * contentEdgeInsets can be used to center the items in the middle of the tabBar.
 */
@property UIEdgeInsets contentEdgeInsets;

/**
 * Sets the height of tab bar.
 */
- (void)setHeight:(CGFloat)height;

/**
 * Returns the minimum height of tab bar's items.
 */
- (CGFloat)minimumContentHeight;

/*
 * Enable or disable tabBar translucency. Default is NO.
 */
@property (nonatomic, getter=isTranslucent) BOOL translucent;

#pragma mark -Stroke & animation
@property (assign, nonatomic) BOOL isShowStrokeAnimaiton;
/**
 Color of the outline when selected and during animations
 */
@property (strong, nonatomic) UIColor *barItemStrokeColor;

/**
 Width of the outline when selected and during animations
 */
@property (assign, nonatomic) CGFloat barItemLineWidth;

@end
