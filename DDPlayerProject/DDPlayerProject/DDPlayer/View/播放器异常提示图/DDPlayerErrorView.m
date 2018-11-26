//
//  DDPlayerErrorView.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/21.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerErrorView.h"
#import "DDPlayerTool.h"

@interface DDPlayerErrorView()

@property(nonatomic, strong) UIButton *backButton;
@property(nonatomic, strong) UIButton *retryButton;
@property(nonatomic, strong) UILabel *promptLabel;

@end

@implementation DDPlayerErrorView

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
    [self addSubview:self.retryButton];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).mas_offset(20);
    }];
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).mas_offset(-18);
    }];
    [self.retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.promptLabel.mas_bottom).mas_offset(24);
        make.centerX.equalTo(self);
    }];
}
#pragma mark - action
- (void)backButtonClick:(UIButton *)button {
    if (self.backButtonClickBlock) {
        self.backButtonClickBlock(button);
    }
}
- (void)retryButtonClick:(UIButton *)button {
    if (self.retryBlock) {
        self.retryBlock();
    }
}

#pragma mark - public
- (void)setError:(NSError *)error url:(NSString *)url {
    NSString *netOrLocal = [url hasPrefix:@"http"] ? @"网络视频" : @"本地视频";

    if (error) {
        if (error.code == -1100) {
            
            if ([url hasPrefix:@"http"]) {
                self.promptLabel.text = [NSString stringWithFormat:@"抱歉，%@-播放出现错误,请点击重试\n或观看其他视频",netOrLocal];
            }else {
                self.promptLabel.text = [NSString stringWithFormat:@"抱歉，%@-下载的视频出现错误,请点击重试\n或删除下载的视频",netOrLocal];
            }
            
        }else if (error.code == -11819) {
            self.promptLabel.text = [NSString stringWithFormat:@"抱歉，%@-当前网络环境不好，播放器正在缓慢加载中，\n请退出本页面重新进入",netOrLocal];
        }else {
            
            if ([url hasPrefix:@"http"]) {
                self.promptLabel.text = [NSString stringWithFormat:@"抱歉，%@-播放出现错误,请点击重试\n或观看其他视频\n错误代码：%ld",netOrLocal,error.code];
            }else {
                self.promptLabel.text = [NSString stringWithFormat:@"抱歉，%@-下载的视频出现错误,请点击重试\n或删除下载的视频\n错误代码：%ld",netOrLocal,error.code];
            }
        }
    }else {
        if ([url hasPrefix:@"http"]) {
            self.promptLabel.text = [NSString stringWithFormat:@"抱歉，%@-播放出现错误,请点击重试\n或观看其他视频",netOrLocal];
        }else {
            self.promptLabel.text = [NSString stringWithFormat:@"抱歉，%@-下载的视频出现错误,请点击重试\n或删除下载的视频",netOrLocal];
        }
    }
    
    
    
}

#pragma mark - overrid method
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

#pragma mark - getter
- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_backButton setTitle:@"\t\t" forState:UIControlStateNormal];
        [_backButton setImage:[UIImage imageNamed:@"DDPlayer_Btn_Back"] forState:UIControlStateNormal];
        _backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _backButton;
}
- (UIButton *)retryButton {
    if (!_retryButton) {
        _retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_retryButton addTarget:self action:@selector(retryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_retryButton setImage:[UIImage imageNamed:@"DDPlayer_Btn_Retry"] forState:UIControlStateNormal];
    }
    return _retryButton;
}
- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.textColor = [UIColor whiteColor];
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [DDPlayerTool PingFangSCRegularAndSize:14];
        _promptLabel.text = @"抱歉，视频播放出现错误，请点击重试或\n观看其他视频。";
        _promptLabel.numberOfLines = 0;
    }
    return _promptLabel;
}

@end
