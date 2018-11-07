//
//  DDVideoPlayerTool.h
//  DDVideoPlayer
//
//  Created by wuqh on 2018/11/7.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface DDVideoPlayerTool : NSObject

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


@end

NS_ASSUME_NONNULL_END
