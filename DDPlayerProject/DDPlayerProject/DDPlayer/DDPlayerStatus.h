//
//  DDPlayerStatus.h
//  DDPlayerProject
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

typedef NS_ENUM(NSInteger,DDShareType) {
    DDShareTypeWechat,  //微信好友
    DDShareTypeFriend,  //微信朋友圈
    DDShareTypeWeibo,   //微博
    DDShareTypeQQ,      //QQ
};



#endif /* DDPlayerStatus_h */
