//
//  DDNetworkWarnView.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/15.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDNetworkWarnView.h"
#import <Masonry.h>

@interface DDNetworkWarnView()

@property(nonatomic, strong) UIButton *backButton;
@property(nonatomic, strong) UILabel *promptLabel;
@property(nonatomic, strong) UIButton *playButton;

@end

@implementation DDNetworkWarnView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    [self addSubview:self.backButton];
    [self addSubview:self.promptLabel];
    [self addSubview:self.playButton];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(20);
    }];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.playButton.mas_top).mas_offset(-24);
    }];
    
}
#pragma mark - action
- (void)backButtonClick:(UIButton *)button {
    if (self.backButtonClickBlock) {
        self.backButtonClickBlock(button);
    }
}
- (void)playButtonClick:(UIButton *)button {
    if (self.playButtonClickBlock) {
        self.playButtonClickBlock(button);
    }
}

#pragma mark - getter
- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_backButton setImage:[UIImage imageNamed:@"DDPlayer_Btn_Back"] forState:UIControlStateNormal];
    }
    return _backButton;
}
- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel.text = @"您当前正在使用流量播放视频，是否继续观看？";
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.textColor = UIColor.whiteColor;
        _promptLabel.font = [UIFont systemFontOfSize:13];
    }
    return _promptLabel;
}
- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"DDPlayer_Btn_flowAlert"] forState:UIControlStateNormal];
        [_playButton setTitle:@"继续播放" forState:UIControlStateNormal];
        _playButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_playButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
        [_playButton addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}
@end
