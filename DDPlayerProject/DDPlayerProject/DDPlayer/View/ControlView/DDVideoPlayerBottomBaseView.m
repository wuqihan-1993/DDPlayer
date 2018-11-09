//
//  DDVideoPlayerBottomBaseView.m
//  DDVideoPlayer
//
//  Created by wuqh on 2018/11/7.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDVideoPlayerBottomBaseView.h"
#import "Masonry.h"
@interface DDVideoPlayerBottomBaseView()

@end

@implementation DDVideoPlayerBottomBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    [self addSubview:self.maskView];
    [self addSubview:self.playButton];
    [self addSubview:self.timeLabel];
    [self addSubview:self.slider];
    
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - action
- (void)playButtonClick:(UIButton *)button {
    
}

#pragma mark - getter
- (UIImageView *)maskView {
    if (!_maskView) {
        _maskView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DDPlayer_Bg_MaskBottom"]];
    }
    return _maskView;
}
- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:@"DDPlayer_Btn_BottomPortraitPlay"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"DDPlayer_Btn_BottomPortraitPause"] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.text = @"00:00/02:22";
    }
    return _timeLabel;
}
- (UISlider *)slider {
    if (!_slider) {
        _slider = [[UISlider alloc] init];
        [_slider setThumbImage:[UIImage imageNamed:@"DDPlayer_Icon_ProgressThumb"] forState:UIControlStateNormal];
        [_slider setThumbImage:[UIImage imageNamed:@"DDPlayer_Icon_ProgressThumb_sel"] forState:UIControlStateHighlighted];
        [_slider setMinimumTrackTintColor:[UIColor whiteColor]];
        [_slider setMaximumTrackTintColor:[UIColor colorWithWhite:1 alpha:0.3]];
    }
    return _slider;
}


@end
