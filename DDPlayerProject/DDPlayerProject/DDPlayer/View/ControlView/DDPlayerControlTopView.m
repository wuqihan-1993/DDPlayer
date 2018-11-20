//
//  DDVideoPlayerTopView.m
//  DDVideoPlayer
//
//  Created by wuqh on 2018/11/7.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerControlTopView.h"
#import "Masonry.h"
#import "DDPlayerTool.h"

@interface DDPlayerControlTopView()

@property(nonatomic, strong) UIImageView *maskView;
@property(nonatomic, strong) UIButton *backTitleButton;
@property(nonatomic, strong) UIButton *shareButton;

@end

@implementation DDPlayerControlTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self addSubview:self.maskView];
    [self addSubview:self.backTitleButton];
    [self addSubview:self.shareButton];
    
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.backTitleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(20);
        make.top.equalTo(self).mas_offset(20);
    }];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).mas_offset(-20);
        make.centerY.equalTo(self.backTitleButton);
    }];
}

#pragma mark - override method
- (void)updateUIWithPortrait {
    [self.backTitleButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(20);
        make.top.equalTo(self).mas_offset(20);
    }];
    [self.shareButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).mas_offset(-20);
    }];
}
- (void)updateUIWithLandscape {
    [self.backTitleButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_equalTo(DDPlayerTool.isiPhoneX ? 44 : 20);
        make.top.equalTo(self).mas_offset(33);
    }];
    [self.shareButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).mas_offset(DDPlayerTool.isiPhoneX ? -44 : -20);
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
- (void)shareButtonClick:(UIButton *)button {
    if (self.shareButtonClickBlock) {
        self.shareButtonClickBlock(button);
    }
}

#pragma mark - setter
- (void)setTitle:(NSString *)title {
    _title = title;
    [self.backTitleButton setTitle:[NSString stringWithFormat:@"   %@",title] forState:UIControlStateNormal];
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
        [_backTitleButton setTitle:@"\t\t" forState:UIControlStateNormal];
        [_backTitleButton setImage:[UIImage imageNamed:@"DDPlayer_Btn_Back"] forState:UIControlStateNormal];
        [_backTitleButton setImage:[UIImage imageNamed:@"DDPlayer_Btn_Back"] forState:UIControlStateHighlighted];
        [_backTitleButton addTarget:self action:@selector(backTitleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _backTitleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _backTitleButton;
}
- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setImage:[UIImage imageNamed:@"DDPlayer_Btn_LandShare"] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}


@end
