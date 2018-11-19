//
//  DDPlayer.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/9.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDPlayerDelegate.h"
#import <AVKit/AVKit.h>
#import "DDPlayerStatus.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDPlayer : NSObject

@property(nonatomic, weak) id<DDPlayerDelegate> delegate;
@property(nonatomic, weak) id<DDPlayerDelegate> delegateController;
@property(nonatomic, strong) AVURLAsset *currentAsset;
@property(nonatomic, strong) AVPlayerItem *currentItem;
/**
 播放该视频总时长
 */
@property(nonatomic, assign, readonly) NSTimeInterval duration;
/**
 播放器当前时间
 */
@property(nonatomic, assign, readonly) NSTimeInterval currentTime;
/**
 播放器状态
 */
@property(nonatomic, assign, readonly) DDPlayerStatus status;
/**
 是否可以后台播放
 */
@property(nonatomic, assign) BOOL isBackgroundPlay;

/**
 播放器是否是暂停状态
 */
@property(nonatomic, assign, readonly) BOOL isPause;

/**
 网络流量是否能播放
 */
@property(nonatomic, assign) BOOL isCanPlayOnWWAN;

/**
 播放器是否正在跳转到指定时间。NO代表跳转完成，YES代表正在跳转
 */
@property(nonatomic, assign, readonly) BOOL isSeekingToTime;


@property(nonatomic, assign) CGFloat volume;

- (void)bindToPlayerLayer:(AVPlayerLayer *)layer;
- (void)replaceWithUrl:(NSString*)url;
- (void)stop;
- (void)play;
- (void)playImmediatelyAtRate:(CGFloat)rate;
- (void)pause;
- (void)seekToTime:(NSTimeInterval)time completionHandler:(void(^)(BOOL))completionHandler;


@end

NS_ASSUME_NONNULL_END
