//
//  DDPlayerDelegate.h
//  DDVideoPlayer
//
//  Created by wuqh on 2018/11/9.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDPlayerStatus.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DDPlayerDelegate <NSObject>

@optional
- (void)playerTimeChanged:(double)currentTime;
- (void)playerStatusChanged:(DDPlayerStatus)status;

@end

NS_ASSUME_NONNULL_END
