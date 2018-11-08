//
//  DDVideoPlayer.m
//  DDVideoPlayer
//
//  Created by wuqh on 2018/11/7.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDVideoPlayer.h"
#import "Masonry.h"

@interface DDVideoPlayer()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayerItem *currentPlayerItem;

@property (nonatomic, strong) NSMutableArray *videoLines;

@property(nonatomic, weak) id timeObserver;

@end

@implementation DDVideoPlayer

#pragma mark - life cycle
- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removePlayerItemObservers];
    [self removePlayerObservers];
}

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = UIColor.blackColor;
        [self initNotificationObserver];
        [self initAVPlayer];
        [self initUI];
    }
    return self;
}

#pragma mark - override method
- (void)layoutSubviews {
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
}

#pragma mark - public method
- (void)playVideoLines:(NSMutableArray<DDVideoLineModel*> *)videoLines {
    self.videoLines = videoLines;
    
    DDVideoLineModel *line = videoLines.firstObject;
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:line.lineUrl]];
    self.currentPlayerItem = item;
    [self addPlayerItemObservers];
    [self.player replaceCurrentItemWithPlayerItem:item];
    [self.player play];
}

- (void)pause {
   
}
- (void)continuePlay {
    
}
- (void)playWithSpecifiedTime:(NSInteger)SpecifiedTime compelete:(void (^)(void))compeleteBlock {
    
}

- (void)updatePlayerStatus {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.currentPlayerItem == nil) {
            return;
        }
        if (self.player.error != nil || self.currentPlayerItem.error != nil) {
            self.status = DDVideoPlayerStatusError;
            return;
        }
        if (@available(iOS 10.0, *)) {
            switch (self.player.timeControlStatus) {
                case AVPlayerTimeControlStatusPlaying:
                    self.status = DDVideoPlayerStatusPlaying;
                    break;
                case AVPlayerTimeControlStatusPaused:
                    self.status = DDVideoPlayerStatusPaused;
                    break;
                case AVPlayerTimeControlStatusWaitingToPlayAtSpecifiedRate:
                    self.status = DDVideoPlayerStatusBuffering;
                    break;
                default:
                    break;
            }
        } else {
            if (self.player.rate != 0) {
                if (self.currentPlayerItem.isPlaybackLikelyToKeepUp) {
                    self.status = DDVideoPlayerStatusPlaying;
                }else {
                    self.status = DDVideoPlayerStatusBuffering;
                }
            }else {
                self.status = DDVideoPlayerStatusPaused;
            }

        }
    });
}
#pragma mark - private method
#pragma mark 初始化播放器
/**
 初始化播放器
 */
- (void)initAVPlayer {
    self.player = [[AVPlayer alloc] init];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self addPlayerObservers];
    [self.layer addSublayer:self.playerLayer];
}
#pragma mark 初始化UI
- (void)initUI {
    self.componentContainerView = [[DDVideoPlayerContainerView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.componentContainerView];
    [self.componentContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
#pragma mark 注册通知
/**
 注册通知
 */
- (void)initNotificationObserver {
    // 当应用程序进入活跃时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    // 当应用程序不再活跃和失去焦点时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name: UIApplicationWillResignActiveNotification object:nil];
    // 屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidPlayToEndTime:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

static NSString *observerContext = @"DDVideoPlayer.KVO.Context";
#pragma mark kvo
- (void)addPlayerObservers {
    __weak typeof(self) weakSelf = self;
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(0.1, NSEC_PER_SEC) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        NSLog(@"这里干嘛用的？");
        [weakSelf updatePlayerStatus];
        
        NSLog(@"%lld",time.value);
        NSLog(@"%d",time.timescale);
        
        
        
    }];
}
- (void)removePlayerObservers {
    [self.player removeTimeObserver:self.timeObserver];
}
- (void)addPlayerItemObservers {
    [self.currentPlayerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:&observerContext];
    [self.currentPlayerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:&observerContext];
    [self.currentPlayerItem addObserver:self forKeyPath:@"isPlaybackBufferEmpty" options:NSKeyValueObservingOptionNew context:&observerContext];
    [self.currentPlayerItem addObserver:self forKeyPath:@"isPlaybackBufferFull" options:NSKeyValueObservingOptionNew context:&observerContext];
}
- (void)removePlayerItemObservers {
    [self.currentPlayerItem removeObserver:self forKeyPath:@"status"];
    [self.currentPlayerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [self.currentPlayerItem removeObserver:self forKeyPath:@"isPlaybackBufferEmpty"];
    [self.currentPlayerItem removeObserver:self forKeyPath:@"isPlaybackBufferFull"];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == &observerContext) {
        [self updatePlayerStatus];
    }
}

#pragma mark - notification
- (void)applicationDidBecomeActive {
    NSLog(@"%s",__FUNCTION__);
}
- (void)applicationWillResignActive {
    NSLog(@"%s",__FUNCTION__);
}
- (void)screenRotation:(NSNotification *)nf {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    switch (orientation) {
        case UIDeviceOrientationLandscapeLeft:
            [self mas_remakeConstraints:self.landscapeUI];
            break;
        case UIDeviceOrientationLandscapeRight:
            [self mas_remakeConstraints:self.landscapeUI];
            break;
        case UIDeviceOrientationPortrait:
            [self mas_remakeConstraints:self.portraitUI];
            break;
        default:
            break;
    }
}
- (void)playerItemDidPlayToEndTime:(NSNotification *)nf {
    if (nf.object == self.currentPlayerItem) {
        self.status = DDVideoPlayerStatusEnd;
    }
}
#pragma mark - delegate

#pragma mark - getter


@end
