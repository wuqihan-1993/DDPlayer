//
//  DDVideoPlayerContainerView.m
//  DDVideoPlayer
//
//  Created by wuqh on 2018/11/7.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDVideoPlayerContainerView.h"
#import "DDVideoPlayerTool.h"
#import "Masonry.h"
#import "DDVideoPlayerTopView.h"
#import "DDVideoPlayerBottomPortraitView.h"
#import "DDVideoPlayerBottomLandscapeView.h"

@interface DDVideoPlayerContainerView()

@property(nonatomic, strong) UIButton *playButton;
@property(nonatomic, strong) UIButton *lockScreenButton;
@property(nonatomic, strong) UIButton *captureButton;
@property(nonatomic, strong) DDVideoPlayerTopView *topView;
@property(nonatomic, strong) DDVideoPlayerBottomPortraitView *bottomPortraitView;
@property(nonatomic, strong) DDVideoPlayerBottomLandscapeView *bottomLandscapeView;

@end

@implementation DDVideoPlayerContainerView

- (void)dealloc {
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
#pragma mark - action
- (void)playButtonClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(videoPlayerContainerView:clickPlayButton:)]) {
        [self.delegate videoPlayerContainerView:self clickPlayButton:button];
    }
}
- (void)lockScreenButtonClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(videoPlayerContainerView:clicklockScreenButton:)]) {
        [self.delegate videoPlayerContainerView:self clicklockScreenButton:button];
    }
}
- (void)captureButtonClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(videoPlayerContainerView:clickCaptureButton:)]) {
        [self.delegate videoPlayerContainerView:self clickCaptureButton:button];
    }
}

#pragma mark - private method
- (void)initUI{
    [self addSubview:self.topView];
    [self addSubview:self.playButton];
    [self addSubview:self.captureButton];
    [self addSubview:self.lockScreenButton];
    [self addSubview:self.bottomPortraitView];
    [self addSubview:self.bottomLandscapeView];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(60);
    }];
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self.captureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).mas_offset(DDVideoPlayerTool.isiPhoneX ? -20-34 : -20);
        make.centerY.equalTo(self);
    }];
    [self.lockScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(DDVideoPlayerTool.isiPhoneX ? 20+34 : 20);
        make.centerY.equalTo(self);
    }];
    [self.bottomPortraitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(60);
    }];
    [self.bottomLandscapeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(80);
    }];
    
    if (UIDevice.currentDevice.orientation == UIDeviceOrientationPortrait) {
        [self updateUIWithPortrait];
    }else {
        [self updateUIWithLandscape];
    }
    
}
#pragma mark - override method
- (void)updateUIWithPortrait {
    self.captureButton.hidden = YES;
    self.lockScreenButton.hidden = YES;
    self.bottomLandscapeView.hidden = YES;
    self.bottomPortraitView.hidden = NO;
//    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(60);
//    }];
}
- (void)updateUIWithLandscape {
    self.captureButton.hidden = NO;
    self.lockScreenButton.hidden = NO;
    self.bottomLandscapeView.hidden = NO;
    self.bottomPortraitView.hidden = YES;
//    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(64);
//    }];
}

#pragma mark - getter
- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:@"DDPlayer_Btn_CenterPlay"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"DDPlayer_Btn_CenterPause"] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}
- (UIButton *)lockScreenButton {
    if (!_lockScreenButton) {
        _lockScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lockScreenButton setImage:[UIImage imageNamed:@"DDPlayer_Btn_Lock"] forState:UIControlStateNormal];
        [_lockScreenButton addTarget:self action:@selector(lockScreenButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lockScreenButton;
}
- (UIButton *)captureButton {
    if (!_captureButton) {
        _captureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_captureButton setImage:[UIImage imageNamed:@"DDPlayer_Btn_Capture"] forState:UIControlStateNormal];
        [_captureButton addTarget:self action:@selector(captureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _captureButton;
}
- (DDVideoPlayerTopView *)topView {
    if (!_topView) {
        _topView = [[DDVideoPlayerTopView alloc] init];
        __weak typeof(self) weakSelf = self;
        _topView.backTitleButtonClickBlock = ^(UIButton * _Nonnull button) {
            if ([weakSelf.delegate respondsToSelector:@selector(videoPlayerContainerView:clickBackTitleButton:)]) {
                [weakSelf.delegate videoPlayerContainerView:weakSelf clickBackTitleButton:button];
            }
        };
    }
    return _topView;
}
- (DDVideoPlayerBottomPortraitView *)bottomPortraitView {
    if (!_bottomPortraitView) {
        _bottomPortraitView = [[DDVideoPlayerBottomPortraitView alloc] init];
    }
    return _bottomPortraitView;
}
- (DDVideoPlayerBottomLandscapeView *)bottomLandscapeView {
    if (!_bottomLandscapeView) {
        _bottomLandscapeView = [[DDVideoPlayerBottomLandscapeView alloc] init];
    }
    return _bottomLandscapeView;
}
@end
