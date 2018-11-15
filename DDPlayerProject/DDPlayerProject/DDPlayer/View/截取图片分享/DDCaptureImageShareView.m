//
//  DDCaptureImageShareView.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/15.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDCaptureImageShareView.h"
#import <Masonry.h>
#import "DDPlayerTool.h"

@interface DDCaptureImageShareView()
{
    UIImage *_sharedImage;
}
@property(nonatomic, strong) UIImageView *sharedImageView;
@property(nonatomic, strong) UIButton *backButton;
@property(nonatomic, strong) UILabel *promptLabel;

@end

@implementation DDCaptureImageShareView

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
}

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        _sharedImage = image;
        self.sharedImageView.image = image;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    
    [self addSubview:self.backButton ];
    [self addSubview:self.sharedImageView];
    [self addSubview:self.promptLabel];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(20);
        make.top.equalTo(self).mas_offset(24);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    
    [self.sharedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(DDPlayerTool.isiPhoneX ? 34 + 40 : 40);
        make.height.mas_equalTo(DDPlayerTool.screenWidth * 0.4);
        make.width.mas_equalTo(DDPlayerTool.screenWidth * 0.4 * 16 / 9);
        make.centerY.equalTo(self);
    }];
    
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sharedImageView.mas_right).mas_offset(40);
        make.top.equalTo(self.sharedImageView.mas_top);
    }];
    
}
#pragma mark - action
- (void)backButtonClick:(UIButton *)button {
    [self removeFromSuperview];
}

#pragma mark - getter
- (UIImageView *)sharedImageView {
    if (!_sharedImageView) {
        _sharedImageView = [[UIImageView alloc]init];
    }
    return _sharedImageView;
}
- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setTitle:@"取消" forState:UIControlStateNormal];
        [_backButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.textColor = UIColor.whiteColor;
        _promptLabel.font = [UIFont systemFontOfSize:15];
        _promptLabel.text = @"已保存到系统相册，可以分享给好友啦";
    }
    return _promptLabel;
}
@end
