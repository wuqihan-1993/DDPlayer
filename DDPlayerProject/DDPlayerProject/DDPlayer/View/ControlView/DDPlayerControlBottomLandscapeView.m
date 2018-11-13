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

@property(nonatomic, strong) NSArray *rates;

@end

@implementation DDPlayerControlBottomLandscapeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.rates = @[@"1.0X",@"1.25X",@"1.5X"];
    [self updateUI];
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
    if (self.forwardButtonClickBlock) {
        self.forwardButtonClickBlock(button);
    }
}
- (void)rateButtonClick:(UIButton *)button {
    NSInteger index = [self.rates indexOfObject:button.titleLabel.text];
    if (index + 1 >= self.rates.count) {
        [button setTitle:self.rates.firstObject forState:UIControlStateNormal];
    }else {
        [button setTitle:self.rates[index + 1] forState:UIControlStateNormal];
    }
    if (self.rateButtonClickBlock) {
        self.rateButtonClickBlock(button);
    }
}
- (void)clarityButtonClick:(UIButton *)button {
    
}
- (void)chapterButtonClick:(UIButton *)button {
    if (self.chapterButtonClickBlock) {
        self.chapterButtonClickBlock(button);
    }
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
        [_rateButton setTitle:self.rates.firstObject forState:UIControlStateNormal];
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
