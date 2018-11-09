//
//  DDVideoPlayerContainerView.m
//  DDVideoPlayer
//
//  Created by wuqh on 2018/11/7.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerControlView.h"
#import "DDPlayerTool.h"
#import "Masonry.h"
#import "DDPlayerControlTopView.h"


@interface DDPlayerControlView()


@property(nonatomic, strong) UIButton *lockScreenButton;
@property(nonatomic, strong) UIButton *captureButton;
@property(nonatomic, strong) DDPlayerControlTopView *topView;


/**
 是否可见
 */
@property(nonatomic, assign) BOOL isVisible;

@end

@implementation DDPlayerControlView

- (void)dealloc {
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        [self initGestures];
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
- (void)tapAction:(UITapGestureRecognizer *)tap {
    if (self.isVisible) {
        [self disimiss];
    }else {
        [self show];
    }
}
- (void)panAction:(UIPanGestureRecognizer *)pan {
    
    NSLog(@"%@",NSStringFromCGPoint([pan locationInView:self]));
    
}
- (BOOL)isVisible {
    return self.playButton.alpha > 0;
}

#pragma mark - private method
- (void)show {
    NSMutableArray *views = [NSMutableArray arrayWithArray:self.subviews];
    if (DDPlayerTool.isScreenPortrait) {
        [views removeObject:self.bottomLandscapeView];
        [UIView animateWithDuration:0.4 animations:^{
            for (UIView *subView in views) {
                subView.alpha = 1;
            }
        }];
        
    }else {
        [views removeObject:self.bottomPortraitView];
        [UIView animateWithDuration:0.4 animations:^{
            for (UIView *subView in views) {
                subView.alpha = 1;
            }
        }];
    }
}
- (void)disimiss {
    [UIView animateWithDuration:0.4 animations:^{
        for (UIView *subView in self.subviews) {
            subView.alpha = 0;
        }
    }];
    
}
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
        make.right.equalTo(self).mas_offset(DDPlayerTool.isiPhoneX ? -20-34 : -20);
        make.centerY.equalTo(self);
    }];
    [self.lockScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(DDPlayerTool.isiPhoneX ? 20+34 : 20);
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

- (void)initGestures {
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    pan.delegate = self;
    [self addGestureRecognizer:pan];
}
#pragma mark - override method
- (void)updateUIWithPortrait {
    self.captureButton.hidden = YES;
    self.lockScreenButton.hidden = YES;
    self.bottomLandscapeView.hidden = YES;
    self.bottomPortraitView.hidden = NO;
    [self show];
}
- (void)updateUIWithLandscape {
    self.captureButton.hidden = NO;
    self.lockScreenButton.hidden = NO;
    self.bottomLandscapeView.hidden = NO;
    self.bottomPortraitView.hidden = YES;
    [self show];
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
- (DDPlayerControlTopView *)topView {
    if (!_topView) {
        _topView = [[DDPlayerControlTopView alloc] init];
        __weak typeof(self) weakSelf = self;
        _topView.backTitleButtonClickBlock = ^(UIButton * _Nonnull button) {
            if ([weakSelf.delegate respondsToSelector:@selector(videoPlayerContainerView:clickBackTitleButton:)]) {
                [weakSelf.delegate videoPlayerContainerView:weakSelf clickBackTitleButton:button];
            }
        };
    }
    return _topView;
}
- (DDPlayerControlBottomPortraitView *)bottomPortraitView {
    if (!_bottomPortraitView) {
        _bottomPortraitView = [[DDPlayerControlBottomPortraitView alloc] init];
    }
    return _bottomPortraitView;
}
- (DDPlayerControlBottomLandscapeView *)bottomLandscapeView {
    if (!_bottomLandscapeView) {
        _bottomLandscapeView = [[DDPlayerControlBottomLandscapeView alloc] init];
    }
    return _bottomLandscapeView;
}
@end
