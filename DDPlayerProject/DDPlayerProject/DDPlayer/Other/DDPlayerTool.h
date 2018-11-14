//
//  DDPlayerTool.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/9.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface DDPlayerTool : NSObject

@property(class, nonatomic, readonly) BOOL isiPhoneX;
@property(class, nonatomic, readonly) CGFloat screenWidth;
@property(class, nonatomic, readonly) CGFloat screenHeight;
@property(class, nonatomic, readonly) BOOL isScreenLandscape;
@property(class, nonatomic, readonly) BOOL isScreenPortrait;

/**
 16进制颜色
 
 @param hex 16进制
 @return 颜色
 */
+(UIColor *)colorWithRGBHex:(UInt32)hex;

+(void)forceRotatingScreen:(UIInterfaceOrientation)orientation;

/**
 将时间转换为字符串

 @param time 时间 秒
 @return 00:00
 */
+(NSString *)translateTimeToString:(CGFloat )time;

+(BOOL)isLocationPath:(NSString *)path;
@end

NS_ASSUME_NONNULL_END
