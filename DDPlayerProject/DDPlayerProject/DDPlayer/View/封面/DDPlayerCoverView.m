//
//  DDPlayerCoverView.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/9.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerCoverView.h"
#import <Masonry.h>
@interface DDPlayerCoverView()

@property(nonatomic, strong) UIButton *backButton;
@property(nonatomic, strong) UIImageView *coverImageView;
@property(nonatomic, strong) UIButton *playButton;

@end

@implementation DDPlayerCoverView

- (instancetype)initWitCoverImage:(UIImage *)image {
    if (self = [super init]) {
        _coverImage = image;
        self.coverImageView.image = _coverImageView;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}
- (void)initialize
{
    [self addSubview:self.coverImageView];
    [self addSubview:self.backButton];
    [self addSubview:self.playButton];
    
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).mas_offset(20);
    }];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

- (void)setCoverImage:(UIImage *)coverImage {
    _coverImage = coverImage;
    self.coverImageView.image = coverImage;
}

#pragma mark - action
- (void)backButtonClick:(UIButton *)button {
    if (self.backButtonClickBlock) {
        self.backButtonClickBlock();
    }
}
- (void)playerButtonClick:(UIButton *)button {
    if (self.playButtonClickBlock) {
        self.playButtonClickBlock();
    }
    [self removeFromSuperview];
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
- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:@"DDPlayer_Icon_coverPlay"] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(playerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}
- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
    }
    return _coverImageView;
}

@end
