//
//  DDPlayerStatus.h
//  DDVideoPlayer
//
//  Created by wuqh on 2018/11/9.
//  Copyright © 2018 wuqh. All rights reserved.
//

#ifndef DDPlayerStatus_h
#define DDPlayerStatus_h

typedef NS_ENUM(NSInteger,DDPlayerStatus) {
    DDPlayerStatusUnknown,
    DDPlayerStatusBuffering,
    DDPlayerStatusPlaying,
    DDPlayerStatusPaused,
    DDPlayerStatusEnd,
    DDPlayerStatusError
};

#endif /* DDPlayerStatus_h */
