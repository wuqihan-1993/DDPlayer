//
//  DDPlayer.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/9.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayer.h"

static NSString *observerContext = @"DDPlayer.KVO.Contexxt";

@interface DDPlayer()

@property(nonatomic, assign) NSTimeInterval duration;
@property(nonatomic, assign) NSTimeInterval currentTime;
@property(nonatomic, assign) DDPlayerStatus status;

@property(nonatomic, strong) AVPlayer *player;
@property(nonatomic, strong) id timeObserver;

@property(nonatomic, strong) NSMutableArray<DDPlayerDelegate> *delegates;

@end

@implementation DDPlayer

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
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
    [self addPlayerObservers];
    [self addNotifications];
}

#pragma mark - public
- (void)replaceWithUrl:(NSURL *)url {
    self.currentAsset = [AVAsset assetWithURL:url];
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
    [self.player play];
}
- (void)pause {
    [self.player pause];
}
- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^)(BOOL))completionHandler {
    [self.player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC) completionHandler:completionHandler];
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
    if (self.currentItem == nil) {
        return;
    }
    [self.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:&observerContext];
    [self.currentItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:&observerContext];
    [self.currentItem addObserver:self forKeyPath:@"isPlaybackBufferEmpty" options:NSKeyValueObservingOptionNew context:&observerContext];
    [self.currentItem addObserver:self forKeyPath:@"isPlaybackBufferFull" options:NSKeyValueObservingOptionNew context:&observerContext];
}
- (void)removeItemObservers {
    if (self.currentItem == nil) {
        return;
    }
    [self.currentItem removeObserver:self forKeyPath:@"status" context:&observerContext];
    [self.currentItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp" context:&observerContext];
    [self.currentItem removeObserver:self forKeyPath:@"isPlaybackBufferEmpty" context:&observerContext];
    [self.currentItem removeObserver:self forKeyPath:@"isPlaybackBufferFull" context:&observerContext];
    
}
- (void)addPlayerObservers {
    __weak typeof(self) weakSelf = self;//下面会造成循环引用
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(0.1, NSEC_PER_SEC) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        [weakSelf updateStatus];
        
        if (weakSelf.currentItem == nil) {
            return ;
        }
        if (CMTimeGetSeconds(weakSelf.currentItem.duration) <= 0) {
            return ;
        }
        NSLog(@"%lf &*&*& %lf",CMTimeGetSeconds(time),CMTimeGetSeconds(weakSelf.currentItem.duration));
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


@end

