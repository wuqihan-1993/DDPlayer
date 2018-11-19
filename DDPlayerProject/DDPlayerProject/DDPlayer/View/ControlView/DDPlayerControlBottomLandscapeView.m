//
//  DDVideoPlayerBottomLandscapeView.m
//  DDVideoPlayer
//
//  Created by wuqh on 2018/11/7.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerControlBottomLandscapeView.h"
#import "Masonry.h"
#import "DDPlayerTool.h"

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
    
    [self.playButton setImage:[UIImage imageNamed:@"DDPlayer_Btn_LandSBottPlay"] forState:UIControlStateNormal];
    [self.playButton setImage:[UIImage imageNamed:@"DDPlayer_Btn_LandSBottPause"] forState:UIControlStateSelected];
    [self updateUI];
}
- (void)updateUI {
    
    [self addSubview:self.forwardButton];
    [self addSubview:self.rateButton];
    [self addSubview:self.clarityButton];
    [self addSubview:self.chapterButton];
    
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).mas_offset(DDPlayerTool.isiPhoneX ? 44 : 20);
        make.right.equalTo(self).mas_offset(DDPlayerTool.isiPhoneX ? -44 : -20);
    }];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(DDPlayerTool.isiPhoneX ? 44 : 20);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(40);
    }];
    [self.forwardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playButton.mas_right).mas_offset(4);
        make.centerY.equalTo(self.playButton);
        make.width.mas_equalTo(40);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.forwardButton.mas_right).mas_offset(4);
        make.centerY.equalTo(self.playButton);
    }];
    [self.chapterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).mas_offset(DDPlayerTool.isiPhoneX ? -44 : -20);
        make.centerY.equalTo(self.playButton);
        make.width.mas_equalTo(60);
    }];
    [self.clarityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.chapterButton.mas_left).mas_offset(-4);
        make.centerY.equalTo(self.playButton);
        make.width.mas_equalTo(60);
    }];
    [self.rateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.clarityButton.mas_left).mas_offset(-4);
        make.centerY.equalTo(self.playButton);
        make.width.mas_equalTo(60);
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
    if (self.clarityButtonClickBlock) {
        self.clarityButtonClickBlock(button);
    }
}
- (void)chapterButtonClick:(UIButton *)button {
    if (self.chapterButtonClickBlock) {
        self.chapterButtonClickBlock(button);
    }
}

- (UIButton *)forwardButton {
    if (!_forwardButton) {
        _forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forwardButton setImage:[UIImage imageNamed:@"DDPlayer_Btn_Next"] forState:UIControlStateNormal];
        [_forwardButton addTarget:self action:@selector(forwardButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _forwardButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _forwardButton;
}
- (UIButton *)rateButton {
    if (!_rateButton) {
        _rateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rateButton setTitle:self.rates.firstObject forState:UIControlStateNormal];
        _rateButton.titleLabel.font = [DDPlayerTool pingfangSCSemiboldAndSize:15];
        [_rateButton addTarget:self action:@selector(rateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _rateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _rateButton;
}
- (UIButton *)clarityButton {
    if (!_clarityButton) {
        _clarityButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _clarityButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [_clarityButton setTitle:@"标准" forState:UIControlStateNormal];
        _clarityButton.titleLabel.font = [DDPlayerTool pingfangSCSemiboldAndSize:15];
        [_clarityButton addTarget:self action:@selector(clarityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _clarityButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _clarityButton;
}
- (UIButton *)chapterButton {
    if (!_chapterButton) {
        _chapterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _chapterButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [_chapterButton setTitle:@"章节" forState:UIControlStateNormal];
        _chapterButton.titleLabel.font = [DDPlayerTool pingfangSCSemiboldAndSize:15];
        [_chapterButton addTarget:self action:@selector(chapterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _chapterButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _chapterButton;
}

@end
