//
//  ZLTabBarController.h
//  ZLTabBarController
//
//  Created by hitao on 16/6/8.
//  Copyright © 2016年 hitao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLTabBar.h"

@protocol ZLTabBarControllerDelegate;

@interface ZLTabBarController : UIViewController<ZLTabBarDelegate>
/**
 * The tab bar controller’s delegate object.
 */
@property (nonatomic, weak) id<ZLTabBarControllerDelegate> delegate;

/**
 * An array of the root view controllers displayed by the tab bar interface.
 */
@property (nonatomic, copy) IBOutletCollection(UIViewController) NSArray *viewControllers;

/**
 * The tab bar view associated with this controller. (read-only)
 */
@property (nonatomic, readonly) ZLTabBar *tabBar;

/**
 * The view controller associated with the currently selected tab item.
 */
@property (nonatomic, weak) UIViewController *selectedViewController;

/**
 * The index of the view controller associated with the currently selected tab item.
 */
@property (nonatomic) NSUInteger selectedIndex;

/**
 * A Boolean value that determines whether the tab bar is hidden.
 */
@property (nonatomic, getter=isTabBarHidden) BOOL tabBarHidden;

/**
 * Changes the visibility of the tab bar.
 */
- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;

@end

@protocol ZLTabBarControllerDelegate <NSObject>
@optional
/**
 * Asks the delegate whether the specified view controller should be made active.
 */
- (BOOL)tabBarController:(ZLTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;

/**
 * Tells the delegate that the user selected an item in the tab bar.
 */
- (void)tabBarController:(ZLTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;

@end

@interface UIViewController (ZLTabBarControllerItem)

/**
 * The tab bar item that represents the view controller when added to a tab bar controller.
 */
@property(nonatomic, setter = zl_setTabBarItem:) ZLTabBarItem *zl_tabBarItem;

/**
 * The nearest ancestor in the view controller hierarchy that is a tab bar controller. (read-only)
 */
@property(nonatomic, readonly) ZLTabBarController *zl_tabBarController;

@end