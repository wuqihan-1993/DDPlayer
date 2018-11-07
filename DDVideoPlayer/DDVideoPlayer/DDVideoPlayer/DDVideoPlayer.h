//
//  DDVideoPlayer.h
//  DDVideoPlayer
//
//  Created by wuqh on 2018/11/7.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import "DDVideoLineModel.h"
#import "DDVideoPlayerContainerView.h"
#import "DDVideoPlayerTool.h"

@class MASConstraintMaker;
NS_ASSUME_NONNULL_BEGIN

@interface DDVideoPlayer : UIView

@property(nonatomic, strong) DDVideoPlayerContainerView *componentContainerView;

/**
 竖屏样式
 */
@property(nonatomic, copy) void(^portraitUI)(MASConstraintMaker *);

/**
 横屏样式
 */
@property(nonatomic, copy) void(^landscapeUI)(MASConstraintMaker *);


/**
 播放视频

 @param videoLines 视频地址数组，因为可能有多个清晰度的视频
 */
- (void)playVideoLines:(NSMutableArray *)videoLines;

/**
 暂停
 */
- (void)pause;

/**
 继续播放
 */
- (void)continuePlay;

/**
 指定时间播放
 
 @param SpecifiedTime 指定时间
 @param compeleteBlock 完成block
 */
- (void)playWithSpecifiedTime:(NSInteger )SpecifiedTime
                    compelete:(void(^)(void))compeleteBlock;


@end

NS_ASSUME_NONNULL_END
