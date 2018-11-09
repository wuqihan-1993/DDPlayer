//
//  DDVideoPlayerBottomLandscapeView.m
//  DDVideoPlayer
//
//  Created by wuqh on 2018/11/7.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerControlBottomLandscapeView.h"
#import "Masonry.h"

@interface DDPlayerControlBottomLandscapeView()

@property(nonatomic, strong) UIButton *forwardButton;
@property(nonatomic, strong) UIButton *rateButton;
@property(nonatomic, strong) UIButton *clarityButton;
@property(nonatomic, strong) UIButton *chapterButton;

@end

@implementation DDPlayerControlBottomLandscapeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self updateUI];
    }
    return self;
}
- (void)updateUI {
    
    [self addSubview:self.forwardButton];
    [self addSubview:self.rateButton];
    [self addSubview:self.clarityButton];
    [self addSubview:self.chapterButton];
    
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).mas_offset(20);
        make.right.equalTo(self).mas_offset(-20);
    }];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(20);
        make.bottom.equalTo(self.mas_bottom).mas_offset(-20);
    }];
    [self.forwardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playButton.mas_right).mas_offset(24);
        make.centerY.equalTo(self.playButton);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.forwardButton.mas_right).mas_offset(24);
        make.centerY.equalTo(self.playButton);
    }];
    [self.chapterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).mas_offset(-20);
        make.centerY.equalTo(self.playButton);
    }];
    [self.clarityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.chapterButton.mas_left).mas_offset(-24);
        make.centerY.equalTo(self.playButton);
    }];
    [self.rateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.clarityButton.mas_left).mas_offset(-24);
        make.centerY.equalTo(self.playButton);
    }];
}

- (void)forwardButtonClick:(UIButton *)button {
    
}
- (void)rateButtonClick:(UIButton *)button {
    
}
- (void)clarityButtonClick:(UIButton *)button {
    
}
- (void)chapterButtonClick:(UIButton *)button {
    
}

- (UIButton *)forwardButton {
    if (!_forwardButton) {
        _forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forwardButton setImage:[UIImage imageNamed:@"DDPlayer_Btn_Forward"] forState:UIControlStateNormal];
        [_forwardButton addTarget:self action:@selector(forwardButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forwardButton;
}
- (UIButton *)rateButton {
    if (!_rateButton) {
        _rateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rateButton setTitle:@"1.0X" forState:UIControlStateNormal];
        [_rateButton addTarget:self action:@selector(rateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rateButton;
}
- (UIButton *)clarityButton {
    if (!_clarityButton) {
        _clarityButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clarityButton setTitle:@"标准" forState:UIControlStateNormal];
        [_clarityButton addTarget:self action:@selector(clarityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clarityButton;
}
- (UIButton *)chapterButton {
    if (!_chapterButton) {
        _chapterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chapterButton setTitle:@"章节" forState:UIControlStateNormal];
        [_chapterButton addTarget:self action:@selector(chapterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chapterButton;
}

@end
