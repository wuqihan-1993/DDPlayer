//
//  DDVideoPlayerBottomBaseView.m
//  DDVideoPlayer
//
//  Created by wuqh on 2018/11/7.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerControlBottomBaseView.h"
#import "Masonry.h"
#import "DDPlayerTool.h"

@interface DDPlayerControlBottomBaseView()

@property(nonatomic, assign) BOOL isBeiginDraging;
@property(nonatomic, assign) BOOL isDraging;

@end

@implementation DDPlayerControlBottomBaseView

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
    if (self.playButtonClickBlock) {
        self.playButtonClickBlock(button);
    }
}

#pragma mark - override method

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
        _timeLabel.text = @"00:00/00:00";
    }
    return _timeLabel;
}
- (UISlider *)slider {
    if (!_slider) {
        _slider = [[UISlider alloc] init];
        [_slider setThumbImage:[UIImage imageNamed:@"DDPlayer_Icon_ProgressThumb"] forState:UIControlStateNormal];
        [_slider setThumbImage:[UIImage imageNamed:@"DDPlayer_Icon_ProgressThumb_sel"] forState:UIControlStateHighlighted];
        [_slider setMaximumTrackTintColor:[UIColor whiteColor]];
        [_slider setMinimumTrackTintColor:[DDPlayerTool colorWithRGBHex:0x61d8bb]];
        [_slider addTarget:self action:@selector(sliderBeginDraging:) forControlEvents:UIControlEventTouchDown];
        [_slider addTarget:self action:@selector(sliderDraging:) forControlEvents:UIControlEventValueChanged];
        [_slider addTarget:self action:@selector(sliderEndDraging:) forControlEvents:UIControlEventTouchCancel | UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        _slider.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTap:)];
        [_slider addGestureRecognizer:tap];
    }
    return _slider;
}


/**
 点击slider

 @param tap tap
 */
- (void)sliderTap:(UITapGestureRecognizer*)tap {
    
    if (self.isDraging ) return;
   
    CGPoint tapPoint = [tap locationInView:tap.view];
    CGFloat percent = tapPoint.x / tap.view.bounds.size.width;
    UISlider *slider = (UISlider*)tap.view;
    slider.value = percent * slider.maximumValue;
    
    if (self.sliderTapBlock) {
        self.sliderTapBlock(slider);
    }
}


/**
 开始拖动slider 只会执行一次

 @param slider slider
 */
- (void)sliderBeginDraging:(UISlider *)slider {
    self.isBeiginDraging = YES;
    if (self.sliderBeginDragingBlock) {
        self.sliderBeginDragingBlock(slider);
    }
}

/**
 正在拖动slider

 @param slider slider
 */
- (void)sliderDraging:(UISlider*)slider {
    
    if (self.isBeiginDraging == NO) return;
    
    self.isDraging = YES;

    if (self.sliderDragingBlock) {
        self.sliderDragingBlock(slider);
    }
}

/**
 拖动slider结束

 @param slider slider
 */
- (void)sliderEndDraging:(UISlider*)slider {
    
    self.isBeiginDraging = NO;
    self.isDraging = NO;
    
    if (self.sliderEndDragingBlock) {
        self.sliderEndDragingBlock(slider);
    }
}


@end
