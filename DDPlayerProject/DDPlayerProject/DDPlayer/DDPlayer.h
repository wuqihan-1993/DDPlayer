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

@interface DDPlayer : NSObject

@property(nonatomic, weak) id<DDPlayerDelegate> delegate;
@property(nonatomic, weak) id<DDPlayerDelegate> delegateController;
@property(nonatomic, strong) AVURLAsset *currentAsset;
@property(nonatomic, strong) AVPlayerItem *currentItem;

@property(nonatomic, strong,readonly) Reachability *reachability;//网络检测器

@property(nonatomic, assign, readonly) BOOL isLocationUrl;

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
 播放器当前速率
 */
@property(nonatomic, assign, readonly) CGFloat rate;
/**
 是否可以后台播放
 */
@property(nonatomic, assign) BOOL isBackgroundPlay;

/**
 播放器是否是暂停状态
 */
@property(nonatomic, assign, readonly) BOOL isPause;

@property(nonatomic, assign, readonly) BOOL isPlaying;

/**
 网络流量是否能播放
 */
@property(nonatomic, assign) BOOL isCanPlayOnWWAN;

/**
 播放器是否正在跳转到指定时间。NO代表跳转完成，YES代表正在跳转
 */
@property(nonatomic, assign, readonly) BOOL isSeekingToTime;



/**
 因为播放器 做了自动播放(比如无网恢复到有网，流量切换到wifi等)
 但是有些业务情况下不能让他自动播放
 所以有些业务出现时，把它设置为NO，业务处理完成 设置为YES
 */
@property(nonatomic, assign) BOOL isNeedCanPlay;


@property(nonatomic, assign) CGFloat volume;

- (void)bindToPlayerLayer:(AVPlayerLayer *)layer;

- (void)playWithUrl:(NSString*)url;

- (void)stop;
- (void)play;
- (void)pause;
- (void)playImmediatelyAtRate:(CGFloat)rate;

- (void)seekToTime:(NSTimeInterval)time isPlayImmediately:(BOOL)isPlayImmediately completionHandler:(void (^)(BOOL))completionHandler;


@end

