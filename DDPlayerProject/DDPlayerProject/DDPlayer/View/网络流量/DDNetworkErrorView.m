//
//  DDNetworkErrorView.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/15.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDNetworkErrorView.h"
#import "DDPlayerTool.h"
#import <Masonry.h>

@interface DDNetworkErrorView()

@property(nonatomic, strong) UIButton *backButton;
@property(nonatomic, strong) UIButton *retryButton;
@property(nonatomic, strong) UIImageView *networkErrorImageView;
@property(nonatomic, strong) UILabel *promptLabel;

@end

@implementation DDNetworkErrorView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    
    [self addSubview:self.backButton ];
    [self addSubview:self.networkErrorImageView];
    [self addSubview:self.promptLabel];
    [self addSubview:self.retryButton];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).mas_offset(20);
    }];
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self.networkErrorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.promptLabel.mas_top).mas_offset(-20);
        make.centerX.equalTo(self);
    }];
    [self.retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.promptLabel.mas_bottom).mas_offset(24);
        make.centerX.equalTo(self);
    }];
}

#pragma mark - action
- (void)retryButtonClick:(UIButton *)button {
    
}
- (void)backButtonClick:(UIButton *)button {
    
}

#pragma makr - getter
- (UIButton *)retryButton {
    if (!_retryButton) {
        _retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_retryButton addTarget:self action:@selector(retryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_retryButton setImage:[UIImage imageNamed:@"DDPlayer_Btn_Retry"] forState:UIControlStateNormal];
    }
    return _retryButton;
}
- (UIImageView *)networkErrorImageView {
    if (!_networkErrorImageView) {
        _networkErrorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DDPlayer_Img_NetFailIcon"]];
    }
    return _networkErrorImageView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"DDPlayer_Btn_Back"] forState:UIControlStateNormal];
    }
    return _backButton;
}
- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.font = [DDPlayerTool PingFangSCRegularAndSize:14];
        _promptLabel.textColor = [UIColor whiteColor];
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.text = @"当前网络异常，请检查网络状况后重试";
    }
    return _promptLabel;
}
@end
