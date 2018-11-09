//
//  DDVideoPlayerTopView.m
//  DDVideoPlayer
//
//  Created by wuqh on 2018/11/7.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDVideoPlayerTopView.h"
#import "Masonry.h"
#import "DDPlayerTool.h"

@interface DDVideoPlayerTopView()

@property(nonatomic, strong) UIImageView *maskView;
@property(nonatomic, strong) UIButton *backTitleButton;

@end

@implementation DDVideoPlayerTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self addSubview:self.maskView];
    [self addSubview:self.backTitleButton];
    
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.backTitleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(20);
        make.centerY.equalTo(self);
    }];
}

#pragma mark - override method
- (void)updateUIWithPortrait {
    [self.backTitleButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(20);
    }];
}
- (void)updateUIWithLandscape {
    [self.backTitleButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_equalTo(40);
    }];
}

#pragma mark - action
- (void)backTitleButtonClick:(UIButton *)button {
    //如果当前状态为横屏。则要转为竖屏
    if (DDPlayerTool.isScreenLandscape) {
        [DDPlayerTool forceRotatingScreen:UIInterfaceOrientationPortrait];
    }else {
        if (self.backTitleButtonClickBlock) {
            self.backTitleButtonClickBlock(button);
        }
    }
}

#pragma mark - setter
- (void)setTitle:(NSString *)title {
    _title = title;
    [self.backTitleButton setTitle:title forState:UIControlStateNormal];
}

#pragma mark - getter
- (UIImageView *)maskView {
    if (!_maskView) {
        _maskView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DDPlayer_Bg_MaskTop"]];
    }
    return _maskView;
}
- (UIButton *)backTitleButton {
    if (!_backTitleButton) {
        _backTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backTitleButton setImage:[UIImage imageNamed:@"DDPlayer_Btn_Back"] forState:UIControlStateNormal];
        [_backTitleButton addTarget:self action:@selector(backTitleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backTitleButton;
}


@end
