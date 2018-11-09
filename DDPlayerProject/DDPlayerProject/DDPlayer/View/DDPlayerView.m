//
//  DDPlayerView.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/9.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerView.h"
#import "DDPlayer.h"
#import "DDVideoPlayerContainerView.h"
#import "Masonry.h"
@interface DDPlayerView()<DDPlayerDelegate,DDVideoPlayerContainerViewDelegate>


@property (nonatomic, strong) DDVideoPlayerContainerView *playerControlView;

@end

@implementation DDPlayerView


#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    [self initUI];
    [self.player bindToPlayerLayer:(AVPlayerLayer *)self.layer];
}
- (void)initUI {
    self.backgroundColor = UIColor.blackColor;
    [self addSubview:self.playerControlView];
    [self.playerControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - override system method
+ (Class)layerClass {
    return AVPlayerLayer.class;
}

#pragma mark - getter
- (DDPlayer *)player {
    if (!_player) {
        _player = [[DDPlayer alloc] init];
        _player.delegate = self;
    }
    return _player;
}
- (DDVideoPlayerContainerView *)playerControlView {
    if (!_playerControlView) {
        _playerControlView = [[DDVideoPlayerContainerView alloc] init];
        _playerControlView.delegate = self;
    }
    return _playerControlView;
}

#pragma mark - DDPlayerDelegate
- (void)playerTimeChanged:(double)currentTime {
    
}
- (void)playerStatusChanged:(id)status {
    
}

@end
