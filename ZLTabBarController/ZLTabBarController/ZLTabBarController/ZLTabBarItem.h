//
//  ZLTabBarItem.h
//  ZLTabBarController
//
//  Created by hitao on 16/6/8.
//  Copyright © 2016年 hitao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLTabBarItem : UIControl

@property(nonatomic,assign) CGFloat itemHeight;

#pragma mark - Title configuration
@property(nonatomic,copy) NSString *title;
/**
 * The title attributes dictionary used for tab bar item's selected state.
 */
@property (copy) NSDictionary *selectedTitleAttributes;
@property (copy) NSDictionary *unselectedTitleAttributes;

@property(nonatomic,assign) UIOffset titlePositionAdjustment;

#pragma mark - image icon
/**
 * The image used for tab bar item's selected state.
 */
- (UIImage *)finishedSelectedImage;

/**
 * The image used for tab bar item's unselected state.
 */
- (UIImage *)finishedUnselectedImage;

/**
 * Sets the tab bar item's selected and unselected images.
 */
- (void)setFinishedSelectedImage:(UIImage *)selectedImage withFinishedUnselectedImage:(UIImage *)unselectedImage;

@property (nonatomic) UIOffset imagePositionAdjustment;

#pragma mark - Background configuration

/**
 * The background image used for tab bar item's selected state.
 */
- (UIImage *)backgroundSelectedImage;

/**
 * The background image used for tab bar item's unselected state.
 */
- (UIImage *)backgroundUnselectedImage;

/**
 * Sets the tab bar item's selected and unselected background images.
 */
- (void)setBackgroundSelectedImage:(UIImage *)selectedImage withUnselectedImage:(UIImage *)unselectedImage;

#pragma mark - Badge configuration

/**
 * Text that is displayed in the upper-right corner of the item with a surrounding background.
 */
@property (nonatomic, copy) NSString *badgeValue;

/**
 * Image used for background of badge.
 */
@property (strong) UIImage *badgeBackgroundImage;

/**
 * Color used for badge's background.
 */
@property (strong) UIColor *badgeBackgroundColor;

/**
 * Color used for badge's text.
 */
@property (strong) UIColor *badgeTextColor;

/**
 * The offset for the rectangle around the tab bar item's badge.
 */
@property (nonatomic) UIOffset badgePositionAdjustment;

/**
 * Font used for badge's text.
 */
@property (nonatomic) UIFont *badgeTextFont;

#pragma mark - cire
/**
 UIView that houses the selected/unselected icons
 */
@property (nonatomic, strong) UIView *innerTabBarItem;
@property (nonatomic, assign) CGFloat strokeWidth;

/**
 Color of the outline and text when a tab is selected
 */
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic,assign) CGFloat strokePadding;
@end
