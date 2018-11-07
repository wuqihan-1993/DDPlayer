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

@end

@implementation DDVideoPlayer

#pragma mark - life cycle
- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor blackColor];
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
    self.componentContainerView.frame = self.bounds;
}

#pragma mark - public method
- (void)playVideoLines:(NSMutableArray<DDVideoLineModel*> *)videoLines {
    self.videoLines = videoLines;
    
    DDVideoLineModel *line = videoLines.firstObject;
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:line.lineUrl]];
    self.currentPlayerItem = item;
    [self.player replaceCurrentItemWithPlayerItem:item];
    [self.player play];
}

- (void)pause {
   
}
- (void)continuePlay {
    
}
- (void)playWithSpecifiedTime:(NSInteger)SpecifiedTime compelete:(void (^)(void))compeleteBlock {
    
}
#pragma mark - private method
#pragma mark 初始化播放器

/**
 初始化播放器
 */
- (void)initAVPlayer {
    self.player = [[AVPlayer alloc] init];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.layer addSublayer:self.playerLayer];
}
#pragma mark 初始化UI
- (void)initUI {
    self.componentContainerView = [DDVideoPlayerContainerView new];
    [self addSubview:self.componentContainerView];
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
#pragma mark - delegate

#pragma mark - getter


@end
