//
//  DDTryWatchView.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/23.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDTryWatchView.h"
#import "DDPlayerTool.h"
#import "DDPlayerUIFactory.h"

@interface DDTryWatchView()

@property(nonatomic, strong) UIButton *backButton;
@property(nonatomic, strong) UILabel *promptLabel;
@property(nonatomic, strong) UIButton *buyButton;
@property(nonatomic, strong) UIButton *retryButton;

@end

@implementation DDTryWatchView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    
    self.backgroundColor = UIColor.blackColor;
    
    [self addSubview:self.backButton];
    [self addSubview:self.promptLabel];
    UIStackView *stackView = [[UIStackView alloc]init];
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.spacing = 24;
    [stackView addArrangedSubview:self.buyButton];
    [stackView addArrangedSubview:self.retryButton];
    [self addSubview:stackView];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        if (DDPlayerTool.isScreenPortrait) {
            make.top.left.equalTo(self).mas_offset(20);
        }else {
            make.left.equalTo(self).mas_offset(DDPlayerTool.isiPhoneX ? 44 : 20);
            make.top.equalTo(self).mas_offset(33);
        }
    }];
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).mas_offset(-20);
    }];
    [self.buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(96);
        make.height.mas_equalTo(40);
    }];
    [self.retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(96);
        make.height.mas_equalTo(40);
    }];
    [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.promptLabel.mas_bottom).mas_offset(20);
    }];
}

- (void)updateUIWithPortrait {
    [self.backButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).mas_offset(20);
    }];
}
- (void)updateUIWithLandscape {
    [self.backButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).mas_offset(33);
        make.left.equalTo(self).mas_offset(DDPlayerTool.isiPhoneX ? 44 : 20);
    }];
}


#pragma mark - action
- (void)backButtonClick:(UIButton *)button {
    if (DDPlayerTool.isScreenLandscape) {
        [DDPlayerTool forceRotatingScreen:UIInterfaceOrientationPortrait];
    }else {
        if (self.backBlock) {
            self.backBlock(button);
        }
    }
}
- (void)buyButtonClick:(UIButton *)button {
    if (DDPlayerTool.isScreenLandscape) {
        [DDPlayerTool forceRotatingScreen:UIInterfaceOrientationPortrait];
    }
    if (self.buyBlock) {
        self.buyBlock(button);
    }
}
- (void)retryButtonClick:(UIButton *)button {
    if (self.retryWatchBlock) {
        self.retryWatchBlock(button);
    }
}
#pragma mark - getter
- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [DDPlayerUIFactory backButtonWithTarget:self action:NSSelectorFromString(@"backButtonClick:")];
    }
    return _backButton;
}
- (UIButton *)retryButton {
    if (!_retryButton) {
        _retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_retryButton addTarget:self action:@selector(retryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_retryButton setTitle:@"重新试看" forState:UIControlStateNormal];
        _retryButton.titleLabel.font = [DDPlayerTool PingFangSCRegularAndSize:15];
        _retryButton.layer.borderColor = UIColor.whiteColor.CGColor;
        _retryButton.layer.borderWidth = 1.0;
        _retryButton.layer.cornerRadius = 20;
        _retryButton.layer.masksToBounds = YES;
    }
    return _retryButton;
}
- (UIButton *)buyButton {
    if (!_buyButton) {
        _buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyButton.backgroundColor = [DDPlayerTool colorWithRGBHex:0x61d8bb];
        [_buyButton setTitle:@"购买课程 " forState:UIControlStateNormal];
        _buyButton.titleLabel.font = [DDPlayerTool PingFangSCRegularAndSize:15];
        [_buyButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _buyButton.layer.cornerRadius = 20.0;
        _buyButton.layer.masksToBounds = YES;
        [_buyButton addTarget:self action:@selector(buyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyButton;
}

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc]init];
        _promptLabel.font = [DDPlayerTool PingFangSCRegularAndSize:15];
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.text = @"试看结束，购买课程可查看完整视频";
        _promptLabel.textColor = UIColor.whiteColor;
    }
    return _promptLabel;
}
@end
