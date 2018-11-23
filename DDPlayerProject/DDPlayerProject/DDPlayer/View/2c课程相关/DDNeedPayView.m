//
//  DDNeedPayView.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/23.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDNeedPayView.h"
#import "DDPlayerTool.h"
#import "DDPlayerUIFactory.h"
@interface DDNeedPayView()

@property(nonatomic, strong) UILabel *promptLabel;
@property(nonatomic, strong) UIButton *payButton;
@property(nonatomic, strong) UIButton *backButton;

@end

@implementation DDNeedPayView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    
    [self addSubview:self.backButton];
    [self addSubview:self.promptLabel];
    [self addSubview:self.payButton];

    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        if (DDPlayerTool.isScreenPortrait) {
            make.left.top.equalTo(self).mas_offset(20);
        }else {
            make.left.equalTo(self).mas_offset(DDPlayerTool.isiPhoneX ? 44 : 20);
            make.top.equalTo(self).mas_offset(33);
        }
    }];
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).mas_offset(-20);
    }];
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.promptLabel.mas_bottom).mas_offset(14);
        make.width.mas_equalTo(96);
        make.height.mas_equalTo(40);
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

#pragma mark -action
- (void)backButtonClick:(UIButton *)button {
    if (DDPlayerTool.isScreenLandscape) {
        [DDPlayerTool forceRotatingScreen:UIInterfaceOrientationPortrait];
    }else {
        if (self.backBlock) {
            self.backBlock(button);
        }
    }
}
- (void)payButtonClick:(UIButton *)button {
    if (DDPlayerTool.isScreenLandscape) {
        [DDPlayerTool forceRotatingScreen:UIInterfaceOrientationPortrait];
    }
    if (self.toPayBlock) {
        self.toPayBlock();
    }
}

#pragma mark - getter
- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc]init];
        _promptLabel.font = [DDPlayerTool PingFangSCRegularAndSize:15];
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.textColor = UIColor.whiteColor;
        _promptLabel.text = @"您尚未购买该课程";
    }
    return _promptLabel;
}
- (UIButton *)payButton {
    if (!_payButton) {
        _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _payButton.titleLabel.font = [DDPlayerTool PingFangSCRegularAndSize:15];
        _payButton.backgroundColor = [DDPlayerTool colorWithRGBHex:0x61d8bb];
        [_payButton setTitle:@"立即购买" forState:UIControlStateNormal];
        [_payButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_payButton addTarget:self action:@selector(payButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _payButton.layer.cornerRadius = 20;
        _payButton.layer.masksToBounds = YES;
    }
    return _payButton;
}
- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [DDPlayerUIFactory backButtonWithTarget:self action:NSSelectorFromString(@"backButtonClick:")];
    }
    return _backButton;
}



@end
