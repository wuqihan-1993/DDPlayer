//
//  DDPlayer.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/9.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayer.h"
#import "DDPlayerTool.h"
#import <Reachability.h>
#import "DDKVOManager.h"

static NSString *observerContext = @"DDPlayer.KVO.Contexxt";

@interface DDPlayer()
{
    DDKVOManager* _playerItemKVO;
}
@property(nonatomic, assign) NSTimeInterval duration;
@property(nonatomic, assign) NSTimeInterval currentTime;
@property(nonatomic, assign) DDPlayerStatus status;
@property(nonatomic, assign) BOOL isSeekingToTime;

@property(nonatomic, strong) AVPlayer *player;
@property(nonatomic, strong) id timeObserver;

@property(nonatomic, strong) Reachability *reachability;//网络检测器

@end

@implementation DDPlayer

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
    
    [self deleteReachability];
    [self removeItemObservers];
    [self removePlayerObservers];
    [self removeNotifications];
}

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}
- (void)initialize {
    self.player = [[AVPlayer alloc] init];
    [self addReachability];
    [self addPlayerObservers];
    [self addNotifications];
}

#pragma mark - public
- (void)replaceWithUrl:(NSString *)url {
    
    
    if (![DDPlayerTool isLocationPath:url]) {
        //不是本地视频。。网络是3g 不能立即播放
        if (self.reachability.currentReachabilityStatus == ReachableViaWWAN && self.isCanPlayOnWWAN == NO) {
            [self stop];
            return;
        }
    }
    
    NSURL *URL;
    if ([DDPlayerTool isLocationPath:url]) {
        URL = [NSURL fileURLWithPath:url];
    }else {
        URL = [NSURL URLWithString:url];
    }
    
    self.currentAsset = [AVURLAsset assetWithURL:URL];
    
    [self removeItemObservers];
    self.currentItem = [AVPlayerItem playerItemWithAsset:self.currentAsset];
    [self addItemObservers];
    
    [self.player replaceCurrentItemWithPlayerItem:self.currentItem];
    
}
- (void)stop {
    [self removeItemObservers];
//    self.currentItem = nil;
//    self.currentAsset = nil;
    [self.player replaceCurrentItemWithPlayerItem:nil];
    self.status = DDPlayerStatusUnknown;
}
- (void)play {
    if (![DDPlayerTool isLocationPath:self.currentAsset.URL.absoluteString]) {
        //不是本地视频。。网络是3g 不能立即播放
        if (self.reachability.currentReachabilityStatus == ReachableViaWWAN && self.isCanPlayOnWWAN == NO) {
            return;
        }
    }
    [self.player play];
}
- (void)playImmediatelyAtRate:(CGFloat)rate {
    if (@available(iOS 10.0, *)) {
        [self.player playImmediatelyAtRate:rate];
    } else {
        // Fallback on earlier versions
        self.player.rate= rate;
    }
}
- (void)pause {
    [self.player pause];
}

- (BOOL)isPause {
    return (self.player.rate == 0 && self.status == DDPlayerStatusPaused);
}

- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^)(BOOL))completionHandler {
    
    self.isSeekingToTime = YES;
    
    BOOL beforeIsPause = (self.status == DDPlayerStatusPaused);
    [self pause];
    [self.player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC) completionHandler:^(BOOL finished) {
        self.isSeekingToTime = NO;
        if (completionHandler) {
            completionHandler(finished);
        }
    }];
    if (!beforeIsPause) {
        [self play];
    }
}

- (void)bindToPlayerLayer:(AVPlayerLayer *)layer {
    layer.player = self.player;
}
#pragma mark - setter
- (void)setStatus:(DDPlayerStatus)status {
    if (_status != status) {
        _status = status;
        if ([self.delegate respondsToSelector:@selector(playerStatusChanged:)]) {
            [self.delegate playerStatusChanged:status];
        }
    }
}
- (void)setCurrentTime:(NSTimeInterval)currentTime {
    _currentTime = currentTime;
    if ([self.delegate respondsToSelector:@selector(playerTimeChanged:)]) {
        [self.delegate playerTimeChanged:currentTime];
    }
    if ([self.delegateController respondsToSelector:@selector(playerTimeChanged:)]) {
        [self.delegateController playerTimeChanged:currentTime];
    }
}
- (void)setVolume:(CGFloat)volume {
    _volume = volume;
    self.player.volume = volume;
}
#pragma mark - private
- (void)updateStatus {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.currentItem == nil) {
            return ;
        }
        if (self.player.error != nil && self.currentItem.error != nil) {
            self.status = DDPlayerStatusError;
            return;
        }
        
        if (@available(iOS 10, *)) {
            switch (self.player.timeControlStatus) {
                case AVPlayerTimeControlStatusPlaying:
                    self.status = DDPlayerStatusPlaying;
                    break;
                case AVPlayerTimeControlStatusPaused:
                    self.status = DDPlayerStatusPaused;
                    break;
                case AVPlayerTimeControlStatusWaitingToPlayAtSpecifiedRate:
                    self.status = DDPlayerStatusBuffering;
                    break;
                default:
                    break;
            }
        }else {
            if (self.player.rate != 0) {
                if (self.currentItem.isPlaybackLikelyToKeepUp) {
                    self.status = DDPlayerStatusPlaying;
                }else {
                    self.status = DDPlayerStatusBuffering;
                }
            }else {
                self.status = DDPlayerStatusPaused;
            }
        }
        
    });
}

#pragma mark - kvo
- (void)addItemObservers {
    
    [_playerItemKVO safelyRemoveAllObservers];
    
    _playerItemKVO = [[DDKVOManager alloc] initWithTarget:self.currentItem];
    
    [_playerItemKVO safelyAddObserver:self
                           forKeyPath:@"status"
                              options:NSKeyValueObservingOptionNew
                              context:&observerContext];
    [_playerItemKVO safelyAddObserver:self
                           forKeyPath:@"playbackLikelyToKeepUp"
                              options:NSKeyValueObservingOptionNew
                              context:&observerContext];
    [_playerItemKVO safelyAddObserver:self
                           forKeyPath:@"playbackBufferEmpty"
                              options:NSKeyValueObservingOptionNew
                              context:&observerContext];
    [_playerItemKVO safelyAddObserver:self
                           forKeyPath:@"isPlaybackBufferFull"
                              options:NSKeyValueObservingOptionNew
                              context:&observerContext];
    
    
}
- (void)removeItemObservers {
    [_playerItemKVO safelyRemoveAllObservers];
//    if (self.currentItem == nil) {
//        return;
//    }
//    [self.currentItem removeObserver:self forKeyPath:@"status" context:&observerContext];
//    [self.currentItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp" context:&observerContext];
//    [self.currentItem removeObserver:self forKeyPath:@"isPlaybackBufferEmpty" context:&observerContext];
//    [self.currentItem removeObserver:self forKeyPath:@"isPlaybackBufferFull" context:&observerContext];
    
}
- (void)addPlayerObservers {
    __weak typeof(self) weakSelf = self;//下面会造成循环引用
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(0.1, NSEC_PER_SEC) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        

        DLog(@"%s",__FUNCTION__);
        if (weakSelf.currentItem == nil) {
            return ;
        }
        DLog(@"item不为空 %s",__FUNCTION__);
        [weakSelf updateStatus];
        
        
        if (CMTimeGetSeconds(weakSelf.currentItem.duration) <= 0) {
            return ;
        }
//        NSLog(@"%lf &*&*& %lf",CMTimeGetSeconds(time),CMTimeGetSeconds(weakSelf.currentItem.duration));
        weakSelf.duration = CMTimeGetSeconds(weakSelf.currentItem.duration);
        weakSelf.currentTime = CMTimeGetSeconds(time);
    }];
    [self.player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:&observerContext];
    [self.player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:&observerContext];
    if (@available(iOS 10.0, *)) {
        [self.player addObserver:self forKeyPath:@"timeControlStatus" options:NSKeyValueObservingOptionNew context:&observerContext];
    }
    
}
- (void)removePlayerObservers {
    if (self.timeObserver) {
        [self.player removeTimeObserver:self.timeObserver];
    }
    [self.player removeObserver:self forKeyPath:@"rate" context:&observerContext];
    [self.player removeObserver:self forKeyPath:@"status" context:&observerContext];
    if (@available(iOS 10.0, *)) {
        [self.player removeObserver:self forKeyPath:@"timeControlStatus" context:&observerContext];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == &observerContext) {
        
        if (self.currentItem == object && [keyPath isEqualToString:@"status"] && self.currentItem.status == AVPlayerItemStatusReadyToPlay) {
            
            NSLog(@"AVPlayerItemStatusReadyToPlay");
            if ([self.delegateController respondsToSelector:@selector(playerReadyToPlay)]) {
                [self.delegateController playerReadyToPlay];
            }
            if ([self.delegate respondsToSelector:@selector(playerReadyToPlay)]) {
                [self.delegate playerReadyToPlay];
            }
            if (@available(iOS 10.0, *)) {
                [self.player playImmediatelyAtRate:1.0];
            } else {
                // Fallback on earlier versions
            }
            return;
        }
        
        [self updateStatus];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - notification
- (void)addNotifications {
    
    // 监听播放完成
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(playerItemDidPlayToEndTime:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}
- (void)removeNotifications {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}
- (void)playerItemDidPlayToEndTime:(NSNotification *)notification {
    if (self.currentItem != nil && notification.object == self.currentItem ) {
        self.status = DDPlayerStatusEnd;
        if ([self.delegateController respondsToSelector:@selector(playerPlayFinish)]) {
            [self.delegateController playerPlayFinish];
        }
    }
}


#pragma mark - 网络监测
- (void)addReachability {
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    // 监听网络状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatusChange:) name:kReachabilityChangedNotification object:nil];
}

- (void)netStatusChange:(NSNotification *)notification {
    
    //如果是播放本地视频的时候。不需要知道网络状态的变化。
    if ([DDPlayerTool isLocationPath:self.currentAsset.URL.absoluteString]) {
        return;
    }
    
    Reachability *reach = notification.object;
    if ([self.delegate respondsToSelector:@selector(playerNetworkStatusChanged:)]) {
        [self.delegate playerNetworkStatusChanged:reach.currentReachabilityStatus];
    }

}

- (void)deleteReachability {
    [self.reachability stopNotifier];
}

@end

