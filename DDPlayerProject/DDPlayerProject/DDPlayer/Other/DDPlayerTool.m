//
//  DDPlayerTool.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/9.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerTool.h"

@implementation DDPlayerTool
+(UIColor *)colorWithRGBHex:(UInt32)hex{
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}
+ (BOOL)isiPhoneX {
    return (MAX(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height) == 812 || MAX(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height) ==896);
}
+ (CGFloat)screenWidth {
    return MIN(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
}
+ (CGFloat)screenHeight {
    return MAX(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
}
+ (void)forceRotatingScreen:(UIInterfaceOrientation)orientation {
    SEL selector = NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    int val = orientation;
    [invocation setArgument:&val atIndex:2];
    [invocation invoke];
}
+ (BOOL)isScreenLandscape {
    return ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight);
}
+ (BOOL)isScreenPortrait {
    return ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown);
}
+(NSString *)translateTimeToString:(CGFloat )time{
    if (time > 359999) {
        time = 359999;
    }
    NSString *currentTimeStr;
    
    NSString *currentSecStr = [NSString stringWithFormat:@"%02zd",((NSInteger)time)%60];
    NSInteger currentTemp = ((NSInteger)time)/60;
    NSString *currentMinStr;
    if (time > 3600) {
        currentMinStr = [NSString stringWithFormat:@"%zd",currentTemp];
    }else{
        currentMinStr = [NSString stringWithFormat:@"%02zd",currentTemp];
    }
    currentTimeStr = [NSString stringWithFormat:@"%@:%@",currentMinStr,currentSecStr];
    return currentTimeStr;
}
@end
