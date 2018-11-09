//
//  DDTabBarController.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/9.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDTabBarController.h"
#import "DDVideoViewController.h"
#import "DDNavigationController.h"
@interface DDTabBarController ()

@end

@implementation DDTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    DDVideoViewController *vc = [[DDVideoViewController alloc] init];
    vc.title = @"DDPlayer";
    DDNavigationController *nav = [[DDNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}

#pragma mark - 控制屏幕旋转方法
//是否自动旋转,返回YES可以自动旋转,返回NO禁止旋转
- (BOOL)shouldAutorotate{
    return self.selectedViewController.shouldAutorotate;
}
//返回支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return self.selectedViewController.supportedInterfaceOrientations;
}
//由模态推出的视图控制器 优先支持的屏幕方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return self.selectedViewController.preferredInterfaceOrientationForPresentation;
}


@end
