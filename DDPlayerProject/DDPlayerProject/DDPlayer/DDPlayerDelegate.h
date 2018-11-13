//
//  DDPlayerDelegate.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/9.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDPlayerStatus.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DDPlayerDelegate <NSObject>

@optional

/**
 当前播放时间发生变化

 @param currentTime 当前时间s
 */
- (void)playerTimeChanged:(double)currentTime;

/**
 播放器状态发生变化

 @param status DDPlayerStatus
 */
- (void)playerStatusChanged:(DDPlayerStatus)status;


/**
 播放器播放结束
 */
- (void)playerPlayFinish;

@end

NS_ASSUME_NONNULL_END

