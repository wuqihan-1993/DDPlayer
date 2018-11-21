//
//  DDPlayerCoverView.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/9.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerCoverView.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "DDPlayerTool.h"

@interface DDPlayerCoverView()

@property(nonatomic, strong) UIButton *backButton;
@property(nonatomic, strong) UIImageView *coverImageView;
@property(nonatomic, strong) UIButton *playButton;

@end

@implementation DDPlayerCoverView

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
//        make.width.height.mas_equalTo(60);
    }];
}

- (void)setCoverImage:(UIImage *)coverImage {
    _coverImage = coverImage;
    self.coverImageView.image = coverImage;
}
- (void)setCoverImageName:(NSString *)coverImageName {
    if ([coverImageName hasPrefix:@"http"]) {
        [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:coverImageName] placeholderImage:[UIImage imageNamed:@"DDPlaceHolder_Img_HorizontalImg"]];
    }else {
        self.coverImageView.image = [UIImage imageNamed:coverImageName];
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
        make.left.equalTo(self).mas_offset(DDPlayerTool.isiPhoneX ? 44: 20);
        make.top.equalTo(self).mas_offset(33);
    }];
}

#pragma mark - action
- (void)backButtonClick:(UIButton *)button {
    if (self.backButtonClickBlock) {
        self.backButtonClickBlock(button);
    }
}
- (void)playerButtonClick:(UIButton *)button {
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
        [_backButton setTitle:@"\t\t" forState:UIControlStateNormal];
        _backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
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
