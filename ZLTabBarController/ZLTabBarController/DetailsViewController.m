//
//  DetailsViewController.m
//  ZLTabBarController
//
//  Created by hitao on 16/6/8.
//  Copyright © 2016年 hitao. All rights reserved.
//

#import "DetailsViewController.h"
#import "ZLTabBarController.h"

@implementation DetailsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Details";
    self.view.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"Detail View Controller";
    label.frame = CGRectMake(20, 150, CGRectGetWidth(self.view.frame) - 2 * 20, 20);
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self zl_tabBarController] setTabBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[self zl_tabBarController] setTabBarHidden:NO animated:YES];
    
    [super viewWillDisappear:animated];
}

@end
