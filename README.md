# ZLTabBarController
TabBarController with animation

##ZLTabBarController is simple and high custom tabBarController

###use animation TabBarController
> ![demo1](https://github.com/zingwin/ZLTabBarController/blob/master/1.gif)

###normal TabBarController
> ![demo1](https://github.com/zingwin/ZLTabBarController/blob/master/2.gif)


## Usage

To run the example project, you can download from git

### Installation

ZLTabBarController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ZLTabBarController'
```

###core use code, in AppDelegate.m
```objective-c
-(void)setupViewControllers{
    UIViewController *firstViewController = [[FirstViewController alloc] init];
    UIViewController *firstNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:firstViewController];
    
    UIViewController *secondViewController = [[SecondViewController alloc] init];
    UIViewController *secondNavigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:secondViewController];
    
    UIViewController *thirdViewController = [[ThirdViewController alloc] init];
    UIViewController *thirdNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:thirdViewController];
    
    ZLTabBarController *tabBarController = [[ZLTabBarController alloc] init];
    [tabBarController setViewControllers:@[firstNavigationController, secondNavigationController,
                                           thirdNavigationController]];
   
    [self.window setRootViewController:tabBarController];

    [self customizeTabBarForController:tabBarController];
}

- (void)customizeTabBarForController:(ZLTabBarController *)tabBarController {

    NSArray *tn = @[@"tab_add_nor", @"tab_home_nor", @"tab_user_nor"];
    NSArray *ta = @[@"tab_add_act", @"tab_home_act", @"tab_user_act"];
    
    [tabBarController tabBar].backgroundColor = [UIColor blackColor];
    
    [tabBarController tabBar].isShowStrokeAnimaiton = YES;
    [tabBarController tabBar].barItemLineWidth  = 1.0f;
    [tabBarController tabBar].barItemStrokeColor = UIColorFromHEX(0xEC584E);// [UIColor colorWithHex:0xEC584E];
    
    NSInteger index = 0;
    for (ZLTabBarItem *item in [[tabBarController tabBar] items]) {
        [item setFinishedSelectedImage:[UIImage imageNamed:ta[index]] withFinishedUnselectedImage:[UIImage imageNamed:tn[index]]];
        index++;
    }
}
```